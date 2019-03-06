module HW_tb();
	reg async_sig, outclk;
	wire out_sync_sig;

	Q7_top DUT(async_sig, outclk, out_sync_sig);

	initial forever begin
		outclk = 0; #5;
		 outclk = 1; #5;
	end
	
	initial begin
		#5;
		async_sig=1;
		#5;
		async_sig=0;
		#100;
		async_sig=1;
		#5;
		async_sig=0;
		#5;
		async_sig=1;
		#5;
		async_sig=0;
		#5
		async_sig=1;
		#5;
		async_sig=0;
		#5;
		async_sig=1;
		#5;
		async_sig=0;
		#5
		async_sig=1;
		#5;
		async_sig=0;
		#5;
		async_sig=1;
		#5;
		async_sig=0;
		#5
		async_sig=1;
		#5;
		async_sig=0;
		#5;
	end
endmodule
