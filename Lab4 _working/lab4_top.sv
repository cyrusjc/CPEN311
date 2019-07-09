`default_nettype none
module lab4_top(
    //////////// CLOCK //////////
    CLOCK_50,
    //////////// LED //////////
    LEDR,
    //////////// KEY //////////
    KEY,
    //////////// SW //////////
    SW,
    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5
);
//////////// CLOCK //////////
input                       CLOCK_50;
//////////// LED //////////
output           [9:0]      LEDR;
//////////// KEY //////////
input            [3:0]      KEY;
//////////// SW //////////
input            [9:0]      SW;
//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;

//=======================================================
//  THE FOLLOWING IS TAKEN FROM PIAZZA FROM DR. YAIR AND IS A
//  CONVERSION OF THE VHDL THAT IS PROVIDED
//=======================================================

//=========DECLARING LOGICS/REGS
logic CLK_50M;
logic  [9:0] LED = 0;
assign CLK_50M =  CLOCK_50;
assign LEDR[9:0] = LED[9:0];

//=========INSTANTIATING DECODER
logic [6:0] ssOut;
logic [3:0] nIn;

SevenSegmentDisplayDecoder mod (.nIn(secret_key[23:20]), .ssOut(HEX5));
SevenSegmentDisplayDecoder mod1(.nIn(secret_key[19:16]), .ssOut(HEX4));
SevenSegmentDisplayDecoder mod2(.nIn(secret_key[15:12]), .ssOut(HEX3));
SevenSegmentDisplayDecoder mod3(.nIn(secret_key[11:8]), .ssOut(HEX2));
SevenSegmentDisplayDecoder mod4(.nIn(secret_key[7:4]), .ssOut(HEX1));
SevenSegmentDisplayDecoder mod5(.nIn(secret_key[3:0]), .ssOut(HEX0));

//==========INSTANTIATING FSM TO WRITE MEMORY **** TASK 1 ========================================
wire write_en_init, finish_init;
wire [7:0] address_init, data_init, address_swap, data_swap_out;

init_fsm init_mem	(	.clock(CLK_50M), 					.address(address_init), 	.data(data_init),
							.write_enable(write_en_init), .finish(finish_init), 		.start(init_start),
							.reset(reset)
						);
//============================INSTANTIATING MEMEORY =================================================================
wire [7:0] data_to_mem, data_from_mem, address_to_mem;
wire wren_to_mem;

s_memory RAM		(	.address(address_to_mem),	.clock(CLK_50M), 		.data(data_to_mem), 
							.wren(wren_to_mem),			.q(data_from_mem)	
						 );
//===========================INSTANTIATING SWAP FSM ******** TASK 2 A ==============================================
// WIRE DECLARATION
wire write_en_swap, swap_start, finish_swap;
			
swap_fsm swap_mem	(	.clock(CLK_50M), 				.address(address_swap),			 	.data_in(data_from_mem), 
							.data_out(data_swap_out), 	.write_enable(write_en_swap), 	.start(swap_start),
							.skey (secret_key),			.finish(finish_swap),				.reset(reset)
						);
						
//	======================================================			11    	 10                           			    01             00
// THIS MUX SELECTS WHICH FSM DATA/ WRITE/ ADDRESS IT IS, BASED OFF DATA FROM FSM
 assign address_to_mem 	= addr_data_sel[1] ? (addr_data_sel[0] ? address_dec 	: 8'b0) 	: (addr_data_sel[0] ? address_swap 	: address_init);
 assign  wren_to_mem		= addr_data_sel[1] ? (addr_data_sel[0] ? write_en_s	: 1'b0) 	: (addr_data_sel[0] ? write_en_swap : write_en_init);
 assign  data_to_mem 		= addr_data_sel[1] ? (addr_data_sel[0] ? data_dec 		:	8'b0) 	: (addr_data_sel[0] ? data_swap_out : data_init);

//=======================MASTER CONTROL THAT SELECTS DATA, AND SENDS START SIGNALS TO OTHER FSMS AND CONTROLS SECRET KEY============================	
wire init_start, decode_finish, decode_start;
wire [1:0] addr_data_sel;		
wire [23:0] secret_key;
wire reset;
master_fsm master_control 		(	.init_finish(finish_init),				.init_start(init_start),				.swap_finish(finish_swap),			
											.swap_start(swap_start),				.decode_finish(decode_finish),		.decode_start(decode_start),		
											.addr_data_sel(addr_data_sel),		.secret_key(secret_key),				.clock(CLK_50M),	
											.abort(abort), 							.pass(LED[8]),								.fail(LED[9]),
											.reset(reset)
								);
	
//===========================INSTANTIATING ENCRYPTED ROM AND DECRYPED RAM ******** TASK 2 B ==============================================
wire [7:0] data_from_rom, addr_rom_ram, address_dec, data_dec;
wire [7:0] data_to_dec_mem, data_from_dec_mem;
wire wren_to_dec_mem, write_en_s, abort;
// ROM FOR ENCRY. MSG
rom_message enc_message			(.address(addr_rom_ram),		.clock(CLK_50M),				.q(data_from_rom)); // done
// 1 PORT RAM FOR WRITING DECRYPT. MSG
ram_d_message decrypted_message(	.address(addr_rom_ram),			.clock(CLK_50M), 			.data(data_to_dec_mem), 
											.wren(wren_to_dec_mem),			.q(data_from_dec_mem)
										 );

// LOOP 3 ---- DECRYPTS THE MESSAGE AND WRITES EACH LETTER INTO RAM										 
decode_fsm decrypt_message(	.clock(CLK_50M), 				.start(decode_start),					.done(decode_finish),
										.write_enable(write_en_s),	.write_en_dec(wren_to_dec_mem),		.address_dec(addr_rom_ram),
										.data_in(data_from_mem),	.address(address_dec),					.data_out(data_dec),
										.data_rom(data_from_rom),	.data_dec(data_to_dec_mem),			.bad_key(abort),
										.reset(reset)					
								);
						


								

endmodule
