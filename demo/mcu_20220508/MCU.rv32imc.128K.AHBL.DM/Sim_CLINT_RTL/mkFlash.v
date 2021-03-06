//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// slave_awready                  O     1 reg
// slave_wready                   O     1 reg
// slave_bvalid                   O     1 reg
// slave_bresp                    O     2 reg
// slave_arready                  O     1 reg
// slave_rvalid                   O     1 reg
// slave_rdata                    O    32 reg
// slave_rresp                    O     2 reg
// slave_rlast                    O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// slave_awvalid                  I     1
// slave_awaddr                   I    32 reg
// slave_awlen                    I     8 reg
// slave_awsize                   I     3 reg
// slave_awburst                  I     2 reg
// slave_awlock                   I     1 reg
// slave_awcache                  I     4 reg
// slave_awprot                   I     3 reg
// slave_awqos                    I     4 reg
// slave_awregion                 I     4 reg
// slave_wvalid                   I     1
// slave_wdata                    I    32 reg
// slave_wstrb                    I     4 reg
// slave_wlast                    I     1 reg
// slave_bready                   I     1
// slave_arvalid                  I     1
// slave_araddr                   I    32 reg
// slave_arlen                    I     8 reg
// slave_arsize                   I     3 reg
// slave_arburst                  I     2 reg
// slave_arlock                   I     1 reg
// slave_arcache                  I     4 reg
// slave_arprot                   I     3 reg
// slave_arqos                    I     4 reg
// slave_arregion                 I     4 reg
// slave_rready                   I     1
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

