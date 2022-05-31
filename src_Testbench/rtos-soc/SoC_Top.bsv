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

import AXI4_Types     :: *;
import AXI4_Fabric    :: *;
import AXI4_Deburster :: *;

import AHBL_Types          :: *;
import AHBL_Target_AXI4_Initiator   :: *;

import SoC_Map             :: *;
import MCUTop              :: *;
import Fabric_Defs         :: *;
import SoC_Fabric          :: *;

import CLINT_AXI4          :: *;

import PLIC_AXI4           :: *;
import PLIC_AXI4_16_1_7    :: *;

import UART_Model          :: *;

`ifdef INCLUDE_GDB_CONTROL
import Giraffe_IFC         :: *;
`endif

// ================================================================
// The outermost interface of the SoC

interface SoC_Top_IFC;
   // GPIO interface for visual confirmation on the board
   (* always_ready *)
   method Bit #(16) gpios;

   // UART0 to external console
   interface Get #(Bit #(8)) get_to_console;
   interface Put #(Bit #(8)) put_from_console;

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

`ifndef SYNTHESIS
   // ----------------
   // Debugging: set mcu's verbosity
   method Action  set_verbosity (Bit #(2)  verbosity);
`endif

endinterface

// ================================================================
// Local types and constants

typedef enum {SOC_START,
         SOC_RESETTING,
         SOC_IDLE} SoC_State
deriving (Bits, Eq, FShow);

typedef 16 NUM_EXT_INTR;

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
   MCUTop_IFC mcu <- mkMCUTop (dmi_reset);
`else
   MCUTop_IFC mcu <- mkMCUTop;
`endif

   // ----------------
   // SoC Components

   (*doc= "An AHBL-AXI4 bridge to integrate the MCU to an AXI4 based SoC" *)
   AHBL_Target_AXI4_Initiator ahbl_axi4_bridge <- mkAHBL_Target_AXI4_Initiator; 

   // SoC Fabric
   (*doc= "The AXI4 SoC Fabric" *)
   Fabric_AXI4_IFC  fabric <- mkFabric_AXI4;

   (*doc= "The Core Level Interrupt Device (CLINT)" *)
   CLINT_AXI4_IFC clint <- mkCLINT_AXI4;

   (*doc= "The Platform Level Interrupt Controller (PLIC)" *)
   PLIC_IFC_16_1_7 plic <- mkPLIC_16_1_7;

   (*doc= "A UART device for console IO" *)
   UART_IFC uart <- mkUART;

   // ----------------
   // SoC fabric connections
   mkConnection (mcu.master1,  ahbl_axi4_bridge.ahbl_target);
   mkConnection (ahbl_axi4_bridge.axi4_initiator, fabric.v_from_masters [cpu_ini_num]);
   mkConnection (fabric.v_to_slaves [uart_trgt_num], uart.axi4);
   mkConnection (fabric.v_to_slaves [plic_trgt_num], plic.axi4);
   mkConnection (fabric.v_to_slaves [clint_trgt_num],clint.axi4);

   // The address decoder of the AHBL. There is only one target on this
   // system, so just keep it selected after reset. This target responds
   // with slverr when accesses are outside its implemented space.
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_ahbl_decoder;
      ahbl_axi4_bridge.ahbl_target.hsel (True);
      ahbl_axi4_bridge.ahbl_target.hready (True);
   endrule

`ifndef MIN_CSR
   // Interrupt pins: Unused in this SoC
   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_tieoff;
      mcu.s_external_interrupt_req (False);
   endrule
`endif

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_plic_trgt;
      mcu.m_external_interrupt_req (plic.v_targets[0].m_eip);
   endrule

   (* no_implicit_conditions, fire_when_enabled *)
   rule rl_connect_plic_src;
      // UART is source 0
      plic.v_sources[0].m_interrupt_req (uart.intr);

      // Tie off all other sources
      for (Integer j = 1;
           j < valueOf (NUM_EXT_INTR); j=j+1)
         plic.v_sources[j].m_interrupt_req (False);
   endrule

   rule rl_connect_clint_sint;
      let x <- clint.get_sw_interrupt_req.get ();
      mcu.software_interrupt_req (x);
   endrule

   rule rl_connect_clint_tint;
      let x <- clint.get_timer_interrupt_req.get ();
      mcu.timer_interrupt_req (x);
   endrule

   // ================================================================
   // SOFT RESET

   // No special actions needed from the SoC to reset the MCUTop
   function Action fa_reset_start_actions (Bool running);
      action
      uart.server_reset.request.put (?);
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
      uart.set_addr_map (soc_map.m_uart_addr_base, soc_map.m_uart_addr_lim);

      $display ("%0d:%m.rl_reset_complete_initial", cur_cycle);
   endrule

   // ================================================================
   // INTERFACE
   // GPIO to top-level
   method Bit #(16) gpios = 16'b0;

`ifdef INCLUDE_GDB_CONTROL
   interface JTAG_IFC jtag = mcu.jtag;
`endif

`ifdef WATCH_TOHOST
   // For ISA tests: watch memory writes to <tohost> addr
   method Action set_watch_tohost (Bool  watch_tohost, Fabric_Addr  tohost_addr);
      mcu.set_watch_tohost (watch_tohost, tohost_addr);
   endmethod

   method Fabric_Data mv_tohost_value = mcu.mv_tohost_value;
`endif

   // UART to external console
   interface get_to_console   = uart.get_to_console;
   interface put_from_console = uart.put_from_console;


   // ----------------------------------------------------------------
   // Misc. control and status

`ifndef SYNTHESIS
   method Action  set_verbosity (Bit #(2)  verbosity);
      mcu.set_verbosity (verbosity);
   endmethod
`endif

endmodule: mkSoC_Top

// ================================================================
endpackage
