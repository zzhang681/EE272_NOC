module nochw2 (
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

	// State Machine
	enum reg [3:0] {
		IDLE
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

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			current_state <= IDLE;
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
			pushin <=
		end
	end
endmodule

