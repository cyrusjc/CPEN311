//============================================================================
// LFSR TO GENERATE 2^n - 1 sequences
//============================================================================
module LFSR(
	input clock,
	output [4:0] psuedo_random
);

reg [4:0] bits;

assign psuedo_random = bits;

//ASSIGN SHIFTING RIGHT ONE THEN TAPS AT BITS 0 and 2
always @(posedge clock) begin
	bits <= bits >> 1;
	bits[4] <= bits[0] ^ bits[2]; // TAPS ARE AT BITS 0 AND 2, WE XOR THIS FOR MSB. 
end

// INITIALIZINING SEED DATA = 1
initial begin
	bits = 5'b1;
end
 
endmodule