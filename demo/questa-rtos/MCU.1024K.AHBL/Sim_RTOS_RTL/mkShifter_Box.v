//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// RDY_server_reset_request_put   O     1 reg
// RDY_server_reset_response_get  O     1 reg
// valid                          O     1
// word                           O    32 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// req_right                      I     1
// req_v1                         I    32
// req_v2                         I    32
// EN_server_reset_request_put    I     1
// EN_server_reset_response_get   I     1
// EN_req                         I     1
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

module mkShifter_Box(CLK,
		     RST_N,

		     EN_server_reset_request_put,
		     RDY_server_reset_request_put,

		     EN_server_reset_response_get,
		     RDY_server_reset_response_get,

		     req_right,
		     req_v1,
		     req_v2,
		     EN_req,

		     valid,

		     word);
  input  CLK;
  input  RST_N;

  // action method server_reset_request_put
  input  EN_server_reset_request_put;
  output RDY_server_reset_request_put;

  // action method server_reset_response_get
  input  EN_server_reset_response_get;
  output RDY_server_reset_response_get;

  // action method req
  input  req_right;
  input  [31 : 0] req_v1;
  input  [31 : 0] req_v2;
  input  EN_req;

  // value method valid
  output valid;

  // value method word
  output [31 : 0] word;

  // signals for module outputs
  wire [31 : 0] word;
  wire RDY_server_reset_request_put, RDY_server_reset_response_get, valid;

  // register rg_arith_shift
  reg rg_arith_shift;
  wire rg_arith_shift$D_IN, rg_arith_shift$EN;

  // register rg_right
  reg rg_right;
  wire rg_right$D_IN, rg_right$EN;

  // register rg_shamt
  reg [4 : 0] rg_shamt;
  reg [4 : 0] rg_shamt$D_IN;
  wire rg_shamt$EN;

  // register rg_v1
  reg [31 : 0] rg_v1;
  reg [31 : 0] rg_v1$D_IN;
  wire rg_v1$EN;

  // ports of submodule f_reset_rsps
  wire f_reset_rsps$CLR,
       f_reset_rsps$DEQ,
       f_reset_rsps$EMPTY_N,
       f_reset_rsps$ENQ,
       f_reset_rsps$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_sll,
       CAN_FIRE_RL_rl_sra,
       CAN_FIRE_RL_rl_srl,
       CAN_FIRE_req,
       CAN_FIRE_server_reset_request_put,
       CAN_FIRE_server_reset_response_get,
       WILL_FIRE_RL_rl_sll,
       WILL_FIRE_RL_rl_sra,
       WILL_FIRE_RL_rl_srl,
       WILL_FIRE_req,
       WILL_FIRE_server_reset_request_put,
       WILL_FIRE_server_reset_response_get;

  // inputs to muxes for submodule ports
  wire [31 : 0] MUX_rg_v1$write_1__VAL_2,
		MUX_rg_v1$write_1__VAL_3,
		MUX_rg_v1$write_1__VAL_4;
  wire [4 : 0] MUX_rg_shamt$write_1__VAL_2;

  // remaining internal signals
  wire [30 : 0] rg_v1_BITS_31_TO_1__q1;

  // action method server_reset_request_put
  assign RDY_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign CAN_FIRE_server_reset_request_put = f_reset_rsps$FULL_N ;
  assign WILL_FIRE_server_reset_request_put = EN_server_reset_request_put ;

  // action method server_reset_response_get
  assign RDY_server_reset_response_get = f_reset_rsps$EMPTY_N ;
  assign CAN_FIRE_server_reset_response_get = f_reset_rsps$EMPTY_N ;
  assign WILL_FIRE_server_reset_response_get = EN_server_reset_response_get ;

  // action method req
  assign CAN_FIRE_req = 1'd1 ;
  assign WILL_FIRE_req = EN_req ;

  // value method valid
  assign valid = rg_shamt == 5'd0 ;

  // value method word
  assign word = rg_v1 ;

  // submodule f_reset_rsps
  FIFO10 #(.guarded(1'd1)) f_reset_rsps(.RST(RST_N),
					.CLK(CLK),
					.ENQ(f_reset_rsps$ENQ),
					.DEQ(f_reset_rsps$DEQ),
					.CLR(f_reset_rsps$CLR),
					.FULL_N(f_reset_rsps$FULL_N),
					.EMPTY_N(f_reset_rsps$EMPTY_N));

  // rule RL_rl_sll
  assign CAN_FIRE_RL_rl_sll = !rg_right && rg_shamt != 5'd0 ;
  assign WILL_FIRE_RL_rl_sll = CAN_FIRE_RL_rl_sll && !EN_req ;

  // rule RL_rl_sra
  assign CAN_FIRE_RL_rl_sra = rg_right && rg_arith_shift && rg_shamt != 5'd0 ;
  assign WILL_FIRE_RL_rl_sra = CAN_FIRE_RL_rl_sra && !EN_req ;

  // rule RL_rl_srl
  assign CAN_FIRE_RL_rl_srl =
	     rg_right && !rg_arith_shift && rg_shamt != 5'd0 ;
  assign WILL_FIRE_RL_rl_srl = CAN_FIRE_RL_rl_srl && !EN_req ;

  // inputs to muxes for submodule ports
  assign MUX_rg_shamt$write_1__VAL_2 = rg_shamt - 5'd1 ;
  assign MUX_rg_v1$write_1__VAL_2 = { 1'd0, rg_v1[31:1] } ;
  assign MUX_rg_v1$write_1__VAL_3 =
	     { rg_v1_BITS_31_TO_1__q1[30], rg_v1_BITS_31_TO_1__q1 } ;
  assign MUX_rg_v1$write_1__VAL_4 = { rg_v1[30:0], 1'd0 } ;

  // register rg_arith_shift
  assign rg_arith_shift$D_IN = !EN_server_reset_request_put && req_v2[7] ;
  assign rg_arith_shift$EN = EN_req || EN_server_reset_request_put ;

  // register rg_right
  assign rg_right$D_IN = !EN_server_reset_request_put && req_right ;
  assign rg_right$EN = EN_req || EN_server_reset_request_put ;

  // register rg_shamt
  always@(EN_server_reset_request_put or
	  WILL_FIRE_RL_rl_srl or
	  MUX_rg_shamt$write_1__VAL_2 or
	  WILL_FIRE_RL_rl_sra or WILL_FIRE_RL_rl_sll or EN_req or req_v2)
  case (1'b1)
    EN_server_reset_request_put: rg_shamt$D_IN = 5'd0;
    WILL_FIRE_RL_rl_srl: rg_shamt$D_IN = MUX_rg_shamt$write_1__VAL_2;
    WILL_FIRE_RL_rl_sra: rg_shamt$D_IN = MUX_rg_shamt$write_1__VAL_2;
    WILL_FIRE_RL_rl_sll: rg_shamt$D_IN = MUX_rg_shamt$write_1__VAL_2;
    EN_req: rg_shamt$D_IN = req_v2[4:0];
    default: rg_shamt$D_IN = 5'b01010 /* unspecified value */ ;
  endcase
  assign rg_shamt$EN =
	     WILL_FIRE_RL_rl_srl || WILL_FIRE_RL_rl_sra ||
	     WILL_FIRE_RL_rl_sll ||
	     EN_req ||
	     EN_server_reset_request_put ;

  // register rg_v1
  always@(EN_server_reset_request_put or
	  WILL_FIRE_RL_rl_srl or
	  MUX_rg_v1$write_1__VAL_2 or
	  WILL_FIRE_RL_rl_sra or
	  MUX_rg_v1$write_1__VAL_3 or
	  WILL_FIRE_RL_rl_sll or MUX_rg_v1$write_1__VAL_4 or EN_req or req_v1)
  case (1'b1)
    EN_server_reset_request_put: rg_v1$D_IN = 32'd0;
    WILL_FIRE_RL_rl_srl: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_2;
    WILL_FIRE_RL_rl_sra: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_3;
    WILL_FIRE_RL_rl_sll: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_4;
    EN_req: rg_v1$D_IN = req_v1;
    default: rg_v1$D_IN = 32'hAAAAAAAA /* unspecified value */ ;
  endcase
  assign rg_v1$EN =
	     EN_req || WILL_FIRE_RL_rl_sll || WILL_FIRE_RL_rl_srl ||
	     WILL_FIRE_RL_rl_sra ||
	     EN_server_reset_request_put ;

  // submodule f_reset_rsps
  assign f_reset_rsps$ENQ = EN_server_reset_request_put ;
  assign f_reset_rsps$DEQ = EN_server_reset_response_get ;
  assign f_reset_rsps$CLR = 1'b0 ;

  // remaining internal signals
  assign rg_v1_BITS_31_TO_1__q1 = rg_v1[31:1] ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_shamt <= `BSV_ASSIGNMENT_DELAY 5'd0;
      end
    else
      begin
        if (rg_shamt$EN) rg_shamt <= `BSV_ASSIGNMENT_DELAY rg_shamt$D_IN;
      end
    if (rg_arith_shift$EN)
      rg_arith_shift <= `BSV_ASSIGNMENT_DELAY rg_arith_shift$D_IN;
    if (rg_right$EN) rg_right <= `BSV_ASSIGNMENT_DELAY rg_right$D_IN;
    if (rg_v1$EN) rg_v1 <= `BSV_ASSIGNMENT_DELAY rg_v1$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_arith_shift = 1'h0;
    rg_right = 1'h0;
    rg_shamt = 5'h0A;
    rg_v1 = 32'hAAAAAAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkShifter_Box

