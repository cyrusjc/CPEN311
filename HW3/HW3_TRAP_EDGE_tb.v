module trap_edge_tb();
	reg async_sig, clk, reset;
	wire trapped_edge;

	trap_edge DUT(async_sig, clk, reset, trapped_edge);

	initial forever begin
		clk = 0; #5;
		clk = 1; #5;
	end
		
	initial begin
		async_sig = 0;
		reset = 0;#2
		async_sig = 1;#1;
		async_sig = 0;#1;
		#50;
		reset = 1; #1;
		#20
		$stop;
	
	end
		
endmodule
