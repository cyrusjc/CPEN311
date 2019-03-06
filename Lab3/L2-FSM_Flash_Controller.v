									//43210
`define S_wait 				5'b00000
`define S_initiate_read 	5'b00010
`define S_wait_for_slave 	5'b00110
`define S_strobe_read		5'b01010
`define S_finished			5'b10000

`define S_width				5

// --------------------------------------------------------------------------------------------------------
//		THIS TAKES IN 50MHZ FOR STATE MACHINE
//		OUTPUTS TO FLIP FLOP FOR 22KHZ MACHINE
//		OUTPUTS READ TO FLASH
//--------------------------------------------------------------------------------------------------------------------
module fsm_read_only(		clock, flash_mem_read, 
							flash_mem_waitrequest, flash_mem_readdata, 
							flash_mem_readdatavalid, flash_data_out, start
							);
							
	input	clock, flash_mem_waitrequest, flash_mem_readdatavalid;
	input [32-1:0] flash_mem_readdata;
	input start;

	output flash_mem_read;	
	output reg [32-1:0] flash_data_out = 32'b0; 					//REGISTER FOR DATA

	reg [`S_width-1:0] state = `S_wait;						//DECLARING a 5 BIT STATE DEFINED ABOVE
	wire strobe_read_reg; 								//STROBE FOR READ REG		
	
	assign flash_mem_read = state[1];				//READ IS BIT 1
	assign strobe_read_reg = state[3];				//STROBE REG IS BIT 3
	
	always @(posedge clock)
	begin
		casex (state)
	
			`S_wait:						state <= `S_initiate_read;
						
			`S_initiate_read: 		state <= `S_wait_for_slave;
																
			`S_wait_for_slave:	begin
											//IF WAIT REQUESST IS HIGH, THEN WE REMAIN AT THIS STATE
											if(flash_mem_waitrequest ) state <= `S_wait_for_slave;
											else state <= `S_strobe_read;
										end
										
			`S_strobe_read:		begin	
											//TRIGGERS FLIP FLOP WITH STROBE READ AS CLK
											if (flash_mem_readdatavalid) state <= `S_finished;
											else state <= `S_strobe_read;
										end
										
			`S_finished:			if(start) state <= `S_wait;
										else state = `S_finished;
										
			default:					state <= `S_wait;
			
		endcase
	end
	
	//S_strobe_read_REG WILL TRIGGER flash_data_out
	always @(posedge strobe_read_reg)
	begin
		flash_data_out <= flash_mem_readdata;
	end

endmodule