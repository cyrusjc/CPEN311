
`default_nettype none
 `define USE_PACOBLAZE
module 
picoblaze_template
#(
parameter clk_freq_in_hz = 50000000
) (
				output reg[9:0] led,
				input clk,
				input interrupt,
				input [31:0] input_data
			     );


  
//--
//------------------------------------------------------------------------------------
//--
//-- Signals used to connect KCPSM3 to program ROM and I/O logic
//--

wire[9:0]  address;
wire[17:0]  instruction;
wire[7:0]  port_id;
wire[7:0]  out_port;
reg[7:0]  in_port;
wire  write_strobe;
wire  read_strobe;
wire  interrupt_ack;
wire  kcpsm3_reset;

//--
//-- Signals used to generate interrupt 
//--
reg[26:0] int_count;
reg event_1hz;

//-- Signals for LCD operation
//--
//--

reg        lcd_rw_control;
reg[7:0]   lcd_output_data;
pacoblaze3 led_8seg_kcpsm
(
                  .address(address),
               .instruction(instruction),
                   .port_id(port_id),
              .write_strobe(write_strobe),
                  .out_port(out_port),
               .read_strobe(read_strobe),
                   .in_port(in_port),
                 .interrupt(trapped_interupt),
             .interrupt_ack(interrupt_ack),
                     .reset(kcpsm3_reset),
                       .clk(clk));

 wire [19:0] raw_instruction;
	
	pacoblaze_instruction_memory 
	pacoblaze_instruction_memory_inst(
     	.addr(address),
	    .outdata(raw_instruction)
	);
	
	always @ (posedge clk)
	begin
	      instruction <= raw_instruction[17:0];
	end

    assign kcpsm3_reset = 0;                       
  
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- Interrupt 
//	 -- Using the module trap_edge created in the HW, we have an interupt signal that comes from the data_FF, and the trap edge module
//  -- traps the edge until interupt_ack resets it. 
//  ----------------------------------------------------------------------------------------------------------------------------------

		wire trapped_interupt;
		trap_edge trap_interupt(.async_sig(interrupt), .clock(clk), .reset(interrupt_ack), .trapped_edge(trapped_interupt));
		
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 input ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  --
//  -- The inputs connect via a pipelined multiplexer
//  --

 always @ (posedge clk)
 begin
    case (port_id[7:0])
        8'h00: in_port <= input_data[7:0];	// ID PORT = 0 THEN BYTE 1 (0 to 7)
		  8'h01: in_port <= input_data[15:8];	// ID PORT = 1 THEN BYTE 2	( 8 to 15)
		  8'h02: in_port <= input_data[23:16];	// ID PORT = 10 THEN BYTE 3 (16 to 23)
		  8'h04: in_port <= input_data[31:24];	// ID PORT = 100 THEN BYTE 14 (24 to 31)
		  default: in_port <= 8'bx;
		  
    endcase
end
   
//
//  --
//  ----------------------------------------------------------------------------------------------------------------------------------
//  -- KCPSM3 output ports 
//  ----------------------------------------------------------------------------------------------------------------------------------
//  --
//  -- adding the output registers to the processor
//  --
//   

	// 
  always @ (posedge clk)
  begin
        //LED is port 80 hex 
        if (write_strobe & port_id[7])  //IF PORT ID 1000_0000 THEN OUTPUTS OUR LED 2 TO 9
          led[9:2] <= out_port;
        if (write_strobe & port_id[6])  //IF PORT ID 100_0000 THEN OUTPUT OUR 0 THIS IS OUR 1 SECOND LED
          led[0] <= out_port[0];

  end


endmodule
