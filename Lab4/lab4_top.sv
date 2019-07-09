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

//=========INSTANTIATING DECODER========
// DECODING SECRET_KEY FSM
//=====================================
logic [6:0] ssOut;
logic [3:0] nIn;
logic [23:0] hex_data_in;
SevenSegmentDisplayDecoder mod (.nIn(hex_data_in[23:20]), .ssOut(HEX5));
SevenSegmentDisplayDecoder mod1(.nIn(hex_data_in[19:16]), .ssOut(HEX4));
SevenSegmentDisplayDecoder mod2(.nIn(hex_data_in[15:12]), .ssOut(HEX3));
SevenSegmentDisplayDecoder mod3(.nIn(hex_data_in[11:8]), .ssOut(HEX2));
SevenSegmentDisplayDecoder mod4(.nIn(hex_data_in[7:4]), .ssOut(HEX1));
SevenSegmentDisplayDecoder mod5(.nIn(hex_data_in[3:0]), .ssOut(HEX0));

wire [23:0] secret_key_1, secret_key_2, secret_key_3, secret_key_4;
wire [3:0] found, not_found;
wire key_found;

// THE LEFT MOST LEDS WILL TURN ON DEPENDING ON WHICH CORE WE FIND THE KEY IN
assign {LED[6], LED[7], LED[8], LED[9]} = found;
assign LED[0] = & not_found;
// COMB LOGIC - IF KEY IS FOUND IN CORE 1 to 4, THEN IS ONE AND STOPS ALL CORES
assign key_found = | found;

//=========================================== BONUS ====================================================================
//	A CORE IS COMPOSED OF 4 FSMS, EACH WITH THEIR WORKING MEMORY, ROM, AND RAM.
// FSMS INCLUDE: A INITIALIZE FSM ( LOOP 1), A SWAPPING FSM(LOOP 2), AND A DECODING FSM (LOOP 3), AND A MASTER FSM
// EACH OF THESE FSM IS CONTROLLED BY A MASTER FSM THAT CONTROLS WHICH FSM READS/ WRITES TO MEMORY
//======================================================================================================================
core #(24'h000_000, 24'h100_000) 	core_1	( .key_found(key_found), 		.found(found[0]), 				.not_found(not_found[0]),
															.CLK_50M(CLK_50M), 	.secret_key(secret_key_1)
															);
														
core #(24'h100_000, 24'h200_000) 	core_2	(	.key_found(key_found), 		.found(found[1]), 				.not_found(not_found[1]),
															.CLK_50M(CLK_50M), 	.secret_key(secret_key_2)
															);
															
core #(24'h200_000, 24'h300_000) 	core_3	( .key_found(key_found), 		.found(found[2]), 				.not_found(not_found[2]),
																.CLK_50M(CLK_50M), 	.secret_key(secret_key_3)
															);
															
core #(24'h300_000, 24'h400_000) 	core_4	( .key_found(key_found), 		.found(found[3]), 				.not_found(not_found[3]),
																.CLK_50M(CLK_50M), 	.secret_key(secret_key_4)
															);				
// DEPENDING ON WHICH CORE FOUND THE KEY, WE OUTUT THE SECRET KEY FROM THAT.
assign LED[1]= |(!found & !not_found);							
always @(*) begin
	case (found)
		4'b0001:	hex_data_in <= secret_key_1;
		4'b0010:	hex_data_in <= secret_key_2; 
		4'b0100:	hex_data_in <= secret_key_3;
		4'b1000:	hex_data_in <= secret_key_4;
		4'b0000: hex_data_in <= {4'hF,secret_key_1[19:0]};
		default:	hex_data_in <= 24'hz;
	endcase
end
								

endmodule
