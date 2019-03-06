module Q7_top(async_sig, outclk, out_sync_sig);
	input async_sig, outclk;
	output out_sync_sig;

	wire FDC1OUT, FDC2OUT, FDC3OUT, FDC_1OUT;
	wire VCC, GND;
	
	assign VCC = 1'b1;
	assign GND = 1'b0;
	
	vDFF #(1) FDC1 	(.C(async_sig),	.D(VCC), 	.Q(FDC1OUT),	 .clr(FDC_1OUT)	);
	vDFF #(1) FDC2 	(.C(outclk), 	.D(FDC1OUT), 	.Q(FDC2OUT),	 .clr(GND)	);	
	vDFF #(1) FDC3 	(.C(outclk), 	.D(FDC2OUT),	.Q(FDC3OUT),	 .clr(GND)	);
	vDFF #(1) FDC_1	(.C(outclk), 	.D(FDC3OUT), 	.Q(FDC_1OUT), 	 .clr(GND)	);

	assign out_sync_sig = FDC3OUT;

endmodule

module vDFF(C,D,Q,clr);

	parameter n = 6;

	input		C, clr;
	input 	       [n-1:0] D;
	output reg     [n-1:0] Q;
	
	always@(posedge C or posedge clr) begin
		if (clr) Q = 0;
		else Q = D;
	end

endmodule

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