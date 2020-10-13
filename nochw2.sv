module noc_intf (
	input clk,
	input rst,
	input noc_to_dev_ctl,
	input [7:0] noc_to_dev_data,
	output reg noc_from_dev_ctl,
	output reg [7:0] noc_from_dev_data,
	output reg pushin,
	output reg firstin,
	input stopin,
	output reg [63:0] din,
	input pushout,
	input firstout,
	output reg stopout,
	input [63:0] dout
);

	// State Machine for RECEIVING data
	enum reg [3:0] {
		IDLE_R,
		READ,
		WRITE,
		MSG_R,
		DEST_R,
		SRC_R,
		ADDR_R
	} current_state_r, next_state_r;

	// State Machine for SENDING data
	enum reg [3:0] {
		IDLE_S,
		READ_RESP,
		WRITE_RESP,
		MSGADDR,
		MSGDATA,
		DEST_S,
		SRC_S,
		DLENGTH_S
	} current_state_s, next_state_s;

	// I/O Buffer
	reg noc_from_dev_ctl_d, pushin_d, firstin_d, stopout_d;
	reg [7:0] noc_from_dev_data_d;
	reg [63:0] din_d;

	// Address and Data length
	reg [1:0] Alen;
	reg [3:0] Alen_cnt, Alen_cnt_d;
	reg [2:0] Dlen;
	reg [7:0] Dlen_cnt, Dlen_cnt_d;
	reg [2:0] cmd, cmd_d, cmd_s, cmd_s_d;

	// Destination ID and Source ID
	reg [7:0] Dest_ID, Dest_ID_d, Src_ID, Src_ID_d;

	// Read/Write Address 
	reg [7:0][7:0] Addr, Addr_d;
	reg [2:0] Addr_index, Addr_index_d;

	// Read/Write Data
	union packed {
		reg [199:0][7:0] Dev; // Interface data
		reg [24:0][63:0] Per; // To/from Perm block
	} data_pkg, data_pkg_d;
	reg [7:0] data_index, data_index_d;

	// Perm Control
	reg write_perm, write_perm_d, read_perm, read_perm_d;
	reg [4:0] perm_index, perm_index_d;

	//Control Signal for Read/Write Command
	reg Get_DID, Get_SID;

	//Control Signal for Read/Write Response
	reg [1:0] send_msg, send_msg_d; // 0:NOP 1:MSG 2:READ 3:WRITE
        reg [1:0] rc, rc_d;	
	reg Send_SID, Send_data;
	reg [7:0] Actual_data_d, Actual_data;
	reg [7:0] Resp_data, Resp_data_d;
	
	task AD_assignment;
		Alen = noc_to_dev_data[7:6];
		Dlen = noc_to_dev_data[5:3];
		case (noc_to_dev_data[7:6])
			2'b00: Alen_cnt_d = 1;
			2'b01: Alen_cnt_d = 2;
			2'b10: Alen_cnt_d = 4;
			2'b11: Alen_cnt_d = 8;
		endcase
		case (noc_to_dev_data[5:3])
			3'b000: Dlen_cnt_d = 1;
			3'b001: Dlen_cnt_d = 2;
			3'b010: Dlen_cnt_d = 4;
			3'b011: Dlen_cnt_d = 8;
			3'b100: Dlen_cnt_d = 16;
			3'b101: Dlen_cnt_d = 32;
			3'b110: Dlen_cnt_d = 64;
			3'b111: Dlen_cnt_d = 128;
		endcase
	endtask

	// State Machine for RECEIVING DATA	
	always @ (*) begin
		next_state_r = current_state_r;
		Alen = 0;
		Alen_cnt_d = Alen_cnt;
		Dlen = 0;
		Dlen_cnt_d = Dlen_cnt;
		cmd_d = cmd;
		Dest_ID_d = Dest_ID;
		Src_ID_d = Src_ID;
		Addr_d = Addr;
		Addr_index_d = Addr_index;
		data_pkg_d = data_pkg;
		data_index_d = data_index;
		write_perm_d = write_perm;
		perm_index_d = perm_index;
		send_msg_d = send_msg;
		rc_d = rc;
		case (current_state_r)
			IDLE_R: begin
				Alen_cnt_d = 0;
				Dlen_cnt_d = 0;
				Dest_ID_d = 0;
				Src_ID_d = 0;
				if (noc_to_dev_ctl) begin
					case (noc_to_dev_data[2:0])
						3'b001: begin
							AD_assignment();
							next_state_r = READ;
							cmd_d = 3'b001;
						end
						3'b010: begin
							AD_assignment();
							next_state_r = DEST_R;
							cmd_d = 3'b010;
						end
						3'b101: begin
							next_state_r = MSG_R;
						end
					endcase
				end
			end
			READ: begin
				$display("READ STATE%t", $time);
				next_state_r = MSG_R;
			end
			WRITE: begin
				if (~write_perm) begin
					data_pkg_d.Dev[data_index] = noc_to_dev_data;
					data_index_d = data_index + 1;
				end
				if (data_index == 198) begin
					write_perm_d = 1;
					if (Dlen_cnt != 1) begin
						rc_d = 2'b10;
					end
				end
				Dlen_cnt_d = Dlen_cnt - 1;
				if (Dlen_cnt == 1) begin
					Dlen_cnt_d = 0;
					if (rc!=1 && rc!=2) rc_d = 0;
					send_msg_d = 3; // Write Response
					next_state_r = IDLE_R;
				end
				$display("data[%d] = %b%t", data_index, data_pkg_d.Dev[data_index], $time);
			end
			MSG_R: begin
				$display("MSG STATE%t", $time);
			end
			DEST_R: begin
