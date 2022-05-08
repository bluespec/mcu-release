// Copyright (c) 2016-2020 Bluespec, Inc. All Rights Reserved.

package SoC_Top;

// ================================================================
// This package is the SoC "top-level".

// (Note: there will be further layer(s) above this for
//    simulation top-level, FPGA top-level, etc.)

// ================================================================
// Exports

export SoC_Top_IFC (..), mkSoC_Top;

// ================================================================
// BSV library imports

import FIFOF         :: *;
import GetPut        :: *;
import ClientServer  :: *;
import Connectable   :: *;
import Memory        :: *;
import Vector        :: *;

// ----------------
// BSV additional libs

import Cur_Cycle     :: *;
import GetPut_Aux    :: *;

// ================================================================
// Project imports

import SoC_Map             :: *;
import MCUTop              :: *;
import Fabric_Defs         :: *;

import AHBL_Types          :: *;
`ifdef TEST_GPIO
import GPIO_AHBL           :: *;
`endif
`ifdef TEST_CLINT
import CLINT_AHBL          :: *;
`endif
`ifdef TEST_PLIC
import PLIC_AHBL           :: *;
import PLIC_16_1_7         :: *;
import InterruptInjector   :: *;
`endif

`ifdef INCLUDE_GDB_CONTROL
import Giraffe_IFC         :: *;
`endif

`ifdef TCM_LOADER
import Loader        :: *;
`endif

// ================================================================
// The outermost interface of the SoC

interface SoC_Top_IFC;
   // GPIO interface for visual confirmation on the board
   (* always_ready *)
   method Bit #(16) gpios;

   // ----------------------------------------------------------------
   // Debug Interface

`ifdef INCLUDE_GDB_CONTROL
   interface JTAG_IFC jtag;
`endif

   // ----------------
   // In simulation: watch memory writes to <tohost> addr to end
   // test, report PASS/FAIL
`ifdef WATCH_TOHOST
   method Action set_watch_tohost (Bool  watch_tohost, Fabric_Addr  tohost_addr);
   method Fabric_Data mv_tohost_value;
`endif

endinterface

// ================================================================
// Local types and constants

typedef enum {SOC_START,
         SOC_RESETTING,
         SOC_IDLE} SoC_State
deriving (Bits, Eq, FShow);

`ifdef TEST_PLIC
typedef 16 NUM_EXT_INTR;
`endif

// ================================================================
// The module

(* synthesize *)
`ifdef INCLUDE_GDB_CONTROL
module mkSoC_Top ((*reset="dmi_reset"*) Reset dmi_reset, SoC_Top_IFC _ifc);
`else
module mkSoC_Top (SoC_Top_IFC);
`endif
   Reg #(SoC_State) rg_state <- mkReg (SOC_START);

   // SoC address map specifying base and limit for memories, IPs, etc.
   SoC_Map_IFC soc_map <- mkSoC_Map;

   // ----------------
   (*doc="MCU Core"*)
`ifdef INCLUDE_GDB_CONTROL
   MCUTop_IFC core <- mkMCUTop (dmi_reset);
`else
   MCUTop_IFC core <- mkMCUTop;
`endif

   // ----------------
   // SoC IPs

`ifdef TEST_CLINT
   (*doc= "NOTE: The Core Level Interrupt Device (CLINT)" *)
   CLINT_AHBL_IFC clint <- mkCLINT_AHBL;
`endif
`ifdef TEST_PLIC
   (*doc= "NOTE: The Platform Level Interrupt Controller (PLIC)" *)
   PLIC_IFC_16_1_7 plic <- mkPLIC_16_1_7;

   (*doc= "NOTE: A synthetic interrupt injector to test the PLIC" *)
   Injector_IFC ii <- mkInterruptInjector;
`endif
`ifdef TEST_GPIO
   (*doc= "NOTE: A GPIO device to signal information on the LEDs" *)
   GPIO_IFC   gpio  <- mkGPIO;
`endif

   // ----------------
   // SoC fabric connections

