`define S0 5'b0
`define S1 5'b10
`define S2 5'b11
`define S3 5'b100
`define S4 5'b101
`define S5 5'b110
`define S6 5'b111
`define S7 5'b1000
`define S8 5'b1001
`define S9 5'b1011
`define S10 5'b1100
`define S11 5'b1111
`define S12 5'b10000
`define S13 5'b10001
`define S14 5'b10010
`define S15 5'b10011
`define S16 5'b10100
`define S17 5'b10101


module FSM_logic (clk, q);
	
	parameter m = 10;
	
	input clk;
	output reg [m-1:0] q;
	
	reg [4:0] state, nextstate;

	initial begin
		state <= 5'b1;
	end
	
	always @(*) begin
		case (state)
			`S0:	begin nextstate = `S1; q = 10'b1; end
			`S1:	begin nextstate = `S2; q = 10'b10; end
			`S2:	begin nextstate = `S3; q = 10'b100; end
			`S3:	begin nextstate = `S4; q = 10'b1000; end
			`S4:	begin nextstate = `S5; q = 10'b10000; end
			`S5:	begin nextstate = `S6; q = 10'b100000; end
			`S6:	begin nextstate = `S7; q = 10'b1000000; end
			`S7:	begin nextstate = `S8; q = 10'b10000000; end
			`S8:	begin nextstate = `S9; q = 10'b100000000; end
			`S9:	begin nextstate = `S10; q = 10'b1000000000; end
			`S10:	begin nextstate = `S11; q = 10'b100000000; end
			`S11:	begin nextstate = `S12; q = 10'b10000000; end
			`S12:	begin nextstate = `S13; q = 10'b1000000; end
			`S13:	begin nextstate = `S14; q = 10'b100000; end
			`S14:	begin nextstate = `S15; q = 10'b10000; end
			`S15:	begin nextstate = `S16; q = 10'b1000; end
			`S16:	begin nextstate = `S17; q = 10'b100; end
			`S17:	begin nextstate = `S0; q = 10'b10; end

			default: begin nextstate = `S0; q =10'b1; end
		endcase
	end
	
	always @(posedge clk) begin
		state <= nextstate;
	end
	
endmodule

