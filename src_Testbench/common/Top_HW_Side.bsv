// Copyright (c) 2013-2020 Bluespec, Inc. All Rights Reserved.

package Top_HW_Side;

// ================================================================
// mkTop_HW_Side is the top-level system for simulation.
// ================================================================
// BSV lib imports

import GetPut       :: *;
import Clocks       :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;

// ================================================================
// Project imports

import ISA_Decls        :: *;
import SoC_Top          :: *;
import Fabric_Defs      :: *;

`ifdef INCLUDE_GDB_CONTROL
import External_Control :: *;
import Giraffe_IFC      :: *;
import JtagTap          :: *;
`endif
import C_Imports        :: *;

// ================================================================
// Top-level module.
// Instantiates the SoC.

UInt #(6) initialInterval = 30;

(* synthesize *)
module mkTop_HW_Side (Empty) ;
`ifdef INCLUDE_GDB_CONTROL
   let clk <- exposeCurrentClock;
   let initRst_Ifc <- mkReset(2, True, clk);
   Reg#(UInt#(6)) initCount <- mkReg(initialInterval); // for questa
   rule rl_decCnt (initCount != 0);
      initCount <= initCount - 1;
      initRst_Ifc.assertReset();
   endrule
   let initialReset = initRst_Ifc.new_rst;

   let systemReset = initialReset;

   let dmiReset <- mkResetInverter(initialReset); // active high

   SoC_Top_IFC    soc_top   <- mkSoC_Top (dmiReset, reset_by systemReset);


   // Tie off jtag pins for simulation
   rule tie_off_jtag1_rl;
      soc_top.jtag.tclk(0);
   endrule

   rule tie_off_jtag2_rl;
      soc_top.jtag.tms(0);
      soc_top.jtag.tdi(0);
   endrule

`else
   SoC_Top_IFC    soc_top   <- mkSoC_Top;
`endif

   // ================================================================
   // BEHAVIOR

   Reg #(Bool) rg_banner_printed <- mkReg (False);

   // Display a banner
   rule rl_step0 (! rg_banner_printed);
      $display ("================================================================");
      $display ("Bluespec RISC-V Demo SoC simulation v1.3");
      $display ("Copyright (c) 2017-2021 Bluespec, Inc. All Rights Reserved.");
      $display ("================================================================");

      rg_banner_printed <= True;

      // Set CPU verbosity and logdelay (simulation only)
      Bool v1 <- $test$plusargs ("v1");
      Bool v2 <- $test$plusargs ("v2");
      Bool v3 <- $test$plusargs ("v3");
      Bit #(2)  verbosity = (v3 ? 3 : ((v2 ? 2 : (v1 ? 1 : 0))));
      soc_top.set_verbosity  (verbosity);

      $display ("Setting debug verbosity to %0d", verbosity);

`ifdef WATCH_TOHOST
      // ----------------
      // Load tohost addr from symbol-table file
      Bool watch_tohost <- $test$plusargs ("tohost");
      let tha <- c_get_symbol_val ("tohost");
      Fabric_Addr tohost_addr = truncate (tha);
      $display ("INFO: watch_tohost = %0d, tohost_addr = 0x%0h",
		pack (watch_tohost), tohost_addr);
      soc_top.set_watch_tohost (watch_tohost, tohost_addr);
`endif

   endrule: rl_step0

   // Terminate on test writing non-zero to <tohost_addr>

`ifdef WATCH_TOHOST
   rule rl_terminate_tohost (soc_top.mv_tohost_value != 0);
      let tohost_value = soc_top.mv_tohost_value;

      $display ("================================================================");
      $display ("%0d: %m:.rl_terminate_tohost: tohost_value is 0x%0h (= 0d%0d)",
		cur_cycle, tohost_value, tohost_value);
      let test_num = (tohost_value >> 1);
      if (test_num == 0) $display ("    PASS");
      else               $display ("    FAIL <test_%0d>", test_num);

      $finish (0);
   endrule
`endif

`ifdef TEST_UART
   // ================================================================
   // UART console I/O

   // Relay system console output to terminal

   rule rl_relay_console_out;
      let ch <- soc_top.get_to_console.get;
      $write ("%c", ch);
      $fflush (stdout);
   endrule

   // Poll terminal input and relay any chars into system console input.
   // Note: rg_console_in_poll is used to poll only every N cycles, whenever it wraps around to 0.

   Reg #(Bit #(12)) rg_console_in_poll <- mkReg (0);

   rule rl_relay_console_in;
      if (rg_console_in_poll == 0) begin
	 Bit #(8) ch <- c_trygetchar (?);
	 if (ch != 0) begin
	    soc_top.put_from_console.put (ch);
	 end
      end
      rg_console_in_poll <= rg_console_in_poll + 1;
   endrule
`endif

   // ================================================================
   // GPIO Output -- mimic "LEDs" and display update whenever the GPIO
   // output changes

   // Displays the colors produced by writing to a RGB led
   function Action fa_display_rgb_led (Bit #(3) rgb);
      action
         case (rgb)
            // RGB
            3'b000 : $write (" - ");
            3'b001 : $write (" B ");
            3'b010 : $write (" G ");
            3'b011 : $write (" C ");
            3'b100 : $write (" R ");
            3'b101 : $write (" M ");
            3'b110 : $write (" Y ");
            3'b111 : $write (" W ");
         endcase
      endaction
   endfunction

   Reg #(Bit #(16)) rg_gpio_out <- mkReg (0);
   let gpio_out = soc_top.gpios;
   rule rl_display_leds (rg_gpio_out != gpio_out);
      rg_gpio_out <= gpio_out;
      $write ("LED: ");
      fa_display_rgb_led (gpio_out [15:13]);
      fa_display_rgb_led (gpio_out [12:10]);
      fa_display_rgb_led (gpio_out [9:7]);
      fa_display_rgb_led (gpio_out [6:4]);
      for (Integer i=0; i<4; i=i+1) begin
         if (gpio_out [(3-i)] == 1'b1) $write (" x ");
         else $write (" - ");
      end
      $write ("\n");
      $fflush (stdout);
   endrule

endmodule

// ================================================================

endpackage
