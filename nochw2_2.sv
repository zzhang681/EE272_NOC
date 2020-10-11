`timescale 1ns/10ps

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
	output reg [63:0] dout
);

	// State Machine       //Edited Oct/10/20:51 ZZ
	enum reg [3:0] {
		//IDLE,
		NOP,          //00000000
		Read,         //AADDD001
		Write,        //010
		Read_resp,    //011
		Write_resp,   //100
		Message      //101
//		,Res1         //110
//		,Res2          //111
	} current_state, next_state;

	// I/O Buffer
	reg noc_from_dev_ctl_d, pushin_d, firstin_d, stopout_d;
	reg [7:0] noc_from_dev_data_d;
	reg [63:0] din_d, dout_d;

	//NOC Message Info
	reg [1:0] Alen;
	reg [3:0] Atimes_d, Atimes;
	reg [2:0] Dlen;
	reg [7:0] Dtimes_d, Dtimes;

	//Control Signal for Read/Write Command
	reg Get_DID, Get_SID;

	//NOC Dest and Src
	reg [7:0] Dest_ID, Src_ID;

	//Address of Read/Write Command
	reg [7:0][7:0] Addr;
	reg [2:0] Addr_pos_d, Addr_pos;

	//Read/Write Data
	union packed {
		reg [199:0][7:0] Dev;
		reg [24:0][63:0] Per;
	} data_in;
	reg [7:0] Din_pos_d, Din_pos;

	//Control Signal for Read/Write Response
	reg Send_SID, Send_data;
	reg [7:0] Actual_data_d, Actual_data;
	reg [7:0] Resp_data;
    
    
    initial begin
        current_state = NOP;
        next_state = NOP;
    end
    
    //next_state logic
    always @(posedge clk) begin
        next_state <= current_state;
        case(current_state)
            NOP: begin
                if(noc_from_dev_ctl) begin
                    case(noc_from_dev_data[2:0])        //least 3 bits of packet head
                        3'b001: next_state <= Read;
                        3'b010: next_state <= Write;
                        3'b011: next_state <= Read_resp;
                        3'b100: next_state <= Write_resp;
                        3'b101: next_state <= Message;
                        default: next_state <= NOP;
                    endcase
                end else next_state <= NOP;
            end
            
            Read: begin
                //read operation
                //Alen+Dlen, Dest_ID, Src_ID, Addr(1-8bytes)
            end
            
            Write: begin
                //write operation
                //Alen+Dlen, Dest_ID, Src_ID, Addr(1-8bytes), write data(?)
            end
            
            Read_resp: begin
                //read response
                //RC+000, Dest_ID, Src_ID, Addr(1-8bytes), Actual_data, Resp_data
            end
            
            Write_resp: begin
                //write response
                //RC+000, Dest_ID, Src_ID, Addr(1-8bytes), Actual_data
            end
            
            Message: begin
                //message
                //AL+Dlen, Dest_ID, Src_ID, message addr(?), message data(?)
            end
            
            //some states for further ops
            
            default: next_state <= NOP;
        endcase
    end
    
    //take care everything except next_state
    always @(*) begin
        case(current_state)
            NOP: begin
            end
            
            Read: begin
                //read operation
                //Alen+Dlen, Dest_ID, Src_ID, Addr(1-8bytes)
            end
            
            Write: begin
                //write operation
                //Alen+Dlen, Dest_ID, Src_ID, Addr(1-8bytes), write data(?)
            end
            
            Read_resp: begin
                //read response
                //RC+000, Dest_ID, Src_ID, Addr(1-8bytes), Actual_data, Resp_data
            end
            
            Write_resp: begin
                //write response
                //RC+000, Dest_ID, Src_ID, Addr(1-8bytes), Actual_data
            end
            
            Message: begin
                //message
                //AL+Dlen, Dest_ID, Src_ID, message addr(?), message data(?)
            end
            
            //some states for further ops
            
            default: begin
            end
        endcase
    end
    
    
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			current_state <= NOP;
			noc_from_dev_ctl <= 0;
			pushin <= 0;
			firstin <= 0;
			stopout <= 0;
			noc_from_dev_data <= 0;
			din <= 0;
			dout <= 0;
		end
		else begin
			current_state <= next_state;
			noc_from_dev_ctl <= noc_from_dev_ctl_d;
			pushin <= pushin_d;
			firstin <= firstin_d;
			stopout <= stopout_d;
			noc_from_dev_data <= noc_from_dev_data_d;
			din <= din_d;
			dout <= dout_d;
		end
	end
endmodule

