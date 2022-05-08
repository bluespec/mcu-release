// Copyright (c) 2021- Bluespec, Inc. All Rights Reserved.

package InterruptInjector;
// ================================================================
// This package defines:
//     Injector_IFC
//     mkInterruptInjector
//
// The package implements an interrupt injector which generates
// interrupts to the core based on cycles that are multiples of
// two (for instance, 4K, 8K, 16K, etc) cycles. The idea is to
// create cases where multiple interrupts are signaled
// simultaneously to the core.

// ================================================================
// BSV library imports

import Vector        ::*;
import FIFOF         ::*;
import GetPut        ::*;
import ClientServer  ::*;

// Project imports
import AHBL_Types    :: *;
import AHBL_Defs     :: *;
import Fabric_Defs   :: *;
import Cur_Cycle     :: *;
import GetPut_Aux    :: *;
import Semi_FIFOF    :: *;

// ================================================================
// Local type definitions
// Number of generated interrupts
typedef 4 NUM_INJ_INTR;

// Latency of first interrupt in cycles
typedef 1024 LATENCY;

// Bit position in counter which should flip to count LATENCY
typedef TLog #(LATENCY) COUNT_BITPOS;
Integer count_bitpos = valueOf (COUNT_BITPOS);

// Interface definition
interface Injector_IFC;
   // Connect to core's external interrupt pins
   (* always_ready *) method Bit #(NUM_INJ_INTR) irq;
endinterface


// ================================================================
(* synthesize *)
module mkInterruptInjector (Injector_IFC);
   // Verbosity: 0: quiet; 1: reads/writes
   Integer verbosity = 0;

   Reg #(Bit #(32)) rg_counter      <- mkReg (0);

   // Module is ready for operation after reset
   Reg #(Bool)      rg_module_ready <- mkReg (True);

   // The actual interrupt requests - set by HW, cleared after fixed duration
   // because we can't give sw access without an AHB fabric
   Vector #(  NUM_INJ_INTR
            , Reg #(Bit #(1))) vrg_irq <- replicateM (mkReg (0));

   Vector #(  NUM_INJ_INTR
            , Reg #(Bit #(32))) vrg_counter <- replicateM (mkReg (0));

   // ================================================================
   // BEHAVIOR

   // -----------------------------------------------------------
   // Run the counter, generate the interrupts
   for (Integer i=0; i < valueOf (NUM_INJ_INTR); i=i+1) begin
      rule rl_assert_irq (vrg_irq[i] == 1'b0);
         let nxt_count = vrg_counter[i] + 1;
         if (nxt_count [count_bitpos+i] == 1'b1) begin
            vrg_irq[i] <= 1'b1;
            vrg_counter[i] <= 32'h100; // 256 cycle on period
         end
         else vrg_counter[i] <= nxt_count;
      endrule
      rule rl_deassert_irq (vrg_irq[i] == 1'b1);
         let nxt_count = vrg_counter[i] - 1;
         if (nxt_count == 0) vrg_irq[i] <= 1'b0;
         vrg_counter[i] <= nxt_count;
      endrule
   end


   method Bit #(NUM_INJ_INTR) irq = pack (readVReg (vrg_irq));
   // -----------------------------------------------------------
endmodule

// ================================================================
endpackage

