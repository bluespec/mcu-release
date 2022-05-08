//
// Generated by Bluespec Compiler, version 2021.12.1-27-g9a7d5e05 (build 9a7d5e05)
//
//
// Ports:
// Name                         I/O  size props
// CLK                            I     1 clock
// RST_N                          I     1 reset
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

module mkTop_HW_Side(CLK,
		     RST_N);
  input  CLK;
  input  RST_N;

  // register initCount
  reg [5 : 0] initCount;
  wire [5 : 0] initCount$D_IN;
  wire initCount$EN;

  // register rg_banner_printed
  reg rg_banner_printed;
  wire rg_banner_printed$D_IN, rg_banner_printed$EN;

  // register rg_gpio_out
  reg [15 : 0] rg_gpio_out;
  wire [15 : 0] rg_gpio_out$D_IN;
  wire rg_gpio_out$EN;

  // ports of submodule dmiReset
  wire dmiReset$RESET_OUT;

  // ports of submodule initRst_Ifc
  wire initRst_Ifc$ASSERT_IN, initRst_Ifc$OUT_RST;

  // ports of submodule soc_top
  wire [31 : 0] soc_top$mv_tohost_value, soc_top$set_watch_tohost_tohost_addr;
  wire [15 : 0] soc_top$gpios;
  wire soc_top$EN_set_watch_tohost,
       soc_top$RDY_mv_tohost_value,
       soc_top$RDY_set_watch_tohost,
       soc_top$jtag_TCK,
       soc_top$jtag_TDI,
       soc_top$jtag_TMS,
       soc_top$set_watch_tohost_watch_tohost;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_decCnt,
       CAN_FIRE_RL_rl_display_leds,
       CAN_FIRE_RL_rl_step0,
       CAN_FIRE_RL_rl_terminate_tohost,
       CAN_FIRE_RL_tie_off_jtag1_rl,
       CAN_FIRE_RL_tie_off_jtag2_rl,
       WILL_FIRE_RL_rl_decCnt,
       WILL_FIRE_RL_rl_display_leds,
       WILL_FIRE_RL_rl_step0,
       WILL_FIRE_RL_rl_terminate_tohost,
       WILL_FIRE_RL_tie_off_jtag1_rl,
       WILL_FIRE_RL_tie_off_jtag2_rl;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h717;
  reg TASK_testplusargs___d9;
  reg [31 : 0] tohost_addr__h605;
  reg [31 : 0] v__h711;
  // synopsys translate_on

  // remaining internal signals
  wire [31 : 0] test_num__h760;

  // submodule dmiReset
  ResetInverter dmiReset(.RESET_IN(initRst_Ifc$OUT_RST),
			 .RESET_OUT(dmiReset$RESET_OUT));

  // submodule initRst_Ifc
  MakeResetA #(.RSTDELAY(32'd2), .init(1'd0)) initRst_Ifc(.CLK(CLK),
							  .RST(RST_N),
							  .DST_CLK(CLK),
							  .ASSERT_IN(initRst_Ifc$ASSERT_IN),
							  .ASSERT_OUT(),
							  .OUT_RST(initRst_Ifc$OUT_RST));

  // submodule soc_top
  mkSoC_Top soc_top(.dmi_reset(dmiReset$RESET_OUT),
		    .CLK(CLK),
		    .RST_N(initRst_Ifc$OUT_RST),
		    .jtag_TCK(soc_top$jtag_TCK),
		    .jtag_TDI(soc_top$jtag_TDI),
		    .jtag_TMS(soc_top$jtag_TMS),
		    .set_watch_tohost_tohost_addr(soc_top$set_watch_tohost_tohost_addr),
		    .set_watch_tohost_watch_tohost(soc_top$set_watch_tohost_watch_tohost),
		    .EN_set_watch_tohost(soc_top$EN_set_watch_tohost),
		    .gpios(soc_top$gpios),
		    .jtag_TDO(),
		    .RDY_set_watch_tohost(soc_top$RDY_set_watch_tohost),
		    .mv_tohost_value(soc_top$mv_tohost_value),
		    .RDY_mv_tohost_value(soc_top$RDY_mv_tohost_value),
		    .CLK_jtag_tclk_out(),
		    .CLK_GATE_jtag_tclk_out());

  // rule RL_rl_decCnt
  assign CAN_FIRE_RL_rl_decCnt = initCount != 6'd0 ;
  assign WILL_FIRE_RL_rl_decCnt = CAN_FIRE_RL_rl_decCnt ;

  // rule RL_tie_off_jtag1_rl
  assign CAN_FIRE_RL_tie_off_jtag1_rl = 1'd1 ;
  assign WILL_FIRE_RL_tie_off_jtag1_rl = 1'd1 ;

  // rule RL_tie_off_jtag2_rl
  assign CAN_FIRE_RL_tie_off_jtag2_rl = 1'd1 ;
  assign WILL_FIRE_RL_tie_off_jtag2_rl = 1'd1 ;

  // rule RL_rl_terminate_tohost
  assign CAN_FIRE_RL_rl_terminate_tohost =
	     soc_top$RDY_mv_tohost_value && soc_top$mv_tohost_value != 32'd0 ;
  assign WILL_FIRE_RL_rl_terminate_tohost = CAN_FIRE_RL_rl_terminate_tohost ;

  // rule RL_rl_step0
  assign CAN_FIRE_RL_rl_step0 =
	     soc_top$RDY_set_watch_tohost && !rg_banner_printed ;
  assign WILL_FIRE_RL_rl_step0 = CAN_FIRE_RL_rl_step0 ;

  // rule RL_rl_display_leds
  assign CAN_FIRE_RL_rl_display_leds = rg_gpio_out != soc_top$gpios ;
  assign WILL_FIRE_RL_rl_display_leds = CAN_FIRE_RL_rl_display_leds ;

  // register initCount
  assign initCount$D_IN = initCount - 6'd1 ;
  assign initCount$EN = CAN_FIRE_RL_rl_decCnt ;

  // register rg_banner_printed
  assign rg_banner_printed$D_IN = 1'd1 ;
  assign rg_banner_printed$EN = CAN_FIRE_RL_rl_step0 ;

  // register rg_gpio_out
  assign rg_gpio_out$D_IN = soc_top$gpios ;
  assign rg_gpio_out$EN = CAN_FIRE_RL_rl_display_leds ;

  // submodule initRst_Ifc
  assign initRst_Ifc$ASSERT_IN = CAN_FIRE_RL_rl_decCnt ;

  // submodule soc_top
  assign soc_top$jtag_TCK = 1'd0 ;
  assign soc_top$jtag_TDI = 1'd0 ;
  assign soc_top$jtag_TMS = 1'd0 ;
  assign soc_top$set_watch_tohost_tohost_addr = tohost_addr__h605 ;
  assign soc_top$set_watch_tohost_watch_tohost = TASK_testplusargs___d9 ;
  assign soc_top$EN_set_watch_tohost = CAN_FIRE_RL_rl_step0 ;

  // remaining internal signals
  assign test_num__h760 = { 1'd0, soc_top$mv_tohost_value[31:1] } ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        initCount <= `BSV_ASSIGNMENT_DELAY 6'd30;
	rg_banner_printed <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_gpio_out <= `BSV_ASSIGNMENT_DELAY 16'd0;
      end
    else
      begin
        if (initCount$EN) initCount <= `BSV_ASSIGNMENT_DELAY initCount$D_IN;
	if (rg_banner_printed$EN)
	  rg_banner_printed <= `BSV_ASSIGNMENT_DELAY rg_banner_printed$D_IN;
	if (rg_gpio_out$EN)
	  rg_gpio_out <= `BSV_ASSIGNMENT_DELAY rg_gpio_out$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    initCount = 6'h2A;
    rg_banner_printed = 1'h0;
    rg_gpio_out = 16'hAAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (WILL_FIRE_RL_rl_terminate_tohost)
      $display("================================================================");
    if (WILL_FIRE_RL_rl_terminate_tohost)
      begin
        v__h717 = $stime;
	#0;
      end
    v__h711 = v__h717 / 32'd10;
    if (WILL_FIRE_RL_rl_terminate_tohost)
      $display("%0d: %m:.rl_terminate_tohost: tohost_value is 0x%0h (= 0d%0d)",
	       v__h711,
	       soc_top$mv_tohost_value,
	       soc_top$mv_tohost_value);
    if (WILL_FIRE_RL_rl_terminate_tohost &&
	soc_top$mv_tohost_value[31:1] == 31'd0)
      $display("    PASS");
    if (WILL_FIRE_RL_rl_terminate_tohost &&
	soc_top$mv_tohost_value[31:1] != 31'd0)
      $display("    FAIL <test_%0d>", test_num__h760);
    if (WILL_FIRE_RL_rl_terminate_tohost) $finish(32'd0);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("================================================================");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("Bluespec RISC-V Demo SoC simulation v1.3");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("Copyright (c) 2017-2021 Bluespec, Inc. All Rights Reserved.");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("================================================================");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  TASK_testplusargs___d9 = $test$plusargs("tohost");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  tohost_addr__h605 = $imported_c_get_symbol_val("tohost");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("INFO: watch_tohost = %0d, tohost_addr = 0x%0h",
		 TASK_testplusargs___d9,
		 tohost_addr__h605);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds) $write("LED: ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b0)
	$write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b001)
	$write(" B ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b010)
	$write(" G ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b011)
	$write(" C ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b100)
	$write(" R ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b101)
	$write(" M ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b110)
	$write(" Y ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[15:13] == 3'b111)
	$write(" W ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b0)
	$write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b001)
	$write(" B ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b010)
	$write(" G ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b011)
	$write(" C ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b100)
	$write(" R ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b101)
	$write(" M ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b110)
	$write(" Y ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[12:10] == 3'b111)
	$write(" W ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b0)
	$write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b001)
	$write(" B ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b010)
	$write(" G ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b011)
	$write(" C ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b100)
	$write(" R ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b101)
	$write(" M ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b110)
	$write(" Y ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[9:7] == 3'b111)
	$write(" W ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b0)
	$write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b001)
	$write(" B ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b010)
	$write(" G ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b011)
	$write(" C ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b100)
	$write(" R ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b101)
	$write(" M ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b110)
	$write(" Y ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[6:4] == 3'b111)
	$write(" W ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[3]) $write(" x ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && !soc_top$gpios[3]) $write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[2]) $write(" x ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && !soc_top$gpios[2]) $write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[1]) $write(" x ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && !soc_top$gpios[1]) $write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && soc_top$gpios[0]) $write(" x ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds && !soc_top$gpios[0]) $write(" - ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds) $write("\n");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_display_leds) $fflush(32'h80000001);
  end
  // synopsys translate_on
endmodule  // mkTop_HW_Side

