module shared_access_to_one_state_machine
#(
	parameter N = 32,
	parameter M = 8
)
(
output reg [(N-1):0] output_arguments,
output start_target_state_machine,
input target_state_machine_finished,
input sm_clk,
input logic start_request_a,
input logic start_request_b,
output logic finish_a,
output logic finish_b,
output logic reset_start_request_a,
output logic reset_start_request_b,
input [(N-1):0] input_arguments_a,
input [(N-1):0] input_arguments_b,
output reg [(M-1):0] received_data_a,
output reg [(M-1):0] received_data_b,
input reset,
input [M-1:0] in_received_data
);
				// 6543210
	parameter s_wait	=	7'b0000000;
	parameter s_check 	=	7'b0000001;
	parameter s_start_a	=	7'b0000010;
	parameter s_start_b 	=	7'b0000110;
	parameter s_strobe_a	=  	7'b0100000;
	parameter s_strobe_b	= 	7'b1000000;
	parameter s_finish_a 	=	7'b0001000;
	parameter s_finish_b	=	7'b0010100;

	wire sel_a_b, strobe_a, strobe_b;

	reg [6:0 ]state ;
	assign finish_a = state[3];
	assign finish_b = state[4];
	assign sel_a_b = state[2];
	assign start_target_state_machine = state[1];
	assign reset_start_request_a = state[3];
	assign reset_start_request_b = state[4];
	assign strobe_a = state[5];
	assign strobe_b = state[6];


	assign output_arguments = sel_a_b ? input_arguments_b : input_arguments_a;

	always @(posedge sm_clk) begin
		case(state)
		
			s_wait 		:	if (start_request_a | start_request_b) 
								state <= s_check;
							else 	
								state <= s_wait;
			
			s_check		: 	if(start_request_a)
								state <= s_start_a;
							else if (start_request_b) 
								state <= s_start_b;
								
			s_start_a	:	if(target_state_machine_finished) 
								state <= s_strobe_a;
							else 
								state <= s_start_a;
								
			s_strobe_a	:	state <= s_finish_a;				
								
			s_finish_a	:	state <= s_wait;
								
			s_start_b	:   if(target_state_machine_finished)
								state <= s_strobe_b;
							else	
								state <= s_start_b;
								
			s_strobe_b	:	state <= s_finish_b;	
			
			s_finish_b	:	state <= s_wait;
				
								
			
			default: state <= s_wait;
		endcase
	end
			
	always @(posedge strobe_a or negedge reset) begin
		if (!reset) received_data_a <= 8'b0;
			received_data_a <= in_received_data;
		end	

	always @(posedge strobe_b or negedge reset) begin
		if (!reset) received_data_b <= 8'b0;
		received_data_b <= in_received_data;
	end
endmodule