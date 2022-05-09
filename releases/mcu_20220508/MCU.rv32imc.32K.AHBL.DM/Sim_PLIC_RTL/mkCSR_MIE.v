//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// mv_read                        O    32
// mav_write                      O    32
// CLK                            I     1 clock
// RST_N                          I     1 reset
// mav_write_mie                  I     3
// EN_reset                       I     1
// EN_mav_write                   I     1
//
// Combinational paths from inputs to outputs:
//   mav_write_mie -> mav_write
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkCSR_MIE(CLK,
		 RST_N,

		 EN_reset,

		 mv_read,

		 mav_write_mie,
		 EN_mav_write,
		 mav_write);
  input  CLK;
  input  RST_N;

  // action method reset
  input  EN_reset;

  // value method mv_read
  output [31 : 0] mv_read;

  // actionvalue method mav_write
  input  [2 : 0] mav_write_mie;
  input  EN_mav_write;
  output [31 : 0] mav_write;

  // signals for module outputs
  wire [31 : 0] mav_write, mv_read;

  // register rg_meie
  reg rg_meie;
  wire rg_meie$D_IN, rg_meie$EN;

  // register rg_msie
  reg rg_msie;
  wire rg_msie$D_IN, rg_msie$EN;

  // register rg_mtie
  reg rg_mtie;
  wire rg_mtie$D_IN, rg_mtie$EN;

  // rule scheduling signals
  wire CAN_FIRE_mav_write,
       CAN_FIRE_reset,
       WILL_FIRE_mav_write,
       WILL_FIRE_reset;

  // remaining internal signals
  wire [11 : 0] new_mie__h340, x__h212;

  // action method reset
  assign CAN_FIRE_reset = 1'd1 ;
  assign WILL_FIRE_reset = EN_reset ;

  // value method mv_read
  assign mv_read = { 20'd0, x__h212 } ;

  // actionvalue method mav_write
  assign mav_write = { 20'd0, new_mie__h340 } ;
  assign CAN_FIRE_mav_write = 1'd1 ;
  assign WILL_FIRE_mav_write = EN_mav_write ;

  // register rg_meie
  assign rg_meie$D_IN = EN_mav_write && mav_write_mie[2] ;
  assign rg_meie$EN = EN_mav_write || EN_reset ;

  // register rg_msie
  assign rg_msie$D_IN = EN_mav_write && mav_write_mie[0] ;
  assign rg_msie$EN = EN_mav_write || EN_reset ;

  // register rg_mtie
  assign rg_mtie$D_IN = EN_mav_write && mav_write_mie[1] ;
  assign rg_mtie$EN = EN_mav_write || EN_reset ;

  // remaining internal signals
  assign new_mie__h340 =
	     { mav_write_mie[2],
	       3'b0,
	       mav_write_mie[1],
	       3'b0,
	       mav_write_mie[0],
	       3'b0 } ;
  assign x__h212 = { rg_meie, 3'b0, rg_mtie, 3'b0, rg_msie, 3'b0 } ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_meie <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_msie <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_mtie <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (rg_meie$EN) rg_meie <= `BSV_ASSIGNMENT_DELAY rg_meie$D_IN;
	if (rg_msie$EN) rg_msie <= `BSV_ASSIGNMENT_DELAY rg_msie$D_IN;
	if (rg_mtie$EN) rg_mtie <= `BSV_ASSIGNMENT_DELAY rg_mtie$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_meie = 1'h0;
    rg_msie = 1'h0;
    rg_mtie = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkCSR_MIE
