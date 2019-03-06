module intermediate();
	reg fsma_start, fsmb_start;
	reg target_state_machine_finished;
	reg clk;
	reg [7:0] in_recieved_data;
	reg [31:0] input_arguments_a;
	reg [31:0] input_arguments_b;
	reg rst;

	wire fsma_start_trap;
	wire reset_from_intermediate_a;
	wire reset_from_intermediate_b;
	wire [31:0] output_arguments;
	wire start_target_state_machine;
	wire finish_a, finish_b; 
	wire [7:0] recieved_data_a;
	wire [7:0] recieved_data_b;

	
	

	trap_edge TO_A(fsma_start, clk, reset_from_intermediate_a, fsma_start_trap);
	trap_edge TO_B(fsmb_start, clk, reset_from_intermediate_b, fsmb_start_trap);
	
	shared_access_to_one_state_machine DUT(output_arguments, start_target_state_machine, target_state_machine_finished,
						clk,fsma_start_trap,fsmb_start_trap,finish_a,finish_b,reset_from_intermediate_a, reset_from_intermediate_b,
						input_arguments_a,input_arguments_b,recieved_data_a,recieved_data_b,
						rst,in_recieved_data);

	initial forever begin
		clk = 0;#5;
		clk = 1;#5;
	end	
	
	initial begin
		fsma_start = 1;#1; fsma_start = 0;

		in_recieved_data = 8'b1111;
		rst = 1;
		fsma_start = 0; fsmb_start = 0; 
		target_state_machine_finished = 0;
		input_arguments_a = 32'b0;
		input_arguments_b = 32'b1; #10;
 	fsmb_start = 1;#1; fsmb_start = 0;
 		fsmb_start = 1;#1; fsmb_start = 0;
		#100;
		target_state_machine_finished = 1;#10;
		target_state_machine_finished = 0;#100;
		target_state_machine_finished = 1;#10;
		in_recieved_data = 8'b1010;
		fsma_start = 1;#1;fsma_start=0;
		target_state_machine_finished = 0;#40;
		target_state_machine_finished = 1;#10;
		
		$stop;
	
	end
		
endmodule