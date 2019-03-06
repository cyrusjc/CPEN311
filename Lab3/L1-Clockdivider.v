module clock_divider (inclk, divisor, outclk, reset);
	
	input inclk,reset;
	input [31:0] divisor;
	output reg outclk;
	
	reg [31:0] count;
	reg[31:0] div;
	
	always@(*) begin
		div = divisor >> 1;
	end
	
	//NEED TO INITIALIZE REGISTERS OR ELSE ERROR!
	initial begin
		count = 0;
		outclk = 0;
	end
	
	//THIS COUNTS  THE NUMBER OF POSEDGES, AFTER COUNTING THE DIVISOR AMOUNT OF POSEDGES, IT CHANGES STATE OF CLOCK
	always @(posedge inclk) begin
		count <= count + 1;

		if (count ==  div-1) begin
			count <=0;
			outclk <= !outclk;
		end
	end

	//assign outclk = clka | clkb;
	
endmodule