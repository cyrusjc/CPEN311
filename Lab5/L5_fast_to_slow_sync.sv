module fast_to_slow_sync
(
input clk1,
input clk2,
input [11:0] data_in,
output [11:0] data_out
);
	
	logic [11:0] reg1_out, reg3_out;
	logic en, temp;
	
	vDFF #(12) reg1 (data_in,		reg1_out,  	1'b1, 	clk1 );
	vDFF #(12) reg3 (reg1_out, 	reg3_out, 	en,   	clk1, );
	vDFF #(12) reg2 (reg3_out,  	data_out,	1'b1, 	clk2,);
	
	vDFF #(1)  s1 	(clk2, temp,	 1'b1,		~clk1);
	vDFF #(1)  s2 	(temp, en,		 1'b1, 		~clk1);
	
endmodule



module vDFF (D, Q, en, clk);

	parameter n = 12;
	
	input [n-1:0] D;
	input en;
	input clk;
	
	output reg [n-1: 0] Q;
	
	always_ff@(posedge clk)
		if(en) 		Q <= D;
		else 				Q <= D;
	
endmodule

