//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// m_itcm_addr_base               O    32 const
// m_itcm_addr_size               O    32 const
// m_itcm_addr_lim                O    32 const
// m_is_itcm_addr                 O     1
// m_dtcm_addr_base               O    32 const
// m_dtcm_addr_size               O    32 const
// m_dtcm_addr_lim                O    32 const
// m_is_dtcm_addr                 O     1
// m_pc_reset_value               O    32 const
// m_mtvec_reset_value            O    32 const
// CLK                            I     1 unused
// RST_N                          I     1 unused
// m_is_itcm_addr_addr            I    32
// m_is_dtcm_addr_addr            I    32
//
// Combinational paths from inputs to outputs:
//   m_is_itcm_addr_addr -> m_is_itcm_addr
//   m_is_dtcm_addr_addr -> m_is_dtcm_addr
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

module mkCore_Map(CLK,
		  RST_N,

		  m_itcm_addr_base,

		  m_itcm_addr_size,

		  m_itcm_addr_lim,

		  m_is_itcm_addr_addr,
		  m_is_itcm_addr,

		  m_dtcm_addr_base,

		  m_dtcm_addr_size,

		  m_dtcm_addr_lim,

		  m_is_dtcm_addr_addr,
		  m_is_dtcm_addr,

		  m_pc_reset_value,

		  m_mtvec_reset_value);
  input  CLK;
  input  RST_N;

  // value method m_itcm_addr_base
  output [31 : 0] m_itcm_addr_base;

  // value method m_itcm_addr_size
  output [31 : 0] m_itcm_addr_size;

  // value method m_itcm_addr_lim
  output [31 : 0] m_itcm_addr_lim;

  // value method m_is_itcm_addr
  input  [31 : 0] m_is_itcm_addr_addr;
  output m_is_itcm_addr;

  // value method m_dtcm_addr_base
  output [31 : 0] m_dtcm_addr_base;

  // value method m_dtcm_addr_size
  output [31 : 0] m_dtcm_addr_size;

  // value method m_dtcm_addr_lim
  output [31 : 0] m_dtcm_addr_lim;

  // value method m_is_dtcm_addr
  input  [31 : 0] m_is_dtcm_addr_addr;
  output m_is_dtcm_addr;

  // value method m_pc_reset_value
  output [31 : 0] m_pc_reset_value;

  // value method m_mtvec_reset_value
  output [31 : 0] m_mtvec_reset_value;

  // signals for module outputs
  wire [31 : 0] m_dtcm_addr_base,
		m_dtcm_addr_lim,
		m_dtcm_addr_size,
		m_itcm_addr_base,
		m_itcm_addr_lim,
		m_itcm_addr_size,
		m_mtvec_reset_value,
		m_pc_reset_value;
  wire m_is_dtcm_addr, m_is_itcm_addr;

  // value method m_itcm_addr_base
  assign m_itcm_addr_base = 32'hC0000000 ;

  // value method m_itcm_addr_size
  assign m_itcm_addr_size = 32'd1048576 ;

  // value method m_itcm_addr_lim
  assign m_itcm_addr_lim = 32'hC0100000 ;

  // value method m_is_itcm_addr
  assign m_is_itcm_addr = m_is_itcm_addr_addr[31:20] == 12'd3072 ;

  // value method m_dtcm_addr_base
  assign m_dtcm_addr_base = 32'hC8000000 ;

  // value method m_dtcm_addr_size
  assign m_dtcm_addr_size = 32'd1048576 ;

  // value method m_dtcm_addr_lim
  assign m_dtcm_addr_lim = 32'hC8100000 ;

  // value method m_is_dtcm_addr
  assign m_is_dtcm_addr = m_is_dtcm_addr_addr[31:20] == 12'd3200 ;

  // value method m_pc_reset_value
  assign m_pc_reset_value = 32'hC0000000 ;

  // value method m_mtvec_reset_value
  assign m_mtvec_reset_value = 32'hC0000000 ;
endmodule  // mkCore_Map
