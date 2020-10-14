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
	reg [7:0] data_index_s, data_index_s_d;
	reg [6:0] pkt_data_len, pkt_data_len_d;	//data packet length for read response
	reg data_full, data_full_d; // Indicate a full set of 200 byte data

	// Perm Control
	reg write_perm, write_perm_d;
	reg read_perm, read_perm_d;
	reg [4:0] perm_index, perm_index_d;

	//Control Signal for Read/Write Command
	reg [1:0] get_r_w, get_r_w_d; // Get message 0:nothing 1:read 2:write
	reg [1:0] get_r_w_s, get_r_w_s_d; // Get message 0:nothing 1:read 2:write
	reg Get_DID, Get_SID;

	//Control Signal for Read/Write Response, Message
	reg [2:0] send_msg, send_msg_d; // 0:NOP 1:MSG 2:READ 3:WRITE 4:PUSHOUT MSG 5: STOPIN MSG
        reg [1:0] rc, rc_d;
	reg [7:0] Actual_data_d, Actual_data;
	reg [7:0] Actual_data_s_d, Actual_data_s;		//number of bytes in read resp
	reg [7:0] Resp_data, Resp_data_d;
	reg [7:0] Msg_addr, Msg_addr_d; // Message address(pushout, stopin)
	reg Send_SID, Send_data;
	
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
		Dest_ID_d = Dest_ID;
		Src_ID_d = Src_ID;
		Addr_d = Addr;
		Addr_index_d = Addr_index;
		data_pkg_d = data_pkg;
		data_index_d = data_index;
		data_full_d = data_full;
		write_perm_d = write_perm;
		read_perm_d = read_perm;
		perm_index_d = perm_index;
		get_r_w_d = get_r_w;
		send_msg_d = send_msg;
		rc_d = rc;
		Actual_data_d = Actual_data;
		Resp_data_d = Resp_data;
		Msg_addr_d = Msg_addr;
		case (current_state_r)
			IDLE_R: begin
				Alen_cnt_d = 0;
				Dlen_cnt_d = 0;
//				Dest_ID_d = 0;
//				Src_ID_d = 0;
				data_full_d = 0;
				if (noc_to_dev_ctl) begin
					case (noc_to_dev_data[2:0])
						3'b001: begin // GET READ
							$display("REEEEEEEEEEEEEEEEEEEAD COMMAND GET!");
							get_r_w_d = 1;
							AD_assignment();
							next_state_r = DEST_R;
						end
						3'b010: begin // GET WRITE
							$display("WRIIIIIIIIIIIIIIIIIITE COMMAND GET!");
							get_r_w_d = 2;
							AD_assignment();
							next_state_r = DEST_R;
						end
						3'b101: begin
							next_state_r = MSG_R;
						end
					endcase
				end
			end
			WRITE: begin
				if (~data_full) begin
					data_pkg_d.Dev[data_index] = noc_to_dev_data;
					data_index_d = data_index + 1;
					Actual_data_d = Actual_data + 1; // Count the actual data length
				end
				if (data_index == 199) begin
					data_index_d = 0;
					data_full_d = 1;
					write_perm_d = 1;
					Actual_data_d = Actual_data + 1;
					if (Dlen_cnt != 1) begin
						$display("PARTIAL READ %d%t", Dlen_cnt, $time);
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
				$display("write_perm:%b  WRITEDATA[%d] = %b%t", write_perm, data_index, data_pkg_d.Dev[data_index], $time);
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
					if (get_r_w == 1) begin
						read_perm_d = 1; // Signal the perm controller to read perm
						next_state_r = IDLE_R;
					end
					else if (get_r_w == 2) begin
						next_state_r = WRITE;
					end
					else begin
						$display("GET READ OR WRITE ERROR");
					end
				end
				$display("Addr[%b] = %b%t", Addr_index, Addr_d[Addr_index], $time);
			end
		endcase
	end

	// State Machine for SENDING DATA
	always @ (posedge clk) begin
		next_state_s = current_state_s;
//		noc_from_dev_ctl_d = noc_from_dev_ctl;
//		noc_from_dev_data_d = noc_from_dev_data;
//		send_msg_d = send_msg;
		pkt_data_len_d = pkt_data_len;
		Actual_data_s_d = Actual_data_s;
		data_index_s_d = data_index_s;
		get_r_w_s_d = get_r_w_s;
		if (send_msg) begin
			//////// Routing responses
