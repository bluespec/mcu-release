//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// RDY_server_reset_request_put   O     1 reg
// RDY_server_reset_response_get  O     1
// RDY_dmem_req                   O     1
// dmem_word32_get                O    32 reg
// RDY_dmem_word32_get            O     1
// dmem_exc_get                   O     5 reg
// RDY_dmem_exc_get               O     1
// mem_master_HADDR               O    32 reg
// mem_master_HBURST              O     3 const
// mem_master_HMASTLOCK           O     1 const
// mem_master_HPROT               O     4 const
// mem_master_HSIZE               O     3 reg
// mem_master_HTRANS              O     2 reg
// mem_master_HWDATA              O    32 reg
// mem_master_HWRITE              O     1 reg
// RDY_dma_req                    O     1 reg
// verbosity                      I     2
// CLK                            I     1 clock
// RST_N                          I     1 reset
// dmem_req_op                    I     1
// dmem_req_f3                    I     3
// dmem_req_addr                  I    32
// dmem_req_store_value           I    32 reg
// mem_master_HRDATA              I    32 reg
// mem_master_HREADY              I     1
// mem_master_HRESP               I     1
// dma_req_addr                   I    32 reg
// dma_req_wdata                  I    32 reg
// EN_server_reset_request_put    I     1
// EN_server_reset_response_get   I     1
// EN_dmem_req                    I     1
// EN_dma_req                     I     1
// EN_dmem_word32_get             I     1
// EN_dmem_exc_get                I     1
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

