
//TAKES THESE THE ASCI CODE AS INPUT, AND OUTPUTS STOP/START/RESTART TO THE DATA OUTPUT
module KB_Interface(code, start, back, restart, interupt, clock1, audio_up, audio_down, audio_reset);
	
	input 			interupt, clock1;
	input 	[7:0] code;
	
	output reg			restart = 0;
	
	output reg			audio_up = 0;
	output reg 			audio_down = 0; 
	output reg 			audio_reset = 0;
	output reg 			start = 0;
	output reg 			back = 0;

	reg async_restart; 
	
	//---------------------------------------------------------------------------------------
	// PARAMTERS FOR KEYBOARD
	//--------------------------------------------------------------------------------------
	parameter big_b = 8'h42; //BACKWARDS
	parameter big_d = 8'h44; //PAUSE
	parameter big_r = 8'h52; //RESTART
	parameter big_e = 8'h45; //PLAY
	parameter big_f =	8'h46; //FORWARD
	parameter c_1   =	8'h31;	// BONUS 
	parameter c_2   =	8'h32;	// BONUS 
	parameter c_3   =	8'h33;	// BONUS 
	//---------------------------------------------------------------------------------------
	// END OF PARAMTERS FOR KEYBOARD
	//--------------------------------------------------------------------------------------
	
	always @(posedge interupt)
	begin
		/*
		if (code == c_1) 	 async_audio_up <= !async_audio_up;
		if (code == c_2)	 async_audio_down <= !async_audio_down;
		if (code == c_3)	 async_audio_reset <= !async_audio_reset;
		*/
		if (code == big_r) async_restart <= !async_restart;
		if (code == big_b) back <= 1'b1;
		if (code == big_f) back <= 1'b0;
		if (code == big_d) start <= 1'b0;
		if (code == big_e) start <= 1'b1;		
	end
	

	wire restart_1, 		restart_2	;
	
	//PULSE FOR RESTART
	Synchronizer sync_restart_sig			(	.async_sig(async_restart), 	.outclk(clock1), 	.out_sync_sig(restart_1)	);	
	Synchronizer sync_restart_sig1		(	.async_sig(!async_restart), 	.outclk(clock1), 	.out_sync_sig(restart_2)	);
	
	always@(clock1)
	begin
		restart = restart_1 | restart_2;	
	end
	

	reg async_audio_reset = 0;
	reg async_audio_up = 0;
	reg async_audio_down = 0;
	
	wire audio_reset1,		audio_reset2;
	wire audio_up1,			audio_up2;
	wire audio_down1,		audio_down2;
	
	//BONUS BONUS BONUS BONUS BONUS VOLUME CONTROL///	
	//PULSE FOR 1
	Synchronizer sync_restart_aud_res	(	.async_sig(async_audio_reset), 	.outclk(clock1), 	.out_sync_sig(audio_reset1)	);
	Synchronizer sync_restart_aud_res1	(	.async_sig(!async_audio_reset), 	.outclk(clock1), 	.out_sync_sig(audio_reset2)	);

/*
	//PULSE FOR 2
	Synchronizer sync_restart_aud_up		(	.async_sig(async_audio_up), 	.outclk(clock1), 	.out_sync_sig(audio_up1)	);
	Synchronizer sync_restart_aud_up1	(	.async_sig(!async_audio_up), 	.outclk(clock1), 	.out_sync_sig(audio_up2)	);
	
	//PULSE FOR 3
	Synchronizer sync_restart_aud_down		(	.async_sig(async_audio_down), 	.outclk(clock1), 	.out_sync_sig(audio_down2)	);
	Synchronizer sync_restart_aud_down1		(	.async_sig(!async_audio_down), 	.outclk(clock1), 	.out_sync_sig(audio_down1)	);	
	
	
	assign audio_reset = audio_reset1 | audio_reset2;
	assign audio_up = audio_up1 | audio_up2;
	assign audio_down = audio_down1 | audio_down2;
*/

endmodule