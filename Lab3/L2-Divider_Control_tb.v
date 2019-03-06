
module L2_Divider_Control_tb();
	reg speed_up, speed_down, speed_reset, clock;
	wire [31:0] out;
	
	parameter base = 32'd1227;
	
	divider L2_Divider_tb(.clock(clock), .speed_up(speed_up), .speed_down(speed_down), .reset(speed_reset), .divider(out));
	
	initial forever begin
	clock = 0;#5;
	clock = 1; #5;
	end
	
	initial begin
	
		speed_up = 0; speed_reset = 0; speed_down = 0;
		if( out != base) begin $display("BASE DIVISION IS NOT THE SAME"); $stop; end
//-----------------------TESTING SPEED UP EVENT (DECREASING DIVISIOR)
		speed_up = 1; 
		@(posedge clock) #1; if( out != base -10'd1) begin $display("speed up no worky +1"); $stop; end
		@(posedge clock) #1; if( out != base -10'd2) begin $display("speed up no worky +2"); $stop; end
//-----------------------TESTING RESET
		speed_up = 0;
		speed_reset = 1; 
		@(posedge clock) speed_reset = 0; #1;
		if( out != base) begin $display("RESET DOES NOT WORK"); $stop; end
//-----------------------TESTING SPEED DOWN (INCREASING DIVISOR)
		speed_reset =0; speed_down = 1;
		@(posedge clock) #1; if( out != base +10'd1) begin $display("speed down no worky +1"); $stop; end
		@(posedge clock) #1; if( out != base +10'd2) begin $display("speed down no worky +2"); $stop; end

		$display("end of SIM WORKS OKAY"); $stop;
	end

endmodule