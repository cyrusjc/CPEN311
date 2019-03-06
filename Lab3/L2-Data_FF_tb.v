`define MAXADDRESS 			32'h7FFFF

module L2_data_out_tb();

	reg clock, back, start, restart, vol_up, vol_down, vol_reset;
	reg [31:0] in;
	wire [15:0] out;
	wire [31:0] address;
	wire fetch;
	data_out data_out_DUT(clock, back, start, restart, in , out ,address, vol_up, vol_down, vol_reset, fetch);
		
	initial forever begin
	clock = 0;#5;
	clock = 1;#5;
	end
	
	initial begin
	in = 32'b1111_1111_1111_1111;
	back = 0; start =1; restart = 0;
	#40; back = 1;
	#40; back = 0; start = 1;
	#40; start = 0;
	restart = 1;
	end
endmodule