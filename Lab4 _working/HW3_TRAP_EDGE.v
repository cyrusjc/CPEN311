module trap_edge(async_sig, clock, reset, trapped_edge);
	input async_sig, clock, reset;
	output reg trapped_edge;
	
	reg trap;

	always@(posedge async_sig or posedge reset)
		if (reset) trap <= 0;
		else trap <= 1;

	always @(posedge clock) trapped_edge = trap;
		
endmodule
