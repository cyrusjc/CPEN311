module clock_divider_tb ();
	reg inclk;
	reg [31:0] divisor;
	wire outclk;
	reg reset;
	
	clock_divider test(.inclk(inclk),.divisor(divisor),.outclk(outclk),.reset(reset));
	

	reg [31:0] f;
	
	initial begin // sets it so that this turns in and off every 5ps.
    		inclk = 0; #20000;
    		forever begin
      			inclk = 1 ; #20000;
      			inclk = 0 ; #20000;
    		end
  	end


	initial begin
		reset = 1;
		divisor = 32'd2;
		#600000;
		divisor = 32'd5;

	end
		

		//#1000000;
		//f*1000000;
		//$display("frequency is:%d,",f);
		//$stop;
		
	
	


	
endmodule