`ifdef TEST_CLINT
   // CPU Mem master to CLINT
   mkConnection (core.master1,  clint.fabric);
`endif
`ifdef TEST_PLIC
   // CPU Mem master to PLIC
   mkConnection (core.master1,  plic.fabric);
`endif
`ifdef TEST_GPIO
   // CPU Mem master to GPIO
   mkConnection (core.master1,  gpio.target);
`endif


`ifdef TCM_LOADER
   (*doc= "NOTE: A device to test TCM Loader function" *)
   Loader_IFC loader <- mkLoader;

   mkConnection (loader.toFabric, core.dma_server);
   mkConnection (loader.cpu_halt, core.cpu_halt);
   mkConnection (loader.reset_done, core.reset_done);
`endif

   // The address decoder of the AHBL. There is only one target on this
   // system, so just keep it selected after reset. This target responds
   // with slverr when accesses are outside its implemented space.
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_ahbl_decoder;
`ifdef TEST_CLINT
      clint.fabric.hsel (True);
      clint.fabric.hready (True);
`endif
`ifdef TEST_PLIC
      plic.fabric.hsel (True);
      plic.fabric.hready (True);
`endif
`ifdef TEST_GPIO
      gpio.target.hsel (True);
      gpio.target.hready (True);
`endif
   endrule

`ifndef MIN_CSR
   // Interrupt pins: Unused in this SoC
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_tieoff;
      core.s_external_interrupt_req (False);
   endrule
`endif

`ifdef TEST_PLIC
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_plic_tgt;
      core.m_external_interrupt_req (plic.v_targets[0].m_eip);
   endrule

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_plic_src;
      Vector #(NUM_INJ_INTR, Bit #(1)) v_intr = unpack (ii.irq);
      for (Integer i=0; i < valueOf (NUM_INJ_INTR); i=i+1)
         plic.v_sources[i].m_interrupt_req (unpack (v_intr[i]));

      for (Integer j = valueOf (NUM_INJ_INTR);
           j < valueOf (NUM_EXT_INTR); j=j+1)
         plic.v_sources[j].m_interrupt_req (False);
   endrule
`else
   rule rl_connect_plic_tgt;
      core.m_external_interrupt_req (False);
   endrule
`endif

`ifdef TEST_CLINT
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_clint_sint;
      core.software_interrupt_req (clint.sw_interrupt_pending);
   endrule

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_clint_tint;
      core.timer_interrupt_req (clint.timer_interrupt_pending);
   endrule
`else
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_clint_sint;
      core.software_interrupt_req (False);
   endrule

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_clint_tint;
      core.timer_interrupt_req (False);
   endrule
`endif

   // ================================================================
   // SOFT RESET

   // No special actions needed from the SoC to reset the MCUTop
   function Action fa_reset_start_actions (Bool running);
      action
      noAction;
      endaction
   endfunction

   // ----------------
   // Initial reset; CPU comes up running.

   rule rl_reset_start_initial (rg_state == SOC_START);
      Bool running = True;
      fa_reset_start_actions (running);
      rg_state <= SOC_RESETTING;

      $display ("%0d:%m.rl_reset_start_initial ...", cur_cycle);
   endrule

   rule rl_reset_complete_initial (rg_state == SOC_RESETTING);
      rg_state <= SOC_IDLE;

      $display ("%0d:%m.rl_reset_complete_initial", cur_cycle);
   endrule

   // ================================================================
   // INTERFACE
   // GPIO to top-level
`ifdef TEST_GPIO
   method Bit #(16) gpios = gpio.out;
`else
   method Bit #(16) gpios = 16'b0;
`endif

`ifdef INCLUDE_GDB_CONTROL
   interface JTAG_IFC jtag = core.jtag;
`endif

`ifdef WATCH_TOHOST
   // For ISA tests: watch memory writes to <tohost> addr
   method Action set_watch_tohost (Bool  watch_tohost, Fabric_Addr  tohost_addr);
      core.set_watch_tohost (watch_tohost, tohost_addr);
   endmethod

   method Fabric_Data mv_tohost_value = core.mv_tohost_value;
`endif

endmodule: mkSoC_Top

// ================================================================
endpackage
