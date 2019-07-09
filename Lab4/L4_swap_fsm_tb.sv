module swap_fsm_tb();
	
reg clock; 
reg [23:0] s_key;
reg [7:0] data_in;
wire [7:0] data_out;
wire [7:0] address;
reg start;
wire write_enable;
wire finish;
reg reset;

swap_fsm dut(clock, s_key, data_in, data_out, address,start, write_enable, finish, input_reset);

initial forever begin
	clock = 1;#5;
	clock = 0;#5;
end

initial begin
	s_key = 0;
	data_in = 0;
	reset = 0;
	#10;
	start = 1;
	#200;

end

endmodule
