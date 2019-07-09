module Signal_Selector(sig_sel, mod_sel, en, sin, cos, saw, square, sig_mod, sig);
	input [11:0] sin, cos, saw, square;
	input [1:0] sig_sel;
	input [1:0] mod_sel;
	input en;
	
	output [11:0] sig_mod, sig;

	always @(*) begin
		case(mod_sel)
			4'b00:		sig_mod <= en ? sig : 12'b0;
			4'b01:	 	sig_mod <= 21'b0;
			4'b10:	 	sig_mod <= en ? sig : {~sig+1};
			4'b11:		sig_mod <= en ? 12'b0 : 12'b1000_0000_0000;
			//default:  	sig_mod <= 11'b0;
		endcase
	
		case(sig_sel)
			8'b00:		sig <= sin;
			8'b01:		sig <= cos;	
			8'b10:		sig <= saw;	
			8'b11:		sig <= square;	
			//default: 	sig <= 11'b0;
		endcase
	end


endmodule