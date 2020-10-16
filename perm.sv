//`include "m55.sv"
module perm_blk (
	input clk,
	input rst,
	input pushin,
	output reg stopin,
	input firstin,
	input [63:0] din,
	output reg [2:0] m1rx,
	output reg [2:0] m1ry,
	input [63:0] m1rd,
	output reg [2:0] m1wx,
	output reg [2:0] m1wy,
	output reg m1wr,
	output reg [63:0] m1wd,
	output reg [2:0] m2rx,
	output reg [2:0] m2ry,
	input [63:0] m2rd,
	output reg [2:0] m2wx,
	output reg [2:0] m2wy,
	output reg m2wr,
	output reg [63:0] m2wd,
	output reg [2:0] m3rx,
	output reg [2:0] m3ry,
	input [63:0] m3rd,
	output reg [2:0] m3wx,
	output reg [2:0] m3wy,
	output reg m3wr,
	output reg [63:0] m3wd,
	output reg [2:0] m4rx,
	output reg [2:0] m4ry,
	input [63:0] m4rd,
	output reg [2:0] m4wx,
	output reg [2:0] m4wy,
	output reg m4wr,
	output reg [63:0] m4wd,
	output reg pushout,
	input stopout,
	output reg firstout,
	output reg [63:0] dout);
	
	reg [63:0] m1wd_d, m2wd_d, m3wd_d, m4wd_d;
	reg [2:0] m1rx_d, m1ry_d, m1wx_d, m1wy_d, m1wr_d, m2rx_d, m2ry_d, m2wx_d, m2wy_d, m2wr_d, m3rx_d, m3ry_d, m3wx_d, m3wy_d, m3wr_d, m4rx_d, m4ry_d, m4wx_d, m4wy_d, m4wr_d;
	reg [4:0][63:0] theta_c = 0;
	reg [5:0] roundc, roundc_d;
	reg [2:0] rcnum, rcnum_d;
	reg [8:0] rc, rc_d;
	reg f_set, f_set_d;

	enum reg [4:0] {
		IDLE,
		DATA_IN,
		THETA_C,
		BUFFER_1,
		BUFFER_T,
		THETA_D_RHO_PI,
		CHI_1,
		BUFFER_2,
		BUFFER_3,
		CHI_2,
		BUFFER_4,
		IOTA,
		BUFFER_5,
		BUFFER_6,
		CLEAN,
		DATA_OUT,
		BUFFER_7,
		BUFFER_8,
		OVERFLOW,
		BUFFER_9
	} current_state, next_state;

/*	m55 in_buffer (clk, rst, m1rx, m1ry, m1rd, m1wx, m1wy, m1wr, m1wd);
	m55 out_buffer (clk, rst, m2rx, m2ry, m2rd, m2wx, m2wy, m2wr, m2wd);
	m55 work_mem1 (clk, rst, m3rx, m3ry, m3rd, m3wx, m3wy, m3wr, m3wd);
	m55 work_mem2 (clk, rst, m4rx, m4ry, m4rd, m4wx, m4wy, m4wr, m4wd);
*/
	always @ (*) begin
		next_state = current_state;
		dout = 64'b0;
		stopin = 1;
		pushout = 0;
		firstout = 0;
		m1wx_d = m1wx;
		m1wy_d = m1wy;
		m1wr_d = m1wr;
		m1wd_d = m1wd;
		m1rx_d = m1rx;
		m1ry_d = m1ry;
		m2wx_d = m2wx;
		m2wy_d = m2wy;
		m2wr_d = m2wr;
		m2wd_d = m2wd;
		m2rx_d = m2rx;
		m2ry_d = m2ry;
		m3wx_d = m3wx;
		m3wy_d = m3wy;
		m3wr_d = m3wr;
		m3wd_d = m3wd;
		m3rx_d = m3rx;
		m3ry_d = m3ry;
		m4wx_d = m4wx;
		m4wy_d = m4wy;
		m4wr_d = m4wr;
		m4wd_d = m4wd;
		m4rx_d = m4rx;
		m4ry_d = m4ry;
		roundc_d = roundc;
		rcnum_d = rcnum;
		rc_d = rc;
		f_set_d = f_set;
