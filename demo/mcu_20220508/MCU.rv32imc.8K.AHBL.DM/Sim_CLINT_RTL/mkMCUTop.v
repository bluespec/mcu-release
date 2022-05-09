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
// dma_server_awready             O     1 reg
// dma_server_wready              O     1 reg
// dma_server_bvalid              O     1 reg
// dma_server_bid                 O     4 reg
// dma_server_bresp               O     2 reg
// dma_server_arready             O     1 reg
// dma_server_rvalid              O     1 reg
// dma_server_rid                 O     4 reg
// dma_server_rdata               O    32 reg
// dma_server_rresp               O     2 reg
// dma_server_rlast               O     1 reg
// reset_done                     O     1 reg
// RDY_set_watch_tohost           O     1 reg
// mv_tohost_value                O    32 reg
// RDY_mv_tohost_value            O     1 reg
// TDO                            O     1
// CLK_tclk_out                   O     1 clock
// CLK_GATE_tclk_out              O     1 const
// RST_N_ndm_resetn               O     1 reset
// TRST                           I     1 reset
// CLK                            I     1 clock
// RST_N                          I     1 reset
// master1_HRDATA                 I    32 reg
// master1_HREADY                 I     1
// master1_HRESP                  I     1
// ext_interrupt                  I     1 reg
// sw_interrupt                   I     1 reg
// timer_interrupt                I     1 reg
// dma_server_awvalid             I     1
// dma_server_awid                I     4 reg
// dma_server_awaddr              I    32 reg
// dma_server_awlen               I     8 reg
// dma_server_awsize              I     3 reg
// dma_server_awburst             I     2 reg
// dma_server_awlock              I     1 reg
// dma_server_awcache             I     4 reg
// dma_server_awprot              I     3 reg
// dma_server_awqos               I     4 reg
// dma_server_awregion            I     4 reg
// dma_server_wvalid              I     1
// dma_server_wdata               I    32 reg
// dma_server_wstrb               I     4 reg
// dma_server_wlast               I     1 reg
// dma_server_bready              I     1
// dma_server_arvalid             I     1
// dma_server_arid                I     4 reg
// dma_server_araddr              I    32 reg
// dma_server_arlen               I     8 reg
// dma_server_arsize              I     3 reg
// dma_server_arburst             I     2 reg
// dma_server_arlock              I     1 reg
// dma_server_arcache             I     4 reg
// dma_server_arprot              I     3 reg
// dma_server_arqos               I     4 reg
// dma_server_arregion            I     4 reg
// dma_server_rready              I     1
// cpu_halt_x                     I     1
// set_watch_tohost_watch_tohost  I     1
// set_watch_tohost_tohost_addr   I    32 reg
// TDI                            I     1
// TMS                            I     1
// TCK                            I     1
// EN_set_watch_tohost            I     1
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

