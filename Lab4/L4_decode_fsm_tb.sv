module TB_decode();
	
reg clock;
reg [7:0] data_in;
wire [7:0] address;
wire [7:0] data_out;
wire write_enable;

reg [7:0] data_rom;
wire [7:0] data_dec;
wire [7:0] address_dec;
wire write_en_dec;

reg start;
wire done;
wire bad_key;
reg reset;

decode_fsm dut(clock, data_in, address, data_out, write_enable, data_rom, data_dec, address_dec, write_en_dec, start, done , bad_key, reset);

initial forever begin
	clock = 1;#5;
	clock = 0;#5;
end

initial begin
	data_rom = 0;
	data_in = 0;
	reset = 0;
	#10;
	start = 1;
	#200;

end

endmodule
