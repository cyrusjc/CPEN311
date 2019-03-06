module hw2_tb();
	reg clk,rst,pause,restart;
	wire [1:0] state;
	wire even,odd,terminal;

	fsm tb(.state(state), .odd(odd) , .even(even), .terminal(terminal), .pause(pause), .restart(restart), .clk(clk), .rst(rst));

	initial begin
		clk = 0; #5;
		forever begin
		clk = 1; #5;
		clk = 0; #5;
		end
	end
	
	initial begin
		rst = 1; rst= 0; rst = 1; rst=0;
		restart = 1;#7;
		if (odd != 1 | state != 2'b11) $display ("WRONG STATE OUTPUT #1"); #5;
		restart = 0;	
		if (odd != 1 | state != 2'b11) $display ("WRONG STATE OUTPUT #1"); #5;
		if (even != 1 | state != 2'b01) $display ("WRONG STATE OUTPUT NOT EVEN #2"); #10;
		if (odd != 1 | state != 2'b10 ) begin $display ("WRONG OUTPUT/ STATE 3 #3"); $stop; end #5;
		if (state != 2'b10) $display("NOT IN RIGHT STATE SHOULD BE STATE 3 #4");
		pause = 1; #5 if (state != 2'b10) $display("NOT IN RIGHT STATE SHOULD BE STATE 3 #5");#5;
		restart = 1; pause = 0; #10; if (state != 2'b11) $display("SHOULD BE STATE ONE #6");
		if (state != 2'b11) $display("SHOULD BE STATE ONE #7");#5;
		restart = 0;#10
		pause = 1; if (state != 2'b01) $display("SHOULD BE STATE 2 #8");#5;
		if (state != 2'b01) $display("SHOULD BE STATE 2 #9");
		
		
		
		
		$display ("END OF SIM FSM OKAY");
$stop;

	end
endmodule
