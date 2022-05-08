//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// RDY_server_reset_request_put   O     1 reg
// RDY_server_reset_response_get  O     1
// RDY_imem_req                   O     1
// imem_instr                     O    37
// RDY_imem_instr                 O     1
// RDY_backdoor_req               O     1
// backdoor_rsp                   O    33
// RDY_backdoor_rsp               O     1
// RDY_dma_req                    O     1 reg
// verbosity                      I     2
// CLK                            I     1 clock
// RST_N                          I     1 reset
// imem_req_addr                  I    32
// backdoor_req_read              I     1 reg
// backdoor_req_addr              I    32
// backdoor_req_wdata             I    32 reg
// backdoor_req_f3                I     3
// dma_req_addr                   I    32
// dma_req_wdata                  I    32
// EN_server_reset_request_put    I     1
// EN_server_reset_response_get   I     1
// EN_imem_req                    I     1
// EN_backdoor_req                I     1
// EN_dma_req                     I     1
// EN_imem_instr                  I     1
// EN_backdoor_rsp                I     1
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

module mkITCM(verbosity,
	      CLK,
	      RST_N,

	      EN_server_reset_request_put,
	      RDY_server_reset_request_put,

	      EN_server_reset_response_get,
	      RDY_server_reset_response_get,

	      imem_req_addr,
	      EN_imem_req,
	      RDY_imem_req,

	      EN_imem_instr,
	      imem_instr,
	      RDY_imem_instr,

	      backdoor_req_read,
	      backdoor_req_addr,
	      backdoor_req_wdata,
	      backdoor_req_f3,
	      EN_backdoor_req,
	      RDY_backdoor_req,

	      EN_backdoor_rsp,
	      backdoor_rsp,
	      RDY_backdoor_rsp,

	      dma_req_addr,
	      dma_req_wdata,
	      EN_dma_req,
	      RDY_dma_req);
  input  [1 : 0] verbosity;
  input  CLK;
  input  RST_N;

  // action method server_reset_request_put
  input  EN_server_reset_request_put;
  output RDY_server_reset_request_put;

  // action method server_reset_response_get
  input  EN_server_reset_response_get;
  output RDY_server_reset_response_get;

  // action method imem_req
  input  [31 : 0] imem_req_addr;
  input  EN_imem_req;
  output RDY_imem_req;

  // actionvalue method imem_instr
  input  EN_imem_instr;
  output [36 : 0] imem_instr;
  output RDY_imem_instr;

  // action method backdoor_req
  input  backdoor_req_read;
  input  [31 : 0] backdoor_req_addr;
  input  [31 : 0] backdoor_req_wdata;
  input  [2 : 0] backdoor_req_f3;
  input  EN_backdoor_req;
  output RDY_backdoor_req;

  // actionvalue method backdoor_rsp
  input  EN_backdoor_rsp;
  output [32 : 0] backdoor_rsp;
  output RDY_backdoor_rsp;

  // action method dma_req
  input  [31 : 0] dma_req_addr;
  input  [31 : 0] dma_req_wdata;
  input  EN_dma_req;
  output RDY_dma_req;

  // signals for module outputs
  wire [36 : 0] imem_instr;
  wire [32 : 0] backdoor_rsp;
  wire RDY_backdoor_req,
       RDY_backdoor_rsp,
       RDY_dma_req,
       RDY_imem_instr,
       RDY_imem_req,
       RDY_server_reset_request_put,
       RDY_server_reset_response_get;

  // register rg_dbg_addr
  reg [31 : 0] rg_dbg_addr;
  wire [31 : 0] rg_dbg_addr$D_IN;
  wire rg_dbg_addr$EN;

  // register rg_dbg_f3
  reg [2 : 0] rg_dbg_f3;
  wire [2 : 0] rg_dbg_f3$D_IN;
  wire rg_dbg_f3$EN;

  // register rg_dbg_rsp_err
  reg rg_dbg_rsp_err;
  wire rg_dbg_rsp_err$D_IN, rg_dbg_rsp_err$EN;

  // register rg_dbg_rsp_valid
  reg rg_dbg_rsp_valid;
  wire rg_dbg_rsp_valid$D_IN, rg_dbg_rsp_valid$EN;

  // register rg_dbg_wdata
  reg [31 : 0] rg_dbg_wdata;
  wire [31 : 0] rg_dbg_wdata$D_IN;
  wire rg_dbg_wdata$EN;

  // register rg_read_not_write
  reg rg_read_not_write;
  wire rg_read_not_write$D_IN, rg_read_not_write$EN;

  // register rg_rsp_exc
  reg [4 : 0] rg_rsp_exc;
  wire [4 : 0] rg_rsp_exc$D_IN;
  wire rg_rsp_exc$EN;

  // register rg_state
  reg rg_state;
  wire rg_state$D_IN, rg_state$EN;

  // ports of submodule addr_map
  wire [31 : 0] addr_map$m_is_dtcm_addr_addr, addr_map$m_is_itcm_addr_addr;
  wire addr_map$m_is_itcm_addr;

  // ports of submodule f_reset_rsps
  wire f_reset_rsps$CLR,
       f_reset_rsps$DEQ,
       f_reset_rsps$EMPTY_N,
       f_reset_rsps$ENQ,
       f_reset_rsps$FULL_N;

  // ports of submodule mem
  reg [31 : 0] mem$DIB;
  reg [10 : 0] mem$ADDRB;
  wire [31 : 0] mem$DIA, mem$DOA, mem$DOB;
  wire [10 : 0] mem$ADDRA;
  wire mem$ENA, mem$ENB, mem$WEA, mem$WEB;

  // ports of submodule rg_rsp_valid
  wire rg_rsp_valid$CLR,
       rg_rsp_valid$DEQ,
       rg_rsp_valid$EMPTY_N,
       rg_rsp_valid$ENQ,
       rg_rsp_valid$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_dbg_write_completion,
       CAN_FIRE_RL_rl_reset,
       CAN_FIRE_backdoor_req,
       CAN_FIRE_backdoor_rsp,
       CAN_FIRE_dma_req,
       CAN_FIRE_imem_instr,
       CAN_FIRE_imem_req,
       CAN_FIRE_server_reset_request_put,
       CAN_FIRE_server_reset_response_get,
       WILL_FIRE_RL_rl_dbg_write_completion,
       WILL_FIRE_RL_rl_reset,
       WILL_FIRE_backdoor_req,
       WILL_FIRE_backdoor_rsp,
       WILL_FIRE_dma_req,
       WILL_FIRE_imem_instr,
       WILL_FIRE_imem_req,
       WILL_FIRE_server_reset_request_put,
       WILL_FIRE_server_reset_response_get;

  // inputs to muxes for submodule ports
  reg [31 : 0] MUX_mem$b_put_3__VAL_2;
  wire [4 : 0] MUX_rg_rsp_exc$write_1__VAL_2;
  wire MUX_rg_dbg_rsp_valid$write_1__SEL_1;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h2159;
  reg [31 : 0] v__h1821;
  reg [31 : 0] v__h1735;
  reg [31 : 0] v__h2005;
  reg [31 : 0] v__h2775;
  reg [31 : 0] v__h2914;
  reg [31 : 0] v__h3698;
  reg [31 : 0] v__h3047;
  reg [31 : 0] v__h1729;
  reg [31 : 0] v__h1815;
  reg [31 : 0] v__h1999;
  reg [31 : 0] v__h2153;
  reg [31 : 0] v__h2769;
  reg [31 : 0] v__h2908;
  reg [31 : 0] v__h3041;
  reg [31 : 0] v__h3692;
  // synopsys translate_on

  // remaining internal signals
  reg [31 : 0] CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9,
	       CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7,
	       CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8,
	       IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140,
	       IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131,
	       IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37,
	       ram_out__h2997;
  wire [31 : 0] result__h3180,
		result__h3208,
		result__h3236,
		result__h3264,
		result__h3305,
		result__h3333,
		result__h3361,
		result__h3389,
		result__h3430,
		result__h3458,
		result__h3497,
		result__h3525;
  wire [15 : 0] memDOB_BITS_15_TO_0__q2, memDOB_BITS_31_TO_16__q5;
  wire [7 : 0] memDOB_BITS_15_TO_8__q3,
	       memDOB_BITS_23_TO_16__q4,
	       memDOB_BITS_31_TO_24__q6,
	       memDOB_BITS_7_TO_0__q1;
  wire NOT_backdoor_req_f3_BITS_1_TO_0_8_EQ_0b0_9_0_A_ETC___d109,
       NOT_verbosity_ULE_1_0___d71;

  // action method server_reset_request_put
  assign RDY_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign CAN_FIRE_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign WILL_FIRE_server_reset_request_put = EN_server_reset_request_put ;

  // action method server_reset_response_get
  assign RDY_server_reset_response_get = rg_state && f_reset_rsps$EMPTY_N ;
  assign CAN_FIRE_server_reset_response_get =
	     rg_state && f_reset_rsps$EMPTY_N ;
  assign WILL_FIRE_server_reset_response_get = EN_server_reset_response_get ;

  // action method imem_req
  assign RDY_imem_req = rg_state && rg_rsp_valid$FULL_N ;
  assign CAN_FIRE_imem_req = rg_state && rg_rsp_valid$FULL_N ;
  assign WILL_FIRE_imem_req = EN_imem_req ;

  // actionvalue method imem_instr
  assign imem_instr = { mem$DOA, rg_rsp_exc } ;
  assign RDY_imem_instr = rg_state && rg_rsp_valid$EMPTY_N ;
  assign CAN_FIRE_imem_instr = rg_state && rg_rsp_valid$EMPTY_N ;
  assign WILL_FIRE_imem_instr = EN_imem_instr ;

  // action method backdoor_req
  assign RDY_backdoor_req = rg_state && !rg_dbg_rsp_valid ;
  assign CAN_FIRE_backdoor_req = rg_state && !rg_dbg_rsp_valid ;
  assign WILL_FIRE_backdoor_req = EN_backdoor_req ;

  // actionvalue method backdoor_rsp
  assign backdoor_rsp = { ram_out__h2997, rg_dbg_rsp_err } ;
  assign RDY_backdoor_rsp = rg_state && rg_dbg_rsp_valid ;
  assign CAN_FIRE_backdoor_rsp = rg_state && rg_dbg_rsp_valid ;
  assign WILL_FIRE_backdoor_rsp = EN_backdoor_rsp ;

  // action method dma_req
  assign RDY_dma_req = rg_state ;
  assign CAN_FIRE_dma_req = rg_state ;
  assign WILL_FIRE_dma_req = EN_dma_req ;

  // submodule addr_map
  mkCore_Map addr_map(.CLK(CLK),
		      .RST_N(RST_N),
		      .m_is_dtcm_addr_addr(addr_map$m_is_dtcm_addr_addr),
		      .m_is_itcm_addr_addr(addr_map$m_is_itcm_addr_addr),
		      .m_itcm_addr_base(),
		      .m_itcm_addr_size(),
		      .m_itcm_addr_lim(),
		      .m_is_itcm_addr(addr_map$m_is_itcm_addr),
		      .m_dtcm_addr_base(),
		      .m_dtcm_addr_size(),
		      .m_dtcm_addr_lim(),
		      .m_is_dtcm_addr(),
		      .m_pc_reset_value(),
		      .m_mtvec_reset_value());

  // submodule f_reset_rsps
  FIFO10 #(.guarded(1'd1)) f_reset_rsps(.RST(RST_N),
					.CLK(CLK),
					.ENQ(f_reset_rsps$ENQ),
					.DEQ(f_reset_rsps$DEQ),
					.CLR(f_reset_rsps$CLR),
					.FULL_N(f_reset_rsps$FULL_N),
					.EMPTY_N(f_reset_rsps$EMPTY_N));

  // submodule mem
  BRAM2 #(.PIPELINED(1'd0),
	  .ADDR_WIDTH(32'd11),
	  .DATA_WIDTH(32'd32),
	  .MEMSIZE(12'd2048)) mem(.CLKA(CLK),
				  .CLKB(CLK),
				  .ADDRA(mem$ADDRA),
				  .ADDRB(mem$ADDRB),
				  .DIA(mem$DIA),
				  .DIB(mem$DIB),
				  .WEA(mem$WEA),
				  .WEB(mem$WEB),
				  .ENA(mem$ENA),
				  .ENB(mem$ENB),
				  .DOA(mem$DOA),
				  .DOB(mem$DOB));

  // submodule rg_rsp_valid
  FIFO20 #(.guarded(1'd1)) rg_rsp_valid(.RST(RST_N),
					.CLK(CLK),
					.ENQ(rg_rsp_valid$ENQ),
					.DEQ(rg_rsp_valid$DEQ),
					.CLR(rg_rsp_valid$CLR),
					.FULL_N(rg_rsp_valid$FULL_N),
					.EMPTY_N(rg_rsp_valid$EMPTY_N));

  // rule RL_rl_dbg_write_completion
  assign CAN_FIRE_RL_rl_dbg_write_completion =
	     rg_dbg_rsp_valid && !rg_read_not_write && !rg_dbg_rsp_err ;
  assign WILL_FIRE_RL_rl_dbg_write_completion =
	     CAN_FIRE_RL_rl_dbg_write_completion && !EN_dma_req ;

  // rule RL_rl_reset
  assign CAN_FIRE_RL_rl_reset = !rg_state ;
  assign WILL_FIRE_RL_rl_reset = CAN_FIRE_RL_rl_reset ;

  // inputs to muxes for submodule ports
  assign MUX_rg_dbg_rsp_valid$write_1__SEL_1 =
	     EN_backdoor_rsp || WILL_FIRE_RL_rl_reset ;
  always@(rg_dbg_f3 or
	  mem$DOB or
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37 or
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9 or
	  rg_dbg_wdata)
  begin
    case (rg_dbg_f3[1:0])
      2'd0:
	  MUX_mem$b_put_3__VAL_2 =
	      IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37;
      2'd1:
	  MUX_mem$b_put_3__VAL_2 =
	      CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9;
      2'd2, 2'd3: MUX_mem$b_put_3__VAL_2 = rg_dbg_wdata;
    endcase
  end
  assign MUX_rg_rsp_exc$write_1__VAL_2 =
	     { imem_req_addr[1:0] != 2'b0 || !addr_map$m_is_itcm_addr,
	       (imem_req_addr[1:0] == 2'b0) ? 4'd1 : 4'd0 } ;

  // register rg_dbg_addr
  assign rg_dbg_addr$D_IN = backdoor_req_addr ;
  assign rg_dbg_addr$EN = EN_backdoor_req ;

  // register rg_dbg_f3
  assign rg_dbg_f3$D_IN = backdoor_req_f3 ;
  assign rg_dbg_f3$EN = EN_backdoor_req ;

  // register rg_dbg_rsp_err
  assign rg_dbg_rsp_err$D_IN =
	     EN_backdoor_req &&
	     NOT_backdoor_req_f3_BITS_1_TO_0_8_EQ_0b0_9_0_A_ETC___d109 ;
  assign rg_dbg_rsp_err$EN = EN_backdoor_req || WILL_FIRE_RL_rl_reset ;

  // register rg_dbg_rsp_valid
  assign rg_dbg_rsp_valid$D_IN = !MUX_rg_dbg_rsp_valid$write_1__SEL_1 ;
  assign rg_dbg_rsp_valid$EN =
	     EN_backdoor_rsp || WILL_FIRE_RL_rl_reset || EN_backdoor_req ;

  // register rg_dbg_wdata
  assign rg_dbg_wdata$D_IN = backdoor_req_wdata ;
  assign rg_dbg_wdata$EN = EN_backdoor_req ;

  // register rg_read_not_write
  assign rg_read_not_write$D_IN = backdoor_req_read ;
  assign rg_read_not_write$EN = EN_backdoor_req ;

  // register rg_rsp_exc
  assign rg_rsp_exc$D_IN =
	     WILL_FIRE_RL_rl_reset ? 5'd10 : MUX_rg_rsp_exc$write_1__VAL_2 ;
  assign rg_rsp_exc$EN = WILL_FIRE_RL_rl_reset || EN_imem_req ;

  // register rg_state
  assign rg_state$D_IN = !EN_server_reset_request_put ;
  assign rg_state$EN = EN_server_reset_request_put || WILL_FIRE_RL_rl_reset ;

  // submodule addr_map
  assign addr_map$m_is_dtcm_addr_addr = 32'h0 ;
  assign addr_map$m_is_itcm_addr_addr = imem_req_addr ;

  // submodule f_reset_rsps
  assign f_reset_rsps$ENQ = EN_server_reset_request_put ;
  assign f_reset_rsps$DEQ = EN_server_reset_response_get ;
  assign f_reset_rsps$CLR = 1'b0 ;

  // submodule mem
  assign mem$ADDRA = imem_req_addr[12:2] ;
  always@(EN_backdoor_req or
	  backdoor_req_addr or
	  WILL_FIRE_RL_rl_dbg_write_completion or
	  rg_dbg_addr or EN_dma_req or dma_req_addr)
  begin
    case (1'b1) // synopsys parallel_case
      EN_backdoor_req: mem$ADDRB = backdoor_req_addr[12:2];
      WILL_FIRE_RL_rl_dbg_write_completion: mem$ADDRB = rg_dbg_addr[12:2];
      EN_dma_req: mem$ADDRB = dma_req_addr[12:2];
      default: mem$ADDRB = 11'b01010101010 /* unspecified value */ ;
    endcase
  end
  assign mem$DIA = 32'hAAAAAAAA /* unspecified value */  ;
  always@(EN_backdoor_req or
	  WILL_FIRE_RL_rl_dbg_write_completion or
	  MUX_mem$b_put_3__VAL_2 or EN_dma_req or dma_req_wdata)
  begin
    case (1'b1) // synopsys parallel_case
      EN_backdoor_req: mem$DIB = 32'hAAAAAAAA /* unspecified value */ ;
      WILL_FIRE_RL_rl_dbg_write_completion: mem$DIB = MUX_mem$b_put_3__VAL_2;
      EN_dma_req: mem$DIB = dma_req_wdata;
      default: mem$DIB = 32'hAAAAAAAA /* unspecified value */ ;
    endcase
  end
  assign mem$WEA = 1'd0 ;
  assign mem$WEB = !EN_backdoor_req ;
  assign mem$ENA = EN_imem_req ;
  assign mem$ENB =
	     EN_backdoor_req || WILL_FIRE_RL_rl_dbg_write_completion ||
	     EN_dma_req ;

  // submodule rg_rsp_valid
  assign rg_rsp_valid$ENQ = EN_imem_req ;
  assign rg_rsp_valid$DEQ = EN_imem_instr ;
  assign rg_rsp_valid$CLR = CAN_FIRE_RL_rl_reset ;

  // remaining internal signals
  assign NOT_backdoor_req_f3_BITS_1_TO_0_8_EQ_0b0_9_0_A_ETC___d109 =
	     backdoor_req_f3[1:0] != 2'b0 &&
	     (backdoor_req_f3[1:0] != 2'b01 || backdoor_req_addr[0]) &&
	     (backdoor_req_f3[1:0] != 2'b10 ||
	      backdoor_req_addr[1:0] != 2'b0) &&
	     (backdoor_req_f3[1:0] != 2'b11 ||
	      backdoor_req_addr[2:0] != 3'b0) ;
  assign NOT_verbosity_ULE_1_0___d71 = verbosity > 2'd1 ;
  assign memDOB_BITS_15_TO_0__q2 = mem$DOB[15:0] ;
  assign memDOB_BITS_15_TO_8__q3 = mem$DOB[15:8] ;
  assign memDOB_BITS_23_TO_16__q4 = mem$DOB[23:16] ;
  assign memDOB_BITS_31_TO_16__q5 = mem$DOB[31:16] ;
  assign memDOB_BITS_31_TO_24__q6 = mem$DOB[31:24] ;
  assign memDOB_BITS_7_TO_0__q1 = mem$DOB[7:0] ;
  assign result__h3180 =
	     { {24{memDOB_BITS_7_TO_0__q1[7]}}, memDOB_BITS_7_TO_0__q1 } ;
  assign result__h3208 =
	     { {24{memDOB_BITS_15_TO_8__q3[7]}}, memDOB_BITS_15_TO_8__q3 } ;
  assign result__h3236 =
	     { {24{memDOB_BITS_23_TO_16__q4[7]}}, memDOB_BITS_23_TO_16__q4 } ;
  assign result__h3264 =
	     { {24{memDOB_BITS_31_TO_24__q6[7]}}, memDOB_BITS_31_TO_24__q6 } ;
  assign result__h3305 = { 24'd0, mem$DOB[7:0] } ;
  assign result__h3333 = { 24'd0, mem$DOB[15:8] } ;
  assign result__h3361 = { 24'd0, mem$DOB[23:16] } ;
  assign result__h3389 = { 24'd0, mem$DOB[31:24] } ;
  assign result__h3430 =
	     { {16{memDOB_BITS_15_TO_0__q2[15]}}, memDOB_BITS_15_TO_0__q2 } ;
  assign result__h3458 =
	     { {16{memDOB_BITS_31_TO_16__q5[15]}},
	       memDOB_BITS_31_TO_16__q5 } ;
  assign result__h3497 = { 16'd0, mem$DOB[15:0] } ;
  assign result__h3525 = { 16'd0, mem$DOB[31:16] } ;
  always@(rg_dbg_addr or mem$DOB or rg_dbg_wdata)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37 =
	      { mem$DOB[31:8], rg_dbg_wdata[7:0] };
      2'h1:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37 =
	      { mem$DOB[31:16], rg_dbg_wdata[7:0], mem$DOB[7:0] };
      2'h2:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37 =
	      { mem$DOB[31:24], rg_dbg_wdata[7:0], mem$DOB[15:0] };
      2'h3:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_m_ETC___d37 =
	      { rg_dbg_wdata[7:0], mem$DOB[23:0] };
    endcase
  end
  always@(rg_dbg_addr or
	  result__h3180 or result__h3208 or result__h3236 or result__h3264)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131 =
	      result__h3180;
      2'h1:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131 =
	      result__h3208;
      2'h2:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131 =
	      result__h3236;
      2'h3:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131 =
	      result__h3264;
    endcase
  end
  always@(rg_dbg_addr or
	  result__h3305 or result__h3333 or result__h3361 or result__h3389)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140 =
	      result__h3305;
      2'h1:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140 =
	      result__h3333;
      2'h2:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140 =
	      result__h3361;
      2'h3:
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140 =
	      result__h3389;
    endcase
  end
  always@(rg_dbg_addr or result__h3430 or result__h3458)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7 =
	      result__h3430;
      2'h2:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7 =
	      result__h3458;
      default: CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7 = 32'd0;
    endcase
  end
  always@(rg_dbg_addr or result__h3497 or result__h3525)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8 =
	      result__h3497;
      2'h2:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8 =
	      result__h3525;
      default: CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8 = 32'd0;
    endcase
  end
  always@(rg_dbg_f3 or
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131 or
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7 or
	  mem$DOB or
	  IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140 or
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8)
  begin
    case (rg_dbg_f3)
      3'b0:
	  ram_out__h2997 =
	      IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_S_ETC___d131;
      3'b001:
	  ram_out__h2997 =
	      CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result430_0x2_ETC__q7;
      3'b010, 3'b011, 3'b110: ram_out__h2997 = mem$DOB;
      3'b100:
	  ram_out__h2997 =
	      IF_rg_dbg_addr_1_BITS_1_TO_0_6_EQ_0x0_7_THEN_0_ETC___d140;
      3'b101:
	  ram_out__h2997 =
	      CASE_rg_dbg_addr_BITS_1_TO_0_0x0_result497_0x2_ETC__q8;
      3'd7: ram_out__h2997 = 32'd0;
    endcase
  end
  always@(rg_dbg_addr or mem$DOB or rg_dbg_wdata)
  begin
    case (rg_dbg_addr[1:0])
      2'h0:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9 =
	      { mem$DOB[31:16], rg_dbg_wdata[15:0] };
      2'h2:
	  CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9 =
	      { rg_dbg_wdata[15:0], mem$DOB[15:0] };
      default: CASE_rg_dbg_addr_BITS_1_TO_0_0x0_memDOB_BITS__ETC__q9 =
		   mem$DOB;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_dbg_rsp_err <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_dbg_rsp_valid <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_rsp_exc <= `BSV_ASSIGNMENT_DELAY 5'd10;
	rg_state <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (rg_dbg_rsp_err$EN)
	  rg_dbg_rsp_err <= `BSV_ASSIGNMENT_DELAY rg_dbg_rsp_err$D_IN;
	if (rg_dbg_rsp_valid$EN)
	  rg_dbg_rsp_valid <= `BSV_ASSIGNMENT_DELAY rg_dbg_rsp_valid$D_IN;
	if (rg_rsp_exc$EN)
	  rg_rsp_exc <= `BSV_ASSIGNMENT_DELAY rg_rsp_exc$D_IN;
	if (rg_state$EN) rg_state <= `BSV_ASSIGNMENT_DELAY rg_state$D_IN;
      end
    if (rg_dbg_addr$EN) rg_dbg_addr <= `BSV_ASSIGNMENT_DELAY rg_dbg_addr$D_IN;
    if (rg_dbg_f3$EN) rg_dbg_f3 <= `BSV_ASSIGNMENT_DELAY rg_dbg_f3$D_IN;
    if (rg_dbg_wdata$EN)
      rg_dbg_wdata <= `BSV_ASSIGNMENT_DELAY rg_dbg_wdata$D_IN;
    if (rg_read_not_write$EN)
      rg_read_not_write <= `BSV_ASSIGNMENT_DELAY rg_read_not_write$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_dbg_addr = 32'hAAAAAAAA;
    rg_dbg_f3 = 3'h2;
    rg_dbg_rsp_err = 1'h0;
    rg_dbg_rsp_valid = 1'h0;
    rg_dbg_wdata = 32'hAAAAAAAA;
    rg_read_not_write = 1'h0;
    rg_rsp_exc = 5'h0A;
    rg_state = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0)
	begin
	  v__h2159 = $stime;
	  #0;
	end
    v__h2153 = v__h2159 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0)
	$display("%06d:[D]:%m.imem.instr", v__h2153);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71)
	$write("           (instr 0x%08h) (exc ", mem$DOA);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71 &&
	  rg_rsp_exc[4])
	$write("tagged Valid ", "'h%h", rg_rsp_exc[3:0]);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71 &&
	  !rg_rsp_exc[4])
	$write("tagged Invalid ", "");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_instr && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71)
	$write(")", "\n");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && imem_req_addr[1:0] == 2'b0 &&
	  !addr_map$m_is_itcm_addr)
	begin
	  v__h1821 = $stime;
	  #0;
	end
    v__h1815 = v__h1821 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && imem_req_addr[1:0] == 2'b0 &&
	  !addr_map$m_is_itcm_addr)
	$display("%06d:[E]:%m.req: INSTR_ACCESS_FAULT", v__h1815);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && imem_req_addr[1:0] != 2'b0)
	begin
	  v__h1735 = $stime;
	  #0;
	end
    v__h1729 = v__h1735 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && imem_req_addr[1:0] != 2'b0)
	$display("%06d:[E]:%m.req: INSTR_ADDR_MISALIGNED", v__h1729);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && verbosity != 2'd0)
	begin
	  v__h2005 = $stime;
	  #0;
	end
    v__h1999 = v__h2005 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && verbosity != 2'd0)
	$display("%06d:[D]:%m.imem.req", v__h1999);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_imem_req && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71)
	$display("           (addr 0x%08h)", imem_req_addr);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71)
	begin
	  v__h2775 = $stime;
	  #0;
	end
    v__h2769 = v__h2775 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71)
	$display("%06d:[D]:%m.backdoor.req", v__h2769);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71)
	$write("           (addr 0x%08h) (wdata 0x%08h) (f3 0x%03b) (read ",
	       backdoor_req_addr,
	       backdoor_req_wdata,
	       backdoor_req_f3);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71 && backdoor_req_read)
	$write("True");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71 &&
	  !backdoor_req_read)
	$write("False");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71) $write(")", "\n");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71 &&
	  NOT_backdoor_req_f3_BITS_1_TO_0_8_EQ_0b0_9_0_A_ETC___d109)
	begin
	  v__h2914 = $stime;
	  #0;
	end
    v__h2908 = v__h2914 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_req && NOT_verbosity_ULE_1_0___d71 &&
	  NOT_backdoor_req_f3_BITS_1_TO_0_8_EQ_0b0_9_0_A_ETC___d109)
	$display("%06d:[E]:%m.backdoor.req: ADDR_MISALIGNED", v__h2908);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_dma_req && NOT_verbosity_ULE_1_0___d71)
	begin
	  v__h3698 = $stime;
	  #0;
	end
    v__h3692 = v__h3698 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_dma_req && NOT_verbosity_ULE_1_0___d71)
	$display("%06d:[D]:%m.backdoor.req", v__h3692);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_dma_req && NOT_verbosity_ULE_1_0___d71 && verbosity == 2'd3)
	$display("           (addr 0x%08h) (wdata 0x%08h)",
		 dma_req_addr,
		 dma_req_wdata);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0)
	begin
	  v__h3047 = $stime;
	  #0;
	end
    v__h3041 = v__h3047 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0)
	$display("%06d:[D]:%m.backdoor.rsp", v__h3041);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71)
	$write("           (ram_out 0x%08h) (err ", ram_out__h2997);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0 &&
	  NOT_verbosity_ULE_1_0___d71 &&
	  rg_dbg_rsp_err)
	$write("True");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0 &&
	  NOT_verbosity_ULE_1_0___d71 &&
	  !rg_dbg_rsp_err)
	$write("False");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_backdoor_rsp && verbosity != 2'd0 && NOT_verbosity_ULE_1_0___d71)
	$write(")", "\n");
  end
  // synopsys translate_on
endmodule  // mkITCM

