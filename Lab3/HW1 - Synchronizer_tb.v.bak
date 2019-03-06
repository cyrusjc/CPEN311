module HW_tb();
	reg async_sig, outclk;
	wire out_sync_sig;

	Synchronizer DUT(async_sig, outclk, out_sync_sig);

	initial forever begin
		outclk = 0; #5;
		 outclk = 1; #5;
	end
	
	initial begin
		async_sig = 0;
		forever begin
			async_sig = 0;#89;
			async_sig = 1;#89;
		end
	end
endmodule