/*				if (noc_to_dev_ctl) begin
					$display("ERROR IN STATEMACHINE%t", $time);
				end
				else begin
*/				if (noc_to_dev_data) begin	
					Dest_ID_d = noc_to_dev_data;
					next_state_r = SRC_R;
				end
				else begin // Got NON-ZERO Address
					send_msg_d = 1; // Send an ERROR Message: 8'h03
					Resp_data_d = 8'h03;
					next_state_r = IDLE_R;
				end
//				end
			end
			SRC_R: begin
				if (noc_to_dev_data) begin
					Src_ID_d = noc_to_dev_data;
					next_state_r = ADDR_R;
					$display("DEST %b  SRC %b", Dest_ID, Src_ID_d);
				end
				else begin
					send_msg_d = 1; // ERROR: 8'h03
					Resp_data_d = 8'h03;
					next_state_r = IDLE_R;
				end
			end	
			ADDR_R: begin
				Addr_d[Addr_index] = noc_to_dev_data;
				Addr_index_d = Addr_index + 1;
				Alen_cnt_d = Alen_cnt - 1;
				if (Alen_cnt == 1) begin
					Addr_index_d = 0;
					Alen_cnt_d = 0;
					if(cmd == 3'b001)
					next_state_r = WRITE;
					else begin
					   next_state_r = IDLE_R;      //read
					   send_msg_d = 2;             //read response
					end
				end
				$display("Addr[%b] = %b%t", Addr_index, Addr_d[Addr_index], $time);
			end
		endcase
	end

	// State Machine for SENDING DATA
	always @ (*) begin
		next_state_s = current_state_s;
		noc_from_dev_ctl_d = noc_from_dev_ctl;
		noc_from_dev_data_d = noc_from_dev_data;
		send_msg_d = send_msg;
		read_perm_d = read_perm;
		cmd_s_d = cmd_s;
		case (current_state_s)
			IDLE_S: begin
				case (send_msg)
					1: begin
						noc_from_dev_ctl_d = 1;
						noc_from_dev_data_d = 8'b00000101;
						cmd_s_d = 3'b101;
						next_state_s = DEST_S;
					end
					2: begin
					   noc_from_dev_ctl_d = 1;
					   noc_from_dev_data_d = {rc, 6'b000011};
					   read_perm_d = 1;
					   cmd_s_d = 3'b011;
					   next_state_s = DEST_S;
					   $display("READ RESP @%t", $time);
					end
					3: begin
						noc_from_dev_ctl_d = 1;
				        noc_from_dev_data_d = {rc, 6'b000100};
				        cmd_s_d = 3'b100;
						next_state_s = DEST_S;
						$display("WR COMMAND RC %b%t", noc_from_dev_data_d, $time);
					end
				endcase
			end
			READ_RESP: begin
			     if(~read_perm) begin
			         data_pkg_d[data_index] = 1;
			         data_index_d = data_index + 1;
			     end
			     if(data_index == 198) begin
			         read_perm_d = 1;
			         Actual_data_d = Actual_data + 2;
			         if(Dlen_cnt != 2) begin
			             $display("-------------------------%d%t", Dlen_cnt, $time);
			             rc_d = 2'b10;
			         end
			     end
			     Dlen_cnt_d = Dlen_cnt - 1;
			     if(Dlen_cnt == 1) begin
			         Dlen_cnt_d = 0;             //read response
			         next_state_s = IDLE_S;
			     end 
			end
				
			MSGADDR: begin
				noc_from_dev_data_d = 0; // UNCERTAIN
				next_state_s = MSGDATA;
			end
			MSGDATA: begin
				noc_from_dev_data_d = Resp_data;
				send_msg_d = 0;
				next_state_s = IDLE_S;
			end
			DEST_S: begin
				noc_from_dev_ctl_d = 0;
				noc_from_dev_data_d = Dest_ID;
				next_state_s = SRC_S;
				$display("WR COMMAND DE %b%t", noc_from_dev_data_d, $time);
			end
			SRC_S: begin
				noc_from_dev_data_d = Src_ID;
				$display("\n SM %d", send_msg);
				if (send_msg == 1)
					next_state_s = MSGADDR;
				else if (send_msg==3 || send_msg==5)
					next_state_s = DLENGTH_S;
				$display("WR COMMAND SO %b%t", noc_from_dev_data_d, $time);
			end
			DLENGTH_S: begin
				noc_from_dev_data_d = Actual_data;
				rc_d = 0;
				send_msg_d = 0;
				Actual_data_d = 0;
				if(cmd_s == 3'b100) next_state_s = IDLE_S;
				else next_state_s = READ_RESP;      //read data
				$display("WR COMMAND AL %b%t", noc_from_dev_data_d, $time);
			end
		endcase
	end
    
    
    // PUSHOUT AND STOPIN FROM PERM
	always @ (posedge pushout or negedge stopin) begin
		if (pushout) begin
			send_msg_d = 4;
		end
		else if (!stopin) begin
			send_msg_d = 5;
		end
	end
    
    
	// PERM CONTROL
	always @ (posedge clk) begin
	//maybe latch happens in this block
	   stopout_d = stopout;
	   write_perm_d = write_perm;
	   read_perm_d = read_perm;
	   perm_index_d = perm_index;
	   data_pkg_d = data_pkg;
	   din_d = din;
	   pushin_d = pushin;
		if (write_perm) begin
			firstin_d = (perm_index==0) ? 1 : 0;
			pushin_d = 1;
			din_d = data_pkg.Per[perm_index];
			perm_index_d = perm_index + 1;
			if (perm_index == 24) begin
				write_perm_d = 0;
				pushin_d = 0;
				din_d = 0;
				perm_index_d = 0;
			end
			$display("first%b data[%d] = %b", firstin_d, perm_index, din_d);
		end else if (read_perm) begin
		      //data_index for package, perm_index for reveive
		      perm_index_d = firstout ? 0 : perm_index;
		      if(pushout) begin
		          data_pkg_d[perm_index] = dout;
		          perm_index_d = perm_index + 1;
		          if(perm_index == 24) begin
		              read_perm_d = 0;
		              stopout_d = 1;
		              perm_index_d = 0;
		          end
		      end
		end
	end


///////////
int i = 17;
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			current_state_r <= IDLE_R;
			current_state_s <= IDLE_S;
			noc_from_dev_ctl <= 0;
			pushin <= 0;
			firstin <= 0;
			stopout <= 0;
			noc_from_dev_data <= 0;
			din <= 0;
			Alen <= 0;
			Alen_cnt <= 0;
			Dlen <= 0;
			Dlen_cnt <= 0;
			Dest_ID <= 0;
			Src_ID <= 0;
			Addr <= 0;
			Addr_index <= 0;
			data_pkg <= 0;
			data_index <= 0;
			write_perm <= 0;
			read_perm <= 0;
			perm_index <= 0;
			send_msg <= 0;
			rc <= 0;
			cmd <= 0;
			cmd_s <= 0;
		end
		else begin
			current_state_r <= next_state_r;
			current_state_s <= next_state_s;
			noc_from_dev_ctl <= noc_from_dev_ctl_d;
			pushin <= pushin_d;
			firstin <= firstin_d;
			stopout <= stopout_d;
			noc_from_dev_data <= noc_from_dev_data_d;
			din <= din_d;
			Alen_cnt <= Alen_cnt_d;
			Dlen_cnt <= Dlen_cnt_d;
			cmd <= cmd_d;
			cmd_s <= cmd_s_d;
			Dest_ID <= Dest_ID_d;
			Src_ID <= Src_ID_d;
			Addr <= Addr_d;
			Addr_index <= Addr_index_d;
			data_pkg <= data_pkg_d;
			data_index <= data_index_d;
			write_perm <= write_perm_d;
			read_perm <= read_perm_d;
			perm_index <= perm_index_d;
			send_msg <= send_msg_d;
			rc <= rc_d;

			if (noc_to_dev_ctl == 1 && i!=0) begin
				$display("ctl%b%d.COMMAND %b%t", noc_to_dev_ctl, i, noc_to_dev_data, $time);
				i-=1;
			end
		end
	end
endmodule