//			$display("-----------send msg %b %b", send_msg, current_state_s);
			case (current_state_s)
				IDLE_S: begin
					case (send_msg)
						1: begin
							noc_from_dev_ctl_d = 1;
							noc_from_dev_data_d = 8'b00000101;
							next_state_s = DEST_S;
							get_r_w_s_d = 2;
							$display("MSG ALDL %b%t", noc_from_dev_data_d, $time);
						end
						2: begin
							noc_from_dev_ctl_d = 1;
							noc_from_dev_data_d = {rc, 6'b000011};
							next_state_s = DEST_S;
							get_r_w_s_d = 1;
							$display("READ RSP RC %b%t", noc_from_dev_data_d, $time);
						end
						3: begin
							noc_from_dev_ctl_d = 1;
							noc_from_dev_data_d = {rc, 6'b000100};
							next_state_s = DEST_S;
							get_r_w_s_d = 0;
							$display("WR RSP RC %b%t", noc_from_dev_data_d, $time);
						end
						5: begin
							noc_from_dev_ctl_d = 1;
							noc_from_dev_data_d = 8'b00000101;
							next_state_s = DEST_S;
							get_r_w_s_d = 0;
							$display("EEEEEEEEEEEEEEERRRRRRRRRRRRRR");
						end
					endcase
				end
				READ_RESP: begin
					$display("READ RESPONSE, Actual_data_s = %d @%t", Actual_data_s, $time);	//Actual_data_s: how much data left
					case(Actual_data_s):	//packet: 128 + 64 + 8
						199: begin
							if (data_index_s == 128) begin
								Actual_data_s_d = 71;
								rc_d = 2;
								next_state_s = IDLE_S;
							end else begin
								noc_from_dev_data_d = data_pkg.Dev[data_index_s];
								data_index_s_d = data_index_s + 1;
								next_state_s = READ_RESP;
							end
						end
						71: begin
							if (data_index_s == 192) begin
								Actual_data_s_d = 7;
								rc_d = 2;
								next_state_s = IDLE_S;
							end else begin
								noc_from_dev_data_d = data_pkg.Dev[data_index_s];
								data_index_s_d = data_index_s + 1;
								next_state_s = READ_RESP;
							end
						end
						7: begin
							if (data_index_s == 200) begin
								Actual_data_s_d = 0;
								rc_d = 0;
								next_state_s = IDLE_S;
								$display("200 bytes data response %t", $time);
							end else begin
								noc_from_dev_data_d = data_pkg.Dev[data_index_s];
								data_index_s_d = data_index_s + 1;
								next_state_s = READ_RESP;
							end
						end
						default: $display("Error. Actual Data S is %d %t", Actual_data_s, $time);
					endcase
				end
				MSGADDR: begin
//					noc_from_dev_data_d = 0; // UNCERTAIN
					noc_from_dev_data_d = Msg_addr;
					next_state_s = MSGDATA;
					$display("MSG ADDR %b%t", noc_from_dev_data_d, $time);
				end
				MSGDATA: begin
					noc_from_dev_data_d = Resp_data;
					send_msg_d = 0;
					next_state_s = IDLE_S;
					$display("MSG DATA %b%t", noc_from_dev_data_d, $time);
				end
				DEST_S: begin
					noc_from_dev_ctl_d = 0;
					noc_from_dev_data_d = Src_ID; /////////////////////
					next_state_s = SRC_S;
					if (get_r_w_s == 2) $display("WR RESP DE %b%t", noc_from_dev_data_d, $time);
					else if (get_r_w_s == 1) $display("READ RESP DE %b%t", noc_from_dev_data_d, $time);
					else $display("Error. No such case. DEST_S %b%t", noc_from_dev_data_d, $time);
				end
				SRC_S: begin
					noc_from_dev_data_d = Dest_ID;  /////////////////////
					$display("\n SM %d", send_msg);
					if (send_msg == 1) begin
						Msg_addr_d = 8'h42;
						Resp_data_d = 8'h78;
						next_state_s = MSGADDR;
					end
					else if (send_msg==3 || send_msg==5) begin
						next_state_s = DLENGTH_S;
					end
					//$display("WR RESP SO %b%t", noc_from_dev_data_d, $time);
					if (get_r_w_s == 2) $display("WR RESP SO %b%t", noc_from_dev_data_d, $time);
					else if (get_r_w_s == 1) $display("READ RESP SO %b%t", noc_from_dev_data_d, $time);
					else $display("Error. No such case. SRC_S %b%t", noc_from_dev_data_d, $time);
				end
				DLENGTH_S: begin
					//noc_from_dev_data_d = Actual_data;
					//rc_d = 0;
					if (send_msg == 5) begin // Send a following Message
						send_msg_d = 1;
					end
					else begin
						send_msg_d = 0;
					end
					//Actual_data_d = 0;
					//$display("WR RESP AL %b%t",noc_from_dev_data_d, $time);
					if (get_r_w_s == 2) begin
						$display("WR RESP AL %b%t", noc_from_dev_data_d, $time);
						rc_d = 0;
						noc_from_dev_data_d = Actual_data;
						Actual_data_d = 0;
						next_state_s = IDLE_S;
					end else if (get_r_w_s == 1) begin
						$display("READ RESP AL %b%t", noc_from_dev_data_d, $time);
						case(Actual_data_s):
							199: noc_from_dev_data_d = 128;
							71: noc_from_dev_data_d = 64;
							7: noc_from_dev_data_d = 8;
							default: noc_from_dev_data_d = 0;
						endcase
						next_state_s = READ_RESP;
					end else begin 
						$display("Error. No such case. DLENGTH_S %b%t", noc_from_dev_data_d, $time);
						next_state_s = IDLE_S;
					end
				end
			endcase
		end
	end

	// PUSHOUT AND STOPIN FROM PERM
	always @ (posedge pushout) begin
		send_msg_d = 4;
	end
	always @ (negedge stopin) begin
		send_msg_d = 5;
	end

	// PERM CONTROL
	always @ (posedge clk) begin
		if (write_perm) begin
			firstin_d = (perm_index==0) ? 1 : 0;
			pushin_d = 1;
			din_d = data_pkg.Per[perm_index];
			//////// WRITE TO PERM
//			$display("stopin%b first%b push%b data[%d] = %h%t", stopin, firstin_d, pushin_d, perm_index, din_d, $time);
			perm_index_d = perm_index + 1;
			if (perm_index == 24) begin
				write_perm_d = 0;
				pushin_d = 0;
				din_d = 0;
				perm_index_d = 0;
			end
		end
		if (read_perm) begin
			stopout_d = 0;
			if (firstout) begin
				data_pkg_d.Per[data_index] = dout;
				data_pkg_d.Dev[Actual_data_s] = dout[7:0];
				data_pkg_d.Dev[Actual_data_s+1] = dout[15:8];
				data_pkg_d.Dev[Actual_data_s+2] = dout[23:16];
				data_pkg_d.Dev[Actual_data_s+3] = dout[31:24];
				data_pkg_d.Dev[Actual_data_s+4] = dout[39:32];
				data_pkg_d.Dev[Actual_data_s+5] = dout[47:40];
				data_pkg_d.Dev[Actual_data_s+6] = dout[55:48];
				data_pkg_d.Dev[Actual_data_s+7] = dout[63:56];
				data_index_d = data_index + 1;
				Actual_data_s_d = Actual_data_s + 8;
			end
			else begin
				data_pkg_d.Per[data_index] = dout;
				data_pkg_d.Dev[Actual_data_s] = dout[7:0];
				data_pkg_d.Dev[Actual_data_s+1] = dout[15:8];
				data_pkg_d.Dev[Actual_data_s+2] = dout[23:16];
				data_pkg_d.Dev[Actual_data_s+3] = dout[31:24];
				data_pkg_d.Dev[Actual_data_s+4] = dout[39:32];
				data_pkg_d.Dev[Actual_data_s+5] = dout[47:40];
				data_pkg_d.Dev[Actual_data_s+6] = dout[55:48];
				data_pkg_d.Dev[Actual_data_s+7] = dout[63:56];
				data_index_d = data_index + 1;
				Actual_data_s_d = Actual_data_s + 8;
				if (data_index == 24) begin // PERM READ COMPLETE
					read_perm_d = 0;
					stopout_d = 1;
					data_index_d = 0;
				end
			end
		end
	end


///////////
int i = 41;
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			current_state_r <= IDLE_R;
			current_state_s <= IDLE_S;
			noc_from_dev_ctl <= 0;
			pushin <= 0;
			firstin <= 0;
			stopout <= 1;
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
			data_index_s <= 0;
			data_full <= 0;
			pkt_data_len <= 0;
			write_perm <= 0;
			read_perm <= 0;
			perm_index <= 0;
			get_r_w <= 0;
			get_r_w_s <= 0;
			send_msg <= 0;
			rc <= 0;
			Actual_data <= 0;
			Actual_data_s <= 0;
			Resp_data <= 0;
			Msg_addr <= 0;
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
			Dest_ID <= Dest_ID_d;
			Src_ID <= Src_ID_d;
			Addr <= Addr_d;
			Addr_index <= Addr_index_d;
			data_pkg <= data_pkg_d;
			data_index <= data_index_d;
			data_index_s <= data_index_s_d;
			data_full <= data_full_d;
			pkt_data_len <= pkt_data_len_d;
			write_perm <= write_perm_d;
			read_perm <= read_perm_d;
			perm_index <= perm_index_d;
			get_r_w <= get_r_w_d;
			get_r_w_s <= get_r_w_s_d;
			send_msg <= send_msg_d;
			rc <= rc_d;
			Actual_data <= Actual_data_d;
			Actual_data_s <= Actual_data_S_d;
			Resp_data <= Resp_data_d;
			Msg_addr <= Msg_addr_d;

			if (noc_to_dev_ctl == 1 && i!=0) begin
				$display("ctl%b%d.COMMAND %b%t", noc_to_dev_ctl, i, noc_to_dev_data, $time);
				i-=1;
			end
//			if(dout!=0)
//				$display("DOUT %h%t", dout, $time);
		end
	end
endmodule

