
//TAKES A BASE DIVIDER, THEN ADDS AND REMOVES ONE ON EVENT
module divider(clock, speed_up, speed_down, reset, divider);
	parameter base = 32'd1227;
	
	input speed_up, speed_down, reset;
	input clock;

	
	output reg [31:0] divider = base;
	
	always @(posedge clock)
	begin
			if (speed_up)			 	divider <= divider - 1;
			else if(speed_down) 		divider <=divider + 1;
			else if(reset)				divider <= base;
	end
		
endmodule	