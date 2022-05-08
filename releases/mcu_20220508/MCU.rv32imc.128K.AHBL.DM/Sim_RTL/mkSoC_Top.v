//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// gpios                          O    16 reg
// jtag_TDO                       O     1
// RDY_set_watch_tohost           O     1 reg
// mv_tohost_value                O    32 reg
// RDY_mv_tohost_value            O     1 reg
// CLK_jtag_tclk_out              O     1 clock
// CLK_GATE_jtag_tclk_out         O     1 const
// dmi_reset                      I     1 reset
// CLK                            I     1 clock
// RST_N                          I     1 reset
// jtag_TDI                       I     1
// jtag_TMS                       I     1
// jtag_TCK                       I     1
// set_watch_tohost_watch_tohost  I     1
// set_watch_tohost_tohost_addr   I    32 reg
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

module mkSoC_Top(dmi_reset,
		 CLK,
		 RST_N,

		 gpios,

		 jtag_TDI,

		 jtag_TMS,

		 jtag_TCK,

		 jtag_TDO,

		 set_watch_tohost_watch_tohost,
		 set_watch_tohost_tohost_addr,
		 EN_set_watch_tohost,
		 RDY_set_watch_tohost,

		 mv_tohost_value,
		 RDY_mv_tohost_value,

		 CLK_jtag_tclk_out,
		 CLK_GATE_jtag_tclk_out);
  input  dmi_reset;
  input  CLK;
  input  RST_N;

  // value method gpios
  output [15 : 0] gpios;

  // action method jtag_tdi
  input  jtag_TDI;

  // action method jtag_tms
  input  jtag_TMS;

  // action method jtag_tclk
  input  jtag_TCK;

  // value method jtag_tdo
  output jtag_TDO;

  // action method set_watch_tohost
  input  set_watch_tohost_watch_tohost;
  input  [31 : 0] set_watch_tohost_tohost_addr;
  input  EN_set_watch_tohost;
  output RDY_set_watch_tohost;

  // value method mv_tohost_value
  output [31 : 0] mv_tohost_value;
  output RDY_mv_tohost_value;

  // oscillator and gates for output clock CLK_jtag_tclk_out
  output CLK_jtag_tclk_out;
  output CLK_GATE_jtag_tclk_out;

  // signals for module outputs
  wire [31 : 0] mv_tohost_value;
  wire [15 : 0] gpios;
  wire CLK_GATE_jtag_tclk_out,
       CLK_jtag_tclk_out,
       RDY_mv_tohost_value,
       RDY_set_watch_tohost,
       jtag_TDO;

  // register rg_state
  reg [1 : 0] rg_state;
  wire [1 : 0] rg_state$D_IN;
  wire rg_state$EN;

  // ports of submodule core
  wire [31 : 0] core$dma_server_araddr,
		core$dma_server_awaddr,
		core$dma_server_rdata,
		core$dma_server_wdata,
		core$master1_HADDR,
		core$master1_HRDATA,
		core$master1_HWDATA,
		core$mv_tohost_value,
		core$set_watch_tohost_tohost_addr;
  wire [7 : 0] core$dma_server_arlen, core$dma_server_awlen;
  wire [3 : 0] core$dma_server_arcache,
	       core$dma_server_arid,
	       core$dma_server_arqos,
	       core$dma_server_arregion,
	       core$dma_server_awcache,
	       core$dma_server_awid,
	       core$dma_server_awqos,
	       core$dma_server_awregion,
	       core$dma_server_bid,
	       core$dma_server_rid,
	       core$dma_server_wstrb,
	       core$master1_HPROT;
  wire [2 : 0] core$dma_server_arprot,
	       core$dma_server_arsize,
	       core$dma_server_awprot,
	       core$dma_server_awsize,
	       core$master1_HBURST,
	       core$master1_HSIZE;
  wire [1 : 0] core$dma_server_arburst,
	       core$dma_server_awburst,
	       core$dma_server_bresp,
	       core$dma_server_rresp,
	       core$master1_HTRANS;
  wire core$CLK_tclk_out,
       core$EN_set_watch_tohost,
       core$RDY_mv_tohost_value,
       core$RDY_set_watch_tohost,
       core$TCK,
       core$TDI,
       core$TDO,
       core$TMS,
       core$cpu_halt_x,
       core$dma_server_arlock,
       core$dma_server_arready,
       core$dma_server_arvalid,
       core$dma_server_awlock,
       core$dma_server_awready,
       core$dma_server_awvalid,
       core$dma_server_bready,
       core$dma_server_bvalid,
       core$dma_server_rlast,
       core$dma_server_rready,
       core$dma_server_rvalid,
       core$dma_server_wlast,
       core$dma_server_wready,
       core$dma_server_wvalid,
       core$ext_interrupt,
       core$master1_HMASTLOCK,
       core$master1_HREADY,
       core$master1_HRESP,
       core$master1_HWRITE,
       core$reset_done,
       core$set_watch_tohost_watch_tohost,
       core$sw_interrupt,
       core$timer_interrupt;

  // ports of submodule gpio
  wire [31 : 0] gpio$target_HADDR, gpio$target_HRDATA, gpio$target_HWDATA;
  wire [15 : 0] gpio$out;
  wire [3 : 0] gpio$target_HPROT;
  wire [2 : 0] gpio$target_HBURST, gpio$target_HSIZE;
  wire [1 : 0] gpio$target_HTRANS;
  wire gpio$target_HMASTLOCK,
       gpio$target_HREADY,
       gpio$target_HREADYOUT,
       gpio$target_HRESP,
       gpio$target_HSEL,
       gpio$target_HWRITE;

  // ports of submodule loader
  wire [31 : 0] loader$toFabric_araddr,
		loader$toFabric_awaddr,
		loader$toFabric_rdata,
		loader$toFabric_wdata;
  wire [7 : 0] loader$toFabric_arlen, loader$toFabric_awlen;
  wire [3 : 0] loader$toFabric_arcache,
	       loader$toFabric_arid,
	       loader$toFabric_arqos,
	       loader$toFabric_arregion,
	       loader$toFabric_awcache,
	       loader$toFabric_awid,
	       loader$toFabric_awqos,
	       loader$toFabric_awregion,
	       loader$toFabric_bid,
	       loader$toFabric_rid,
	       loader$toFabric_wstrb;
  wire [2 : 0] loader$toFabric_arprot,
	       loader$toFabric_arsize,
	       loader$toFabric_awprot,
	       loader$toFabric_awsize;
  wire [1 : 0] loader$toFabric_arburst,
	       loader$toFabric_awburst,
	       loader$toFabric_bresp,
	       loader$toFabric_rresp;
  wire loader$cpu_halt,
       loader$reset_done_x,
       loader$toFabric_arlock,
       loader$toFabric_arready,
       loader$toFabric_arvalid,
       loader$toFabric_awlock,
       loader$toFabric_awready,
       loader$toFabric_awvalid,
       loader$toFabric_bready,
       loader$toFabric_bvalid,
       loader$toFabric_rlast,
       loader$toFabric_rready,
       loader$toFabric_rvalid,
       loader$toFabric_wlast,
       loader$toFabric_wready,
       loader$toFabric_wvalid;

  // rule scheduling signals
  wire CAN_FIRE_RL_mkConnectionVtoAf,
       CAN_FIRE_RL_mkConnectionVtoAf_1,
       CAN_FIRE_RL_rl_ahbl_decoder,
       CAN_FIRE_RL_rl_connect_clint_sint,
       CAN_FIRE_RL_rl_connect_clint_tint,
       CAN_FIRE_RL_rl_connect_haddr,
       CAN_FIRE_RL_rl_connect_hburst,
       CAN_FIRE_RL_rl_connect_hmastlock,
       CAN_FIRE_RL_rl_connect_hprot,
       CAN_FIRE_RL_rl_connect_hrdata,
       CAN_FIRE_RL_rl_connect_hready,
       CAN_FIRE_RL_rl_connect_hresp,
       CAN_FIRE_RL_rl_connect_hsize,
       CAN_FIRE_RL_rl_connect_htrans,
       CAN_FIRE_RL_rl_connect_hwdata,
       CAN_FIRE_RL_rl_connect_hwrite,
       CAN_FIRE_RL_rl_connect_plic_tgt,
       CAN_FIRE_RL_rl_rd_addr_channel,
       CAN_FIRE_RL_rl_rd_data_channel,
       CAN_FIRE_RL_rl_reset_complete_initial,
       CAN_FIRE_RL_rl_reset_start_initial,
       CAN_FIRE_RL_rl_wr_addr_channel,
       CAN_FIRE_RL_rl_wr_data_channel,
       CAN_FIRE_RL_rl_wr_response_channel,
       CAN_FIRE_jtag_tclk,
       CAN_FIRE_jtag_tdi,
       CAN_FIRE_jtag_tms,
       CAN_FIRE_set_watch_tohost,
       WILL_FIRE_RL_mkConnectionVtoAf,
       WILL_FIRE_RL_mkConnectionVtoAf_1,
       WILL_FIRE_RL_rl_ahbl_decoder,
       WILL_FIRE_RL_rl_connect_clint_sint,
       WILL_FIRE_RL_rl_connect_clint_tint,
       WILL_FIRE_RL_rl_connect_haddr,
       WILL_FIRE_RL_rl_connect_hburst,
       WILL_FIRE_RL_rl_connect_hmastlock,
       WILL_FIRE_RL_rl_connect_hprot,
       WILL_FIRE_RL_rl_connect_hrdata,
       WILL_FIRE_RL_rl_connect_hready,
       WILL_FIRE_RL_rl_connect_hresp,
       WILL_FIRE_RL_rl_connect_hsize,
       WILL_FIRE_RL_rl_connect_htrans,
       WILL_FIRE_RL_rl_connect_hwdata,
       WILL_FIRE_RL_rl_connect_hwrite,
       WILL_FIRE_RL_rl_connect_plic_tgt,
       WILL_FIRE_RL_rl_rd_addr_channel,
       WILL_FIRE_RL_rl_rd_data_channel,
       WILL_FIRE_RL_rl_reset_complete_initial,
       WILL_FIRE_RL_rl_reset_start_initial,
       WILL_FIRE_RL_rl_wr_addr_channel,
       WILL_FIRE_RL_rl_wr_data_channel,
       WILL_FIRE_RL_rl_wr_response_channel,
       WILL_FIRE_jtag_tclk,
       WILL_FIRE_jtag_tdi,
       WILL_FIRE_jtag_tms,
       WILL_FIRE_set_watch_tohost;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h2203;
  reg [31 : 0] v__h2274;
  reg [31 : 0] v__h2197;
  reg [31 : 0] v__h2268;
  // synopsys translate_on

  // oscillator and gates for output clock CLK_jtag_tclk_out
  assign CLK_jtag_tclk_out = core$CLK_tclk_out ;
  assign CLK_GATE_jtag_tclk_out = 1'b1 ;

  // value method gpios
  assign gpios = gpio$out ;

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
  assign jtag_TDO = core$TDO ;

  // action method set_watch_tohost
  assign RDY_set_watch_tohost = core$RDY_set_watch_tohost ;
  assign CAN_FIRE_set_watch_tohost = core$RDY_set_watch_tohost ;
  assign WILL_FIRE_set_watch_tohost = EN_set_watch_tohost ;

  // value method mv_tohost_value
  assign mv_tohost_value = core$mv_tohost_value ;
  assign RDY_mv_tohost_value = core$RDY_mv_tohost_value ;

  // submodule core
  // MCU Core
  mkMCUTop core(.TRST(dmi_reset),
		.CLK(CLK),
		.RST_N(RST_N),
		.TCK(core$TCK),
		.TDI(core$TDI),
		.TMS(core$TMS),
		.cpu_halt_x(core$cpu_halt_x),
		.dma_server_araddr(core$dma_server_araddr),
		.dma_server_arburst(core$dma_server_arburst),
		.dma_server_arcache(core$dma_server_arcache),
		.dma_server_arid(core$dma_server_arid),
		.dma_server_arlen(core$dma_server_arlen),
		.dma_server_arlock(core$dma_server_arlock),
		.dma_server_arprot(core$dma_server_arprot),
		.dma_server_arqos(core$dma_server_arqos),
		.dma_server_arregion(core$dma_server_arregion),
		.dma_server_arsize(core$dma_server_arsize),
		.dma_server_arvalid(core$dma_server_arvalid),
		.dma_server_awaddr(core$dma_server_awaddr),
		.dma_server_awburst(core$dma_server_awburst),
		.dma_server_awcache(core$dma_server_awcache),
		.dma_server_awid(core$dma_server_awid),
		.dma_server_awlen(core$dma_server_awlen),
		.dma_server_awlock(core$dma_server_awlock),
		.dma_server_awprot(core$dma_server_awprot),
		.dma_server_awqos(core$dma_server_awqos),
		.dma_server_awregion(core$dma_server_awregion),
		.dma_server_awsize(core$dma_server_awsize),
		.dma_server_awvalid(core$dma_server_awvalid),
		.dma_server_bready(core$dma_server_bready),
		.dma_server_rready(core$dma_server_rready),
		.dma_server_wdata(core$dma_server_wdata),
		.dma_server_wlast(core$dma_server_wlast),
		.dma_server_wstrb(core$dma_server_wstrb),
		.dma_server_wvalid(core$dma_server_wvalid),
		.ext_interrupt(core$ext_interrupt),
		.master1_HRDATA(core$master1_HRDATA),
		.master1_HREADY(core$master1_HREADY),
		.master1_HRESP(core$master1_HRESP),
		.set_watch_tohost_tohost_addr(core$set_watch_tohost_tohost_addr),
		.set_watch_tohost_watch_tohost(core$set_watch_tohost_watch_tohost),
		.sw_interrupt(core$sw_interrupt),
		.timer_interrupt(core$timer_interrupt),
		.EN_set_watch_tohost(core$EN_set_watch_tohost),
		.master1_HADDR(core$master1_HADDR),
		.master1_HBURST(core$master1_HBURST),
		.master1_HMASTLOCK(core$master1_HMASTLOCK),
		.master1_HPROT(core$master1_HPROT),
		.master1_HSIZE(core$master1_HSIZE),
		.master1_HTRANS(core$master1_HTRANS),
		.master1_HWDATA(core$master1_HWDATA),
		.master1_HWRITE(core$master1_HWRITE),
		.dma_server_awready(core$dma_server_awready),
		.dma_server_wready(core$dma_server_wready),
		.dma_server_bvalid(core$dma_server_bvalid),
		.dma_server_bid(core$dma_server_bid),
		.dma_server_bresp(core$dma_server_bresp),
		.dma_server_arready(core$dma_server_arready),
		.dma_server_rvalid(core$dma_server_rvalid),
		.dma_server_rid(core$dma_server_rid),
		.dma_server_rdata(core$dma_server_rdata),
		.dma_server_rresp(core$dma_server_rresp),
		.dma_server_rlast(core$dma_server_rlast),
		.reset_done(core$reset_done),
		.RDY_set_watch_tohost(core$RDY_set_watch_tohost),
		.mv_tohost_value(core$mv_tohost_value),
		.RDY_mv_tohost_value(core$RDY_mv_tohost_value),
		.TDO(core$TDO),
		.CLK_tclk_out(core$CLK_tclk_out),
		.CLK_GATE_tclk_out(),
		.RST_N_ndm_resetn());

  // submodule gpio
  // NOTE: A GPIO device to signal information on the LEDs
  mkGPIO gpio(.CLK(CLK),
	      .RST_N(RST_N),
	      .target_HADDR(gpio$target_HADDR),
	      .target_HBURST(gpio$target_HBURST),
	      .target_HMASTLOCK(gpio$target_HMASTLOCK),
	      .target_HPROT(gpio$target_HPROT),
	      .target_HREADY(gpio$target_HREADY),
	      .target_HSEL(gpio$target_HSEL),
	      .target_HSIZE(gpio$target_HSIZE),
	      .target_HTRANS(gpio$target_HTRANS),
	      .target_HWDATA(gpio$target_HWDATA),
	      .target_HWRITE(gpio$target_HWRITE),
	      .target_HRDATA(gpio$target_HRDATA),
	      .target_HREADYOUT(gpio$target_HREADYOUT),
	      .target_HRESP(gpio$target_HRESP),
	      .out(gpio$out));

  // submodule loader
  // NOTE: A device to test TCM Loader function
  mkLoader loader(.CLK(CLK),
		  .RST_N(RST_N),
		  .reset_done_x(loader$reset_done_x),
		  .toFabric_arready(loader$toFabric_arready),
		  .toFabric_awready(loader$toFabric_awready),
		  .toFabric_bid(loader$toFabric_bid),
		  .toFabric_bresp(loader$toFabric_bresp),
		  .toFabric_bvalid(loader$toFabric_bvalid),
		  .toFabric_rdata(loader$toFabric_rdata),
		  .toFabric_rid(loader$toFabric_rid),
		  .toFabric_rlast(loader$toFabric_rlast),
		  .toFabric_rresp(loader$toFabric_rresp),
		  .toFabric_rvalid(loader$toFabric_rvalid),
		  .toFabric_wready(loader$toFabric_wready),
		  .toFabric_awvalid(loader$toFabric_awvalid),
		  .toFabric_awid(loader$toFabric_awid),
		  .toFabric_awaddr(loader$toFabric_awaddr),
		  .toFabric_awlen(loader$toFabric_awlen),
		  .toFabric_awsize(loader$toFabric_awsize),
		  .toFabric_awburst(loader$toFabric_awburst),
		  .toFabric_awlock(loader$toFabric_awlock),
		  .toFabric_awcache(loader$toFabric_awcache),
		  .toFabric_awprot(loader$toFabric_awprot),
		  .toFabric_awqos(loader$toFabric_awqos),
		  .toFabric_awregion(loader$toFabric_awregion),
		  .toFabric_wvalid(loader$toFabric_wvalid),
		  .toFabric_wdata(loader$toFabric_wdata),
		  .toFabric_wstrb(loader$toFabric_wstrb),
		  .toFabric_wlast(loader$toFabric_wlast),
		  .toFabric_bready(loader$toFabric_bready),
		  .toFabric_arvalid(loader$toFabric_arvalid),
		  .toFabric_arid(loader$toFabric_arid),
		  .toFabric_araddr(loader$toFabric_araddr),
		  .toFabric_arlen(loader$toFabric_arlen),
		  .toFabric_arsize(loader$toFabric_arsize),
		  .toFabric_arburst(loader$toFabric_arburst),
		  .toFabric_arlock(loader$toFabric_arlock),
		  .toFabric_arcache(loader$toFabric_arcache),
		  .toFabric_arprot(loader$toFabric_arprot),
		  .toFabric_arqos(loader$toFabric_arqos),
		  .toFabric_arregion(loader$toFabric_arregion),
		  .toFabric_rready(loader$toFabric_rready),
		  .cpu_halt(loader$cpu_halt));

  // submodule soc_map
  mkSoC_Map soc_map(.CLK(CLK),
		    .RST_N(RST_N),
		    .m_gpio_addr_base(),
		    .m_gpio_addr_size(),
		    .m_gpio_addr_lim(),
		    .m_plic_addr_base(),
		    .m_plic_addr_size(),
		    .m_plic_addr_lim(),
		    .m_clint_addr_base(),
		    .m_clint_addr_size(),
		    .m_clint_addr_lim());

  // rule RL_rl_connect_haddr
  assign CAN_FIRE_RL_rl_connect_haddr = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_haddr = 1'd1 ;

  // rule RL_rl_connect_hburst
  assign CAN_FIRE_RL_rl_connect_hburst = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hburst = 1'd1 ;

  // rule RL_rl_connect_hmastlock
  assign CAN_FIRE_RL_rl_connect_hmastlock = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hmastlock = 1'd1 ;

  // rule RL_rl_connect_hprot
  assign CAN_FIRE_RL_rl_connect_hprot = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hprot = 1'd1 ;

  // rule RL_rl_connect_hsize
  assign CAN_FIRE_RL_rl_connect_hsize = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hsize = 1'd1 ;

  // rule RL_rl_connect_htrans
  assign CAN_FIRE_RL_rl_connect_htrans = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_htrans = 1'd1 ;

  // rule RL_rl_connect_hwdata
  assign CAN_FIRE_RL_rl_connect_hwdata = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hwdata = 1'd1 ;

  // rule RL_rl_connect_hwrite
  assign CAN_FIRE_RL_rl_connect_hwrite = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hwrite = 1'd1 ;

  // rule RL_rl_connect_hrdata
  assign CAN_FIRE_RL_rl_connect_hrdata = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hrdata = 1'd1 ;

  // rule RL_rl_connect_hready
  assign CAN_FIRE_RL_rl_connect_hready = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hready = 1'd1 ;

  // rule RL_rl_connect_hresp
  assign CAN_FIRE_RL_rl_connect_hresp = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_hresp = 1'd1 ;

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

  // rule RL_mkConnectionVtoAf_1
  assign CAN_FIRE_RL_mkConnectionVtoAf_1 = 1'd1 ;
  assign WILL_FIRE_RL_mkConnectionVtoAf_1 = 1'd1 ;

  // rule RL_mkConnectionVtoAf
  assign CAN_FIRE_RL_mkConnectionVtoAf = 1'd1 ;
  assign WILL_FIRE_RL_mkConnectionVtoAf = 1'd1 ;

  // rule RL_rl_ahbl_decoder
  assign CAN_FIRE_RL_rl_ahbl_decoder = 1'd1 ;
  assign WILL_FIRE_RL_rl_ahbl_decoder = 1'd1 ;

  // rule RL_rl_connect_plic_tgt
  assign CAN_FIRE_RL_rl_connect_plic_tgt = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_plic_tgt = 1'd1 ;

  // rule RL_rl_connect_clint_sint
  assign CAN_FIRE_RL_rl_connect_clint_sint = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_clint_sint = 1'd1 ;

  // rule RL_rl_connect_clint_tint
  assign CAN_FIRE_RL_rl_connect_clint_tint = 1'd1 ;
  assign WILL_FIRE_RL_rl_connect_clint_tint = 1'd1 ;

  // rule RL_rl_reset_start_initial
  assign CAN_FIRE_RL_rl_reset_start_initial = rg_state == 2'd0 ;
  assign WILL_FIRE_RL_rl_reset_start_initial = rg_state == 2'd0 ;

  // rule RL_rl_reset_complete_initial
  assign CAN_FIRE_RL_rl_reset_complete_initial = rg_state == 2'd1 ;
  assign WILL_FIRE_RL_rl_reset_complete_initial = rg_state == 2'd1 ;

  // register rg_state
  assign rg_state$D_IN = WILL_FIRE_RL_rl_reset_start_initial ? 2'd1 : 2'd2 ;
  assign rg_state$EN =
	     WILL_FIRE_RL_rl_reset_start_initial ||
	     WILL_FIRE_RL_rl_reset_complete_initial ;

  // submodule core
  assign core$TCK = jtag_TCK ;
  assign core$TDI = jtag_TDI ;
  assign core$TMS = jtag_TMS ;
  assign core$cpu_halt_x = loader$cpu_halt ;
  assign core$dma_server_araddr = loader$toFabric_araddr ;
  assign core$dma_server_arburst = loader$toFabric_arburst ;
  assign core$dma_server_arcache = loader$toFabric_arcache ;
  assign core$dma_server_arid = loader$toFabric_arid ;
  assign core$dma_server_arlen = loader$toFabric_arlen ;
  assign core$dma_server_arlock = loader$toFabric_arlock ;
  assign core$dma_server_arprot = loader$toFabric_arprot ;
  assign core$dma_server_arqos = loader$toFabric_arqos ;
  assign core$dma_server_arregion = loader$toFabric_arregion ;
  assign core$dma_server_arsize = loader$toFabric_arsize ;
  assign core$dma_server_arvalid = loader$toFabric_arvalid ;
  assign core$dma_server_awaddr = loader$toFabric_awaddr ;
  assign core$dma_server_awburst = loader$toFabric_awburst ;
  assign core$dma_server_awcache = loader$toFabric_awcache ;
  assign core$dma_server_awid = loader$toFabric_awid ;
  assign core$dma_server_awlen = loader$toFabric_awlen ;
  assign core$dma_server_awlock = loader$toFabric_awlock ;
  assign core$dma_server_awprot = loader$toFabric_awprot ;
  assign core$dma_server_awqos = loader$toFabric_awqos ;
  assign core$dma_server_awregion = loader$toFabric_awregion ;
  assign core$dma_server_awsize = loader$toFabric_awsize ;
  assign core$dma_server_awvalid = loader$toFabric_awvalid ;
  assign core$dma_server_bready = loader$toFabric_bready ;
  assign core$dma_server_rready = loader$toFabric_rready ;
  assign core$dma_server_wdata = loader$toFabric_wdata ;
  assign core$dma_server_wlast = loader$toFabric_wlast ;
  assign core$dma_server_wstrb = loader$toFabric_wstrb ;
  assign core$dma_server_wvalid = loader$toFabric_wvalid ;
  assign core$ext_interrupt = 1'd0 ;
  assign core$master1_HRDATA = gpio$target_HRDATA ;
  assign core$master1_HREADY = gpio$target_HREADYOUT ;
  assign core$master1_HRESP = gpio$target_HRESP ;
  assign core$set_watch_tohost_tohost_addr = set_watch_tohost_tohost_addr ;
  assign core$set_watch_tohost_watch_tohost = set_watch_tohost_watch_tohost ;
  assign core$sw_interrupt = 1'd0 ;
  assign core$timer_interrupt = 1'd0 ;
  assign core$EN_set_watch_tohost = EN_set_watch_tohost ;

  // submodule gpio
  assign gpio$target_HADDR = core$master1_HADDR ;
  assign gpio$target_HBURST = core$master1_HBURST ;
  assign gpio$target_HMASTLOCK = core$master1_HMASTLOCK ;
  assign gpio$target_HPROT = core$master1_HPROT ;
  assign gpio$target_HREADY = 1'd1 ;
  assign gpio$target_HSEL = 1'd1 ;
  assign gpio$target_HSIZE = core$master1_HSIZE ;
  assign gpio$target_HTRANS = core$master1_HTRANS ;
  assign gpio$target_HWDATA = core$master1_HWDATA ;
  assign gpio$target_HWRITE = core$master1_HWRITE ;

  // submodule loader
  assign loader$reset_done_x = core$reset_done ;
  assign loader$toFabric_arready = core$dma_server_arready ;
  assign loader$toFabric_awready = core$dma_server_awready ;
  assign loader$toFabric_bid = core$dma_server_bid ;
  assign loader$toFabric_bresp = core$dma_server_bresp ;
  assign loader$toFabric_bvalid = core$dma_server_bvalid ;
  assign loader$toFabric_rdata = core$dma_server_rdata ;
  assign loader$toFabric_rid = core$dma_server_rid ;
  assign loader$toFabric_rlast = core$dma_server_rlast ;
  assign loader$toFabric_rresp = core$dma_server_rresp ;
  assign loader$toFabric_rvalid = core$dma_server_rvalid ;
  assign loader$toFabric_wready = core$dma_server_wready ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_state <= `BSV_ASSIGNMENT_DELAY 2'd0;
      end
    else
      begin
        if (rg_state$EN) rg_state <= `BSV_ASSIGNMENT_DELAY rg_state$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_state = 2'h2;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_reset_start_initial)
	begin
	  v__h2203 = $stime;
	  #0;
	end
    v__h2197 = v__h2203 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_reset_start_initial)
	$display("%0d:%m.rl_reset_start_initial ...", v__h2197);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_reset_complete_initial)
	begin
	  v__h2274 = $stime;
	  #0;
	end
    v__h2268 = v__h2274 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_reset_complete_initial)
	$display("%0d:%m.rl_reset_complete_initial", v__h2268);
  end
  // synopsys translate_on
endmodule  // mkSoC_Top