module mkFlash(CLK,
	       RST_N,

	       slave_awvalid,
	       slave_awaddr,
	       slave_awlen,
	       slave_awsize,
	       slave_awburst,
	       slave_awlock,
	       slave_awcache,
	       slave_awprot,
	       slave_awqos,
	       slave_awregion,

	       slave_awready,

	       slave_wvalid,
	       slave_wdata,
	       slave_wstrb,
	       slave_wlast,

	       slave_wready,

	       slave_bvalid,

	       slave_bresp,

	       slave_bready,

	       slave_arvalid,
	       slave_araddr,
	       slave_arlen,
	       slave_arsize,
	       slave_arburst,
	       slave_arlock,
	       slave_arcache,
	       slave_arprot,
	       slave_arqos,
	       slave_arregion,

	       slave_arready,

	       slave_rvalid,

	       slave_rdata,

	       slave_rresp,

	       slave_rlast,

	       slave_rready);
  input  CLK;
  input  RST_N;

  // action method slave_m_awvalid
  input  slave_awvalid;
  input  [31 : 0] slave_awaddr;
  input  [7 : 0] slave_awlen;
  input  [2 : 0] slave_awsize;
  input  [1 : 0] slave_awburst;
  input  slave_awlock;
  input  [3 : 0] slave_awcache;
  input  [2 : 0] slave_awprot;
  input  [3 : 0] slave_awqos;
  input  [3 : 0] slave_awregion;

  // value method slave_m_awready
  output slave_awready;

  // action method slave_m_wvalid
  input  slave_wvalid;
  input  [31 : 0] slave_wdata;
  input  [3 : 0] slave_wstrb;
  input  slave_wlast;

  // value method slave_m_wready
  output slave_wready;

  // value method slave_m_bvalid
  output slave_bvalid;

  // value method slave_m_bid

  // value method slave_m_bresp
  output [1 : 0] slave_bresp;

  // value method slave_m_buser

  // action method slave_m_bready
  input  slave_bready;

  // action method slave_m_arvalid
  input  slave_arvalid;
  input  [31 : 0] slave_araddr;
  input  [7 : 0] slave_arlen;
  input  [2 : 0] slave_arsize;
  input  [1 : 0] slave_arburst;
  input  slave_arlock;
  input  [3 : 0] slave_arcache;
  input  [2 : 0] slave_arprot;
  input  [3 : 0] slave_arqos;
  input  [3 : 0] slave_arregion;

  // value method slave_m_arready
  output slave_arready;

  // value method slave_m_rvalid
  output slave_rvalid;

  // value method slave_m_rid

  // value method slave_m_rdata
  output [31 : 0] slave_rdata;

  // value method slave_m_rresp
  output [1 : 0] slave_rresp;

  // value method slave_m_rlast
  output slave_rlast;

  // value method slave_m_ruser

  // action method slave_m_rready
  input  slave_rready;

  // signals for module outputs
  wire [31 : 0] slave_rdata;
  wire [1 : 0] slave_bresp, slave_rresp;
  wire slave_arready,
       slave_awready,
       slave_bvalid,
       slave_rlast,
       slave_rvalid,
       slave_wready;

  // register rg_addr_base
  reg [31 : 0] rg_addr_base;
  wire [31 : 0] rg_addr_base$D_IN;
  wire rg_addr_base$EN;

  // register rg_addr_lim
  reg [31 : 0] rg_addr_lim;
  wire [31 : 0] rg_addr_lim$D_IN;
  wire rg_addr_lim$EN;

  // register rg_module_ready
  reg rg_module_ready;
  wire rg_module_ready$D_IN, rg_module_ready$EN;

  // ports of submodule slave_xactor_f_rd_addr
  wire [60 : 0] slave_xactor_f_rd_addr$D_IN, slave_xactor_f_rd_addr$D_OUT;
  wire slave_xactor_f_rd_addr$CLR,
       slave_xactor_f_rd_addr$DEQ,
       slave_xactor_f_rd_addr$EMPTY_N,
       slave_xactor_f_rd_addr$ENQ,
       slave_xactor_f_rd_addr$FULL_N;

  // ports of submodule slave_xactor_f_rd_data
  wire [34 : 0] slave_xactor_f_rd_data$D_IN, slave_xactor_f_rd_data$D_OUT;
  wire slave_xactor_f_rd_data$CLR,
       slave_xactor_f_rd_data$DEQ,
       slave_xactor_f_rd_data$EMPTY_N,
       slave_xactor_f_rd_data$ENQ,
       slave_xactor_f_rd_data$FULL_N;

  // ports of submodule slave_xactor_f_wr_addr
  wire [60 : 0] slave_xactor_f_wr_addr$D_IN, slave_xactor_f_wr_addr$D_OUT;
  wire slave_xactor_f_wr_addr$CLR,
       slave_xactor_f_wr_addr$DEQ,
       slave_xactor_f_wr_addr$EMPTY_N,
       slave_xactor_f_wr_addr$ENQ,
       slave_xactor_f_wr_addr$FULL_N;

  // ports of submodule slave_xactor_f_wr_data
  wire [36 : 0] slave_xactor_f_wr_data$D_IN;
  wire slave_xactor_f_wr_data$CLR,
       slave_xactor_f_wr_data$DEQ,
       slave_xactor_f_wr_data$EMPTY_N,
       slave_xactor_f_wr_data$ENQ,
       slave_xactor_f_wr_data$FULL_N;

  // ports of submodule slave_xactor_f_wr_resp
  wire [1 : 0] slave_xactor_f_wr_resp$D_IN, slave_xactor_f_wr_resp$D_OUT;
  wire slave_xactor_f_wr_resp$CLR,
       slave_xactor_f_wr_resp$DEQ,
       slave_xactor_f_wr_resp$EMPTY_N,
       slave_xactor_f_wr_resp$ENQ,
       slave_xactor_f_wr_resp$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_process_rd_req,
       CAN_FIRE_RL_rl_process_wr_req,
       CAN_FIRE_slave_m_arvalid,
       CAN_FIRE_slave_m_awvalid,
       CAN_FIRE_slave_m_bready,
       CAN_FIRE_slave_m_rready,
       CAN_FIRE_slave_m_wvalid,
       WILL_FIRE_RL_rl_process_rd_req,
       WILL_FIRE_RL_rl_process_wr_req,
       WILL_FIRE_slave_m_arvalid,
       WILL_FIRE_slave_m_awvalid,
       WILL_FIRE_slave_m_bready,
       WILL_FIRE_slave_m_rready,
       WILL_FIRE_slave_m_wvalid;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h892;
  reg [31 : 0] v__h1431;
  reg [31 : 0] v__h886;
  reg [31 : 0] v__h1425;
  // synopsys translate_on

  // remaining internal signals
  reg [31 : 0] rdata__h713;
  reg CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2,
      CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1;
  wire [31 : 0] raw_byte_addr__h711;
  wire [1 : 0] v__h717;
  wire IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32,
       IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106;

  // action method slave_m_awvalid
  assign CAN_FIRE_slave_m_awvalid = 1'd1 ;
  assign WILL_FIRE_slave_m_awvalid = 1'd1 ;

  // value method slave_m_awready
  assign slave_awready = slave_xactor_f_wr_addr$FULL_N ;

  // action method slave_m_wvalid
  assign CAN_FIRE_slave_m_wvalid = 1'd1 ;
  assign WILL_FIRE_slave_m_wvalid = 1'd1 ;

  // value method slave_m_wready
  assign slave_wready = slave_xactor_f_wr_data$FULL_N ;

  // value method slave_m_bvalid
  assign slave_bvalid = slave_xactor_f_wr_resp$EMPTY_N ;

  // value method slave_m_bresp
  assign slave_bresp = slave_xactor_f_wr_resp$D_OUT ;

  // action method slave_m_bready
  assign CAN_FIRE_slave_m_bready = 1'd1 ;
  assign WILL_FIRE_slave_m_bready = 1'd1 ;

  // action method slave_m_arvalid
  assign CAN_FIRE_slave_m_arvalid = 1'd1 ;
  assign WILL_FIRE_slave_m_arvalid = 1'd1 ;

  // value method slave_m_arready
  assign slave_arready = slave_xactor_f_rd_addr$FULL_N ;

  // value method slave_m_rvalid
  assign slave_rvalid = slave_xactor_f_rd_data$EMPTY_N ;

  // value method slave_m_rdata
  assign slave_rdata = slave_xactor_f_rd_data$D_OUT[34:3] ;

  // value method slave_m_rresp
  assign slave_rresp = slave_xactor_f_rd_data$D_OUT[2:1] ;

  // value method slave_m_rlast
  assign slave_rlast = slave_xactor_f_rd_data$D_OUT[0] ;

  // action method slave_m_rready
  assign CAN_FIRE_slave_m_rready = 1'd1 ;
  assign WILL_FIRE_slave_m_rready = 1'd1 ;

  // submodule slave_xactor_f_rd_addr
  FIFO2 #(.width(32'd61), .guarded(1'd1)) slave_xactor_f_rd_addr(.RST(RST_N),
								 .CLK(CLK),
								 .D_IN(slave_xactor_f_rd_addr$D_IN),
								 .ENQ(slave_xactor_f_rd_addr$ENQ),
								 .DEQ(slave_xactor_f_rd_addr$DEQ),
								 .CLR(slave_xactor_f_rd_addr$CLR),
								 .D_OUT(slave_xactor_f_rd_addr$D_OUT),
								 .FULL_N(slave_xactor_f_rd_addr$FULL_N),
								 .EMPTY_N(slave_xactor_f_rd_addr$EMPTY_N));

  // submodule slave_xactor_f_rd_data
  FIFO2 #(.width(32'd35), .guarded(1'd1)) slave_xactor_f_rd_data(.RST(RST_N),
								 .CLK(CLK),
								 .D_IN(slave_xactor_f_rd_data$D_IN),
								 .ENQ(slave_xactor_f_rd_data$ENQ),
								 .DEQ(slave_xactor_f_rd_data$DEQ),
								 .CLR(slave_xactor_f_rd_data$CLR),
								 .D_OUT(slave_xactor_f_rd_data$D_OUT),
								 .FULL_N(slave_xactor_f_rd_data$FULL_N),
								 .EMPTY_N(slave_xactor_f_rd_data$EMPTY_N));

  // submodule slave_xactor_f_wr_addr
  FIFO2 #(.width(32'd61), .guarded(1'd1)) slave_xactor_f_wr_addr(.RST(RST_N),
								 .CLK(CLK),
								 .D_IN(slave_xactor_f_wr_addr$D_IN),
								 .ENQ(slave_xactor_f_wr_addr$ENQ),
								 .DEQ(slave_xactor_f_wr_addr$DEQ),
								 .CLR(slave_xactor_f_wr_addr$CLR),
								 .D_OUT(slave_xactor_f_wr_addr$D_OUT),
								 .FULL_N(slave_xactor_f_wr_addr$FULL_N),
								 .EMPTY_N(slave_xactor_f_wr_addr$EMPTY_N));

  // submodule slave_xactor_f_wr_data
  FIFO2 #(.width(32'd37), .guarded(1'd1)) slave_xactor_f_wr_data(.RST(RST_N),
								 .CLK(CLK),
								 .D_IN(slave_xactor_f_wr_data$D_IN),
								 .ENQ(slave_xactor_f_wr_data$ENQ),
								 .DEQ(slave_xactor_f_wr_data$DEQ),
								 .CLR(slave_xactor_f_wr_data$CLR),
								 .D_OUT(),
								 .FULL_N(slave_xactor_f_wr_data$FULL_N),
								 .EMPTY_N(slave_xactor_f_wr_data$EMPTY_N));

  // submodule slave_xactor_f_wr_resp
  FIFO2 #(.width(32'd2), .guarded(1'd1)) slave_xactor_f_wr_resp(.RST(RST_N),
								.CLK(CLK),
								.D_IN(slave_xactor_f_wr_resp$D_IN),
								.ENQ(slave_xactor_f_wr_resp$ENQ),
								.DEQ(slave_xactor_f_wr_resp$DEQ),
								.CLR(slave_xactor_f_wr_resp$CLR),
								.D_OUT(slave_xactor_f_wr_resp$D_OUT),
								.FULL_N(slave_xactor_f_wr_resp$FULL_N),
								.EMPTY_N(slave_xactor_f_wr_resp$EMPTY_N));

  // rule RL_rl_process_rd_req
  assign CAN_FIRE_RL_rl_process_rd_req =
	     slave_xactor_f_rd_addr$EMPTY_N &&
	     slave_xactor_f_rd_data$FULL_N &&
	     rg_module_ready ;
  assign WILL_FIRE_RL_rl_process_rd_req = CAN_FIRE_RL_rl_process_rd_req ;

  // rule RL_rl_process_wr_req
  assign CAN_FIRE_RL_rl_process_wr_req =
	     slave_xactor_f_wr_addr$EMPTY_N &&
	     slave_xactor_f_wr_data$EMPTY_N &&
	     slave_xactor_f_wr_resp$FULL_N &&
	     rg_module_ready ;
  assign WILL_FIRE_RL_rl_process_wr_req = CAN_FIRE_RL_rl_process_wr_req ;

  // register rg_addr_base
  assign rg_addr_base$D_IN = 32'h0 ;
  assign rg_addr_base$EN = 1'b0 ;

  // register rg_addr_lim
  assign rg_addr_lim$D_IN = 32'h0 ;
  assign rg_addr_lim$EN = 1'b0 ;

  // register rg_module_ready
  assign rg_module_ready$D_IN = 1'b0 ;
  assign rg_module_ready$EN = 1'b0 ;

  // submodule slave_xactor_f_rd_addr
  assign slave_xactor_f_rd_addr$D_IN =
	     { slave_araddr,
	       slave_arlen,
	       slave_arsize,
	       slave_arburst,
	       slave_arlock,
	       slave_arcache,
	       slave_arprot,
	       slave_arqos,
	       slave_arregion } ;
  assign slave_xactor_f_rd_addr$ENQ =
	     slave_arvalid && slave_xactor_f_rd_addr$FULL_N ;
  assign slave_xactor_f_rd_addr$DEQ = CAN_FIRE_RL_rl_process_rd_req ;
  assign slave_xactor_f_rd_addr$CLR = 1'b0 ;

  // submodule slave_xactor_f_rd_data
  assign slave_xactor_f_rd_data$D_IN = { rdata__h713, v__h717, 1'd1 } ;
  assign slave_xactor_f_rd_data$ENQ = CAN_FIRE_RL_rl_process_rd_req ;
  assign slave_xactor_f_rd_data$DEQ =
	     slave_rready && slave_xactor_f_rd_data$EMPTY_N ;
  assign slave_xactor_f_rd_data$CLR = 1'b0 ;

  // submodule slave_xactor_f_wr_addr
  assign slave_xactor_f_wr_addr$D_IN =
	     { slave_awaddr,
	       slave_awlen,
	       slave_awsize,
	       slave_awburst,
	       slave_awlock,
	       slave_awcache,
	       slave_awprot,
	       slave_awqos,
	       slave_awregion } ;
  assign slave_xactor_f_wr_addr$ENQ =
	     slave_awvalid && slave_xactor_f_wr_addr$FULL_N ;
  assign slave_xactor_f_wr_addr$DEQ = CAN_FIRE_RL_rl_process_wr_req ;
  assign slave_xactor_f_wr_addr$CLR = 1'b0 ;

  // submodule slave_xactor_f_wr_data
  assign slave_xactor_f_wr_data$D_IN =
	     { slave_wdata, slave_wstrb, slave_wlast } ;
  assign slave_xactor_f_wr_data$ENQ =
	     slave_wvalid && slave_xactor_f_wr_data$FULL_N ;
  assign slave_xactor_f_wr_data$DEQ = CAN_FIRE_RL_rl_process_wr_req ;
  assign slave_xactor_f_wr_data$CLR = 1'b0 ;

  // submodule slave_xactor_f_wr_resp
  assign slave_xactor_f_wr_resp$D_IN =
	     IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106 ?
	       2'b10 :
	       2'b0 ;
  assign slave_xactor_f_wr_resp$ENQ = CAN_FIRE_RL_rl_process_wr_req ;
  assign slave_xactor_f_wr_resp$DEQ =
	     slave_bready && slave_xactor_f_wr_resp$EMPTY_N ;
  assign slave_xactor_f_wr_resp$CLR = 1'b0 ;

  // remaining internal signals
  assign IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32 =
	     CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2 ||
	     rg_addr_base > raw_byte_addr__h711 ||
	     raw_byte_addr__h711 >= rg_addr_lim ;
  assign IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106 =
	     CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1 ||
	     rg_addr_base > slave_xactor_f_wr_addr$D_OUT[60:29] ||
	     slave_xactor_f_wr_addr$D_OUT[60:29] >= rg_addr_lim ;
  assign raw_byte_addr__h711 =
	     slave_xactor_f_rd_addr$D_OUT[60:29] - rg_addr_base ;
  assign v__h717 =
	     IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32 ?
	       2'b10 :
	       2'b0 ;
  always@(raw_byte_addr__h711)
  begin
    case (raw_byte_addr__h711[7:0])
      8'd0: rdata__h713 = 32'hC80002B7;
      8'd4: rdata__h713 = 32'h00004337;
      8'd8: rdata__h713 = 32'hFF030313;
      8'd12: rdata__h713 = 32'h00628133;
      8'd16: rdata__h713 = 32'h00012023;
      8'd20: rdata__h713 = 32'h6FFF04B7;
      8'd24: rdata__h713 = 32'h00048403;
      8'd28: rdata__h713 = 32'h00144413;
      8'd32: rdata__h713 = 32'h00848023;
      8'd36: rdata__h713 = 32'h00000913;
      8'd40: rdata__h713 = 32'h10000993;
      8'd44: rdata__h713 = 32'h00190913;
      8'd48: rdata__h713 = 32'hFF391EE3;
      8'd52: rdata__h713 = 32'hFE5FF06F;
      8'd56, 8'd60: rdata__h713 = 32'h00000013;
      default: rdata__h713 = 32'hAAAAAAAA;
    endcase
  end
  always@(slave_xactor_f_wr_addr$D_OUT)
  begin
    case (slave_xactor_f_wr_addr$D_OUT[20:18])
      3'b001:
	  CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1 =
	      slave_xactor_f_wr_addr$D_OUT[29];
      3'b010:
	  CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1 =
	      slave_xactor_f_wr_addr$D_OUT[30:29] != 2'd0;
      3'b011:
	  CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1 =
	      slave_xactor_f_wr_addr$D_OUT[31:29] != 3'd0;
      default: CASE_slave_xactor_f_wr_addrD_OUT_BITS_20_TO_1_ETC__q1 =
		   slave_xactor_f_wr_addr$D_OUT[20:18] != 3'b0;
    endcase
  end
  always@(slave_xactor_f_rd_addr$D_OUT or raw_byte_addr__h711)
  begin
    case (slave_xactor_f_rd_addr$D_OUT[20:18])
      3'b001:
	  CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2 =
	      raw_byte_addr__h711[0];
      3'b010:
	  CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2 =
	      raw_byte_addr__h711[1:0] != 2'd0;
      3'b011:
	  CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2 =
	      raw_byte_addr__h711[2:0] != 3'd0;
      default: CASE_slave_xactor_f_rd_addrD_OUT_BITS_20_TO_1_ETC__q2 =
		   slave_xactor_f_rd_addr$D_OUT[20:18] != 3'b0;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_addr_base <= `BSV_ASSIGNMENT_DELAY 32'd0;
	rg_addr_lim <= `BSV_ASSIGNMENT_DELAY 32'h00000040;
	rg_module_ready <= `BSV_ASSIGNMENT_DELAY 1'd1;
      end
    else
      begin
        if (rg_addr_base$EN)
	  rg_addr_base <= `BSV_ASSIGNMENT_DELAY rg_addr_base$D_IN;
	if (rg_addr_lim$EN)
	  rg_addr_lim <= `BSV_ASSIGNMENT_DELAY rg_addr_lim$D_IN;
	if (rg_module_ready$EN)
	  rg_module_ready <= `BSV_ASSIGNMENT_DELAY rg_module_ready$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_addr_base = 32'hAAAAAAAA;
    rg_addr_lim = 32'hAAAAAAAA;
    rg_module_ready = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	begin
	  v__h892 = $stime;
	  #0;
	end
    v__h886 = v__h892 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$display("%0d: ERROR: Flash.rl_process_rd_req: unrecognized or misaligned addr",
		 v__h886);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("    ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("AXI4_Rd_Addr { ", "arid: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", 1'd0);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "araddr: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[60:29]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arlen: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[28:21]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arsize: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[20:18]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arburst: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[17:16]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arlock: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[15]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arcache: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[14:11]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arprot: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[10:8]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arqos: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[7:4]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "arregion: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", slave_xactor_f_rd_addr$D_OUT[3:0]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write(", ", "aruser: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("'h%h", 1'd0, " }");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_rd_req &&
	  IF_slave_xactor_f_rd_addr_first_BITS_20_TO_18__ETC___d32)
	$write("\n");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	begin
	  v__h1431 = $stime;
	  #0;
	end
    v__h1425 = v__h1431 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$display("%0d: ERROR: Flash.rl_process_wr_req: unrecognized addr",
		 v__h1425);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("    ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("AXI4_Wr_Addr { ", "awid: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", 1'd0);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awaddr: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[60:29]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awlen: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[28:21]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awsize: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[20:18]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awburst: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[17:16]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awlock: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[15]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awcache: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[14:11]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awprot: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[10:8]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awqos: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[7:4]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awregion: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", slave_xactor_f_wr_addr$D_OUT[3:0]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write(", ", "awuser: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("'h%h", 1'd0, " }");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_process_wr_req &&
	  IF_slave_xactor_f_wr_addr_first__3_BITS_20_TO__ETC___d106)
	$write("\n");
  end
  // synopsys translate_on
endmodule  // mkFlash