module mkDTCM(verbosity,
	      CLK,
	      RST_N,

	      EN_server_reset_request_put,
	      RDY_server_reset_request_put,

	      EN_server_reset_response_get,
	      RDY_server_reset_response_get,

	      dmem_req_op,
	      dmem_req_f3,
	      dmem_req_addr,
	      dmem_req_store_value,
	      EN_dmem_req,
	      RDY_dmem_req,

	      EN_dmem_word32_get,
	      dmem_word32_get,
	      RDY_dmem_word32_get,

	      EN_dmem_exc_get,
	      dmem_exc_get,
	      RDY_dmem_exc_get,

	      mem_master_HADDR,

	      mem_master_HBURST,

	      mem_master_HMASTLOCK,

	      mem_master_HPROT,

	      mem_master_HSIZE,

	      mem_master_HTRANS,

	      mem_master_HWDATA,

	      mem_master_HWRITE,

	      mem_master_HRDATA,

	      mem_master_HREADY,

	      mem_master_HRESP,

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

  // action method dmem_req
  input  dmem_req_op;
  input  [2 : 0] dmem_req_f3;
  input  [31 : 0] dmem_req_addr;
  input  [31 : 0] dmem_req_store_value;
  input  EN_dmem_req;
  output RDY_dmem_req;

  // actionvalue method dmem_word32_get
  input  EN_dmem_word32_get;
  output [31 : 0] dmem_word32_get;
  output RDY_dmem_word32_get;

  // actionvalue method dmem_exc_get
  input  EN_dmem_exc_get;
  output [4 : 0] dmem_exc_get;
  output RDY_dmem_exc_get;

  // value method mem_master_haddr
  output [31 : 0] mem_master_HADDR;

  // value method mem_master_hburst
  output [2 : 0] mem_master_HBURST;

  // value method mem_master_hmastlock
  output mem_master_HMASTLOCK;

  // value method mem_master_hprot
  output [3 : 0] mem_master_HPROT;

  // value method mem_master_hsize
  output [2 : 0] mem_master_HSIZE;

  // value method mem_master_htrans
  output [1 : 0] mem_master_HTRANS;

  // value method mem_master_hwdata
  output [31 : 0] mem_master_HWDATA;

  // value method mem_master_hwrite
  output mem_master_HWRITE;

  // action method mem_master_hrdata
  input  [31 : 0] mem_master_HRDATA;

  // action method mem_master_hready
  input  mem_master_HREADY;

  // action method mem_master_hresp
  input  mem_master_HRESP;

  // action method dma_req
  input  [31 : 0] dma_req_addr;
  input  [31 : 0] dma_req_wdata;
  input  EN_dma_req;
  output RDY_dma_req;

  // signals for module outputs
  wire [31 : 0] dmem_word32_get, mem_master_HADDR, mem_master_HWDATA;
  wire [4 : 0] dmem_exc_get;
  wire [3 : 0] mem_master_HPROT;
  wire [2 : 0] mem_master_HBURST, mem_master_HSIZE;
  wire [1 : 0] mem_master_HTRANS;
  wire RDY_dma_req,
       RDY_dmem_exc_get,
       RDY_dmem_req,
       RDY_dmem_word32_get,
       RDY_server_reset_request_put,
       RDY_server_reset_response_get,
       mem_master_HMASTLOCK,
       mem_master_HWRITE;

  // register fabric_adapter_rg_haddr
  reg [31 : 0] fabric_adapter_rg_haddr;
  wire [31 : 0] fabric_adapter_rg_haddr$D_IN;
  wire fabric_adapter_rg_haddr$EN;

  // register fabric_adapter_rg_hsize
  reg [2 : 0] fabric_adapter_rg_hsize;
  wire [2 : 0] fabric_adapter_rg_hsize$D_IN;
  wire fabric_adapter_rg_hsize$EN;

  // register fabric_adapter_rg_htrans
  reg [1 : 0] fabric_adapter_rg_htrans;
  wire [1 : 0] fabric_adapter_rg_htrans$D_IN;
  wire fabric_adapter_rg_htrans$EN;

  // register fabric_adapter_rg_hwdata
  reg [31 : 0] fabric_adapter_rg_hwdata;
  wire [31 : 0] fabric_adapter_rg_hwdata$D_IN;
  wire fabric_adapter_rg_hwdata$EN;

  // register fabric_adapter_rg_hwrite
  reg fabric_adapter_rg_hwrite;
  wire fabric_adapter_rg_hwrite$D_IN, fabric_adapter_rg_hwrite$EN;

  // register fabric_adapter_rg_state
  reg [1 : 0] fabric_adapter_rg_state;
  reg [1 : 0] fabric_adapter_rg_state$D_IN;
  wire fabric_adapter_rg_state$EN;

  // register mmio_rg_fsm_state
  reg [1 : 0] mmio_rg_fsm_state;
  reg [1 : 0] mmio_rg_fsm_state$D_IN;
  wire mmio_rg_fsm_state$EN;

  // register rg_exc
  reg [4 : 0] rg_exc;
  wire [4 : 0] rg_exc$D_IN;
  wire rg_exc$EN;

  // register rg_rsp_from_mmio
  reg rg_rsp_from_mmio;
  wire rg_rsp_from_mmio$D_IN, rg_rsp_from_mmio$EN;

  // register rg_state
  reg rg_state;
  wire rg_state$D_IN, rg_state$EN;

  // ports of submodule addr_map
  wire [31 : 0] addr_map$m_is_dtcm_addr_addr, addr_map$m_is_itcm_addr_addr;
  wire addr_map$m_is_dtcm_addr;

  // ports of submodule f_mem_rdata
  wire [32 : 0] f_mem_rdata$D_IN, f_mem_rdata$D_OUT;
  wire f_mem_rdata$CLR,
       f_mem_rdata$DEQ,
       f_mem_rdata$EMPTY_N,
       f_mem_rdata$ENQ,
       f_mem_rdata$FULL_N;

  // ports of submodule f_mem_req
  wire [34 : 0] f_mem_req$D_IN, f_mem_req$D_OUT;
  wire f_mem_req$CLR,
       f_mem_req$DEQ,
       f_mem_req$EMPTY_N,
       f_mem_req$ENQ,
       f_mem_req$FULL_N;

  // ports of submodule f_mem_wdata
  wire [31 : 0] f_mem_wdata$D_IN, f_mem_wdata$D_OUT;
  wire f_mem_wdata$CLR,
       f_mem_wdata$DEQ,
       f_mem_wdata$EMPTY_N,
       f_mem_wdata$ENQ,
       f_mem_wdata$FULL_N;

  // ports of submodule f_req
  wire [67 : 0] f_req$D_IN, f_req$D_OUT;
  wire f_req$CLR, f_req$DEQ, f_req$EMPTY_N, f_req$ENQ, f_req$FULL_N;

  // ports of submodule f_reset_rsps
  wire f_reset_rsps$CLR,
       f_reset_rsps$DEQ,
       f_reset_rsps$EMPTY_N,
       f_reset_rsps$ENQ,
       f_reset_rsps$FULL_N;

  // ports of submodule f_rsp_exc
  reg [4 : 0] f_rsp_exc$D_IN;
  wire [4 : 0] f_rsp_exc$D_OUT;
  wire f_rsp_exc$CLR,
       f_rsp_exc$DEQ,
       f_rsp_exc$EMPTY_N,
       f_rsp_exc$ENQ,
       f_rsp_exc$FULL_N;

  // ports of submodule f_rsp_word32
  reg [31 : 0] f_rsp_word32$D_IN;
  wire [31 : 0] f_rsp_word32$D_OUT;
  wire f_rsp_word32$CLR,
       f_rsp_word32$DEQ,
       f_rsp_word32$EMPTY_N,
       f_rsp_word32$ENQ,
       f_rsp_word32$FULL_N;

  // ports of submodule mem
  wire [31 : 0] mem$DIA, mem$DIB, mem$DOA;
  wire [10 : 0] mem$ADDRA, mem$ADDRB;
  wire [3 : 0] mem$WEA, mem$WEB;
  wire mem$ENA, mem$ENB;

  // rule scheduling signals
  wire CAN_FIRE_RL_fabric_adapter_rl_complete_nseq_req,
       CAN_FIRE_RL_fabric_adapter_rl_nseq_req,
       CAN_FIRE_RL_fabric_adapter_rl_read_response,
       CAN_FIRE_RL_fabric_adapter_rl_write_response,
       CAN_FIRE_RL_mmio_rl_read_req,
       CAN_FIRE_RL_mmio_rl_read_rsp,
       CAN_FIRE_RL_mmio_rl_write_req,
       CAN_FIRE_RL_rl_reset,
       CAN_FIRE_RL_rl_tcm_rsp,
       CAN_FIRE_dma_req,
       CAN_FIRE_dmem_exc_get,
       CAN_FIRE_dmem_req,
       CAN_FIRE_dmem_word32_get,
       CAN_FIRE_mem_master_hrdata,
       CAN_FIRE_mem_master_hready,
       CAN_FIRE_mem_master_hresp,
       CAN_FIRE_server_reset_request_put,
       CAN_FIRE_server_reset_response_get,
       WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req,
       WILL_FIRE_RL_fabric_adapter_rl_nseq_req,
       WILL_FIRE_RL_fabric_adapter_rl_read_response,
       WILL_FIRE_RL_fabric_adapter_rl_write_response,
       WILL_FIRE_RL_mmio_rl_read_req,
       WILL_FIRE_RL_mmio_rl_read_rsp,
       WILL_FIRE_RL_mmio_rl_write_req,
       WILL_FIRE_RL_rl_reset,
       WILL_FIRE_RL_rl_tcm_rsp,
       WILL_FIRE_dma_req,
       WILL_FIRE_dmem_exc_get,
       WILL_FIRE_dmem_req,
       WILL_FIRE_dmem_word32_get,
       WILL_FIRE_mem_master_hrdata,
       WILL_FIRE_mem_master_hready,
       WILL_FIRE_mem_master_hresp,
       WILL_FIRE_server_reset_request_put,
       WILL_FIRE_server_reset_response_get;

  // inputs to muxes for submodule ports
  wire [34 : 0] MUX_f_mem_req$enq_1__VAL_1, MUX_f_mem_req$enq_1__VAL_2;
  wire [31 : 0] MUX_f_rsp_word32$enq_1__VAL_1;
  wire [4 : 0] MUX_f_rsp_exc$enq_1__VAL_3, MUX_rg_exc$write_1__VAL_2;
  wire [1 : 0] MUX_fabric_adapter_rg_state$write_1__VAL_4;
  wire MUX_mem$a_put_1__SEL_1,
       MUX_mmio_rg_fsm_state$write_1__SEL_2,
       MUX_rg_rsp_from_mmio$write_1__VAL_1;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h5848;
  reg [31 : 0] v__h3642;
  reg [31 : 0] v__h4983;
  reg [31 : 0] v__h3636;
  reg [31 : 0] v__h4977;
  reg [31 : 0] v__h5842;
  // synopsys translate_on

  // remaining internal signals
  reg [31 : 0] CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7,
	       CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8,
	       IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170,
	       IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179,
	       _theResult___snd__h3950,
	       mask__h1506,
	       ram_out__h3501,
	       ram_st_value__h3731,
	       y__h1733;
  reg [3 : 0] _theResult___fst__h3949,
	      _theResult___fst__h3982,
	      byte_en__h3730;
  reg CASE_f_reqD_OUT_BITS_65_TO_64_0b0_ld_val_bits_ETC__q9;
  wire [31 : 0] _theResult___snd__h3954,
		_theResult___snd__h3958,
		_theResult___snd__h3983,
		_theResult___snd__h3987,
		data1__h1462,
		data__h1974,
		ld_val_bits__h1331,
		result__h1721,
		result__h1788,
		result__h4528,
		result__h4557,
		result__h4585,
		result__h4613,
		result__h4654,
		result__h4682,
		result__h4710,
		result__h4738,
		result__h4779,
		result__h4807,
		result__h4846,
		result__h4874;
  wire [15 : 0] memDOA_BITS_15_TO_0__q2, memDOA_BITS_31_TO_16__q5;
  wire [7 : 0] memDOA_BITS_15_TO_8__q4,
	       memDOA_BITS_23_TO_16__q3,
	       memDOA_BITS_31_TO_24__q6,
	       memDOA_BITS_7_TO_0__q1;
  wire [4 : 0] shamt_bits__h1984;
  wire NOT_verbosity_ULE_1_47___d248,
       dmem_req_f3_BITS_1_TO_0_08_EQ_0b0_09_OR_dmem_r_ETC___d238;

  // action method server_reset_request_put
  assign RDY_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign CAN_FIRE_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign WILL_FIRE_server_reset_request_put = EN_server_reset_request_put ;

  // action method server_reset_response_get
  assign RDY_server_reset_response_get = rg_state && f_reset_rsps$EMPTY_N ;
  assign CAN_FIRE_server_reset_response_get =
	     rg_state && f_reset_rsps$EMPTY_N ;
  assign WILL_FIRE_server_reset_response_get = EN_server_reset_response_get ;

  // action method dmem_req
  assign RDY_dmem_req = rg_state && f_req$FULL_N ;
  assign CAN_FIRE_dmem_req = rg_state && f_req$FULL_N ;
  assign WILL_FIRE_dmem_req = EN_dmem_req ;

  // actionvalue method dmem_word32_get
  assign dmem_word32_get = f_rsp_word32$D_OUT ;
  assign RDY_dmem_word32_get = rg_state && f_rsp_word32$EMPTY_N ;
  assign CAN_FIRE_dmem_word32_get = rg_state && f_rsp_word32$EMPTY_N ;
  assign WILL_FIRE_dmem_word32_get = EN_dmem_word32_get ;

  // actionvalue method dmem_exc_get
  assign dmem_exc_get = f_rsp_exc$D_OUT ;
  assign RDY_dmem_exc_get = rg_state && f_rsp_exc$EMPTY_N ;
  assign CAN_FIRE_dmem_exc_get = rg_state && f_rsp_exc$EMPTY_N ;
  assign WILL_FIRE_dmem_exc_get = EN_dmem_exc_get ;

  // value method mem_master_haddr
  assign mem_master_HADDR = fabric_adapter_rg_haddr ;

  // value method mem_master_hburst
  assign mem_master_HBURST = 3'd1 ;

  // value method mem_master_hmastlock
  assign mem_master_HMASTLOCK = 1'd0 ;

  // value method mem_master_hprot
  assign mem_master_HPROT = 4'd12 ;

  // value method mem_master_hsize
  assign mem_master_HSIZE = fabric_adapter_rg_hsize ;

  // value method mem_master_htrans
  assign mem_master_HTRANS = fabric_adapter_rg_htrans ;

  // value method mem_master_hwdata
  assign mem_master_HWDATA = fabric_adapter_rg_hwdata ;

  // value method mem_master_hwrite
  assign mem_master_HWRITE = fabric_adapter_rg_hwrite ;

  // action method mem_master_hrdata
  assign CAN_FIRE_mem_master_hrdata = 1'd1 ;
  assign WILL_FIRE_mem_master_hrdata = 1'd1 ;

  // action method mem_master_hready
  assign CAN_FIRE_mem_master_hready = 1'd1 ;
  assign WILL_FIRE_mem_master_hready = 1'd1 ;

  // action method mem_master_hresp
  assign CAN_FIRE_mem_master_hresp = 1'd1 ;
  assign WILL_FIRE_mem_master_hresp = 1'd1 ;

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
		      .m_is_itcm_addr(),
		      .m_dtcm_addr_base(),
		      .m_dtcm_addr_size(),
		      .m_dtcm_addr_lim(),
		      .m_is_dtcm_addr(addr_map$m_is_dtcm_addr),
		      .m_pc_reset_value(),
		      .m_mtvec_reset_value());

  // submodule f_mem_rdata
  FIFO1 #(.width(32'd33), .guarded(1'd1)) f_mem_rdata(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(f_mem_rdata$D_IN),
						      .ENQ(f_mem_rdata$ENQ),
						      .DEQ(f_mem_rdata$DEQ),
						      .CLR(f_mem_rdata$CLR),
						      .D_OUT(f_mem_rdata$D_OUT),
						      .FULL_N(f_mem_rdata$FULL_N),
						      .EMPTY_N(f_mem_rdata$EMPTY_N));

  // submodule f_mem_req
  FIFO1 #(.width(32'd35), .guarded(1'd1)) f_mem_req(.RST(RST_N),
						    .CLK(CLK),
						    .D_IN(f_mem_req$D_IN),
						    .ENQ(f_mem_req$ENQ),
						    .DEQ(f_mem_req$DEQ),
						    .CLR(f_mem_req$CLR),
						    .D_OUT(f_mem_req$D_OUT),
						    .FULL_N(f_mem_req$FULL_N),
						    .EMPTY_N(f_mem_req$EMPTY_N));

  // submodule f_mem_wdata
  FIFO1 #(.width(32'd32), .guarded(1'd1)) f_mem_wdata(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(f_mem_wdata$D_IN),
						      .ENQ(f_mem_wdata$ENQ),
						      .DEQ(f_mem_wdata$DEQ),
						      .CLR(f_mem_wdata$CLR),
						      .D_OUT(f_mem_wdata$D_OUT),
						      .FULL_N(f_mem_wdata$FULL_N),
						      .EMPTY_N(f_mem_wdata$EMPTY_N));

  // submodule f_req
  FIFO1 #(.width(32'd68), .guarded(1'd1)) f_req(.RST(RST_N),
						.CLK(CLK),
						.D_IN(f_req$D_IN),
						.ENQ(f_req$ENQ),
						.DEQ(f_req$DEQ),
						.CLR(f_req$CLR),
						.D_OUT(f_req$D_OUT),
						.FULL_N(f_req$FULL_N),
						.EMPTY_N(f_req$EMPTY_N));

  // submodule f_reset_rsps
  FIFO10 #(.guarded(1'd1)) f_reset_rsps(.RST(RST_N),
					.CLK(CLK),
					.ENQ(f_reset_rsps$ENQ),
					.DEQ(f_reset_rsps$DEQ),
					.CLR(f_reset_rsps$CLR),
					.FULL_N(f_reset_rsps$FULL_N),
					.EMPTY_N(f_reset_rsps$EMPTY_N));

  // submodule f_rsp_exc
  FIFO1 #(.width(32'd5), .guarded(1'd1)) f_rsp_exc(.RST(RST_N),
						   .CLK(CLK),
						   .D_IN(f_rsp_exc$D_IN),
						   .ENQ(f_rsp_exc$ENQ),
						   .DEQ(f_rsp_exc$DEQ),
						   .CLR(f_rsp_exc$CLR),
						   .D_OUT(f_rsp_exc$D_OUT),
						   .FULL_N(f_rsp_exc$FULL_N),
						   .EMPTY_N(f_rsp_exc$EMPTY_N));

  // submodule f_rsp_word32
  FIFO1 #(.width(32'd32), .guarded(1'd1)) f_rsp_word32(.RST(RST_N),
						       .CLK(CLK),
						       .D_IN(f_rsp_word32$D_IN),
						       .ENQ(f_rsp_word32$ENQ),
						       .DEQ(f_rsp_word32$DEQ),
						       .CLR(f_rsp_word32$CLR),
						       .D_OUT(f_rsp_word32$D_OUT),
						       .FULL_N(f_rsp_word32$FULL_N),
						       .EMPTY_N(f_rsp_word32$EMPTY_N));

  // submodule mem
  BRAM2BE #(.PIPELINED(1'd0),
	    .ADDR_WIDTH(32'd11),
	    .DATA_WIDTH(32'd32),
	    .CHUNKSIZE(32'd8),
	    .WE_WIDTH(32'd4),
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
				    .DOB());

  // rule RL_mmio_rl_read_req
  assign CAN_FIRE_RL_mmio_rl_read_req =
	     f_req$EMPTY_N && f_mem_req$FULL_N && mmio_rg_fsm_state == 2'd1 &&
	     !f_req$D_OUT[67] ;
  assign WILL_FIRE_RL_mmio_rl_read_req = CAN_FIRE_RL_mmio_rl_read_req ;

  // rule RL_rl_tcm_rsp
  assign CAN_FIRE_RL_rl_tcm_rsp =
	     f_req$EMPTY_N && f_rsp_word32$FULL_N && f_rsp_exc$FULL_N &&
	     !rg_rsp_from_mmio ;
  assign WILL_FIRE_RL_rl_tcm_rsp = CAN_FIRE_RL_rl_tcm_rsp && !EN_dmem_req ;

  // rule RL_mmio_rl_read_rsp
  assign CAN_FIRE_RL_mmio_rl_read_rsp =
	     f_req$EMPTY_N && f_mem_rdata$EMPTY_N && f_rsp_word32$FULL_N &&
	     f_rsp_exc$FULL_N &&
	     mmio_rg_fsm_state == 2'd2 &&
	     rg_rsp_from_mmio ;
  assign WILL_FIRE_RL_mmio_rl_read_rsp = CAN_FIRE_RL_mmio_rl_read_rsp ;

  // rule RL_fabric_adapter_rl_nseq_req
  assign CAN_FIRE_RL_fabric_adapter_rl_nseq_req =
	     f_mem_req$EMPTY_N && mem_master_HREADY &&
	     (f_mem_req$D_OUT[34] || f_mem_wdata$EMPTY_N) &&
	     fabric_adapter_rg_state == 2'd0 ;
  assign WILL_FIRE_RL_fabric_adapter_rl_nseq_req =
	     CAN_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // rule RL_fabric_adapter_rl_complete_nseq_req
  assign CAN_FIRE_RL_fabric_adapter_rl_complete_nseq_req =
	     f_mem_req$EMPTY_N && mem_master_HREADY &&
	     fabric_adapter_rg_state == 2'd1 ;
  assign WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req =
	     CAN_FIRE_RL_fabric_adapter_rl_complete_nseq_req ;

  // rule RL_mmio_rl_write_req
  assign CAN_FIRE_RL_mmio_rl_write_req =
	     f_req$EMPTY_N && f_mem_req$FULL_N && f_rsp_word32$FULL_N &&
	     f_rsp_exc$FULL_N &&
	     f_mem_wdata$FULL_N &&
	     mmio_rg_fsm_state == 2'd1 &&
	     f_req$D_OUT[67] &&
	     rg_rsp_from_mmio ;
  assign WILL_FIRE_RL_mmio_rl_write_req = CAN_FIRE_RL_mmio_rl_write_req ;

  // rule RL_fabric_adapter_rl_read_response
  assign CAN_FIRE_RL_fabric_adapter_rl_read_response =
	     f_mem_req$EMPTY_N && f_mem_rdata$FULL_N && mem_master_HREADY &&
	     fabric_adapter_rg_state == 2'd3 ;
  assign WILL_FIRE_RL_fabric_adapter_rl_read_response =
	     CAN_FIRE_RL_fabric_adapter_rl_read_response ;

  // rule RL_fabric_adapter_rl_write_response
  assign CAN_FIRE_RL_fabric_adapter_rl_write_response =
	     f_mem_req$EMPTY_N && f_mem_wdata$EMPTY_N && mem_master_HREADY &&
	     fabric_adapter_rg_state == 2'd2 ;
  assign WILL_FIRE_RL_fabric_adapter_rl_write_response =
	     CAN_FIRE_RL_fabric_adapter_rl_write_response ;

  // rule RL_rl_reset
  assign CAN_FIRE_RL_rl_reset = !rg_state ;
  assign WILL_FIRE_RL_rl_reset = !rg_state ;

  // inputs to muxes for submodule ports
  assign MUX_mem$a_put_1__SEL_1 =
	     WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] ;
  assign MUX_mmio_rg_fsm_state$write_1__SEL_2 =
	     EN_dmem_req &&
	     dmem_req_f3_BITS_1_TO_0_08_EQ_0b0_09_OR_dmem_r_ETC___d238 &&
	     !addr_map$m_is_dtcm_addr ;
  assign MUX_f_mem_req$enq_1__VAL_1 =
	     { 1'd1, f_req$D_OUT[63:32], f_req$D_OUT[65:64] } ;
  assign MUX_f_mem_req$enq_1__VAL_2 =
	     { 1'd0, f_req$D_OUT[63:32], f_req$D_OUT[65:64] } ;
  assign MUX_f_rsp_exc$enq_1__VAL_3 =
	     { !f_mem_rdata$D_OUT[32], f_req$D_OUT[67] ? 4'd7 : 4'd5 } ;
  assign MUX_f_rsp_word32$enq_1__VAL_1 =
	     (!f_req$D_OUT[66] &&
	      CASE_f_reqD_OUT_BITS_65_TO_64_0b0_ld_val_bits_ETC__q9) ?
	       result__h1721 :
	       result__h1788 ;
  assign MUX_fabric_adapter_rg_state$write_1__VAL_4 =
	     f_mem_req$D_OUT[34] ? 2'd3 : 2'd2 ;
  assign MUX_rg_exc$write_1__VAL_2 =
	     { dmem_req_f3[1:0] != 2'b0 &&
	       (dmem_req_f3[1:0] != 2'b01 || dmem_req_addr[0]) &&
	       (dmem_req_f3[1:0] != 2'b10 || dmem_req_addr[1:0] != 2'b0) &&
	       (dmem_req_f3[1:0] != 2'b11 || dmem_req_addr[2:0] != 3'b0),
	       dmem_req_op ? 4'd6 : 4'd4 } ;
  assign MUX_rg_rsp_from_mmio$write_1__VAL_1 =
	     dmem_req_f3_BITS_1_TO_0_08_EQ_0b0_09_OR_dmem_r_ETC___d238 &&
	     !addr_map$m_is_dtcm_addr ;

  // register fabric_adapter_rg_haddr
  assign fabric_adapter_rg_haddr$D_IN = f_mem_req$D_OUT[33:2] ;
  assign fabric_adapter_rg_haddr$EN = CAN_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // register fabric_adapter_rg_hsize
  assign fabric_adapter_rg_hsize$D_IN =
	     (f_mem_req$D_OUT[1:0] == 2'b11) ?
	       3'd2 :
	       { 1'b0, f_mem_req$D_OUT[1:0] } ;
  assign fabric_adapter_rg_hsize$EN = CAN_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // register fabric_adapter_rg_htrans
  assign fabric_adapter_rg_htrans$D_IN =
	     (WILL_FIRE_RL_rl_reset ||
	      WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req) ?
	       2'd0 :
	       2'd2 ;
  assign fabric_adapter_rg_htrans$EN =
	     WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req ||
	     WILL_FIRE_RL_rl_reset ||
	     WILL_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // register fabric_adapter_rg_hwdata
  assign fabric_adapter_rg_hwdata$D_IN = f_mem_wdata$D_OUT ;
  assign fabric_adapter_rg_hwdata$EN =
	     WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req &&
	     !f_mem_req$D_OUT[34] &&
	     f_mem_wdata$EMPTY_N ;

  // register fabric_adapter_rg_hwrite
  assign fabric_adapter_rg_hwrite$D_IN =
	     !f_mem_req$D_OUT[34] && f_mem_wdata$EMPTY_N ;
  assign fabric_adapter_rg_hwrite$EN =
	     CAN_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // register fabric_adapter_rg_state
  always@(WILL_FIRE_RL_rl_reset or
	  WILL_FIRE_RL_fabric_adapter_rl_write_response or
	  WILL_FIRE_RL_fabric_adapter_rl_read_response or
	  WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req or
	  MUX_fabric_adapter_rg_state$write_1__VAL_4 or
	  WILL_FIRE_RL_fabric_adapter_rl_nseq_req)
  case (1'b1)
    WILL_FIRE_RL_rl_reset || WILL_FIRE_RL_fabric_adapter_rl_write_response ||
    WILL_FIRE_RL_fabric_adapter_rl_read_response:
	fabric_adapter_rg_state$D_IN = 2'd0;
    WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req:
	fabric_adapter_rg_state$D_IN =
	    MUX_fabric_adapter_rg_state$write_1__VAL_4;
    WILL_FIRE_RL_fabric_adapter_rl_nseq_req:
	fabric_adapter_rg_state$D_IN = 2'd1;
    default: fabric_adapter_rg_state$D_IN = 2'b10 /* unspecified value */ ;
  endcase
  assign fabric_adapter_rg_state$EN =
	     WILL_FIRE_RL_fabric_adapter_rl_complete_nseq_req ||
	     WILL_FIRE_RL_fabric_adapter_rl_write_response ||
	     WILL_FIRE_RL_fabric_adapter_rl_read_response ||
	     WILL_FIRE_RL_rl_reset ||
	     WILL_FIRE_RL_fabric_adapter_rl_nseq_req ;

  // register mmio_rg_fsm_state
  always@(WILL_FIRE_RL_rl_reset or
	  MUX_mmio_rg_fsm_state$write_1__SEL_2 or
	  WILL_FIRE_RL_mmio_rl_write_req or
	  WILL_FIRE_RL_mmio_rl_read_rsp or WILL_FIRE_RL_mmio_rl_read_req)
  case (1'b1)
    WILL_FIRE_RL_rl_reset: mmio_rg_fsm_state$D_IN = 2'd0;
    MUX_mmio_rg_fsm_state$write_1__SEL_2: mmio_rg_fsm_state$D_IN = 2'd1;
    WILL_FIRE_RL_mmio_rl_write_req || WILL_FIRE_RL_mmio_rl_read_rsp:
	mmio_rg_fsm_state$D_IN = 2'd0;
    WILL_FIRE_RL_mmio_rl_read_req: mmio_rg_fsm_state$D_IN = 2'd2;
    default: mmio_rg_fsm_state$D_IN = 2'b10 /* unspecified value */ ;
  endcase
  assign mmio_rg_fsm_state$EN =
	     EN_dmem_req &&
	     dmem_req_f3_BITS_1_TO_0_08_EQ_0b0_09_OR_dmem_r_ETC___d238 &&
	     !addr_map$m_is_dtcm_addr ||
	     WILL_FIRE_RL_mmio_rl_write_req ||
	     WILL_FIRE_RL_mmio_rl_read_rsp ||
	     WILL_FIRE_RL_rl_reset ||
	     WILL_FIRE_RL_mmio_rl_read_req ;

  // register rg_exc
  assign rg_exc$D_IN =
	     WILL_FIRE_RL_rl_reset ? 5'd10 : MUX_rg_exc$write_1__VAL_2 ;
  assign rg_exc$EN = WILL_FIRE_RL_rl_reset || EN_dmem_req ;

  // register rg_rsp_from_mmio
  assign rg_rsp_from_mmio$D_IN =
	     EN_dmem_req && MUX_rg_rsp_from_mmio$write_1__VAL_1 ;
  assign rg_rsp_from_mmio$EN = EN_dmem_req || WILL_FIRE_RL_rl_reset ;

  // register rg_state
  assign rg_state$D_IN = !EN_server_reset_request_put ;
  assign rg_state$EN = EN_server_reset_request_put || WILL_FIRE_RL_rl_reset ;

  // submodule addr_map
  assign addr_map$m_is_dtcm_addr_addr = dmem_req_addr ;
  assign addr_map$m_is_itcm_addr_addr = 32'h0 ;

  // submodule f_mem_rdata
  assign f_mem_rdata$D_IN = { !mem_master_HRESP, mem_master_HRDATA } ;
  assign f_mem_rdata$ENQ = CAN_FIRE_RL_fabric_adapter_rl_read_response ;
  assign f_mem_rdata$DEQ = CAN_FIRE_RL_mmio_rl_read_rsp ;
  assign f_mem_rdata$CLR = !rg_state ;

  // submodule f_mem_req
  assign f_mem_req$D_IN =
	     WILL_FIRE_RL_mmio_rl_read_req ?
	       MUX_f_mem_req$enq_1__VAL_1 :
	       MUX_f_mem_req$enq_1__VAL_2 ;
  assign f_mem_req$ENQ =
	     WILL_FIRE_RL_mmio_rl_read_req || WILL_FIRE_RL_mmio_rl_write_req ;
  assign f_mem_req$DEQ =
	     WILL_FIRE_RL_fabric_adapter_rl_write_response ||
	     WILL_FIRE_RL_fabric_adapter_rl_read_response ;
  assign f_mem_req$CLR = !rg_state ;

  // submodule f_mem_wdata
  assign f_mem_wdata$D_IN = data__h1974 << shamt_bits__h1984 ;
  assign f_mem_wdata$ENQ = CAN_FIRE_RL_mmio_rl_write_req ;
  assign f_mem_wdata$DEQ = CAN_FIRE_RL_fabric_adapter_rl_write_response ;
  assign f_mem_wdata$CLR = !rg_state ;

  // submodule f_req
  assign f_req$D_IN =
	     { dmem_req_op,
	       dmem_req_f3,
	       dmem_req_addr,
	       dmem_req_store_value } ;
  assign f_req$ENQ = EN_dmem_req ;
  assign f_req$DEQ =
	     WILL_FIRE_RL_rl_tcm_rsp || WILL_FIRE_RL_mmio_rl_write_req ||
	     WILL_FIRE_RL_mmio_rl_read_rsp ;
  assign f_req$CLR = !rg_state ;

  // submodule f_reset_rsps
  assign f_reset_rsps$ENQ = EN_server_reset_request_put ;
  assign f_reset_rsps$DEQ = EN_server_reset_response_get ;
  assign f_reset_rsps$CLR = 1'b0 ;

  // submodule f_rsp_exc
  always@(WILL_FIRE_RL_rl_tcm_rsp or
	  rg_exc or
	  WILL_FIRE_RL_mmio_rl_write_req or
	  WILL_FIRE_RL_mmio_rl_read_rsp or MUX_f_rsp_exc$enq_1__VAL_3)
  begin
    case (1'b1) // synopsys parallel_case
      WILL_FIRE_RL_rl_tcm_rsp: f_rsp_exc$D_IN = rg_exc;
      WILL_FIRE_RL_mmio_rl_write_req: f_rsp_exc$D_IN = 5'd10;
      WILL_FIRE_RL_mmio_rl_read_rsp:
	  f_rsp_exc$D_IN = MUX_f_rsp_exc$enq_1__VAL_3;
      default: f_rsp_exc$D_IN = 5'b01010 /* unspecified value */ ;
    endcase
  end
  assign f_rsp_exc$ENQ =
	     WILL_FIRE_RL_rl_tcm_rsp || WILL_FIRE_RL_mmio_rl_write_req ||
	     WILL_FIRE_RL_mmio_rl_read_rsp ;
  assign f_rsp_exc$DEQ = EN_dmem_exc_get ;
  assign f_rsp_exc$CLR = !rg_state ;

  // submodule f_rsp_word32
  always@(WILL_FIRE_RL_mmio_rl_read_rsp or
	  MUX_f_rsp_word32$enq_1__VAL_1 or
	  WILL_FIRE_RL_mmio_rl_write_req or
	  f_req$D_OUT or WILL_FIRE_RL_rl_tcm_rsp or ram_out__h3501)
  begin
    case (1'b1) // synopsys parallel_case
      WILL_FIRE_RL_mmio_rl_read_rsp:
	  f_rsp_word32$D_IN = MUX_f_rsp_word32$enq_1__VAL_1;
      WILL_FIRE_RL_mmio_rl_write_req: f_rsp_word32$D_IN = f_req$D_OUT[31:0];
      WILL_FIRE_RL_rl_tcm_rsp: f_rsp_word32$D_IN = ram_out__h3501;
      default: f_rsp_word32$D_IN = 32'hAAAAAAAA /* unspecified value */ ;
    endcase
  end
  assign f_rsp_word32$ENQ =
	     WILL_FIRE_RL_mmio_rl_read_rsp ||
	     WILL_FIRE_RL_mmio_rl_write_req ||
	     WILL_FIRE_RL_rl_tcm_rsp ;
  assign f_rsp_word32$DEQ = EN_dmem_word32_get ;
  assign f_rsp_word32$CLR = !rg_state ;

  // submodule mem
  assign mem$ADDRA =
	     MUX_mem$a_put_1__SEL_1 ?
	       f_req$D_OUT[44:34] :
	       dmem_req_addr[12:2] ;
  assign mem$ADDRB = dma_req_addr[12:2] ;
  assign mem$DIA =
	     MUX_mem$a_put_1__SEL_1 ?
	       ram_st_value__h3731 :
	       32'hAAAAAAAA /* unspecified value */  ;
  assign mem$DIB = dma_req_wdata ;
  assign mem$WEA = MUX_mem$a_put_1__SEL_1 ? byte_en__h3730 : 4'd0 ;
  assign mem$WEB = 4'hF ;
  assign mem$ENA =
	     WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] ||
	     EN_dmem_req ;
  assign mem$ENB = EN_dma_req ;

  // remaining internal signals
  assign NOT_verbosity_ULE_1_47___d248 = verbosity > 2'd1 ;
  assign _theResult___snd__h3954 = { f_req$D_OUT[23:0], 8'hAA } ;
  assign _theResult___snd__h3958 = { f_req$D_OUT[7:0], 24'hAAAAAA } ;
  assign _theResult___snd__h3983 =
	     (f_req$D_OUT[33:32] == 2'h0) ?
	       f_req$D_OUT[31:0] :
	       _theResult___snd__h3987 ;
  assign _theResult___snd__h3987 = { f_req$D_OUT[15:0], 16'hAAAA } ;
  assign data1__h1462 = f_mem_rdata$D_OUT[31:0] >> shamt_bits__h1984 ;
  assign data__h1974 = f_req$D_OUT[31:0] & mask__h1506 ;
  assign dmem_req_f3_BITS_1_TO_0_08_EQ_0b0_09_OR_dmem_r_ETC___d238 =
	     dmem_req_f3[1:0] == 2'b0 ||
	     dmem_req_f3[1:0] == 2'b01 && !dmem_req_addr[0] ||
	     dmem_req_f3[1:0] == 2'b10 && dmem_req_addr[1:0] == 2'b0 ||
	     dmem_req_f3[1:0] == 2'b11 && dmem_req_addr[2:0] == 3'b0 ;
  assign ld_val_bits__h1331 = data1__h1462 & mask__h1506 ;
  assign memDOA_BITS_15_TO_0__q2 = mem$DOA[15:0] ;
  assign memDOA_BITS_15_TO_8__q4 = mem$DOA[15:8] ;
  assign memDOA_BITS_23_TO_16__q3 = mem$DOA[23:16] ;
  assign memDOA_BITS_31_TO_16__q5 = mem$DOA[31:16] ;
  assign memDOA_BITS_31_TO_24__q6 = mem$DOA[31:24] ;
  assign memDOA_BITS_7_TO_0__q1 = mem$DOA[7:0] ;
  assign result__h1721 = ld_val_bits__h1331 | y__h1733 ;
  assign result__h1788 = ld_val_bits__h1331 & mask__h1506 ;
  assign result__h4528 =
	     { {24{memDOA_BITS_7_TO_0__q1[7]}}, memDOA_BITS_7_TO_0__q1 } ;
  assign result__h4557 =
	     { {24{memDOA_BITS_15_TO_8__q4[7]}}, memDOA_BITS_15_TO_8__q4 } ;
  assign result__h4585 =
	     { {24{memDOA_BITS_23_TO_16__q3[7]}}, memDOA_BITS_23_TO_16__q3 } ;
  assign result__h4613 =
	     { {24{memDOA_BITS_31_TO_24__q6[7]}}, memDOA_BITS_31_TO_24__q6 } ;
  assign result__h4654 = { 24'd0, mem$DOA[7:0] } ;
  assign result__h4682 = { 24'd0, mem$DOA[15:8] } ;
  assign result__h4710 = { 24'd0, mem$DOA[23:16] } ;
  assign result__h4738 = { 24'd0, mem$DOA[31:24] } ;
  assign result__h4779 =
	     { {16{memDOA_BITS_15_TO_0__q2[15]}}, memDOA_BITS_15_TO_0__q2 } ;
  assign result__h4807 =
	     { {16{memDOA_BITS_31_TO_16__q5[15]}},
	       memDOA_BITS_31_TO_16__q5 } ;
  assign result__h4846 = { 16'd0, mem$DOA[15:0] } ;
  assign result__h4874 = { 16'd0, mem$DOA[31:16] } ;
  assign shamt_bits__h1984 = { f_req$D_OUT[33:32], 3'b0 } ;
  always@(f_req$D_OUT)
  begin
    case (f_req$D_OUT[65:64])
      2'b0: mask__h1506 = 32'h000000FF;
      2'b01: mask__h1506 = 32'h0000FFFF;
      default: mask__h1506 = 32'hFFFFFFFF;
    endcase
  end
  always@(f_req$D_OUT)
  begin
    case (f_req$D_OUT[65:64])
      2'b0: y__h1733 = 32'hFFFFFF00;
      2'b01: y__h1733 = 32'hFFFF0000;
      default: y__h1733 = 32'd0;
    endcase
  end
  always@(f_req$D_OUT)
  begin
    case (f_req$D_OUT[33:32])
      2'h0: _theResult___fst__h3949 = 4'h1;
      2'h1: _theResult___fst__h3949 = 4'h2;
      2'h2: _theResult___fst__h3949 = 4'h4;
      2'h3: _theResult___fst__h3949 = 4'h8;
    endcase
  end
  always@(f_req$D_OUT)
  begin
    case (f_req$D_OUT[33:32])
      2'h0: _theResult___fst__h3982 = 4'h3;
      2'h2: _theResult___fst__h3982 = 4'hC;
      default: _theResult___fst__h3982 = 4'd0;
    endcase
  end
  always@(f_req$D_OUT or
	  _theResult___snd__h3958 or
	  _theResult___snd__h3954 or _theResult___snd__h3987)
  begin
    case (f_req$D_OUT[33:32])
      2'h0: _theResult___snd__h3950 = f_req$D_OUT[31:0];
      2'h1: _theResult___snd__h3950 = _theResult___snd__h3954;
      2'h2: _theResult___snd__h3950 = _theResult___snd__h3987;
      2'd3: _theResult___snd__h3950 = _theResult___snd__h3958;
    endcase
  end
  always@(f_req$D_OUT or _theResult___snd__h3950 or _theResult___snd__h3983)
  begin
    case (f_req$D_OUT[65:64])
      2'b0: ram_st_value__h3731 = _theResult___snd__h3950;
      2'b01: ram_st_value__h3731 = _theResult___snd__h3983;
      default: ram_st_value__h3731 = f_req$D_OUT[31:0];
    endcase
  end
  always@(f_req$D_OUT or _theResult___fst__h3949 or _theResult___fst__h3982)
  begin
    case (f_req$D_OUT[65:64])
      2'b0: byte_en__h3730 = _theResult___fst__h3949;
      2'b01: byte_en__h3730 = _theResult___fst__h3982;
      2'b10, 2'b11: byte_en__h3730 = 4'hF;
    endcase
  end
  always@(f_req$D_OUT or
	  result__h4528 or result__h4557 or result__h4585 or result__h4613)
  begin
    case (f_req$D_OUT[33:32])
      2'h0:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170 =
	      result__h4528;
      2'h1:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170 =
	      result__h4557;
      2'h2:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170 =
	      result__h4585;
      2'h3:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170 =
	      result__h4613;
    endcase
  end
  always@(f_req$D_OUT or
	  result__h4654 or result__h4682 or result__h4710 or result__h4738)
  begin
    case (f_req$D_OUT[33:32])
      2'h0:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179 =
	      result__h4654;
      2'h1:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179 =
	      result__h4682;
      2'h2:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179 =
	      result__h4710;
      2'h3:
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179 =
	      result__h4738;
    endcase
  end
  always@(f_req$D_OUT or result__h4779 or result__h4807)
  begin
    case (f_req$D_OUT[33:32])
      2'h0:
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7 =
	      result__h4779;
      2'h2:
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7 =
	      result__h4807;
      default: CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7 = 32'd0;
    endcase
  end
  always@(f_req$D_OUT or result__h4846 or result__h4874)
  begin
    case (f_req$D_OUT[33:32])
      2'h0:
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8 =
	      result__h4846;
      2'h2:
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8 =
	      result__h4874;
      default: CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8 = 32'd0;
    endcase
  end
  always@(f_req$D_OUT or
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170 or
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7 or
	  mem$DOA or
	  IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179 or
	  CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8)
  begin
    case (f_req$D_OUT[66:64])
      3'b0:
	  ram_out__h3501 =
	      IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d170;
      3'b001:
	  ram_out__h3501 =
	      CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result779_0_ETC__q7;
      3'b010, 3'b011, 3'b110: ram_out__h3501 = mem$DOA;
      3'b100:
	  ram_out__h3501 =
	      IF_f_req_first_BITS_33_TO_32_3_EQ_0x0_27_THEN__ETC___d179;
      3'b101:
	  ram_out__h3501 =
	      CASE_f_reqD_OUT_BITS_33_TO_32_0x0_result846_0_ETC__q8;
      3'd7: ram_out__h3501 = 32'd0;
    endcase
  end
  always@(f_req$D_OUT or ld_val_bits__h1331)
  begin
    case (f_req$D_OUT[65:64])
      2'b0:
	  CASE_f_reqD_OUT_BITS_65_TO_64_0b0_ld_val_bits_ETC__q9 =
	      ld_val_bits__h1331[7];
      2'b01:
	  CASE_f_reqD_OUT_BITS_65_TO_64_0b0_ld_val_bits_ETC__q9 =
	      ld_val_bits__h1331[15];
      default: CASE_f_reqD_OUT_BITS_65_TO_64_0b0_ld_val_bits_ETC__q9 =
		   ld_val_bits__h1331[31];
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        fabric_adapter_rg_htrans <= `BSV_ASSIGNMENT_DELAY 2'd0;
	fabric_adapter_rg_state <= `BSV_ASSIGNMENT_DELAY 2'd0;
	mmio_rg_fsm_state <= `BSV_ASSIGNMENT_DELAY 2'd0;
	rg_exc <= `BSV_ASSIGNMENT_DELAY 5'd10;
	rg_rsp_from_mmio <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_state <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (fabric_adapter_rg_htrans$EN)
	  fabric_adapter_rg_htrans <= `BSV_ASSIGNMENT_DELAY
	      fabric_adapter_rg_htrans$D_IN;
	if (fabric_adapter_rg_state$EN)
	  fabric_adapter_rg_state <= `BSV_ASSIGNMENT_DELAY
	      fabric_adapter_rg_state$D_IN;
	if (mmio_rg_fsm_state$EN)
	  mmio_rg_fsm_state <= `BSV_ASSIGNMENT_DELAY mmio_rg_fsm_state$D_IN;
	if (rg_exc$EN) rg_exc <= `BSV_ASSIGNMENT_DELAY rg_exc$D_IN;
	if (rg_rsp_from_mmio$EN)
	  rg_rsp_from_mmio <= `BSV_ASSIGNMENT_DELAY rg_rsp_from_mmio$D_IN;
	if (rg_state$EN) rg_state <= `BSV_ASSIGNMENT_DELAY rg_state$D_IN;
      end
    if (fabric_adapter_rg_haddr$EN)
      fabric_adapter_rg_haddr <= `BSV_ASSIGNMENT_DELAY
	  fabric_adapter_rg_haddr$D_IN;
    if (fabric_adapter_rg_hsize$EN)
      fabric_adapter_rg_hsize <= `BSV_ASSIGNMENT_DELAY
	  fabric_adapter_rg_hsize$D_IN;
    if (fabric_adapter_rg_hwdata$EN)
      fabric_adapter_rg_hwdata <= `BSV_ASSIGNMENT_DELAY
	  fabric_adapter_rg_hwdata$D_IN;
    if (fabric_adapter_rg_hwrite$EN)
      fabric_adapter_rg_hwrite <= `BSV_ASSIGNMENT_DELAY
	  fabric_adapter_rg_hwrite$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    fabric_adapter_rg_haddr = 32'hAAAAAAAA;
    fabric_adapter_rg_hsize = 3'h2;
    fabric_adapter_rg_htrans = 2'h2;
    fabric_adapter_rg_hwdata = 32'hAAAAAAAA;
    fabric_adapter_rg_hwrite = 1'h0;
    fabric_adapter_rg_state = 2'h2;
    mmio_rg_fsm_state = 2'h2;
    rg_exc = 5'h0A;
    rg_rsp_from_mmio = 1'h0;
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
      if (EN_dma_req && NOT_verbosity_ULE_1_47___d248)
	begin
	  v__h5848 = $stime;
	  #0;
	end
    v__h5842 = v__h5848 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_dma_req && NOT_verbosity_ULE_1_47___d248)
	$display("%06d:[D]:%m.backdoor.req", v__h5842);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_dma_req && NOT_verbosity_ULE_1_47___d248 && verbosity == 2'd3)
	$display("           (addr 0x%08h) (wdata 0x%08h)",
		 dma_req_addr,
		 dma_req_wdata);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] &&
	  verbosity != 2'd0)
	begin
	  v__h3642 = $stime;
	  #0;
	end
    v__h3636 = v__h3642 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] &&
	  verbosity != 2'd0)
	$display("%0d: %m.fav_write_to_ram: ST", v__h3636);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] &&
	  verbosity != 2'd0)
	$display("      (va %08h) (data %08h)",
		 f_req$D_OUT[63:32],
		 f_req$D_OUT[31:0]);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && f_req$D_OUT[67] && !rg_exc[4] &&
	  verbosity != 2'd0)
	$display("      (RAM byte_en %08b) (RAM data %08h)",
		 byte_en__h3730,
		 ram_st_value__h3731);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && verbosity != 2'd0)
	begin
	  v__h4983 = $stime;
	  #0;
	end
    v__h4977 = v__h4983 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_tcm_rsp && verbosity != 2'd0)
	$display("%0d: %m.rl_tcm_rsp: (va %08h) (word32 %016h)",
		 v__h4977,
		 f_req$D_OUT[63:32],
		 ram_out__h3501);
  end
  // synopsys translate_on
endmodule  // mkDTCM