module mkMCUTop(TRST,
		CLK,
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

		dma_server_awvalid,
		dma_server_awid,
		dma_server_awaddr,
		dma_server_awlen,
		dma_server_awsize,
		dma_server_awburst,
		dma_server_awlock,
		dma_server_awcache,
		dma_server_awprot,
		dma_server_awqos,
		dma_server_awregion,

		dma_server_awready,

		dma_server_wvalid,
		dma_server_wdata,
		dma_server_wstrb,
		dma_server_wlast,

		dma_server_wready,

		dma_server_bvalid,

		dma_server_bid,

		dma_server_bresp,

		dma_server_bready,

		dma_server_arvalid,
		dma_server_arid,
		dma_server_araddr,
		dma_server_arlen,
		dma_server_arsize,
		dma_server_arburst,
		dma_server_arlock,
		dma_server_arcache,
		dma_server_arprot,
		dma_server_arqos,
		dma_server_arregion,

		dma_server_arready,

		dma_server_rvalid,

		dma_server_rid,

		dma_server_rdata,

		dma_server_rresp,

		dma_server_rlast,

		dma_server_rready,

		reset_done,

		cpu_halt_x,

		set_watch_tohost_watch_tohost,
		set_watch_tohost_tohost_addr,
		EN_set_watch_tohost,
		RDY_set_watch_tohost,

		mv_tohost_value,
		RDY_mv_tohost_value,

		TDI,

		TMS,

		TCK,

		TDO,

		CLK_tclk_out,
		CLK_GATE_tclk_out,

		RST_N_ndm_resetn);
  input  TRST;
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

  // action method dma_server_m_awvalid
  input  dma_server_awvalid;
  input  [3 : 0] dma_server_awid;
  input  [31 : 0] dma_server_awaddr;
  input  [7 : 0] dma_server_awlen;
  input  [2 : 0] dma_server_awsize;
  input  [1 : 0] dma_server_awburst;
  input  dma_server_awlock;
  input  [3 : 0] dma_server_awcache;
  input  [2 : 0] dma_server_awprot;
  input  [3 : 0] dma_server_awqos;
  input  [3 : 0] dma_server_awregion;

  // value method dma_server_m_awready
  output dma_server_awready;

  // action method dma_server_m_wvalid
  input  dma_server_wvalid;
  input  [31 : 0] dma_server_wdata;
  input  [3 : 0] dma_server_wstrb;
  input  dma_server_wlast;

  // value method dma_server_m_wready
  output dma_server_wready;

  // value method dma_server_m_bvalid
  output dma_server_bvalid;

  // value method dma_server_m_bid
  output [3 : 0] dma_server_bid;

  // value method dma_server_m_bresp
  output [1 : 0] dma_server_bresp;

  // value method dma_server_m_buser

  // action method dma_server_m_bready
  input  dma_server_bready;

  // action method dma_server_m_arvalid
  input  dma_server_arvalid;
  input  [3 : 0] dma_server_arid;
  input  [31 : 0] dma_server_araddr;
  input  [7 : 0] dma_server_arlen;
  input  [2 : 0] dma_server_arsize;
  input  [1 : 0] dma_server_arburst;
  input  dma_server_arlock;
  input  [3 : 0] dma_server_arcache;
  input  [2 : 0] dma_server_arprot;
  input  [3 : 0] dma_server_arqos;
  input  [3 : 0] dma_server_arregion;

  // value method dma_server_m_arready
  output dma_server_arready;

  // value method dma_server_m_rvalid
  output dma_server_rvalid;

  // value method dma_server_m_rid
  output [3 : 0] dma_server_rid;

  // value method dma_server_m_rdata
  output [31 : 0] dma_server_rdata;

  // value method dma_server_m_rresp
  output [1 : 0] dma_server_rresp;

  // value method dma_server_m_rlast
  output dma_server_rlast;

  // value method dma_server_m_ruser

  // action method dma_server_m_rready
  input  dma_server_rready;

  // value method reset_done
  output reset_done;

  // action method cpu_halt
  input  cpu_halt_x;

  // action method set_watch_tohost
  input  set_watch_tohost_watch_tohost;
  input  [31 : 0] set_watch_tohost_tohost_addr;
  input  EN_set_watch_tohost;
  output RDY_set_watch_tohost;

  // value method mv_tohost_value
  output [31 : 0] mv_tohost_value;
  output RDY_mv_tohost_value;

  // action method jtag_tdi
  input  TDI;

  // action method jtag_tms
  input  TMS;

  // action method jtag_tclk
  input  TCK;

  // value method jtag_tdo
  output TDO;

  // oscillator and gates for output clock CLK_tclk_out
  output CLK_tclk_out;
  output CLK_GATE_tclk_out;

  // output resets
  output RST_N_ndm_resetn;

  // signals for module outputs
  wire [31 : 0] dma_server_rdata,
		master1_HADDR,
		master1_HWDATA,
		mv_tohost_value;
  wire [3 : 0] dma_server_bid, dma_server_rid, master1_HPROT;
  wire [2 : 0] master1_HBURST, master1_HSIZE;
  wire [1 : 0] dma_server_bresp, dma_server_rresp, master1_HTRANS;
  wire CLK_GATE_tclk_out,
       CLK_tclk_out,
       RDY_mv_tohost_value,
       RDY_set_watch_tohost,
       RST_N_ndm_resetn,
       TDO,
       dma_server_arready,
       dma_server_awready,
       dma_server_bvalid,
       dma_server_rlast,
       dma_server_rvalid,
       dma_server_wready,
       master1_HMASTLOCK,
       master1_HWRITE,
       reset_done;

  // ports of submodule bscore
  reg [70 : 0] bscore$debug_request_put;
  wire [36 : 0] bscore$debug_response_get;
  wire [31 : 0] bscore$dma_server_araddr,
		bscore$dma_server_awaddr,
		bscore$dma_server_rdata,
		bscore$dma_server_wdata,
		bscore$master1_HADDR,
		bscore$master1_HRDATA,
		bscore$master1_HWDATA,
		bscore$mv_tohost_value,
		bscore$set_watch_tohost_tohost_addr;
  wire [7 : 0] bscore$dma_server_arlen, bscore$dma_server_awlen;
  wire [3 : 0] bscore$dma_server_arcache,
	       bscore$dma_server_arid,
	       bscore$dma_server_arqos,
	       bscore$dma_server_arregion,
	       bscore$dma_server_awcache,
	       bscore$dma_server_awid,
	       bscore$dma_server_awqos,
	       bscore$dma_server_awregion,
	       bscore$dma_server_bid,
	       bscore$dma_server_rid,
	       bscore$dma_server_wstrb,
	       bscore$master1_HPROT;
  wire [2 : 0] bscore$dma_server_arprot,
	       bscore$dma_server_arsize,
	       bscore$dma_server_awprot,
	       bscore$dma_server_awsize,
	       bscore$master1_HBURST,
	       bscore$master1_HSIZE;
  wire [1 : 0] bscore$dma_server_arburst,
	       bscore$dma_server_awburst,
	       bscore$dma_server_bresp,
	       bscore$dma_server_rresp,
	       bscore$master1_HTRANS;
  wire bscore$EN_debug_request_put,
       bscore$EN_debug_response_get,
       bscore$EN_set_watch_tohost,
       bscore$RDY_debug_request_put,
       bscore$RDY_debug_response_get,
       bscore$RDY_mv_tohost_value,
       bscore$RDY_set_watch_tohost,
       bscore$cpu_halt_x,
       bscore$dma_server_arlock,
       bscore$dma_server_arready,
       bscore$dma_server_arvalid,
       bscore$dma_server_awlock,
       bscore$dma_server_awready,
       bscore$dma_server_awvalid,
       bscore$dma_server_bready,
       bscore$dma_server_bvalid,
       bscore$dma_server_rlast,
       bscore$dma_server_rready,
       bscore$dma_server_rvalid,
       bscore$dma_server_wlast,
       bscore$dma_server_wready,
       bscore$dma_server_wvalid,
       bscore$ext_interrupt,
       bscore$master1_HMASTLOCK,
       bscore$master1_HREADY,
       bscore$master1_HRESP,
       bscore$master1_HWRITE,
       bscore$reset_done,
       bscore$set_watch_tohost_watch_tohost,
       bscore$sw_interrupt,
       bscore$timer_interrupt;

  // ports of submodule bsdebug
  reg [36 : 0] bsdebug$toCore_response_put;
  wire [70 : 0] bsdebug$toCore_request_get;
  wire bsdebug$CLK_jtag_tclk_out,
       bsdebug$EN_toCore_request_get,
       bsdebug$EN_toCore_response_put,
       bsdebug$RDY_toCore_request_get,
       bsdebug$RDY_toCore_response_put,
       bsdebug$RST_N_ndm_resetn,
       bsdebug$jtag_TCK,
       bsdebug$jtag_TDI,
       bsdebug$jtag_TDO,
       bsdebug$jtag_TMS;

  // rule scheduling signals
  wire CAN_FIRE_RL_ClientServerRequest,
       CAN_FIRE_RL_ClientServerResponse,
       CAN_FIRE_cpu_halt,
       CAN_FIRE_dma_server_m_arvalid,
       CAN_FIRE_dma_server_m_awvalid,
       CAN_FIRE_dma_server_m_bready,
       CAN_FIRE_dma_server_m_rready,
       CAN_FIRE_dma_server_m_wvalid,
       CAN_FIRE_jtag_tclk,
       CAN_FIRE_jtag_tdi,
       CAN_FIRE_jtag_tms,
       CAN_FIRE_m_external_interrupt_req,
       CAN_FIRE_master1_hrdata,
       CAN_FIRE_master1_hready,
       CAN_FIRE_master1_hresp,
       CAN_FIRE_set_watch_tohost,
       CAN_FIRE_software_interrupt_req,
       CAN_FIRE_timer_interrupt_req,
       WILL_FIRE_RL_ClientServerRequest,
       WILL_FIRE_RL_ClientServerResponse,
       WILL_FIRE_cpu_halt,
       WILL_FIRE_dma_server_m_arvalid,
       WILL_FIRE_dma_server_m_awvalid,
       WILL_FIRE_dma_server_m_bready,
       WILL_FIRE_dma_server_m_rready,
       WILL_FIRE_dma_server_m_wvalid,
       WILL_FIRE_jtag_tclk,
       WILL_FIRE_jtag_tdi,
       WILL_FIRE_jtag_tms,
       WILL_FIRE_m_external_interrupt_req,
       WILL_FIRE_master1_hrdata,
       WILL_FIRE_master1_hready,
       WILL_FIRE_master1_hresp,
       WILL_FIRE_set_watch_tohost,
       WILL_FIRE_software_interrupt_req,
       WILL_FIRE_timer_interrupt_req;

  // oscillator and gates for output clock CLK_tclk_out
  assign CLK_tclk_out = bsdebug$CLK_jtag_tclk_out ;
  assign CLK_GATE_tclk_out = 1'b1 ;

  // output resets
  assign RST_N_ndm_resetn = bsdebug$RST_N_ndm_resetn ;

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

  // action method dma_server_m_awvalid
  assign CAN_FIRE_dma_server_m_awvalid = 1'd1 ;
  assign WILL_FIRE_dma_server_m_awvalid = 1'd1 ;

  // value method dma_server_m_awready
  assign dma_server_awready = bscore$dma_server_awready ;

  // action method dma_server_m_wvalid
  assign CAN_FIRE_dma_server_m_wvalid = 1'd1 ;
  assign WILL_FIRE_dma_server_m_wvalid = 1'd1 ;

  // value method dma_server_m_wready
  assign dma_server_wready = bscore$dma_server_wready ;

  // value method dma_server_m_bvalid
  assign dma_server_bvalid = bscore$dma_server_bvalid ;

  // value method dma_server_m_bid
  assign dma_server_bid = bscore$dma_server_bid ;

  // value method dma_server_m_bresp
  assign dma_server_bresp = bscore$dma_server_bresp ;

  // action method dma_server_m_bready
  assign CAN_FIRE_dma_server_m_bready = 1'd1 ;
  assign WILL_FIRE_dma_server_m_bready = 1'd1 ;

  // action method dma_server_m_arvalid
  assign CAN_FIRE_dma_server_m_arvalid = 1'd1 ;
  assign WILL_FIRE_dma_server_m_arvalid = 1'd1 ;

  // value method dma_server_m_arready
  assign dma_server_arready = bscore$dma_server_arready ;

  // value method dma_server_m_rvalid
  assign dma_server_rvalid = bscore$dma_server_rvalid ;

  // value method dma_server_m_rid
  assign dma_server_rid = bscore$dma_server_rid ;

  // value method dma_server_m_rdata
  assign dma_server_rdata = bscore$dma_server_rdata ;

  // value method dma_server_m_rresp
  assign dma_server_rresp = bscore$dma_server_rresp ;

  // value method dma_server_m_rlast
  assign dma_server_rlast = bscore$dma_server_rlast ;

  // action method dma_server_m_rready
  assign CAN_FIRE_dma_server_m_rready = 1'd1 ;
  assign WILL_FIRE_dma_server_m_rready = 1'd1 ;

  // value method reset_done
  assign reset_done = bscore$reset_done ;

  // action method cpu_halt
  assign CAN_FIRE_cpu_halt = 1'd1 ;
  assign WILL_FIRE_cpu_halt = 1'd1 ;

  // action method set_watch_tohost
  assign RDY_set_watch_tohost = bscore$RDY_set_watch_tohost ;
  assign CAN_FIRE_set_watch_tohost = bscore$RDY_set_watch_tohost ;
  assign WILL_FIRE_set_watch_tohost = EN_set_watch_tohost ;

  // value method mv_tohost_value
  assign mv_tohost_value = bscore$mv_tohost_value ;
  assign RDY_mv_tohost_value = bscore$RDY_mv_tohost_value ;

  // action method jtag_tdi
  assign CAN_FIRE_jtag_tdi = 1'd1 ;
  assign WILL_FIRE_jtag_tdi = 1'd1 ;

  // action method jtag_tms
  assign CAN_FIRE_jtag_tms = 1'd1 ;
  assign WILL_FIRE_jtag_tms = 1'd1 ;

  // action method jtag_tclk
  assign CAN_FIRE_jtag_tclk = 1'd1 ;
  assign WILL_FIRE_jtag_tclk = 1'd1 ;

  // value method jtag_tdo
  assign TDO = bsdebug$jtag_TDO ;

  // submodule bscore
  mkBSCore bscore(.CLK(CLK),
		  .RST_N(RST_N),
		  .cpu_halt_x(bscore$cpu_halt_x),
		  .debug_request_put(bscore$debug_request_put),
		  .dma_server_araddr(bscore$dma_server_araddr),
		  .dma_server_arburst(bscore$dma_server_arburst),
		  .dma_server_arcache(bscore$dma_server_arcache),
		  .dma_server_arid(bscore$dma_server_arid),
		  .dma_server_arlen(bscore$dma_server_arlen),
		  .dma_server_arlock(bscore$dma_server_arlock),
		  .dma_server_arprot(bscore$dma_server_arprot),
		  .dma_server_arqos(bscore$dma_server_arqos),
		  .dma_server_arregion(bscore$dma_server_arregion),
		  .dma_server_arsize(bscore$dma_server_arsize),
		  .dma_server_arvalid(bscore$dma_server_arvalid),
		  .dma_server_awaddr(bscore$dma_server_awaddr),
		  .dma_server_awburst(bscore$dma_server_awburst),
		  .dma_server_awcache(bscore$dma_server_awcache),
		  .dma_server_awid(bscore$dma_server_awid),
		  .dma_server_awlen(bscore$dma_server_awlen),
		  .dma_server_awlock(bscore$dma_server_awlock),
		  .dma_server_awprot(bscore$dma_server_awprot),
		  .dma_server_awqos(bscore$dma_server_awqos),
		  .dma_server_awregion(bscore$dma_server_awregion),
		  .dma_server_awsize(bscore$dma_server_awsize),
		  .dma_server_awvalid(bscore$dma_server_awvalid),
		  .dma_server_bready(bscore$dma_server_bready),
		  .dma_server_rready(bscore$dma_server_rready),
		  .dma_server_wdata(bscore$dma_server_wdata),
		  .dma_server_wlast(bscore$dma_server_wlast),
		  .dma_server_wstrb(bscore$dma_server_wstrb),
		  .dma_server_wvalid(bscore$dma_server_wvalid),
		  .ext_interrupt(bscore$ext_interrupt),
		  .master1_HRDATA(bscore$master1_HRDATA),
		  .master1_HREADY(bscore$master1_HREADY),
		  .master1_HRESP(bscore$master1_HRESP),
		  .set_watch_tohost_tohost_addr(bscore$set_watch_tohost_tohost_addr),
		  .set_watch_tohost_watch_tohost(bscore$set_watch_tohost_watch_tohost),
		  .sw_interrupt(bscore$sw_interrupt),
		  .timer_interrupt(bscore$timer_interrupt),
		  .EN_debug_request_put(bscore$EN_debug_request_put),
		  .EN_debug_response_get(bscore$EN_debug_response_get),
		  .EN_set_watch_tohost(bscore$EN_set_watch_tohost),
		  .master1_HADDR(bscore$master1_HADDR),
		  .master1_HBURST(bscore$master1_HBURST),
		  .master1_HMASTLOCK(bscore$master1_HMASTLOCK),
		  .master1_HPROT(bscore$master1_HPROT),
		  .master1_HSIZE(bscore$master1_HSIZE),
		  .master1_HTRANS(bscore$master1_HTRANS),
		  .master1_HWDATA(bscore$master1_HWDATA),
		  .master1_HWRITE(bscore$master1_HWRITE),
		  .RDY_debug_request_put(bscore$RDY_debug_request_put),
		  .debug_response_get(bscore$debug_response_get),
		  .RDY_debug_response_get(bscore$RDY_debug_response_get),
		  .dma_server_awready(bscore$dma_server_awready),
		  .dma_server_wready(bscore$dma_server_wready),
		  .dma_server_bvalid(bscore$dma_server_bvalid),
		  .dma_server_bid(bscore$dma_server_bid),
		  .dma_server_bresp(bscore$dma_server_bresp),
		  .dma_server_arready(bscore$dma_server_arready),
		  .dma_server_rvalid(bscore$dma_server_rvalid),
		  .dma_server_rid(bscore$dma_server_rid),
		  .dma_server_rdata(bscore$dma_server_rdata),
		  .dma_server_rresp(bscore$dma_server_rresp),
		  .dma_server_rlast(bscore$dma_server_rlast),
		  .reset_done(bscore$reset_done),
		  .RDY_set_watch_tohost(bscore$RDY_set_watch_tohost),
		  .mv_tohost_value(bscore$mv_tohost_value),
		  .RDY_mv_tohost_value(bscore$RDY_mv_tohost_value));

  // submodule bsdebug
  mkBSDebug bsdebug(.dmi_reset(TRST),
		    .CLK(CLK),
		    .RST_N(RST_N),
		    .jtag_TCK(bsdebug$jtag_TCK),
		    .jtag_TDI(bsdebug$jtag_TDI),
		    .jtag_TMS(bsdebug$jtag_TMS),
		    .toCore_response_put(bsdebug$toCore_response_put),
		    .EN_toCore_request_get(bsdebug$EN_toCore_request_get),
		    .EN_toCore_response_put(bsdebug$EN_toCore_response_put),
		    .toCore_request_get(bsdebug$toCore_request_get),
		    .RDY_toCore_request_get(bsdebug$RDY_toCore_request_get),
		    .RDY_toCore_response_put(bsdebug$RDY_toCore_response_put),
		    .jtag_TDO(bsdebug$jtag_TDO),
		    .CLK_jtag_tclk_out(bsdebug$CLK_jtag_tclk_out),
		    .CLK_GATE_jtag_tclk_out(),
		    .RST_N_ndm_resetn(bsdebug$RST_N_ndm_resetn));

  // rule RL_ClientServerRequest
  assign CAN_FIRE_RL_ClientServerRequest =
	     bsdebug$RDY_toCore_request_get && bscore$RDY_debug_request_put ;
  assign WILL_FIRE_RL_ClientServerRequest = CAN_FIRE_RL_ClientServerRequest ;

  // rule RL_ClientServerResponse
  assign CAN_FIRE_RL_ClientServerResponse =
	     bsdebug$RDY_toCore_response_put &&
	     bscore$RDY_debug_response_get ;
  assign WILL_FIRE_RL_ClientServerResponse =
	     CAN_FIRE_RL_ClientServerResponse ;

  // submodule bscore
  assign bscore$cpu_halt_x = cpu_halt_x ;
  always@(bsdebug$toCore_request_get)
  begin
    case (bsdebug$toCore_request_get[70:68])
      3'd0, 3'd1, 3'd2, 3'd3, 3'd4:
	  bscore$debug_request_put = bsdebug$toCore_request_get;
      default: bscore$debug_request_put = 71'h2AAAAAAAAAAAAAAAAA;
    endcase
  end
  assign bscore$dma_server_araddr = dma_server_araddr ;
  assign bscore$dma_server_arburst = dma_server_arburst ;
  assign bscore$dma_server_arcache = dma_server_arcache ;
  assign bscore$dma_server_arid = dma_server_arid ;
  assign bscore$dma_server_arlen = dma_server_arlen ;
  assign bscore$dma_server_arlock = dma_server_arlock ;
  assign bscore$dma_server_arprot = dma_server_arprot ;
  assign bscore$dma_server_arqos = dma_server_arqos ;
  assign bscore$dma_server_arregion = dma_server_arregion ;
  assign bscore$dma_server_arsize = dma_server_arsize ;
  assign bscore$dma_server_arvalid = dma_server_arvalid ;
  assign bscore$dma_server_awaddr = dma_server_awaddr ;
  assign bscore$dma_server_awburst = dma_server_awburst ;
  assign bscore$dma_server_awcache = dma_server_awcache ;
  assign bscore$dma_server_awid = dma_server_awid ;
  assign bscore$dma_server_awlen = dma_server_awlen ;
  assign bscore$dma_server_awlock = dma_server_awlock ;
  assign bscore$dma_server_awprot = dma_server_awprot ;
  assign bscore$dma_server_awqos = dma_server_awqos ;
  assign bscore$dma_server_awregion = dma_server_awregion ;
  assign bscore$dma_server_awsize = dma_server_awsize ;
  assign bscore$dma_server_awvalid = dma_server_awvalid ;
  assign bscore$dma_server_bready = dma_server_bready ;
  assign bscore$dma_server_rready = dma_server_rready ;
  assign bscore$dma_server_wdata = dma_server_wdata ;
  assign bscore$dma_server_wlast = dma_server_wlast ;
  assign bscore$dma_server_wstrb = dma_server_wstrb ;
  assign bscore$dma_server_wvalid = dma_server_wvalid ;
  assign bscore$ext_interrupt = ext_interrupt ;
  assign bscore$master1_HRDATA = master1_HRDATA ;
  assign bscore$master1_HREADY = master1_HREADY ;
  assign bscore$master1_HRESP = master1_HRESP ;
  assign bscore$set_watch_tohost_tohost_addr = set_watch_tohost_tohost_addr ;
  assign bscore$set_watch_tohost_watch_tohost =
	     set_watch_tohost_watch_tohost ;
  assign bscore$sw_interrupt = sw_interrupt ;
  assign bscore$timer_interrupt = timer_interrupt ;
  assign bscore$EN_debug_request_put = CAN_FIRE_RL_ClientServerRequest ;
  assign bscore$EN_debug_response_get = CAN_FIRE_RL_ClientServerResponse ;
  assign bscore$EN_set_watch_tohost = EN_set_watch_tohost ;

  // submodule bsdebug
  assign bsdebug$jtag_TCK = TCK ;
  assign bsdebug$jtag_TDI = TDI ;
  assign bsdebug$jtag_TMS = TMS ;
  always@(bscore$debug_response_get)
  begin
    case (bscore$debug_response_get[36:34])
      3'd0, 3'd1, 3'd2, 3'd3, 3'd4:
	  bsdebug$toCore_response_put = bscore$debug_response_get;
      default: bsdebug$toCore_response_put = 37'h0AAAAAAAAA;
    endcase
  end
  assign bsdebug$EN_toCore_request_get = CAN_FIRE_RL_ClientServerRequest ;
  assign bsdebug$EN_toCore_response_put = CAN_FIRE_RL_ClientServerResponse ;
endmodule  // mkMCUTop