//		$display("---x:%b y:%b DATA:%h STOP:%b 1st:%b DIN:%h%t", m1wx, m1wy, m1wd, stopin, firstin, din, $time);
		case (current_state)
			IDLE: begin
				f_set_d = 1;
				if (pushin && firstin) begin
					stopin = 0;
					m1wx_d = 3'b000;
					m1wy_d = 3'b000;
					m1wr_d = 1;
					m1wd_d = din; // WRITE DATA TO INPUT BUFFER
					m2wr_d = 1;
					m2wd_d = 0; // CLEANING DATA IN M2
					m3wr_d = 1;
					m3wd_d = 0; // CLEANING DATA IN M3
					next_state = DATA_IN;
				end
				$display("[PERM] 1st%b x%b y%b DIN:%h%t", firstin, m1wx_d, m1wy_d, din, $time);
			end
			DATA_IN: begin
//				$display("---pushin:%b m1x:%b m1y:%b D:%h", pushin, m1wx, m1wy, m1wd);
				if (pushin) begin
					stopin = 0;
					m1wx_d = m1wx + 3'b001;
					m2wx_d = m2wx + 3'b001;
					m3wx_d = m3wx + 3'b001;
					if (m1wx == 3'b100) begin
						m1wy_d = m1wy + 3'b001;
						m2wy_d = m2wy + 3'b001;
						m3wy_d = m3wy + 3'b001;
						if (m1wy == 3'b100) begin
							m1wx_d = 0;
							m1wy_d = 0;
							m2wx_d = 0;
							m2wy_d = 0;
							m3wx_d = 0;
							m3wy_d = 0;
							m1wr_d = 0;
							m2wr_d = 0;
							m3wr_d = 0;
							stopin = 1; 
							next_state = THETA_C;
						end
						else begin
							m1wx_d = 3'b000;
							m1wr_d = 1;
							m1wd_d = din;
							m2wx_d = 3'b000;
							m2wr_d = 1;
							m2wd_d = 64'b0;
							m3wx_d = 3'b000;
							m3wr_d = 1;
							m3wd_d = 64'b0;
							$display("[PERM] 1st%b x%b y%b DIN:%h%t", firstin, m1wx_d, m1wy_d, din, $time);
						end
					end
					else begin
//						if (m1wx==3'b010 && m1wy==3'b100)  //STOP INPUT BEFORE 100/100
//							stopin = 1;
						m1wr_d = 1;
						m1wd_d = din;
						m2wr_d = 1;
						m2wd_d = 64'b0;
						m3wr_d = 1;
						m3wd_d = 64'b0;
						$display("[PERM] 1st%b x%b y%b DIN:%h%t", firstin, m1wx_d, m1wy_d, din, $time);
					end
//					$display("x:%b y:%b m1:%h%t", m1wx, m1wy, m1wd, $time);
				end
				else begin
					m2rx_d = 0;
					m2ry_d = 0;
					m2wx_d = 0;
					m2wy_d = 0;
					m2wr_d = 1;
					next_state = THETA_C;
				end
//				$display("M1 %b %b %h", m1wx, m1wy, m1wd);
			end
			THETA_C: begin
//				$display("M1 x%b y%b | %b%t", m1rx, m1ry, m1rd, $time);
//				$display("M2 x%b y%b | %b%t", m2rx, m2ry, m2rd, $time);
//				if (roundc == 0)
//					$display("round:%d x:%b y:%b m1rd:%h | 2x:%b 2y:%b m2rd:%h 2wr:%b| TH[%b]:%h%t", roundc, m1rx, m1ry, m1rd, m2rx, m2ry, m2rd, m2wr, m1rx, theta_c[m1rx], $time);
//////////////////////////////// CHECK THETA_C				
//				$display("theta[%b] %h | vm2wd %h | x%b y%b m2rd %h | m1rd %h%t", m1rx, theta_c[m1rx], m2wd_d, m2rx, m2ry, m2rd, m1rd, $time);
				if ((m1ry!=3'b100 && roundc==0) || (roundc!=0) || (f_set==0)) begin
					theta_c[m1rx] = m2rd ^ m1rd;
				end
				m2wr_d = 1;
				m2wd_d = theta_c[m1rx];
				next_state = BUFFER_1;
//				$display("m2rd%h m2rx%b m2ry%b m1rd%h m1rx%b m1ry%b", m2rd, m2rx, m2ry, m1rd, m1rx, m1ry);	
				m1ry_d = m1ry + 3'b001;
				if (m1ry == 3'b100) begin
					m2wd_d = 0;
					m1ry_d = 0;
					m1rx_d = m1rx + 1;
					m2rx_d = m2rx + 1;
					m2wx_d = m2wx + 1;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = 0;
						m2wr_d = 0;
						m2wx_d = 0;
						m2rx_d = 0;
						next_state = THETA_D_RHO_PI;
					end
				end
//				$display("1x:%b 1y:%b | m2wd_d %h | m2rd %h | m1rd %h%t", m1rx, m1ry, m2wd_d, m2rd, m1rd, $time);
//				$display("theta_c[%b]:%h%t", m1rx, theta_c[m1rx], $time);
			end
			BUFFER_1: begin
				next_state = THETA_C;
			end
/*			BUFFER_T: begin
//////////////////////////////// CHECK OUTPUT FROM THETA_C 
//				$display("x%b y%b | %h%t", m1rx, m1ry, m1rd, $time);
//				$display("x%b y%b | %h%t", m2rx, m2ry, m2rd, $time);
//				$display("x%b y%b | %h%t\n", m3rx, m3ry, m3rd, $time);
				m1ry_d = m1ry + 1;
				m2ry_d = m2ry + 1;
				m3ry_d = m3ry + 1;
				if (m1ry == 3'b100) begin
					m1ry_d = 0;
					m2ry_d = 0;
					m3ry_d = 0;
					m1rx_d = m1rx + 1;
					m2rx_d = m2rx + 1;
					m3rx_d = m3rx + 1;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = 0;
						m2rx_d = 0;
						m2ry_d = 0;
						m3rx_d = 0;
						m3ry_d = 0;
						next_state = THETA_D_RHO_PI;
					end
				end
			end
*/			THETA_D_RHO_PI: begin
/*				$display("theta_c[%b] %h | m2rd %h%t", vm1rx, theta_c[vm1rx], m2rd, $time);
//				m1rx_d = vm1rx + 1;
				m2rx_d = vm2rx + 1;
				if (vm1rx==3'b101) begin
					m1rx_d = 0;
					next_state = RHO;
				end
				$display("%b %b %b", m1rx_d, m1rx, m1ry);
*/
				m3wr_d = 1;
				case (m1rx)
					3'b000: begin
						m3wd_d = (theta_c[4] ^ {theta_c[1][62:0], theta_c[1][63]}) ^ m1rd;
					end
					3'b100: begin
						m3wd_d = (theta_c[3] ^ {theta_c[0][62:0], theta_c[0][63]}) ^ m1rd;
					end
					default: begin
						m3wd_d = (theta_c[m1rx-1] ^ {theta_c[m1rx+1][62:0], theta_c[m1rx+1][63]}) ^ m1rd;
					end
				endcase
//				$display("m3wd_d %h | m1rd %h x%b y%b", m3wd_d, m1rd, m1rx, m1ry);
				// THETA ENDS
				case (m1rx)
					0: begin
						case (m1ry)
							0: begin
								m2wd_d = m3wd_d;
								m3wx_d = 0;
								m3wy_d = 0;
							end
							1: begin
								m2wd_d = {m3wd_d[27:0], m3wd_d[63:28]};
								m3wx_d = 1;
								m3wy_d = 3;
							end
							2: begin
								m2wd_d = {m3wd_d[60:0], m3wd_d[63:61]};
								m3wx_d = 2;
								m3wy_d = 1;
							end
							3: begin
								m2wd_d = {m3wd_d[22:0], m3wd_d[63:23]};
								m3wx_d = 3;
								m3wy_d = 4;
							end
							4: begin
								m2wd_d = {m3wd_d[45:0], m3wd_d[63:46]};
								m3wx_d = 4;
								m3wy_d = 2;
							end
							default: begin
								$display("CASE ERROR 1");
							end
						endcase
					end
					1: begin
						case (m1ry)
							0: begin
								m2wd_d = {m3wd_d[62:0], m3wd_d[63]};
								m3wx_d = 0;
								m3wy_d = 2;
							end
							1: begin
								m2wd_d = {m3wd_d[19:0], m3wd_d[63:20]};
								m3wx_d = 1;
								m3wy_d = 0;
							end
							2: begin
								m2wd_d = {m3wd_d[53:0], m3wd_d[63:54]};
								m3wx_d = 2;
								m3wy_d = 3;
							end
							3: begin
								m2wd_d = {m3wd_d[18:0], m3wd_d[63:19]};
								m3wx_d = 3;
								m3wy_d = 1;
							end
							4: begin
								m2wd_d = {m3wd_d[61:0], m3wd_d[63:62]};
								m3wx_d = 4;
								m3wy_d = 4;
							end
							default: begin
								$display("CASE ERROR 1");
							end
						endcase
					end
					2: begin
						case (m1ry)
							0: begin
								m2wd_d = {m3wd_d[1:0], m3wd_d[63:2]};
								m3wx_d = 0;
								m3wy_d = 4;
							end
							1: begin
								m2wd_d = {m3wd_d[57:0], m3wd_d[63:58]};
								m3wx_d = 1;
								m3wy_d = 2;
							end
							2: begin
								m2wd_d = {m3wd_d[20:0], m3wd_d[63:21]};
								m3wx_d = 2;
								m3wy_d = 0;
							end
							3: begin
								m2wd_d = {m3wd_d[48:0], m3wd_d[63:49]};
								m3wx_d = 3;
								m3wy_d = 3;
							end
							4: begin
								m2wd_d = {m3wd_d[2:0], m3wd_d[63:3]};
								m3wx_d = 4;
								m3wy_d = 1;
							end
							default: begin
								$display("CASE ERROR 1");
							end
						endcase
					end
					3: begin
						case (m1ry)
							0: begin
								m2wd_d = {m3wd_d[35:0], m3wd_d[63:36]};
								m3wx_d = 0;
								m3wy_d = 1;
							end
							1: begin
								m2wd_d = {m3wd_d[8:0], m3wd_d[63:9]};
								m3wx_d = 1;
								m3wy_d = 4;
							end
							2: begin
								m2wd_d = {m3wd_d[38:0], m3wd_d[63:39]};
								m3wx_d = 2;
								m3wy_d = 2;
							end
							3: begin
								m2wd_d = {m3wd_d[42:0], m3wd_d[63:43]};
								m3wx_d = 3;
								m3wy_d = 0;
							end
							4: begin
								m2wd_d = {m3wd_d[7:0], m3wd_d[63:8]};
								m3wx_d = 4;
								m3wy_d = 3;
							end
							default: begin
								$display("CASE ERROR 1");
							end
						endcase
					end
					4: begin
						case (m1ry)
							0: begin
								m2wd_d = {m3wd_d[36:0], m3wd_d[63:37]};
								m3wx_d = 0;
								m3wy_d = 3;
							end
							1: begin
								m2wd_d = {m3wd_d[43:0], m3wd_d[63:44]};
								m3wx_d = 1;
								m3wy_d = 1;
							end
							2: begin
								m2wd_d = {m3wd_d[24:0], m3wd_d[63:25]};
								m3wx_d = 2;
								m3wy_d = 4;
							end
							3: begin
								m2wd_d = {m3wd_d[55:0], m3wd_d[63:56]};
								m3wx_d = 3;
								m3wy_d = 2;
							end
							4: begin
								m2wd_d = {m3wd_d[49:0], m3wd_d[63:50]};
								m3wx_d = 4;
								m3wy_d = 0;
							end
							default: begin
								$display("CASE ERROR 1");
							end
						endcase
					end
					default: begin
						$display("CASE ERROR 2");
					end
				endcase
				m3wd_d = m2wd_d;
//				$display("%b %b %h%t", m3wx_d, m3wy_d, m3wd_d, $time);

				m1ry_d = m1ry + 3'b001;
				if (m1ry == 3'b100) begin
					m1rx_d = m1rx + 1;
					m1ry_d = 0;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = 0;
						next_state = CHI_1;
					end
				end
			end
			CHI_1: begin
//				$display("%b %h %b %h", m3rx, theta_c[m3rx], m3ry, m3rd);
				m1wr_d = 0;
				m3wx_d = 0;
				m3wy_d = 0;
				m3wr_d = 0;
//////////////////////////////// CHECK OUTPUT FROM RHO-PI
/*				$display("x%b y%b | %h%t", m3rx, m3ry, m3rd, $time);
				m3ry_d = m3ry + 1;
				if (m3ry == 3'b100) begin
					m3ry_d = 0;
					m3rx_d = m3rx + 1;
					if (m3rx == 3'b100) begin
						m3rx_d = 0;
						m3ry_d = 0;
						next_state = CHI_2;
					end
				end
*/		
//				$display("U| %b %b %h%t", m3rx, m3ry, m3rd, $time);
				case (m3rx)
					0: begin
						theta_c[3] = m3rd;
						theta_c[4] = ~m3rd;
					end
					1: begin
						theta_c[4] = theta_c[4] & m3rd;
						theta_c[0] = ~m3rd;
					end
					2: begin
						theta_c[0] = theta_c[0] & m3rd;
						theta_c[1] = ~m3rd;
					end
					3: begin
						theta_c[1] = theta_c[1] & m3rd;
						theta_c[2] = ~m3rd;
					end
					4: begin
						theta_c[2] = theta_c[2] & m3rd;
						theta_c[3] = (~m3rd) & theta_c[3];
					end
					default: begin
						$display("CASE ERROR 3");
					end
				endcase
//				$display("D| %h %h %h %h %h%t", theta_c[0], theta_c[1], theta_c[2], theta_c[3], theta_c[4], $time);
				m3rx_d = m3rx + 1;
				if (m3rx == 3'b100) begin
					m3rx_d = 0;
					next_state = CHI_2;
				end
				else begin
					next_state = BUFFER_2;
				end
			end
			BUFFER_2: begin
				next_state = BUFFER_3;
			end
			BUFFER_3: begin
				next_state = CHI_1;
			end
			CHI_2: begin
//				$display("%h %h %h %h %h", theta_c[0], theta_c[1], theta_c[2], theta_c[3], theta_c[4]);
				m1wr_d = 1;
				m2wr_d = 1;
				m1wd_d = theta_c[m3rx] ^ m3rd;
				m1wx_d = m3rx;
				m1wy_d = m3ry;
				if (m1wx==0 & m1wy==0) begin
					m2wd_d = m1wd;
//					$display("%b %b %h %h", m2wx, m2wy, m2wd_d, vm1wd);	
				end
				m3rx_d = m3rx + 1;
				if (m3rx == 4'b100) begin
					m3rx_d = 0;
					m3ry_d = m3ry + 1;
					if (m3ry == 4'b100) begin
						m2wr_d = 0;
						m3rx_d = 0;
						m3ry_d = 0;
//						$display("%b %b %b", m2wx, m2wy, m2wd);
						next_state = BUFFER_4;
					end
					else begin
						next_state = CHI_1;
					end
				end
			end
			BUFFER_4: begin
				m1wr_d = 0;
				m1wx_d = 0;
				m1wy_d = 0;
				next_state = IOTA;
			end
			IOTA: begin
//////////////////////////////// CHECK OUTPUT FROM CHI 
/*				$display("x%b y%b | %h%t", m1rx, m1ry, m1rd, $time);
				m1ry_d = m1ry + 1;
				if (m1ry == 3'b100) begin
					m1ry_d = 0;
					m1rx_d = m1rx + 1;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = 0;
						next_state = DATA_OUT;
					end
				end
*/			

				if (rcnum == 0) begin
					theta_c[0] = 0;
				end
//				$display("1 rc[0]:%b%t", rc[0], $time);
				if (rc[8]) begin
					rc_d[0] = ~rc[0];
					rc_d[4] = ~rc[4];
					rc_d[5] = ~rc[5];
					rc_d[6] = ~rc[6];
				end
//				$display("2 rc[0]:%b%t", rc[0], $time);
//				$display("1 %b%t", rc_d, $time);
				rc_d = rc_d << 1;
//				$display("2 %b%t", rc_d, $time);	
				if (roundc==0 && rcnum==0) begin
					rc_d = 9'b000000010;
					theta_c[0] = 1;
				end
				rcnum_d = rcnum + 1;
//				$display("rcnum:%b rcnum_d:%b THETA_C:%h%t", rcnum, rcnum_d, theta_c[0], $time);

				if (rc_d[1]) begin
					case(rcnum_d)
						1: theta_c[0] = 1;
						2: theta_c[0][1] = 1;
						3: theta_c[0][3] = 1;
						4: theta_c[0][7] = 1;
						5: theta_c[0][15] = 1;
						6: theta_c[0][31] = 1;
						7: begin
							theta_c[0][63] = 1;
							roundc_d = roundc + 1;
							if (roundc < 23)
								next_state = BUFFER_5;
							else
								next_state = BUFFER_6;
							m1wr_d = 1;
							m1wd_d = m2rd ^ theta_c[0];
							m1wx_d = 0;
							m1wy_d = 0;
							m1rx_d = 0;
							m1ry_d = 0;
							rcnum_d = 0;
						end
						default: begin
							$display("CASE ERROR 4 | %b", rcnum);
						end
					endcase
				end
				else if (rcnum_d == 7) begin
					roundc_d = roundc + 1;
					if (roundc < 23)
						next_state = BUFFER_5;
					else
						next_state = BUFFER_6;
					m1wr_d = 1;
					m1wd_d = m2rd ^ theta_c[0];
					m1wx_d = 0;
					m1wy_d = 0;
					m1rx_d = 0;
					m1ry_d = 0;
					rcnum_d = 0;
				end
			end	
			BUFFER_5: begin
				theta_c = 0;
				m2wr_d = 1;
				m2wd_d = 0;	
				m2wx_d = 0;
				m2wy_d = 0;		
				m3wr_d = 1;
				m3wd_d = 0;
				m3wx_d = 0;
				m3wy_d = 0;
				next_state = CLEAN;
			end
			BUFFER_6: begin
				roundc_d = 0;
				m1wr_d = 0;
				m1wx_d = 0;
				m1wy_d = 0;
				firstout = 1;
				next_state = DATA_OUT;
//				$display("1st %b OUT %h%t", firstout, dout, $time);
			end
			CLEAN: begin
				m2wd_d = 0;
				m3wd_d = 0;
				m2wx_d = m2wx + 1;
				m3wx_d = m3wx + 1;
				if (m2wx == 3'b100) begin
					m2wx_d = 0;
					m3wx_d = 0;
					m2wy_d = m2wy + 1;
					m3wy_d = m3wy + 1;
					if (m2wy == 3'b100) begin
						m2wy_d = 0;
						m3wy_d = 0;
						next_state = THETA_C;
					end
				end
//				$display("%b", theta_c);
			end
			DATA_OUT: begin
//				next_state = DATA_OUT;
//////////////////////////////// CHECK OUTPUT FROM IOTA 
//				$display("OUTM1 x%b y%b | %h%t", m1rx, m1ry, m1rd, $time);
//				$display("OUTM2 x%b y%b | %h%t", m2rx, m2ry, m2rd, $time);
//				$display("OUTM3 x%b y%b | %h%t\n", m3rx, m3ry, m3rd, $time);
/*				m1ry_d = m1ry + 1;
				m2ry_d = m2ry + 1;
				m3ry_d = m3ry + 1;
				if (m1ry == 3'b100) begin
					m1ry_d = 0;
					m2ry_d = 0;
					m3ry_d = 0;
					m1rx_d = m1rx + 1;
					m2rx_d = m2rx + 1;
					m3rx_d = m3rx + 1;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = 0;
						m2rx_d = 0;
						m2ry_d = 0;
						m3rx_d = 0;
						m3ry_d = 0;
						next_state = BUFFER_8;
					end
				end
*/		
//				$display("STOP %b", stopout);
				if (!stopout) begin
					pushout = 1;
					if (m1rx==0 && m1ry==0) begin
						firstout = 1;
					end
					else
						firstout = 0;
					dout = m1rd;
					m1rx_d = m1rx + 1;
					if (m1rx == 3'b100) begin
						m1rx_d = 0;
						m1ry_d = m1ry + 1;
						if (m1ry == 3'b100) begin
							m1ry_d = 0;
							next_state = BUFFER_8;
						end
					end
				end
				else begin
					pushout = 0;
				end
/////////////////////////////// OUTPUT				
				$display("PERM OUT 1st%b pushout%b OUT:%h%t", firstout, pushout, dout, $time);
			end
//			BUFFER_7: begin
//				if (m1rx!=0 || m1ry!=0) begin
//					$display("1 out %b%t", firstout, $time);
//					firstout = 0;
//				end
//				next_state = DATA_OUT;
//			end
			BUFFER_8: begin
				pushout = 0;
				next_state = IDLE;
			end
/*			BUFFER_9: begin
				m1wx_d = m1wx + 3'b001;
				m2wx_d = m2wx + 3'b001;
				m3wx_d = m3wx + 3'b001;
				m1wd_d = din;
				m2wr_d = 0;
				m3wd_d = 0;
				stopin = 0;
				next_state = DATA_IN;
			end
*/			default:
				$display("STATE MACHINE ERROR AT %b %b | %t", current_state, next_state, $time);
		endcase
	end

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			current_state <= IDLE;
			stopin <= 1;
			pushout <= 64'b0;
			firstout <= 0;
			dout <= 64'b0;
			m1wx <= 0;
			m1wy <= 0;
			m1wr <= 0;
			m1wd <= 0;
			m1rx <= 0;
			m1ry <= 0;
			m2wx <= 0;
			m2wy <= 0;
			m2wr <= 0;
			m2wd <= 0;
			m2rx <= 0;
			m2ry <= 0;
			m3wx <= 0;
			m3wy <= 0;
			m3wr <= 0;
			m3wd <= 0;
			m3rx <= 0;
			m3ry <= 0;
			m4wx <= 0;
			m4wy <= 0;
			m4wr <= 0;
			m4wd <= 0;
			m4rx <= 0;
			m4ry <= 0;
			roundc <= 0;
			rcnum <= 0;
			rc <= 0;
			f_set <= 0;
		end
		else begin
			current_state <= next_state;
			m1wx <= m1wx_d;
			m1wy <= m1wy_d;
			m1wr <= m1wr_d;
			m1wd <= m1wd_d;
			m1rx <= m1rx_d;
			m1ry <= m1ry_d;
			m2wx <= m2wx_d;
			m2wy <= m2wy_d;
			m2wr <= m2wr_d;
			m2wd <= m2wd_d;
			m2rx <= m2rx_d;
			m2ry <= m2ry_d;
			m3wx <= m3wx_d;
			m3wy <= m3wy_d;
			m3wr <= m3wr_d;
			m3wd <= m3wd_d;
			m3rx <= m3rx_d;
			m3ry <= m3ry_d;
			m4wx <= m4wx_d;
			m4wy <= m4wy_d;
			m4wr <= m4wr_d;
			m4wd <= m4wd_d;
			m4rx <= m4rx_d;
			m4ry <= m4ry_d;
			roundc <= roundc_d;
			rcnum <= rcnum_d;
			rc <= rc_d;
			f_set <= f_set_d;
		end
	end

endmodule : perm_blk
