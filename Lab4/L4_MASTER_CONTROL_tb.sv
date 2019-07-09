module TB_master();
	reg clock;
	reg init_finish, swap_finish, decode_finish, abort, key_found;
	wire init_start, swap_start, decode_start, fail, pass, reset;
	wire [1:0] addr_data_sel;
	wire [23:0] secret_key;
	
	master_fsm dut(clock, init_finish, init_start, swap_finish, swap_start, decode_finish, decode_start, addr_data_sel, secret_key, abort,
					key_found, fail, pass, reset);
	
	initial forever begin
		clock = 0;#5;
		clock = 1;#5;
	end

	initial begin
		#30;
		init_finish =1;
		#50;
		swap_finish = 1;
		#50;
		abort = 1;#10;
		abort = 0;
		wait (dut.state == 11'b000_0011_0000);
		$stop;
		decode_finish = 1;#10;	
		$stop;
		
	end
	
	

endmodule