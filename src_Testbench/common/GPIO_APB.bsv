// Copyright (c) 2017 Bluespec, Inc.  All Rights Reserved

package GPIO_APB;

// ================================================================
// A simple GPIO model that sits behind an APB-4 interface
// - Word addressed (APB limitation for a 32-bit APB bus)
// - Supports 32b reads only (ignores HADDR [1:0]

// ================================================================
// BSV lib imports

import DefaultValue        :: *;

// ================================================================
// Project imports

import Cur_Cycle           :: *;
import Fabric_Defs         :: *;
import APB_Defs            :: *;
import APB_Types           :: *;

typedef enum { IDLE, RD_RSP, WR_RSP } Tgt_State deriving (Bits, Eq, FShow);


// ================================================================
// Parameter

typedef  16 IOWordLength;

// ================================================================
// Interface

interface GPIO_IFC;
   // set_addr_map should be called after this module's reset
   method Action set_addr_map (Fabric_Addr addr_base, Fabric_Addr addr_lim);

   // Main Fabric Reqs/Rsps
   interface APB_Target_IFC target;

   // to external world
   (* always_ready *) method Bit #(IOWordLength) out;
endinterface

(*doc="16-bit GPIO behind 32-bit APB4 interface"*)
(*doc="Word-addressed"*)
(*doc="Single 16-bit register at offset 0x0"*)
(*doc="Word writes at offset 0x0 will trigger error response"*)
(*doc="Byte/Half-Word/Word reads at offset 0x0 are okay"*)
(*doc="All R/W accesses at non-0x0 offset will trigger error response"*)
(* synthesize *)
module mkGPIO (GPIO_IFC);

   Bit #(2) verbosity = 0;

   // ----------------
   // AHB-Lite signals and registers

   // Inputs
   Wire #(Bool)        w_psel      <- mkBypassWire;
   Wire #(Bit #(32))   w_paddr     <- mkBypassWire;
   Wire #(Bool)        w_penable   <- mkBypassWire;
   Wire #(Bit #(32))   w_pwdata    <- mkBypassWire;
   Wire #(Bool)        w_pwrite    <- mkBypassWire;
   Wire #(Bit #(4))    w_pstrb     <- mkBypassWire;
   Wire #(Bit #(3))    w_pprot     <- mkBypassWire; 

   Reg #(Bool)        rg_sel       <- mkReg (False);
   Reg #(Bit #(32))   rg_pwdata    <- mkReg (0);
   Reg #(Bit #(4))    rg_pstrb     <- mkReg (0);

   Reg #(Bool)        rg_pready    <- mkReg (False);
   Reg #(Bool)        rg_slverr    <- mkReg (False);

   Reg  #(Tgt_State)   rg_state    <- mkReg (IDLE);

   // ----------------
   Reg #(Bool)                   rg_module_ready   <- mkReg (False);

   Reg #(Fabric_Addr)            rg_addr_base      <- mkRegU;
   Reg #(Fabric_Addr)            rg_addr_lim       <- mkRegU;
   Reg #(Bit #(IOWordLength))    rg_gpio_out       <- mkReg(0);

   // ----------------
   function Bool fn_addr_is_aligned (Fabric_Addr addr);
      return (addr [1:0] == 2'b_00);
   endfunction

   function Bool fn_addr_is_in_range (
      Fabric_Addr base, Fabric_Addr addr, Fabric_Addr lim);
      return ((base <= addr) && (addr < lim));
   endfunction

   function Bool fn_addr_is_ok (Fabric_Addr base, Fabric_Addr addr, Fabric_Addr lim);
      let offset = (addr - base);
      return (   fn_addr_is_aligned (addr)
	      && fn_addr_is_in_range (base, addr, lim)
              && (offset == 0)  // Only a single register is supported at offset 0
              );
   endfunction

   // Is the address okay? Use the raw address from the bus as this check is done
   // in the first phase.
   let addr_is_ok   = fn_addr_is_ok (rg_addr_base, w_paddr, rg_addr_lim);
   
   // Generate the new word (on writes)
   let new_word = fn_replace_bytes (rg_pstrb, extend (rg_gpio_out), rg_pwdata);

   // Look for strobe errors on writes
   Bool werr = (   (w_pstrb != 4'b0001)
                && (w_pstrb != 4'b0010)
                && (w_pstrb != 4'b0011));
   Bool rerr = (   (w_pstrb != 4'b0000));

   // ================================================================
   // BEHAVIOR

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_new_read_tfr (
      rg_module_ready && w_psel && w_penable && !w_pwrite && (rg_state == IDLE));
      rg_pready <= True;                  // response ready
      rg_slverr <= !addr_is_ok || rerr;   // signal error in the response phase
      rg_state <= RD_RSP;
      if (verbosity > 0) $display ("%0d: %m.rl_new_read_tfr: (paddr %08h) "
         , $time, w_paddr, fshow (rg_state));
   endrule

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_read_response (rg_state == RD_RSP);
      rg_pready <= False;  // reset ready (getting ready for next req)
      rg_slverr <= False;  // reset error signal (not strictly necessary)
      rg_state <= IDLE;    // back to waiting for next req
      if (verbosity > 0) $display ("%0d: %m.rl_read_response: (data %08h) "
         , $time, rg_gpio_out
         , "(err ", fshow (rg_slverr), ") ", fshow (rg_state));
   endrule

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_new_write_tfr (
      rg_module_ready && w_psel && w_penable && w_pwrite && (rg_state == IDLE));
      rg_pwdata <= w_pwdata;
      rg_pstrb <= w_pstrb;
      rg_pready <= True;               // response ready
      rg_slverr <= !addr_is_ok || werr;// signal error in the response phase
      rg_state <= WR_RSP;
      if (verbosity > 0) $display ("%0d: %m.rl_new_write_tfr: ", $time, fshow (rg_state)
         , "(paddr %08h) (pstrb %04b) (pwdata %08h)"
         , w_paddr, w_pstrb, w_pwdata
         );
   endrule

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_write_response (rg_state == WR_RSP);
      rg_pready <= False;  // reset ready (getting ready for next req)
      rg_slverr <= False;  // reset error signal (not strictly necessary)
      rg_state <= IDLE;    // back to waiting for next req
      rg_gpio_out <= truncate (new_word);
      if (verbosity > 0) $display ("%0d: %m.rl_write_response: (data %08h) ", $time, new_word
         , "(err ", fshow (rg_slverr), ") ", fshow (rg_state));
   endrule

   // ================================================================
   // INTERFACE

   // set_addr_map should be called after this module's reset
   method Action set_addr_map (Fabric_Addr addr_base, Fabric_Addr addr_lim);
      if (addr_base [1:0] != 0)
         $display ("%0d: WARNING: %m.set_addr_map: addr_base 0x%0h is not 4-Byte-aligned",
                   cur_cycle, addr_base);

      if (addr_lim [1:0] != 0)
         $display ("%0d: WARNING: %m.set_addr_map: addr_lim 0x%0h is not 4-Byte-aligned",
                   cur_cycle, addr_lim);

      rg_addr_base    <= addr_base;
      rg_addr_lim     <= addr_lim;
      rg_module_ready <= True;
      if (verbosity > 0) begin
	 $display ("%0d: %m.set_addr_map: base 0x%0h lim 0x%0h"
            , cur_cycle, addr_base, addr_lim);
      end
   endmethod

   interface APB_Target_IFC target;
      // ----------------
      // Inputs

      method Action psel (Bool sel);
         w_psel <= sel;
      endmethod

      method Action penable (Bool en);
         w_penable <= en;
      endmethod

      method Action paddr (Bit #(32) addr);
         w_paddr <= addr;
      endmethod

      method Action pwdata(Bit #(32) data);
         w_pwdata <= data;
      endmethod

      method Action pprot (Bit #(3) prot);
         w_pprot <= prot;
      endmethod

      method Action pstrb (Bit #(4) strb);
         w_pstrb <= strb;
      endmethod

      method Action pwrite (Bool write);
         w_pwrite <= write;
      endmethod

      // ----------------
      // Outputs

      method Bool       pready    = rg_pready;
      method Bool       pslverr   = rg_slverr;
      method Bit #(32)  prdata    = extend (rg_gpio_out);
   endinterface
   method Bit #(IOWordLength) out = rg_gpio_out;
endmodule

// ================================================================
// APB data is aligned to byte lanes based on pstrb
// This function replaces the appropriate bytes of 'old_word'
// with the appropriate bytes of PWDATA depending on the pstrb
// Also returns err=True for unsupported 'size' and misaligned addrs.
//
// XXX This function currently returns an error for any writes beyond
// 16 bits. Change if IOWordLength != 16.

function Bit #(32) fn_replace_bytes (  Bit #(4)   strb 
                                     , Bit #(32)  orig
                                     , Bit #(32)  data);
   let err = False;
   let new_word = orig;
   case (strb)
      4'b0001 : new_word = {orig [31:24], orig [23:16], orig [15:8], data [7:0]};
      4'b0010 : new_word = {orig [31:24], orig [23:16], data [15:8], orig [7:0]};
      4'b0011 : new_word = {orig [31:16], data [15:0]};
      default : err = True;
   endcase
   return new_word;
endfunction

endpackage
