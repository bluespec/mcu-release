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

  // register rg_banner_printed
  reg rg_banner_printed;
  wire rg_banner_printed$D_IN, rg_banner_printed$EN;

  // register rg_console_in_poll
  reg [11 : 0] rg_console_in_poll;
  wire [11 : 0] rg_console_in_poll$D_IN;
  wire rg_console_in_poll$EN;

  // register rg_gpio_out
  reg [15 : 0] rg_gpio_out;
  wire [15 : 0] rg_gpio_out$D_IN;
  wire rg_gpio_out$EN;

  // ports of submodule soc_top
  wire [31 : 0] soc_top$mv_tohost_value, soc_top$set_watch_tohost_tohost_addr;
  wire [15 : 0] soc_top$gpios;
  wire [7 : 0] soc_top$get_to_console_get, soc_top$put_from_console_put;
  wire [1 : 0] soc_top$set_verbosity_verbosity;
  wire soc_top$EN_get_to_console_get,
       soc_top$EN_put_from_console_put,
       soc_top$EN_set_verbosity,
       soc_top$EN_set_watch_tohost,
       soc_top$RDY_get_to_console_get,
       soc_top$RDY_mv_tohost_value,
       soc_top$RDY_put_from_console_put,
       soc_top$RDY_set_watch_tohost,
       soc_top$set_watch_tohost_watch_tohost;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_display_leds,
       CAN_FIRE_RL_rl_relay_console_in,
       CAN_FIRE_RL_rl_relay_console_out,
       CAN_FIRE_RL_rl_step0,
       CAN_FIRE_RL_rl_terminate_tohost,
       WILL_FIRE_RL_rl_display_leds,
       WILL_FIRE_RL_rl_relay_console_in,
       WILL_FIRE_RL_rl_relay_console_out,
       WILL_FIRE_RL_rl_step0,
       WILL_FIRE_RL_rl_terminate_tohost;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h545;
  reg TASK_testplusargs___d7;
  reg TASK_testplusargs___d6;
  reg TASK_testplusargs___d5;
  reg TASK_testplusargs___d11;
  reg [31 : 0] tohost_addr__h431;
  reg [7 : 0] v__h837;
  reg [31 : 0] v__h539;
  // synopsys translate_on

  // remaining internal signals
  wire [31 : 0] test_num__h588;

  // submodule soc_top
  mkSoC_Top soc_top(.CLK(CLK),
		    .RST_N(RST_N),
		    .put_from_console_put(soc_top$put_from_console_put),
		    .set_verbosity_verbosity(soc_top$set_verbosity_verbosity),
		    .set_watch_tohost_tohost_addr(soc_top$set_watch_tohost_tohost_addr),
		    .set_watch_tohost_watch_tohost(soc_top$set_watch_tohost_watch_tohost),
		    .EN_get_to_console_get(soc_top$EN_get_to_console_get),
		    .EN_put_from_console_put(soc_top$EN_put_from_console_put),
		    .EN_set_watch_tohost(soc_top$EN_set_watch_tohost),
		    .EN_set_verbosity(soc_top$EN_set_verbosity),
		    .gpios(soc_top$gpios),
		    .get_to_console_get(soc_top$get_to_console_get),
		    .RDY_get_to_console_get(soc_top$RDY_get_to_console_get),
		    .RDY_put_from_console_put(soc_top$RDY_put_from_console_put),
		    .RDY_set_watch_tohost(soc_top$RDY_set_watch_tohost),
		    .mv_tohost_value(soc_top$mv_tohost_value),
		    .RDY_mv_tohost_value(soc_top$RDY_mv_tohost_value),
		    .RDY_set_verbosity());

  // rule RL_rl_terminate_tohost
  assign CAN_FIRE_RL_rl_terminate_tohost =
	     soc_top$RDY_mv_tohost_value && soc_top$mv_tohost_value != 32'd0 ;
  assign WILL_FIRE_RL_rl_terminate_tohost = CAN_FIRE_RL_rl_terminate_tohost ;

  // rule RL_rl_step0
  assign CAN_FIRE_RL_rl_step0 =
	     soc_top$RDY_set_watch_tohost && !rg_banner_printed ;
  assign WILL_FIRE_RL_rl_step0 = CAN_FIRE_RL_rl_step0 ;

  // rule RL_rl_relay_console_out
  assign CAN_FIRE_RL_rl_relay_console_out = soc_top$RDY_get_to_console_get ;
  assign WILL_FIRE_RL_rl_relay_console_out = soc_top$RDY_get_to_console_get ;

  // rule RL_rl_relay_console_in
  assign CAN_FIRE_RL_rl_relay_console_in =
	     rg_console_in_poll != 12'd0 || soc_top$RDY_put_from_console_put ;
  assign WILL_FIRE_RL_rl_relay_console_in = CAN_FIRE_RL_rl_relay_console_in ;

  // rule RL_rl_display_leds
  assign CAN_FIRE_RL_rl_display_leds = rg_gpio_out != soc_top$gpios ;
  assign WILL_FIRE_RL_rl_display_leds = CAN_FIRE_RL_rl_display_leds ;

  // register rg_banner_printed
  assign rg_banner_printed$D_IN = 1'd1 ;
  assign rg_banner_printed$EN = CAN_FIRE_RL_rl_step0 ;

  // register rg_console_in_poll
  assign rg_console_in_poll$D_IN = rg_console_in_poll + 12'd1 ;
  assign rg_console_in_poll$EN = CAN_FIRE_RL_rl_relay_console_in ;

  // register rg_gpio_out
  assign rg_gpio_out$D_IN = soc_top$gpios ;
  assign rg_gpio_out$EN = CAN_FIRE_RL_rl_display_leds ;

  // submodule soc_top
  assign soc_top$put_from_console_put = v__h837 ;
  assign soc_top$set_verbosity_verbosity =
	     TASK_testplusargs___d5 ?
	       2'd3 :
	       (TASK_testplusargs___d6 ?
		  2'd2 :
		  (TASK_testplusargs___d7 ? 2'd1 : 2'd0)) ;
  assign soc_top$set_watch_tohost_tohost_addr = tohost_addr__h431 ;
  assign soc_top$set_watch_tohost_watch_tohost = TASK_testplusargs___d11 ;
  assign soc_top$EN_get_to_console_get = soc_top$RDY_get_to_console_get ;
  assign soc_top$EN_put_from_console_put =
	     WILL_FIRE_RL_rl_relay_console_in &&
	     rg_console_in_poll == 12'd0 &&
	     v__h837 != 8'd0 ;
  assign soc_top$EN_set_watch_tohost = CAN_FIRE_RL_rl_step0 ;
  assign soc_top$EN_set_verbosity = CAN_FIRE_RL_rl_step0 ;

  // remaining internal signals
  assign test_num__h588 = { 1'd0, soc_top$mv_tohost_value[31:1] } ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        rg_banner_printed <= `BSV_ASSIGNMENT_DELAY 1'd0;
	rg_console_in_poll <= `BSV_ASSIGNMENT_DELAY 12'd0;
	rg_gpio_out <= `BSV_ASSIGNMENT_DELAY 16'd0;
      end
    else
      begin
        if (rg_banner_printed$EN)
	  rg_banner_printed <= `BSV_ASSIGNMENT_DELAY rg_banner_printed$D_IN;
	if (rg_console_in_poll$EN)
	  rg_console_in_poll <= `BSV_ASSIGNMENT_DELAY rg_console_in_poll$D_IN;
	if (rg_gpio_out$EN)
	  rg_gpio_out <= `BSV_ASSIGNMENT_DELAY rg_gpio_out$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_banner_printed = 1'h0;
    rg_console_in_poll = 12'hAAA;
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
        v__h545 = $stime;
	#0;
      end
    v__h539 = v__h545 / 32'd10;
    if (WILL_FIRE_RL_rl_terminate_tohost)
      $display("%0d: %m:.rl_terminate_tohost: tohost_value is 0x%0h (= 0d%0d)",
	       v__h539,
	       soc_top$mv_tohost_value,
	       soc_top$mv_tohost_value);
    if (WILL_FIRE_RL_rl_terminate_tohost &&
	soc_top$mv_tohost_value[31:1] == 31'd0)
      $display("    PASS");
    if (WILL_FIRE_RL_rl_terminate_tohost &&
	soc_top$mv_tohost_value[31:1] != 31'd0)
      $display("    FAIL <test_%0d>", test_num__h588);
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
	  TASK_testplusargs___d7 = $test$plusargs("v1");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  TASK_testplusargs___d6 = $test$plusargs("v2");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  TASK_testplusargs___d5 = $test$plusargs("v3");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  TASK_testplusargs___d11 = $test$plusargs("tohost");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	begin
	  tohost_addr__h431 = $imported_c_get_symbol_val("tohost");
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_step0)
	$display("INFO: watch_tohost = %0d, tohost_addr = 0x%0h",
		 TASK_testplusargs___d11,
		 tohost_addr__h431);
    if (RST_N != `BSV_RESET_VALUE)
      if (soc_top$RDY_get_to_console_get)
	$write("%c", soc_top$get_to_console_get);
    if (RST_N != `BSV_RESET_VALUE)
      if (soc_top$RDY_get_to_console_get) $fflush(32'h80000001);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_relay_console_in && rg_console_in_poll == 12'd0)
	begin
	  v__h837 = $imported_c_trygetchar(8'hAA);
	  #0;
	end
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
