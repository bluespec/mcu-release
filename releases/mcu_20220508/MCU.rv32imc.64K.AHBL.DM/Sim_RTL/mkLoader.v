//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// toFabric_awvalid               O     1 reg
// toFabric_awid                  O     4 reg
// toFabric_awaddr                O    32 reg
// toFabric_awlen                 O     8 reg
// toFabric_awsize                O     3 reg
// toFabric_awburst               O     2 reg
// toFabric_awlock                O     1 reg
// toFabric_awcache               O     4 reg
// toFabric_awprot                O     3 reg
// toFabric_awqos                 O     4 reg
// toFabric_awregion              O     4 reg
// toFabric_wvalid                O     1 reg
// toFabric_wdata                 O    32 reg
// toFabric_wstrb                 O     4 reg
// toFabric_wlast                 O     1 reg
// toFabric_bready                O     1 reg
// toFabric_arvalid               O     1 reg
// toFabric_arid                  O     4 reg
// toFabric_araddr                O    32 reg
// toFabric_arlen                 O     8 reg
// toFabric_arsize                O     3 reg
// toFabric_arburst               O     2 reg
// toFabric_arlock                O     1 reg
// toFabric_arcache               O     4 reg
// toFabric_arprot                O     3 reg
// toFabric_arqos                 O     4 reg
// toFabric_arregion              O     4 reg
// toFabric_rready                O     1 reg
// cpu_halt                       O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// toFabric_awready               I     1
// toFabric_wready                I     1
// toFabric_bvalid                I     1
// toFabric_bid                   I     4 reg
// toFabric_bresp                 I     2 reg
// toFabric_arready               I     1
// toFabric_rvalid                I     1
// toFabric_rid                   I     4 reg
// toFabric_rdata                 I    32 reg
// toFabric_rresp                 I     2 reg
// toFabric_rlast                 I     1 reg
// reset_done_x                   I     1 reg
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

