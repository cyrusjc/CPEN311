module L5_LFSR_TB();
	reg clock;
	wire [4:0] OUTPUT;
	
	LFSR DUT(clock, OUTPUT);
	
	
	
	initial forever begin
		clock = 0; #5;
		clock = 1; #5;
	end

endmodule