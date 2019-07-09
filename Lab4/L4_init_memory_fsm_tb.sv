module TB_init();	
	reg clock;
	reg start;
	wire [7:0] address;
	wire [7:0] data;
	wire finish;
	wire write_enable;
	reg reset;

	init_fsm DUT(.clock(clock), .start(start), .address(address), .data(data), .finish(finish), .write_enable(write_enable), .reset(reset));

	initial forever begin
		clock = 0; #5;
		clock = 1; #5;
	end

	initial begin
	#20;
	reset = 0;
	start = 1;#10;
	start = 0;#5;
	#200;
	reset = 1;#10;
	reset = 0;#5;
	#10;
	$stop;
	end

endmodule