module hw2_b_tb();
	reg clk,rst,pause,restart,goto_third;
	wire [8:0] state;
	wire [2:0] Out1, Out2;
	wire even,odd,terminal;

	parameter  FIRST = 	9'b011_010_010;
	parameter  SECOND = 	9'b101_100_001;
	parameter  THIRD =	 	9'b010_111_010;
	parameter  FOURTH = 	9'b110_011_001;
	parameter  FIFTH = 	9'b101_010_110;

	fsm_b tb(.state(state), .odd(odd) , .even(even), .terminal(terminal), .pause(pause), .restart(restart), .clk(clk), .rst(rst),
			 .goto_third(goto_third), .Out1(Out1), .Out2(Out2));

	initial begin
		clk = 0; #10;
		forever begin
		clk = 1; #5;
		clk = 0; #5;
		end
	end
	
	initial begin
		rst = 0;#1 rst = 1;#1 rst = 0; goto_third=0; pause = 0; restart = 0;
		if (state != FIRST) begin $display("RESET STATE IS NOT 1"); end
		@(posedge clk) #1;if (state != SECOND) $display ("PROBLEM STATE TRANSITION 1->2");
		@(posedge clk) #1;if (state != THIRD) $display ("PROBLEM STATE TRANSITION 2->3");
		@(posedge clk) #1;if (state != FOURTH) $display ("PROBLEM STATE TRANSITION 3->4");
		@(posedge clk) #1;if (state != FIFTH) $display ("PROBLEM STATE TRANSITION 4->5");
		goto_third = 1;
		@(posedge clk) #1;if (state != THIRD) $display ("PROBLEM STATE TRANSITION 5->3");
		goto_third = 0;
		@(posedge clk) #1;if (state != FOURTH) $display ("PROBLEM STATE TRANSITION 3->4");
		restart = 1;
		@(posedge clk) #1;if (state != FIRST) $display ("PROBLEM WITH RESTART");
		@(posedge clk) #1;if (state != FIRST) $display ("PROBLEM WITH RESTART");
		restart = 0; pause = 1;
		@(posedge clk) #1;if (state != FIRST) $display ("PROBLEM WITH PAUSE");
		pause = 0;
		@(posedge clk) pause =1;
		@(posedge clk) #1;if (state != SECOND) $display ("PROBLEM WITH PAUSE @ 2"); pause =0;
		@(posedge clk) pause = 1;
		@(posedge clk) #1;if (state != THIRD) $display ("PROBLEM WITH PAUSE @ 3"); pause =0;
		@(posedge clk) pause =1;
		@(posedge clk) #1;if (state != FOURTH) $display ("PROBLEM WITH PAUSE @ 4"); pause = 0;
		@(posedge clk) pause = 1;
		@(posedge clk) #1;if (state != FIFTH) $display ("PROBLEM WITH PAUSE @ 5"); pause = 0;
		$display("NO PROBLEMS WITH RESTART OR PAUSE");
		#1;rst = 1;#1; rst= 0; pause = 0; restart=0; goto_third=0;
		
		$stop;
		
		wait(state == FIRST) begin
			#1;
			if ( even != 0 | odd != 1 | Out1 != 3'd3 | Out2 != 3'd2) 
				$display ("PROBLEM WITH ST8 1 OUTPUT");
		end

		wait(state == SECOND) begin
			#1;
			if ( even != 1 | odd != 0 | Out1 != 3'd5 | Out2 != 3'd4) 
				$display ("PROBLEM WITH ST8 2 OUTPUT");
		end
		
		wait(state == THIRD) begin
			#1;
			if ( even != 0 | odd != 1 | Out1 != 3'd2 | Out2 != 3'd7) 
				$display ("PROBLEM WITH ST8 2 OUTPUT");
		end
		
		wait(state == FOURTH) begin
			#1;
			if ( even != 1 | odd != 0 | Out1 != 3'd6 | Out2 != 3'd3) 
				$display ("PROBLEM WITH ST8 2 OUTPUT");
		end

		wait(state == FIFTH) begin
			#1;
			if ( even != 0 | odd != 1 | Out1 != 3'd5 | Out2 != 3'd2) 
				$display ("PROBLEM WITH ST8 2 OUTPUT");
		end
		
		$display ("END OF SIM FSM OKAY");
		$stop;


	end
endmodule
