//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// master1_HADDR                  O    32 reg
// master1_HBURST                 O     3 const
// master1_HMASTLOCK              O     1 const
// master1_HPROT                  O     4 const
// master1_HSIZE                  O     3 reg
// master1_HTRANS                 O     2 reg
// master1_HWDATA                 O    32 reg
// master1_HWRITE                 O     1 reg
// RDY_set_watch_tohost           O     1 reg
// mv_tohost_value                O    32 reg
// RDY_mv_tohost_value            O     1 reg
// RDY_set_verbosity              O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// master1_HRDATA                 I    32 reg
// master1_HREADY                 I     1
// master1_HRESP                  I     1
// ext_interrupt                  I     1 reg
// sw_interrupt                   I     1 reg
// timer_interrupt                I     1 reg
// set_watch_tohost_watch_tohost  I     1
// set_watch_tohost_tohost_addr   I    32 reg
// set_verbosity_verbosity        I     2 reg
// EN_set_watch_tohost            I     1
// EN_set_verbosity               I     1
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

module mkMCUTop(CLK,
		RST_N,

		master1_HADDR,

		master1_HBURST,

		master1_HMASTLOCK,

		master1_HPROT,

		master1_HSIZE,

		master1_HTRANS,

		master1_HWDATA,

		master1_HWRITE,

		master1_HRDATA,

		master1_HREADY,

		master1_HRESP,

		ext_interrupt,

		sw_interrupt,

		timer_interrupt,

		set_watch_tohost_watch_tohost,
		set_watch_tohost_tohost_addr,
		EN_set_watch_tohost,
		RDY_set_watch_tohost,

		mv_tohost_value,
		RDY_mv_tohost_value,

		set_verbosity_verbosity,
		EN_set_verbosity,
		RDY_set_verbosity);
  input  CLK;
  input  RST_N;

  // value method master1_haddr
  output [31 : 0] master1_HADDR;

  // value method master1_hburst
  output [2 : 0] master1_HBURST;

  // value method master1_hmastlock
  output master1_HMASTLOCK;

  // value method master1_hprot
  output [3 : 0] master1_HPROT;

  // value method master1_hsize
  output [2 : 0] master1_HSIZE;

  // value method master1_htrans
  output [1 : 0] master1_HTRANS;

  // value method master1_hwdata
  output [31 : 0] master1_HWDATA;

  // value method master1_hwrite
  output master1_HWRITE;

  // action method master1_hrdata
  input  [31 : 0] master1_HRDATA;

  // action method master1_hready
  input  master1_HREADY;

  // action method master1_hresp
  input  master1_HRESP;

  // action method m_external_interrupt_req
  input  ext_interrupt;

  // action method software_interrupt_req
  input  sw_interrupt;

  // action method timer_interrupt_req
  input  timer_interrupt;

  // action method set_watch_tohost
  input  set_watch_tohost_watch_tohost;
  input  [31 : 0] set_watch_tohost_tohost_addr;
  input  EN_set_watch_tohost;
  output RDY_set_watch_tohost;

  // value method mv_tohost_value
  output [31 : 0] mv_tohost_value;
  output RDY_mv_tohost_value;

  // action method set_verbosity
  input  [1 : 0] set_verbosity_verbosity;
  input  EN_set_verbosity;
  output RDY_set_verbosity;

  // signals for module outputs
  wire [31 : 0] master1_HADDR, master1_HWDATA, mv_tohost_value;
  wire [3 : 0] master1_HPROT;
  wire [2 : 0] master1_HBURST, master1_HSIZE;
  wire [1 : 0] master1_HTRANS;
  wire RDY_mv_tohost_value,
       RDY_set_verbosity,
       RDY_set_watch_tohost,
       master1_HMASTLOCK,
       master1_HWRITE;

  // ports of submodule bscore
  wire [31 : 0] bscore$master1_HADDR,
		bscore$master1_HRDATA,
		bscore$master1_HWDATA,
		bscore$mv_tohost_value,
		bscore$set_watch_tohost_tohost_addr;
  wire [3 : 0] bscore$master1_HPROT;
  wire [2 : 0] bscore$master1_HBURST, bscore$master1_HSIZE;
  wire [1 : 0] bscore$master1_HTRANS, bscore$set_verbosity_verbosity;
  wire bscore$EN_set_verbosity,
       bscore$EN_set_watch_tohost,
       bscore$RDY_mv_tohost_value,
       bscore$RDY_set_watch_tohost,
       bscore$ext_interrupt,
       bscore$master1_HMASTLOCK,
       bscore$master1_HREADY,
       bscore$master1_HRESP,
       bscore$master1_HWRITE,
       bscore$set_watch_tohost_watch_tohost,
       bscore$sw_interrupt,
       bscore$timer_interrupt;

  // rule scheduling signals
  wire CAN_FIRE_m_external_interrupt_req,
       CAN_FIRE_master1_hrdata,
       CAN_FIRE_master1_hready,
       CAN_FIRE_master1_hresp,
       CAN_FIRE_set_verbosity,
       CAN_FIRE_set_watch_tohost,
       CAN_FIRE_software_interrupt_req,
       CAN_FIRE_timer_interrupt_req,
       WILL_FIRE_m_external_interrupt_req,
       WILL_FIRE_master1_hrdata,
       WILL_FIRE_master1_hready,
       WILL_FIRE_master1_hresp,
       WILL_FIRE_set_verbosity,
       WILL_FIRE_set_watch_tohost,
       WILL_FIRE_software_interrupt_req,
       WILL_FIRE_timer_interrupt_req;

  // value method master1_haddr
  assign master1_HADDR = bscore$master1_HADDR ;

  // value method master1_hburst
  assign master1_HBURST = bscore$master1_HBURST ;

  // value method master1_hmastlock
  assign master1_HMASTLOCK = bscore$master1_HMASTLOCK ;

  // value method master1_hprot
  assign master1_HPROT = bscore$master1_HPROT ;

  // value method master1_hsize
  assign master1_HSIZE = bscore$master1_HSIZE ;

  // value method master1_htrans
  assign master1_HTRANS = bscore$master1_HTRANS ;

  // value method master1_hwdata
  assign master1_HWDATA = bscore$master1_HWDATA ;

  // value method master1_hwrite
  assign master1_HWRITE = bscore$master1_HWRITE ;

  // action method master1_hrdata
  assign CAN_FIRE_master1_hrdata = 1'd1 ;
  assign WILL_FIRE_master1_hrdata = 1'd1 ;

  // action method master1_hready
  assign CAN_FIRE_master1_hready = 1'd1 ;
  assign WILL_FIRE_master1_hready = 1'd1 ;

  // action method master1_hresp
  assign CAN_FIRE_master1_hresp = 1'd1 ;
  assign WILL_FIRE_master1_hresp = 1'd1 ;

  // action method m_external_interrupt_req
  assign CAN_FIRE_m_external_interrupt_req = 1'd1 ;
  assign WILL_FIRE_m_external_interrupt_req = 1'd1 ;

  // action method software_interrupt_req
  assign CAN_FIRE_software_interrupt_req = 1'd1 ;
  assign WILL_FIRE_software_interrupt_req = 1'd1 ;

  // action method timer_interrupt_req
  assign CAN_FIRE_timer_interrupt_req = 1'd1 ;
  assign WILL_FIRE_timer_interrupt_req = 1'd1 ;

  // action method set_watch_tohost
  assign RDY_set_watch_tohost = bscore$RDY_set_watch_tohost ;
  assign CAN_FIRE_set_watch_tohost = bscore$RDY_set_watch_tohost ;
  assign WILL_FIRE_set_watch_tohost = EN_set_watch_tohost ;

  // value method mv_tohost_value
  assign mv_tohost_value = bscore$mv_tohost_value ;
  assign RDY_mv_tohost_value = bscore$RDY_mv_tohost_value ;

  // action method set_verbosity
  assign RDY_set_verbosity = 1'd1 ;
  assign CAN_FIRE_set_verbosity = 1'd1 ;
  assign WILL_FIRE_set_verbosity = EN_set_verbosity ;

  // submodule bscore
  mkBSCore bscore(.CLK(CLK),
		  .RST_N(RST_N),
		  .ext_interrupt(bscore$ext_interrupt),
		  .master1_HRDATA(bscore$master1_HRDATA),
		  .master1_HREADY(bscore$master1_HREADY),
		  .master1_HRESP(bscore$master1_HRESP),
		  .set_verbosity_verbosity(bscore$set_verbosity_verbosity),
		  .set_watch_tohost_tohost_addr(bscore$set_watch_tohost_tohost_addr),
		  .set_watch_tohost_watch_tohost(bscore$set_watch_tohost_watch_tohost),
		  .sw_interrupt(bscore$sw_interrupt),
		  .timer_interrupt(bscore$timer_interrupt),
		  .EN_set_watch_tohost(bscore$EN_set_watch_tohost),
		  .EN_set_verbosity(bscore$EN_set_verbosity),
		  .master1_HADDR(bscore$master1_HADDR),
		  .master1_HBURST(bscore$master1_HBURST),
		  .master1_HMASTLOCK(bscore$master1_HMASTLOCK),
		  .master1_HPROT(bscore$master1_HPROT),
		  .master1_HSIZE(bscore$master1_HSIZE),
		  .master1_HTRANS(bscore$master1_HTRANS),
		  .master1_HWDATA(bscore$master1_HWDATA),
		  .master1_HWRITE(bscore$master1_HWRITE),
		  .RDY_set_watch_tohost(bscore$RDY_set_watch_tohost),
		  .mv_tohost_value(bscore$mv_tohost_value),
		  .RDY_mv_tohost_value(bscore$RDY_mv_tohost_value),
		  .RDY_set_verbosity());

  // submodule bscore
  assign bscore$ext_interrupt = ext_interrupt ;
  assign bscore$master1_HRDATA = master1_HRDATA ;
  assign bscore$master1_HREADY = master1_HREADY ;
  assign bscore$master1_HRESP = master1_HRESP ;
  assign bscore$set_verbosity_verbosity = set_verbosity_verbosity ;
  assign bscore$set_watch_tohost_tohost_addr = set_watch_tohost_tohost_addr ;
  assign bscore$set_watch_tohost_watch_tohost =
	     set_watch_tohost_watch_tohost ;
  assign bscore$sw_interrupt = sw_interrupt ;
  assign bscore$timer_interrupt = timer_interrupt ;
  assign bscore$EN_set_watch_tohost = EN_set_watch_tohost ;
  assign bscore$EN_set_verbosity = EN_set_verbosity ;
endmodule  // mkMCUTop
