//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// mv_read                        O    32
// CLK                            I     1 clock
// RST_N                          I     1 reset
// m_external_interrupt_req_req   I     1 reg
// m_software_interrupt_req_req   I     1 reg
// m_timer_interrupt_req_req      I     1 reg
// EN_reset                       I     1 unused
//
// No combinational paths from inputs to outputs
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

module mkCSR_MIP(CLK,
		 RST_N,

		 EN_reset,

		 mv_read,

		 m_external_interrupt_req_req,

		 m_software_interrupt_req_req,

		 m_timer_interrupt_req_req);
  input  CLK;
  input  RST_N;

  // action method reset
  input  EN_reset;

  // value method mv_read
  output [31 : 0] mv_read;

  // action method m_external_interrupt_req
  input  m_external_interrupt_req_req;

  // action method m_software_interrupt_req
  input  m_software_interrupt_req_req;

  // action method m_timer_interrupt_req
  input  m_timer_interrupt_req_req;

  // signals for module outputs
  wire [31 : 0] mv_read;

  // register rg_meip
  reg rg_meip;
  wire rg_meip$D_IN, rg_meip$EN;

  // register rg_msip
  reg rg_msip;
  wire rg_msip$D_IN, rg_msip$EN;

  // register rg_mtip
  reg rg_mtip;
  wire rg_mtip$D_IN, rg_mtip$EN;

  // rule scheduling signals
  wire CAN_FIRE_m_external_interrupt_req,
       CAN_FIRE_m_software_interrupt_req,
       CAN_FIRE_m_timer_interrupt_req,
       CAN_FIRE_reset,
       WILL_FIRE_m_external_interrupt_req,
       WILL_FIRE_m_software_interrupt_req,
       WILL_FIRE_m_timer_interrupt_req,
       WILL_FIRE_reset;

  // remaining internal signals
  wire [11 : 0] new_mip__h214;

  // action method reset
  assign CAN_FIRE_reset = 1'd1 ;
  assign WILL_FIRE_reset = EN_reset ;

  // value method mv_read
  assign mv_read = { 20'd0, new_mip__h214 } ;

  // action method m_external_interrupt_req
  assign CAN_FIRE_m_external_interrupt_req = 1'd1 ;
  assign WILL_FIRE_m_external_interrupt_req = 1'd1 ;

  // action method m_software_interrupt_req
  assign CAN_FIRE_m_software_interrupt_req = 1'd1 ;
  assign WILL_FIRE_m_software_interrupt_req = 1'd1 ;

  // action method m_timer_interrupt_req
  assign CAN_FIRE_m_timer_interrupt_req = 1'd1 ;
  assign WILL_FIRE_m_timer_interrupt_req = 1'd1 ;

  // register rg_meip
  assign rg_meip$D_IN = m_external_interrupt_req_req ;
  assign rg_meip$EN = 1'b1 ;

  // register rg_msip
  assign rg_msip$D_IN = m_software_interrupt_req_req ;
  assign rg_msip$EN = 1'b1 ;

  // register rg_mtip
  assign rg_mtip$D_IN = m_timer_interrupt_req_req ;
  assign rg_mtip$EN = 1'b1 ;

  // remaining internal signals
  assign new_mip__h214 = { rg_meip, 3'b0, rg_mtip, 3'b0, rg_msip, 3'b0 } ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_meip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_msip <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_mtip <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (rg_meip$EN) rg_meip <= `BSV_ASSIGNMENT_DELAY rg_meip$D_IN;
	if (rg_msip$EN) rg_msip <= `BSV_ASSIGNMENT_DELAY rg_msip$D_IN;
	if (rg_mtip$EN) rg_mtip <= `BSV_ASSIGNMENT_DELAY rg_mtip$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_meip = 1'h0;
    rg_msip = 1'h0;
    rg_mtip = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkCSR_MIP

