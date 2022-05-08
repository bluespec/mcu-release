//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// RDY_server_reset_request_put   O     1 reg
// RDY_server_reset_response_get  O     1 reg
// valid                          O     1 reg
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

module mkLog_Shifter_Box(CLK,
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

  // register rg_iteration
  reg [5 : 0] rg_iteration;
  reg [5 : 0] rg_iteration$D_IN;
  wire rg_iteration$EN;

  // register rg_right
  reg rg_right;
  wire rg_right$D_IN, rg_right$EN;

  // register rg_shamt
  reg [4 : 0] rg_shamt;
  wire [4 : 0] rg_shamt$D_IN;
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
  wire [5 : 0] MUX_rg_iteration$write_1__VAL_2;
  wire MUX_rg_v1$write_1__SEL_2,
       MUX_rg_v1$write_1__SEL_3,
       MUX_rg_v1$write_1__SEL_4;

  // remaining internal signals
  wire [31 : 0] a__h11305,
		a__h14564,
		a__h18324,
		a__h21684,
		a__h24938,
		a__h28181,
		a__h31440,
		a__h35196,
		a__h38555,
		a__h41809,
		a__h45052,
		a__h4808,
		a__h48311,
		a__h8062,
		b__h11306,
		b__h14565,
		b__h18325,
		b__h4809,
		b__h8063,
		x__h1414,
		x__h1425,
		x__h1436,
		x__h18291,
		x__h18302,
		x__h18313,
		x__h24927,
		x__h35163,
		x__h35174,
		x__h35185,
		x__h41798,
		x__h8051,
		y__h1415,
		y__h1426,
		y__h1437,
		y__h18292,
		y__h18303,
		y__h18314,
		y__h24928,
		y__h35164,
		y__h35175,
		y__h35186,
		y__h41799,
		y__h8052;
  wire [30 : 0] rg_v1_9_BITS_30_TO_0_0_AND_rg_iteration_BIT_0__ETC___d46,
		rg_v1_BITS_31_TO_1__q1;
  wire [29 : 0] rg_v1_BITS_31_TO_2__q2;
  wire [27 : 0] rg_v1_BITS_31_TO_4__q3;
  wire [23 : 0] rg_v1_BITS_31_TO_8__q4;
  wire [15 : 0] rg_v1_BITS_31_TO_16__q5;
  wire rg_iteration_BIT_0_AND_rg_shamt_0_BIT_0_1_2_OR_ETC___d24;

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
  assign valid = rg_iteration[5] ;

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
  assign CAN_FIRE_RL_rl_sll = !rg_right && !rg_iteration[5] ;
  assign WILL_FIRE_RL_rl_sll = CAN_FIRE_RL_rl_sll && !EN_req ;

  // rule RL_rl_sra
  assign CAN_FIRE_RL_rl_sra = rg_right && rg_arith_shift && !rg_iteration[5] ;
  assign WILL_FIRE_RL_rl_sra = CAN_FIRE_RL_rl_sra && !EN_req ;

  // rule RL_rl_srl
  assign CAN_FIRE_RL_rl_srl =
	     rg_right && !rg_arith_shift && !rg_iteration[5] ;
  assign WILL_FIRE_RL_rl_srl = CAN_FIRE_RL_rl_srl && !EN_req ;

  // inputs to muxes for submodule ports
  assign MUX_rg_v1$write_1__SEL_2 =
	     WILL_FIRE_RL_rl_srl &&
	     (rg_iteration_BIT_0_AND_rg_shamt_0_BIT_0_1_2_OR_ETC___d24 ||
	      rg_iteration[4] && rg_shamt[4]) ;
  assign MUX_rg_v1$write_1__SEL_3 =
	     WILL_FIRE_RL_rl_sra &&
	     (rg_iteration_BIT_0_AND_rg_shamt_0_BIT_0_1_2_OR_ETC___d24 ||
	      rg_iteration[4] && rg_shamt[4]) ;
  assign MUX_rg_v1$write_1__SEL_4 =
	     WILL_FIRE_RL_rl_sll &&
	     (rg_iteration_BIT_0_AND_rg_shamt_0_BIT_0_1_2_OR_ETC___d24 ||
	      rg_iteration[4] && rg_shamt[4]) ;
  assign MUX_rg_iteration$write_1__VAL_2 = { rg_iteration[4:0], 1'd0 } ;
  assign MUX_rg_v1$write_1__VAL_2 = x__h35163 | y__h35164 ;
  assign MUX_rg_v1$write_1__VAL_3 = x__h18291 | y__h18292 ;
  assign MUX_rg_v1$write_1__VAL_4 = x__h1414 | y__h1415 ;

  // register rg_arith_shift
  assign rg_arith_shift$D_IN = !EN_server_reset_request_put && req_v2[7] ;
  assign rg_arith_shift$EN = EN_req || EN_server_reset_request_put ;

  // register rg_iteration
  always@(EN_server_reset_request_put or
	  WILL_FIRE_RL_rl_srl or
	  MUX_rg_iteration$write_1__VAL_2 or
	  WILL_FIRE_RL_rl_sra or WILL_FIRE_RL_rl_sll or EN_req)
  case (1'b1)
    EN_server_reset_request_put: rg_iteration$D_IN = 6'd0;
    WILL_FIRE_RL_rl_srl: rg_iteration$D_IN = MUX_rg_iteration$write_1__VAL_2;
    WILL_FIRE_RL_rl_sra: rg_iteration$D_IN = MUX_rg_iteration$write_1__VAL_2;
    WILL_FIRE_RL_rl_sll: rg_iteration$D_IN = MUX_rg_iteration$write_1__VAL_2;
    EN_req: rg_iteration$D_IN = 6'b000001;
    default: rg_iteration$D_IN = 6'b101010 /* unspecified value */ ;
  endcase
  assign rg_iteration$EN =
	     WILL_FIRE_RL_rl_srl || WILL_FIRE_RL_rl_sra ||
	     WILL_FIRE_RL_rl_sll ||
	     EN_server_reset_request_put ||
	     EN_req ;

  // register rg_right
  assign rg_right$D_IN = !EN_server_reset_request_put && req_right ;
  assign rg_right$EN = EN_req || EN_server_reset_request_put ;

  // register rg_shamt
  assign rg_shamt$D_IN = EN_server_reset_request_put ? 5'd0 : req_v2[4:0] ;
  assign rg_shamt$EN = EN_req || EN_server_reset_request_put ;

  // register rg_v1
  always@(EN_server_reset_request_put or
	  MUX_rg_v1$write_1__SEL_2 or
	  MUX_rg_v1$write_1__VAL_2 or
	  MUX_rg_v1$write_1__SEL_3 or
	  MUX_rg_v1$write_1__VAL_3 or
	  MUX_rg_v1$write_1__SEL_4 or
	  MUX_rg_v1$write_1__VAL_4 or EN_req or req_v1)
  case (1'b1)
    EN_server_reset_request_put: rg_v1$D_IN = 32'd0;
    MUX_rg_v1$write_1__SEL_2: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_2;
    MUX_rg_v1$write_1__SEL_3: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_3;
    MUX_rg_v1$write_1__SEL_4: rg_v1$D_IN = MUX_rg_v1$write_1__VAL_4;
    EN_req: rg_v1$D_IN = req_v1;
    default: rg_v1$D_IN = 32'hAAAAAAAA /* unspecified value */ ;
  endcase
  assign rg_v1$EN =
	     MUX_rg_v1$write_1__SEL_4 || MUX_rg_v1$write_1__SEL_3 ||
	     MUX_rg_v1$write_1__SEL_2 ||
	     EN_req ||
	     EN_server_reset_request_put ;

  // submodule f_reset_rsps
  assign f_reset_rsps$ENQ = EN_server_reset_request_put ;
  assign f_reset_rsps$DEQ = EN_server_reset_response_get ;
  assign f_reset_rsps$CLR = 1'b0 ;

  // remaining internal signals
  assign a__h11305 = { rg_v1[23:0], 8'd0 } ;
  assign a__h14564 = { rg_v1[15:0], 16'd0 } ;
  assign a__h18324 = { rg_v1_BITS_31_TO_1__q1[30], rg_v1_BITS_31_TO_1__q1 } ;
  assign a__h21684 =
	     { {2{rg_v1_BITS_31_TO_2__q2[29]}}, rg_v1_BITS_31_TO_2__q2 } ;
  assign a__h24938 =
	     { {4{rg_v1_BITS_31_TO_4__q3[27]}}, rg_v1_BITS_31_TO_4__q3 } ;
  assign a__h28181 =
	     { {8{rg_v1_BITS_31_TO_8__q4[23]}}, rg_v1_BITS_31_TO_8__q4 } ;
  assign a__h31440 =
	     { {16{rg_v1_BITS_31_TO_16__q5[15]}}, rg_v1_BITS_31_TO_16__q5 } ;
  assign a__h35196 = { 1'd0, rg_v1[31:1] } ;
  assign a__h38555 = { 2'd0, rg_v1[31:2] } ;
  assign a__h41809 = { 4'd0, rg_v1[31:4] } ;
  assign a__h45052 = { 8'd0, rg_v1[31:8] } ;
  assign a__h4808 = { rg_v1[29:0], 2'd0 } ;
  assign a__h48311 = { 16'd0, rg_v1[31:16] } ;
  assign a__h8062 = { rg_v1[27:0], 4'd0 } ;
  assign b__h11306 = {32{rg_iteration[3] && rg_shamt[3]}} ;
  assign b__h14565 = {32{rg_iteration[4] && rg_shamt[4]}} ;
  assign b__h18325 = {32{rg_iteration[0] && rg_shamt[0]}} ;
  assign b__h4809 = {32{rg_iteration[1] && rg_shamt[1]}} ;
  assign b__h8063 = {32{rg_iteration[2] && rg_shamt[2]}} ;
  assign rg_iteration_BIT_0_AND_rg_shamt_0_BIT_0_1_2_OR_ETC___d24 =
	     rg_iteration[0] && rg_shamt[0] ||
	     rg_iteration[1] && rg_shamt[1] ||
	     rg_iteration[2] && rg_shamt[2] ||
	     rg_iteration[3] && rg_shamt[3] ;
  assign rg_v1_9_BITS_30_TO_0_0_AND_rg_iteration_BIT_0__ETC___d46 =
	     rg_v1[30:0] & {31{rg_iteration[0] && rg_shamt[0]}} ;
  assign rg_v1_BITS_31_TO_16__q5 = rg_v1[31:16] ;
  assign rg_v1_BITS_31_TO_1__q1 = rg_v1[31:1] ;
  assign rg_v1_BITS_31_TO_2__q2 = rg_v1[31:2] ;
  assign rg_v1_BITS_31_TO_4__q3 = rg_v1[31:4] ;
  assign rg_v1_BITS_31_TO_8__q4 = rg_v1[31:8] ;
  assign x__h1414 = x__h1425 | y__h1426 ;
  assign x__h1425 = x__h1436 | y__h1437 ;
  assign x__h1436 =
	     { rg_v1_9_BITS_30_TO_0_0_AND_rg_iteration_BIT_0__ETC___d46,
	       1'd0 } ;
  assign x__h18291 = x__h18302 | y__h18303 ;
  assign x__h18302 = x__h18313 | y__h18314 ;
  assign x__h18313 = a__h18324 & b__h18325 ;
  assign x__h24927 = a__h24938 & b__h8063 ;
  assign x__h35163 = x__h35174 | y__h35175 ;
  assign x__h35174 = x__h35185 | y__h35186 ;
  assign x__h35185 = a__h35196 & b__h18325 ;
  assign x__h41798 = a__h41809 & b__h8063 ;
  assign x__h8051 = a__h8062 & b__h8063 ;
  assign y__h1415 = a__h14564 & b__h14565 ;
  assign y__h1426 = x__h8051 | y__h8052 ;
  assign y__h1437 = a__h4808 & b__h4809 ;
  assign y__h18292 = a__h31440 & b__h14565 ;
  assign y__h18303 = x__h24927 | y__h24928 ;
  assign y__h18314 = a__h21684 & b__h4809 ;
  assign y__h24928 = a__h28181 & b__h11306 ;
  assign y__h35164 = a__h48311 & b__h14565 ;
  assign y__h35175 = x__h41798 | y__h41799 ;
  assign y__h35186 = a__h38555 & b__h4809 ;
  assign y__h41799 = a__h45052 & b__h11306 ;
  assign y__h8052 = a__h11305 & b__h11306 ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_iteration <= `BSV_ASSIGNMENT_DELAY 6'd0;
      end
    else
      begin
        if (rg_iteration$EN)
	  rg_iteration <= `BSV_ASSIGNMENT_DELAY rg_iteration$D_IN;
      end
    if (rg_arith_shift$EN)
      rg_arith_shift <= `BSV_ASSIGNMENT_DELAY rg_arith_shift$D_IN;
    if (rg_right$EN) rg_right <= `BSV_ASSIGNMENT_DELAY rg_right$D_IN;
    if (rg_shamt$EN) rg_shamt <= `BSV_ASSIGNMENT_DELAY rg_shamt$D_IN;
    if (rg_v1$EN) rg_v1 <= `BSV_ASSIGNMENT_DELAY rg_v1$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_arith_shift = 1'h0;
    rg_iteration = 6'h2A;
    rg_right = 1'h0;
    rg_shamt = 5'h0A;
    rg_v1 = 32'hAAAAAAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkLog_Shifter_Box

