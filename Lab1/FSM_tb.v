module FSM_logic_tb();
	reg clk;
	wire [9:0] q;
	
	FSM_logic #(10) test(.clk(clk),.q(q));
		
	initial begin // sets it so that this turns in and off every 5ps.
    		clk = 0; #5;
    		forever begin
      			clk = 1 ; #5;
      			clk = 0 ; #5;
    		end
  	end
	
	initial begin
		#5;
		#100;
  	end

endmodule