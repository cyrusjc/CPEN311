module fast_to_slow_sync
(
input clk1,
input clk2,
input [11:0] data_in,
output [11:0] data_out
);
	
	logic [11:0] reg1_out, reg3_out;
	logic en, temp;
	
	vDFF #(12) reg1 (data_in,  1'b1, clk1, reg1_out);
	vDFF #(12) reg3 (reg1_out, en,   clk1, reg3_out);
	vDFF #(12) reg2 (reg3_out, 1'b1, clk2, data_out);
	
	vDFF #(1)  s1 	(clk2, 1'b1, ~clk1, temp);
	vDFF #(1)  s2 	(temp, 	  1'b1, ~clk1, en);
	
endmodule