
//===================********TASK 1********======================
// THIS MODULE CONTROLS ALL SUB FSMS. GIVES START AND FINISH TO FSM AS WELL AS 
// HAS MUX TO CONTROL WHICH ADDRESS WE USE TO ACCESS MEMORY. IT ALSO CONTROLS
// SECRET KEY. OUTPUTS LED 8 WHEN PASS, LED 9 WHEN FAIL
//===========================================================

module master_fsm
(
	input clock,
	input init_finish,
	output init_start,
	input swap_finish,
	output swap_start,
	input decode_finish,
	output decode_start,
	output [1:0] addr_data_sel,
	output reg [23:0] secret_key,
	input abort,
	output fail,
	output pass,
	output reset
	
);
										// 098_7654_3210
parameter start_init 		= 11'b000_0000_0001;
parameter wait_init 			= 11'b000_0000_0000;
parameter finish_init 		= 11'b101_0000_0000;
parameter start_swap			= 11'b000_0001_0010;
parameter wait_swap 			= 11'b000_0001_0000;
parameter finish_swap		= 11'b001_0001_0000;
parameter start_decode  	= 11'b000_0011_0100;
parameter wait_decode 		= 11'b000_0011_0000;
parameter finish_decode 	= 11'b001_1011_0000;
parameter increment_sk 		= 11'b001_0100_0000;		
parameter no_key 		      = 11'b011_0000_0000;	
parameter s_wait 		      = 11'b100_0000_1000;	
parameter s_wait_sk 		   = 11'b001_0000_0000;	


reg [10:0] state;

assign init_start  = state[0];
assign swap_start  = state[1];
assign decode_start = state[2];
assign reset = state[3];
assign addr_data_sel = state[5:4];
assign increment_key = state[6];
assign fail = state[9];
assign pass = state[7];

wire increment_key;


always @(posedge clock) begin
	if (increment_key)
		secret_key <= secret_key + 1'b1;
	else
		secret_key <= secret_key;
	
end
//==================================================================
// 						OUR STATE MACHINE
//==================================================================
always_ff @(posedge clock) begin

	case(state)

		s_wait:			state <= start_init;
	
		start_init:		if (secret_key >= 24'h400000)
								state <= no_key;
							else 
								state <= wait_init;
		
		wait_init:		if (init_finish)
								state <= finish_init;
							else
								state <= wait_init;
		
		finish_init:	state <= start_swap; 
		
		start_swap:		state <= wait_swap;
		
		wait_swap:		if (swap_finish)
								state <= finish_swap;
							else
								state <= wait_swap;
		
		finish_swap:	state <= start_decode;
		
		start_decode:	state <= wait_decode;
		
		wait_decode:	if (decode_finish)
								state <= finish_decode;
								else if (abort)
								state <= increment_sk;
							else
								state <= wait_decode;
								
		increment_sk:	state <= s_wait_sk;
		
		s_wait_sk	:	state <= s_wait;
		
		finish_decode:	state <= finish_decode;
		
		no_key		 :	state <= no_key;
		
		default	: 		state <= s_wait;

	endcase 
end

endmodule