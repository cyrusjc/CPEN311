
module L2_KB_I();
	reg clock;
	reg clock1;
	reg [7:0] code;
	
	parameter big_b= 8'h42; //BACKWARDS
	parameter big_d= 8'h44; //PAUSE
	parameter big_r= 8'h52; //RESTART
	parameter big_e= 8'h45; //PLAY
	parameter big_f =8'h46; //FORWARD
	
	wire start,restart,back;
	
	KB_Interface L2_KB_INTERFACE_TB(.code(code), .start(start), .back(back), .restart(restart), .clock(clock), .clock1(clock1)) ;

	initial forever begin
		clock1 = 0; #1;
		clock1 = 1; #1;
	end

	reg error;
	initial begin
	code = big_b; clock = 0; 
	pulse_interupt(); if(!back) begin $display("back up no worky "); error = 1;$stop; end

	code = big_f;
	pulse_interupt(); if(back) begin $display("forward no worky "); error = 1; $stop; end	

	code = big_e; 
	pulse_interupt(); if(!start) begin $display("START up no worky "); error = 1; $stop; end

	code = big_d; 
	pulse_interupt(); if(start) begin $display("stop no worky "); error = 1; $stop; end	
	
	if(!error) $display("BACK FORWARD, START, STOP WORKS OKAY"); 
	
	code = big_r;
	pulse_interupt(); code = 8'b0;
	#15;
	code = big_r;
	pulse_interupt(); code = 8'b0;
	#10;
	end
	


	$stop;

	task pulse_interupt;
	begin
		clock = 1;#2;
		clock = 0;#2;
	end
	endtask

endmodule