module mkLoader(CLK,
		RST_N,

		toFabric_awvalid,

		toFabric_awid,

		toFabric_awaddr,

		toFabric_awlen,

		toFabric_awsize,

		toFabric_awburst,

		toFabric_awlock,

		toFabric_awcache,

		toFabric_awprot,

		toFabric_awqos,

		toFabric_awregion,

		toFabric_awready,

		toFabric_wvalid,

		toFabric_wdata,

		toFabric_wstrb,

		toFabric_wlast,

		toFabric_wready,

		toFabric_bvalid,
		toFabric_bid,
		toFabric_bresp,

		toFabric_bready,

		toFabric_arvalid,

		toFabric_arid,

		toFabric_araddr,

		toFabric_arlen,

		toFabric_arsize,

		toFabric_arburst,

		toFabric_arlock,

		toFabric_arcache,

		toFabric_arprot,

		toFabric_arqos,

		toFabric_arregion,

		toFabric_arready,

		toFabric_rvalid,
		toFabric_rid,
		toFabric_rdata,
		toFabric_rresp,
		toFabric_rlast,

		toFabric_rready,

		cpu_halt,

		reset_done_x);
  input  CLK;
  input  RST_N;

  // value method toFabric_m_awvalid
  output toFabric_awvalid;

  // value method toFabric_m_awid
  output [3 : 0] toFabric_awid;

  // value method toFabric_m_awaddr
  output [31 : 0] toFabric_awaddr;

  // value method toFabric_m_awlen
  output [7 : 0] toFabric_awlen;

  // value method toFabric_m_awsize
  output [2 : 0] toFabric_awsize;

  // value method toFabric_m_awburst
  output [1 : 0] toFabric_awburst;

  // value method toFabric_m_awlock
  output toFabric_awlock;

  // value method toFabric_m_awcache
  output [3 : 0] toFabric_awcache;

  // value method toFabric_m_awprot
  output [2 : 0] toFabric_awprot;

  // value method toFabric_m_awqos
  output [3 : 0] toFabric_awqos;

  // value method toFabric_m_awregion
  output [3 : 0] toFabric_awregion;

  // value method toFabric_m_awuser

  // action method toFabric_m_awready
  input  toFabric_awready;

  // value method toFabric_m_wvalid
  output toFabric_wvalid;

  // value method toFabric_m_wdata
  output [31 : 0] toFabric_wdata;

  // value method toFabric_m_wstrb
  output [3 : 0] toFabric_wstrb;

  // value method toFabric_m_wlast
  output toFabric_wlast;

  // value method toFabric_m_wuser

  // action method toFabric_m_wready
  input  toFabric_wready;

  // action method toFabric_m_bvalid
  input  toFabric_bvalid;
  input  [3 : 0] toFabric_bid;
  input  [1 : 0] toFabric_bresp;

  // value method toFabric_m_bready
  output toFabric_bready;

  // value method toFabric_m_arvalid
  output toFabric_arvalid;

  // value method toFabric_m_arid
  output [3 : 0] toFabric_arid;

  // value method toFabric_m_araddr
  output [31 : 0] toFabric_araddr;

  // value method toFabric_m_arlen
  output [7 : 0] toFabric_arlen;

  // value method toFabric_m_arsize
  output [2 : 0] toFabric_arsize;

  // value method toFabric_m_arburst
  output [1 : 0] toFabric_arburst;

  // value method toFabric_m_arlock
  output toFabric_arlock;

  // value method toFabric_m_arcache
  output [3 : 0] toFabric_arcache;

  // value method toFabric_m_arprot
  output [2 : 0] toFabric_arprot;

  // value method toFabric_m_arqos
  output [3 : 0] toFabric_arqos;

  // value method toFabric_m_arregion
  output [3 : 0] toFabric_arregion;

  // value method toFabric_m_aruser

  // action method toFabric_m_arready
  input  toFabric_arready;

  // action method toFabric_m_rvalid
  input  toFabric_rvalid;
  input  [3 : 0] toFabric_rid;
  input  [31 : 0] toFabric_rdata;
  input  [1 : 0] toFabric_rresp;
  input  toFabric_rlast;

  // value method toFabric_m_rready
  output toFabric_rready;

  // value method cpu_halt
  output cpu_halt;

  // action method reset_done
  input  reset_done_x;

  // signals for module outputs
  wire [31 : 0] toFabric_araddr, toFabric_awaddr, toFabric_wdata;
  wire [7 : 0] toFabric_arlen, toFabric_awlen;
  wire [3 : 0] toFabric_arcache,
	       toFabric_arid,
	       toFabric_arqos,
	       toFabric_arregion,
	       toFabric_awcache,
	       toFabric_awid,
	       toFabric_awqos,
	       toFabric_awregion,
	       toFabric_wstrb;
  wire [2 : 0] toFabric_arprot,
	       toFabric_arsize,
	       toFabric_awprot,
	       toFabric_awsize;
  wire [1 : 0] toFabric_arburst, toFabric_awburst;
  wire cpu_halt,
       toFabric_arlock,
       toFabric_arvalid,
       toFabric_awlock,
       toFabric_awvalid,
       toFabric_bready,
       toFabric_rready,
       toFabric_wlast,
       toFabric_wvalid;

  // ports of submodule ctrler
  wire [31 : 0] ctrler$cpu_ifc_toFabric_araddr,
		ctrler$cpu_ifc_toFabric_awaddr,
		ctrler$cpu_ifc_toFabric_rdata,
		ctrler$cpu_ifc_toFabric_wdata,
		ctrler$toFlash_araddr,
		ctrler$toFlash_awaddr,
		ctrler$toFlash_rdata,
		ctrler$toFlash_wdata;
  wire [7 : 0] ctrler$cpu_ifc_toFabric_arlen,
	       ctrler$cpu_ifc_toFabric_awlen,
	       ctrler$toFlash_arlen,
	       ctrler$toFlash_awlen;
  wire [3 : 0] ctrler$cpu_ifc_toFabric_arcache,
	       ctrler$cpu_ifc_toFabric_arid,
	       ctrler$cpu_ifc_toFabric_arqos,
	       ctrler$cpu_ifc_toFabric_arregion,
	       ctrler$cpu_ifc_toFabric_awcache,
	       ctrler$cpu_ifc_toFabric_awid,
	       ctrler$cpu_ifc_toFabric_awqos,
	       ctrler$cpu_ifc_toFabric_awregion,
	       ctrler$cpu_ifc_toFabric_bid,
	       ctrler$cpu_ifc_toFabric_rid,
	       ctrler$cpu_ifc_toFabric_wstrb,
	       ctrler$toFlash_arcache,
	       ctrler$toFlash_arqos,
	       ctrler$toFlash_arregion,
	       ctrler$toFlash_awcache,
	       ctrler$toFlash_awqos,
	       ctrler$toFlash_awregion,
	       ctrler$toFlash_wstrb;
  wire [2 : 0] ctrler$cpu_ifc_toFabric_arprot,
	       ctrler$cpu_ifc_toFabric_arsize,
	       ctrler$cpu_ifc_toFabric_awprot,
	       ctrler$cpu_ifc_toFabric_awsize,
	       ctrler$toFlash_arprot,
	       ctrler$toFlash_arsize,
	       ctrler$toFlash_awprot,
	       ctrler$toFlash_awsize;
  wire [1 : 0] ctrler$cpu_ifc_toFabric_arburst,
	       ctrler$cpu_ifc_toFabric_awburst,
	       ctrler$cpu_ifc_toFabric_bresp,
	       ctrler$cpu_ifc_toFabric_rresp,
	       ctrler$toFlash_arburst,
	       ctrler$toFlash_awburst,
	       ctrler$toFlash_bresp,
	       ctrler$toFlash_rresp;
  wire ctrler$cpu_ifc_cpu_halt,
       ctrler$cpu_ifc_reset_done_x,
       ctrler$cpu_ifc_toFabric_arlock,
       ctrler$cpu_ifc_toFabric_arready,
       ctrler$cpu_ifc_toFabric_arvalid,
       ctrler$cpu_ifc_toFabric_awlock,
       ctrler$cpu_ifc_toFabric_awready,
       ctrler$cpu_ifc_toFabric_awvalid,
       ctrler$cpu_ifc_toFabric_bready,
       ctrler$cpu_ifc_toFabric_bvalid,
       ctrler$cpu_ifc_toFabric_rlast,
       ctrler$cpu_ifc_toFabric_rready,
       ctrler$cpu_ifc_toFabric_rvalid,
       ctrler$cpu_ifc_toFabric_wlast,
       ctrler$cpu_ifc_toFabric_wready,
       ctrler$cpu_ifc_toFabric_wvalid,
       ctrler$toFlash_arlock,
       ctrler$toFlash_arready,
       ctrler$toFlash_arvalid,
       ctrler$toFlash_awlock,
       ctrler$toFlash_awready,
       ctrler$toFlash_awvalid,
       ctrler$toFlash_bready,
       ctrler$toFlash_bvalid,
       ctrler$toFlash_rlast,
       ctrler$toFlash_rready,
       ctrler$toFlash_rvalid,
       ctrler$toFlash_wlast,
       ctrler$toFlash_wready,
       ctrler$toFlash_wvalid;

  // ports of submodule flash
  wire [31 : 0] flash$slave_araddr,
		flash$slave_awaddr,
		flash$slave_rdata,
		flash$slave_wdata;
  wire [7 : 0] flash$slave_arlen, flash$slave_awlen;
  wire [3 : 0] flash$slave_arcache,
	       flash$slave_arqos,
	       flash$slave_arregion,
	       flash$slave_awcache,
	       flash$slave_awqos,
	       flash$slave_awregion,
	       flash$slave_wstrb;
  wire [2 : 0] flash$slave_arprot,
	       flash$slave_arsize,
	       flash$slave_awprot,
	       flash$slave_awsize;
  wire [1 : 0] flash$slave_arburst,
	       flash$slave_awburst,
	       flash$slave_bresp,
	       flash$slave_rresp;
  wire flash$slave_arlock,
       flash$slave_arready,
       flash$slave_arvalid,
       flash$slave_awlock,
       flash$slave_awready,
       flash$slave_awvalid,
       flash$slave_bready,
       flash$slave_bvalid,
       flash$slave_rlast,
       flash$slave_rready,
       flash$slave_rvalid,
       flash$slave_wlast,
       flash$slave_wready,
       flash$slave_wvalid;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_rd_addr_channel,
       CAN_FIRE_RL_rl_rd_data_channel,
       CAN_FIRE_RL_rl_wr_addr_channel,
       CAN_FIRE_RL_rl_wr_data_channel,
       CAN_FIRE_RL_rl_wr_response_channel,
       CAN_FIRE_reset_done,
       CAN_FIRE_toFabric_m_arready,
       CAN_FIRE_toFabric_m_awready,
       CAN_FIRE_toFabric_m_bvalid,
       CAN_FIRE_toFabric_m_rvalid,
       CAN_FIRE_toFabric_m_wready,
       WILL_FIRE_RL_rl_rd_addr_channel,
       WILL_FIRE_RL_rl_rd_data_channel,
       WILL_FIRE_RL_rl_wr_addr_channel,
       WILL_FIRE_RL_rl_wr_data_channel,
       WILL_FIRE_RL_rl_wr_response_channel,
       WILL_FIRE_reset_done,
       WILL_FIRE_toFabric_m_arready,
       WILL_FIRE_toFabric_m_awready,
       WILL_FIRE_toFabric_m_bvalid,
       WILL_FIRE_toFabric_m_rvalid,
       WILL_FIRE_toFabric_m_wready;

  // value method toFabric_m_awvalid
  assign toFabric_awvalid = ctrler$cpu_ifc_toFabric_awvalid ;

  // value method toFabric_m_awid
  assign toFabric_awid = ctrler$cpu_ifc_toFabric_awid ;

  // value method toFabric_m_awaddr
  assign toFabric_awaddr = ctrler$cpu_ifc_toFabric_awaddr ;

  // value method toFabric_m_awlen
  assign toFabric_awlen = ctrler$cpu_ifc_toFabric_awlen ;

  // value method toFabric_m_awsize
  assign toFabric_awsize = ctrler$cpu_ifc_toFabric_awsize ;

  // value method toFabric_m_awburst
  assign toFabric_awburst = ctrler$cpu_ifc_toFabric_awburst ;

  // value method toFabric_m_awlock
  assign toFabric_awlock = ctrler$cpu_ifc_toFabric_awlock ;

  // value method toFabric_m_awcache
  assign toFabric_awcache = ctrler$cpu_ifc_toFabric_awcache ;

  // value method toFabric_m_awprot
  assign toFabric_awprot = ctrler$cpu_ifc_toFabric_awprot ;

  // value method toFabric_m_awqos
  assign toFabric_awqos = ctrler$cpu_ifc_toFabric_awqos ;

  // value method toFabric_m_awregion
  assign toFabric_awregion = ctrler$cpu_ifc_toFabric_awregion ;

  // action method toFabric_m_awready
  assign CAN_FIRE_toFabric_m_awready = 1'd1 ;
  assign WILL_FIRE_toFabric_m_awready = 1'd1 ;

  // value method toFabric_m_wvalid
  assign toFabric_wvalid = ctrler$cpu_ifc_toFabric_wvalid ;

  // value method toFabric_m_wdata
  assign toFabric_wdata = ctrler$cpu_ifc_toFabric_wdata ;

  // value method toFabric_m_wstrb
  assign toFabric_wstrb = ctrler$cpu_ifc_toFabric_wstrb ;

  // value method toFabric_m_wlast
  assign toFabric_wlast = ctrler$cpu_ifc_toFabric_wlast ;

  // action method toFabric_m_wready
  assign CAN_FIRE_toFabric_m_wready = 1'd1 ;
  assign WILL_FIRE_toFabric_m_wready = 1'd1 ;

  // action method toFabric_m_bvalid
  assign CAN_FIRE_toFabric_m_bvalid = 1'd1 ;
  assign WILL_FIRE_toFabric_m_bvalid = 1'd1 ;

  // value method toFabric_m_bready
  assign toFabric_bready = ctrler$cpu_ifc_toFabric_bready ;

  // value method toFabric_m_arvalid
  assign toFabric_arvalid = ctrler$cpu_ifc_toFabric_arvalid ;

  // value method toFabric_m_arid
  assign toFabric_arid = ctrler$cpu_ifc_toFabric_arid ;

  // value method toFabric_m_araddr
  assign toFabric_araddr = ctrler$cpu_ifc_toFabric_araddr ;

  // value method toFabric_m_arlen
  assign toFabric_arlen = ctrler$cpu_ifc_toFabric_arlen ;

  // value method toFabric_m_arsize
  assign toFabric_arsize = ctrler$cpu_ifc_toFabric_arsize ;

  // value method toFabric_m_arburst
  assign toFabric_arburst = ctrler$cpu_ifc_toFabric_arburst ;

  // value method toFabric_m_arlock
  assign toFabric_arlock = ctrler$cpu_ifc_toFabric_arlock ;

  // value method toFabric_m_arcache
  assign toFabric_arcache = ctrler$cpu_ifc_toFabric_arcache ;

  // value method toFabric_m_arprot
  assign toFabric_arprot = ctrler$cpu_ifc_toFabric_arprot ;

  // value method toFabric_m_arqos
  assign toFabric_arqos = ctrler$cpu_ifc_toFabric_arqos ;

  // value method toFabric_m_arregion
  assign toFabric_arregion = ctrler$cpu_ifc_toFabric_arregion ;

  // action method toFabric_m_arready
  assign CAN_FIRE_toFabric_m_arready = 1'd1 ;
  assign WILL_FIRE_toFabric_m_arready = 1'd1 ;

  // action method toFabric_m_rvalid
  assign CAN_FIRE_toFabric_m_rvalid = 1'd1 ;
  assign WILL_FIRE_toFabric_m_rvalid = 1'd1 ;

  // value method toFabric_m_rready
  assign toFabric_rready = ctrler$cpu_ifc_toFabric_rready ;

  // value method cpu_halt
  assign cpu_halt = ctrler$cpu_ifc_cpu_halt ;

  // action method reset_done
  assign CAN_FIRE_reset_done = 1'd1 ;
  assign WILL_FIRE_reset_done = 1'd1 ;

  // submodule ctrler
  mkLoad_Control ctrler(.CLK(CLK),
			.RST_N(RST_N),
			.cpu_ifc_reset_done_x(ctrler$cpu_ifc_reset_done_x),
			.cpu_ifc_toFabric_arready(ctrler$cpu_ifc_toFabric_arready),
			.cpu_ifc_toFabric_awready(ctrler$cpu_ifc_toFabric_awready),
			.cpu_ifc_toFabric_bid(ctrler$cpu_ifc_toFabric_bid),
			.cpu_ifc_toFabric_bresp(ctrler$cpu_ifc_toFabric_bresp),
			.cpu_ifc_toFabric_bvalid(ctrler$cpu_ifc_toFabric_bvalid),
			.cpu_ifc_toFabric_rdata(ctrler$cpu_ifc_toFabric_rdata),
			.cpu_ifc_toFabric_rid(ctrler$cpu_ifc_toFabric_rid),
			.cpu_ifc_toFabric_rlast(ctrler$cpu_ifc_toFabric_rlast),
			.cpu_ifc_toFabric_rresp(ctrler$cpu_ifc_toFabric_rresp),
			.cpu_ifc_toFabric_rvalid(ctrler$cpu_ifc_toFabric_rvalid),
			.cpu_ifc_toFabric_wready(ctrler$cpu_ifc_toFabric_wready),
			.toFlash_arready(ctrler$toFlash_arready),
			.toFlash_awready(ctrler$toFlash_awready),
			.toFlash_bresp(ctrler$toFlash_bresp),
			.toFlash_bvalid(ctrler$toFlash_bvalid),
			.toFlash_rdata(ctrler$toFlash_rdata),
			.toFlash_rlast(ctrler$toFlash_rlast),
			.toFlash_rresp(ctrler$toFlash_rresp),
			.toFlash_rvalid(ctrler$toFlash_rvalid),
			.toFlash_wready(ctrler$toFlash_wready),
			.toFlash_awvalid(ctrler$toFlash_awvalid),
			.toFlash_awaddr(ctrler$toFlash_awaddr),
			.toFlash_awlen(ctrler$toFlash_awlen),
			.toFlash_awsize(ctrler$toFlash_awsize),
			.toFlash_awburst(ctrler$toFlash_awburst),
			.toFlash_awlock(ctrler$toFlash_awlock),
			.toFlash_awcache(ctrler$toFlash_awcache),
			.toFlash_awprot(ctrler$toFlash_awprot),
			.toFlash_awqos(ctrler$toFlash_awqos),
			.toFlash_awregion(ctrler$toFlash_awregion),
			.toFlash_wvalid(ctrler$toFlash_wvalid),
			.toFlash_wdata(ctrler$toFlash_wdata),
			.toFlash_wstrb(ctrler$toFlash_wstrb),
			.toFlash_wlast(ctrler$toFlash_wlast),
			.toFlash_bready(ctrler$toFlash_bready),
			.toFlash_arvalid(ctrler$toFlash_arvalid),
			.toFlash_araddr(ctrler$toFlash_araddr),
			.toFlash_arlen(ctrler$toFlash_arlen),
			.toFlash_arsize(ctrler$toFlash_arsize),
			.toFlash_arburst(ctrler$toFlash_arburst),
			.toFlash_arlock(ctrler$toFlash_arlock),
			.toFlash_arcache(ctrler$toFlash_arcache),
			.toFlash_arprot(ctrler$toFlash_arprot),
			.toFlash_arqos(ctrler$toFlash_arqos),
			.toFlash_arregion(ctrler$toFlash_arregion),
			.toFlash_rready(ctrler$toFlash_rready),
			.cpu_ifc_toFabric_awvalid(ctrler$cpu_ifc_toFabric_awvalid),
			.cpu_ifc_toFabric_awid(ctrler$cpu_ifc_toFabric_awid),
			.cpu_ifc_toFabric_awaddr(ctrler$cpu_ifc_toFabric_awaddr),
			.cpu_ifc_toFabric_awlen(ctrler$cpu_ifc_toFabric_awlen),
			.cpu_ifc_toFabric_awsize(ctrler$cpu_ifc_toFabric_awsize),
			.cpu_ifc_toFabric_awburst(ctrler$cpu_ifc_toFabric_awburst),
			.cpu_ifc_toFabric_awlock(ctrler$cpu_ifc_toFabric_awlock),
			.cpu_ifc_toFabric_awcache(ctrler$cpu_ifc_toFabric_awcache),
			.cpu_ifc_toFabric_awprot(ctrler$cpu_ifc_toFabric_awprot),
			.cpu_ifc_toFabric_awqos(ctrler$cpu_ifc_toFabric_awqos),
			.cpu_ifc_toFabric_awregion(ctrler$cpu_ifc_toFabric_awregion),
			.cpu_ifc_toFabric_wvalid(ctrler$cpu_ifc_toFabric_wvalid),
			.cpu_ifc_toFabric_wdata(ctrler$cpu_ifc_toFabric_wdata),
			.cpu_ifc_toFabric_wstrb(ctrler$cpu_ifc_toFabric_wstrb),
			.cpu_ifc_toFabric_wlast(ctrler$cpu_ifc_toFabric_wlast),
			.cpu_ifc_toFabric_bready(ctrler$cpu_ifc_toFabric_bready),
			.cpu_ifc_toFabric_arvalid(ctrler$cpu_ifc_toFabric_arvalid),
			.cpu_ifc_toFabric_arid(ctrler$cpu_ifc_toFabric_arid),
			.cpu_ifc_toFabric_araddr(ctrler$cpu_ifc_toFabric_araddr),
			.cpu_ifc_toFabric_arlen(ctrler$cpu_ifc_toFabric_arlen),
			.cpu_ifc_toFabric_arsize(ctrler$cpu_ifc_toFabric_arsize),
			.cpu_ifc_toFabric_arburst(ctrler$cpu_ifc_toFabric_arburst),
			.cpu_ifc_toFabric_arlock(ctrler$cpu_ifc_toFabric_arlock),
			.cpu_ifc_toFabric_arcache(ctrler$cpu_ifc_toFabric_arcache),
			.cpu_ifc_toFabric_arprot(ctrler$cpu_ifc_toFabric_arprot),
			.cpu_ifc_toFabric_arqos(ctrler$cpu_ifc_toFabric_arqos),
			.cpu_ifc_toFabric_arregion(ctrler$cpu_ifc_toFabric_arregion),
			.cpu_ifc_toFabric_rready(ctrler$cpu_ifc_toFabric_rready),
			.cpu_ifc_cpu_halt(ctrler$cpu_ifc_cpu_halt));

  // submodule flash
  mkFlash flash(.CLK(CLK),
		.RST_N(RST_N),
		.slave_araddr(flash$slave_araddr),
		.slave_arburst(flash$slave_arburst),
		.slave_arcache(flash$slave_arcache),
		.slave_arlen(flash$slave_arlen),
		.slave_arlock(flash$slave_arlock),
		.slave_arprot(flash$slave_arprot),
		.slave_arqos(flash$slave_arqos),
		.slave_arregion(flash$slave_arregion),
		.slave_arsize(flash$slave_arsize),
		.slave_arvalid(flash$slave_arvalid),
		.slave_awaddr(flash$slave_awaddr),
		.slave_awburst(flash$slave_awburst),
		.slave_awcache(flash$slave_awcache),
		.slave_awlen(flash$slave_awlen),
		.slave_awlock(flash$slave_awlock),
		.slave_awprot(flash$slave_awprot),
		.slave_awqos(flash$slave_awqos),
		.slave_awregion(flash$slave_awregion),
		.slave_awsize(flash$slave_awsize),
		.slave_awvalid(flash$slave_awvalid),
		.slave_bready(flash$slave_bready),
		.slave_rready(flash$slave_rready),
		.slave_wdata(flash$slave_wdata),
		.slave_wlast(flash$slave_wlast),
		.slave_wstrb(flash$slave_wstrb),
		.slave_wvalid(flash$slave_wvalid),
		.slave_awready(flash$slave_awready),
		.slave_wready(flash$slave_wready),
		.slave_bvalid(flash$slave_bvalid),
		.slave_bresp(flash$slave_bresp),
		.slave_arready(flash$slave_arready),
		.slave_rvalid(flash$slave_rvalid),
		.slave_rdata(flash$slave_rdata),
		.slave_rresp(flash$slave_rresp),
		.slave_rlast(flash$slave_rlast));

  // rule RL_rl_wr_addr_channel
  assign CAN_FIRE_RL_rl_wr_addr_channel = 1'd1 ;
  assign WILL_FIRE_RL_rl_wr_addr_channel = 1'd1 ;

  // rule RL_rl_wr_data_channel
  assign CAN_FIRE_RL_rl_wr_data_channel = 1'd1 ;
  assign WILL_FIRE_RL_rl_wr_data_channel = 1'd1 ;

  // rule RL_rl_wr_response_channel
  assign CAN_FIRE_RL_rl_wr_response_channel = 1'd1 ;
  assign WILL_FIRE_RL_rl_wr_response_channel = 1'd1 ;

  // rule RL_rl_rd_addr_channel
  assign CAN_FIRE_RL_rl_rd_addr_channel = 1'd1 ;
  assign WILL_FIRE_RL_rl_rd_addr_channel = 1'd1 ;

  // rule RL_rl_rd_data_channel
  assign CAN_FIRE_RL_rl_rd_data_channel = 1'd1 ;
  assign WILL_FIRE_RL_rl_rd_data_channel = 1'd1 ;

  // submodule ctrler
  assign ctrler$cpu_ifc_reset_done_x = reset_done_x ;
  assign ctrler$cpu_ifc_toFabric_arready = toFabric_arready ;
  assign ctrler$cpu_ifc_toFabric_awready = toFabric_awready ;
  assign ctrler$cpu_ifc_toFabric_bid = toFabric_bid ;
  assign ctrler$cpu_ifc_toFabric_bresp = toFabric_bresp ;
  assign ctrler$cpu_ifc_toFabric_bvalid = toFabric_bvalid ;
  assign ctrler$cpu_ifc_toFabric_rdata = toFabric_rdata ;
  assign ctrler$cpu_ifc_toFabric_rid = toFabric_rid ;
  assign ctrler$cpu_ifc_toFabric_rlast = toFabric_rlast ;
  assign ctrler$cpu_ifc_toFabric_rresp = toFabric_rresp ;
  assign ctrler$cpu_ifc_toFabric_rvalid = toFabric_rvalid ;
  assign ctrler$cpu_ifc_toFabric_wready = toFabric_wready ;
  assign ctrler$toFlash_arready = flash$slave_arready ;
  assign ctrler$toFlash_awready = flash$slave_awready ;
  assign ctrler$toFlash_bresp = flash$slave_bresp ;
  assign ctrler$toFlash_bvalid = flash$slave_bvalid ;
  assign ctrler$toFlash_rdata = flash$slave_rdata ;
  assign ctrler$toFlash_rlast = flash$slave_rlast ;
  assign ctrler$toFlash_rresp = flash$slave_rresp ;
  assign ctrler$toFlash_rvalid = flash$slave_rvalid ;
  assign ctrler$toFlash_wready = flash$slave_wready ;

  // submodule flash
  assign flash$slave_araddr = ctrler$toFlash_araddr ;
  assign flash$slave_arburst = ctrler$toFlash_arburst ;
  assign flash$slave_arcache = ctrler$toFlash_arcache ;
  assign flash$slave_arlen = ctrler$toFlash_arlen ;
  assign flash$slave_arlock = ctrler$toFlash_arlock ;
  assign flash$slave_arprot = ctrler$toFlash_arprot ;
  assign flash$slave_arqos = ctrler$toFlash_arqos ;
  assign flash$slave_arregion = ctrler$toFlash_arregion ;
  assign flash$slave_arsize = ctrler$toFlash_arsize ;
  assign flash$slave_arvalid = ctrler$toFlash_arvalid ;
  assign flash$slave_awaddr = ctrler$toFlash_awaddr ;
  assign flash$slave_awburst = ctrler$toFlash_awburst ;
  assign flash$slave_awcache = ctrler$toFlash_awcache ;
  assign flash$slave_awlen = ctrler$toFlash_awlen ;
  assign flash$slave_awlock = ctrler$toFlash_awlock ;
  assign flash$slave_awprot = ctrler$toFlash_awprot ;
  assign flash$slave_awqos = ctrler$toFlash_awqos ;
  assign flash$slave_awregion = ctrler$toFlash_awregion ;
  assign flash$slave_awsize = ctrler$toFlash_awsize ;
  assign flash$slave_awvalid = ctrler$toFlash_awvalid ;
  assign flash$slave_bready = ctrler$toFlash_bready ;
  assign flash$slave_rready = ctrler$toFlash_rready ;
  assign flash$slave_wdata = ctrler$toFlash_wdata ;
  assign flash$slave_wlast = ctrler$toFlash_wlast ;
  assign flash$slave_wstrb = ctrler$toFlash_wstrb ;
  assign flash$slave_wvalid = ctrler$toFlash_wvalid ;
endmodule  // mkLoader

