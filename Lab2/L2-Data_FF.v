`define MAXADDRESS 			32'h7FFFF


//--------------------------------------------------------//
//--------------------------------------------------------//
//22KHZ WILL TRIGGER OUTPUT TO AUDIO SAMPLE
//FIRST IT WILL READ THE LSB 15-0 
//THEN ON 2nd CLOCK IT WILL INCREMENT ADDRESS AND READ MSB.
//IF KEYBOARD INTERUPT THEN:
//b BACKWARDS, DECREMENTS ADDRESS
//r SETS ADDRESS TO 0
//d PAUSES, SKIPS THIS WHOLE THING
//e GOES THROUGH THIS FLIPFLOP	
//--------------------------------------------------------//
//--------------------------------------------------------//
module data_out( clock, back, start, restart,	in, out, address, vol_up, vol_down, vol_reset, fetch);

	input clock;
	input [31:0] in;
	input back, start, restart;
	input vol_up, vol_down,vol_reset;
	
	output fetch;
	output reg [15:0] out;
	output reg [31:0] address = 0;
	
	reg count = 0;
	reg fetch = 0;
	//reg count1 = 0;
	
	wire [15:0] upper_bit;
	wire [15:0] lower_bit;
	
	assign upper_bit = in[31:16];
	assign lower_bit = in[15:0];
	
	always @(posedge clock or posedge restart)
	begin
		if(restart)
		address <= 32'b0;
//---------------------- STOP -----------------
		else 
		if(!start)
		begin
			out <= 32'b0;
			address <= address;
		end
		else
			begin
		//----------------------- BACKWARD -----------------	
				if(back)
				begin
						fetch <= 0;
						count <= !count;
						out <= count  ? lower_bit : upper_bit;
						if (count ==1) begin
							if (address < 32'b0 | address >`MAXADDRESS) address <= `MAXADDRESS;
							else address <= address - 32'h01;
							fetch <= 1;
						end
				end
		//----------------------- FORWARD -----------------	
				else
				begin
						fetch <= 0;
						count <= !count;
						out <= count ? upper_bit : lower_bit;
					if(count==1) begin
						if (address >= `MAXADDRESS) address <= 0;
						else address <= address + 32'h01;
						fetch <= 1;
					end
					
				end
			end
	
	end	

endmodule