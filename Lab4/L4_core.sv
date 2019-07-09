module core
#(
	parameter low_key = 0,
	parameter high_key = 24'h400000)
	
(
	input CLK_50M,
	input key_found,
	output not_found,
	output found,
	output [23:0] secret_key
	
);

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
wire reset;
master_fsm #(low_key,high_key) master_control 	
									(	.init_finish(finish_init),				.init_start(init_start),				.swap_finish(finish_swap),			
											.swap_start(swap_start),				.decode_finish(decode_finish),		.decode_start(decode_start),		
											.addr_data_sel(addr_data_sel),		.secret_key(secret_key),				.clock(CLK_50M),	
											.abort(abort), 							.pass(found),								.fail(not_found),
											.reset(reset),								.key_found(key_found)
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