// Copyright (c) 2017 Bluespec, Inc.  All Rights Reserved

package GPIO_AHBL;

// ================================================================
// A simple GPIO model that sits behind an AHBL interface
// - Word addressed 
// - Supports 32b reads only (ignores HADDR [1:0]
// - Supports reporting ERROR responses
// - Does not support HTRANS_SEQ and HTRANS_BUSY
// ================================================================
// BSV lib imports

import DefaultValue        :: *;

// ================================================================
// Project imports

import Cur_Cycle           :: *;
import Fabric_Defs         :: *;
import AHBL_Defs           :: *;
import AHBL_Types          :: *;


// ================================================================
// Parameter

typedef  16 IOWordLength;
typedef enum { RDY, RSP, ERR } Tgt_State deriving (Bits, Eq, FShow);

// ================================================================
// Interface

interface GPIO_IFC;
   // Main Fabric Reqs/Rsps
   interface AHBL_Slave_IFC #(AHB_Wd_Data) target;

   // to external world
   (* always_ready *) method Bit #(IOWordLength) out;
endinterface

(*doc="16-bit GPIO behind 32-bit AHB-L interface"*)
(*doc="Word-addressed"*)
(*doc="Single 16-bit register at offset 0x0"*)
(*doc="Word writes at offset 0x0 will ignore upper 16 bits"*)
(*doc="Byte/Half-Word/Word reads at offset 0x0 are okay"*)
(*doc="All R/W accesses at non-0x0 offset will trigger error response"*)
(* synthesize *)
module mkGPIO (GPIO_IFC);

   Bit #(2) verbosity = 0;

   // ----------------
   // AHB-Lite signals and registers

   // Inputs
   Wire #(Bool)        w_hsel      <- mkBypassWire;
   Wire #(Bool)        w_hready_in <- mkBypassWire;
   Wire #(Bit #(32))   w_haddr     <- mkBypassWire;
   Wire #(AHBL_Burst)  w_hburst    <- mkBypassWire;
   Wire #(Bool)        w_hmastlock <- mkBypassWire;
   Wire #(AHBL_Prot)   w_hprot     <- mkBypassWire;
   Wire #(AHBL_Size)   w_hsize     <- mkBypassWire;
   Wire #(AHBL_Trans)  w_htrans    <- mkBypassWire;
   Wire #(Bit #(32))   w_hwdata    <- mkBypassWire;
   Wire #(Bool)        w_hwrite    <- mkBypassWire;

   // Outputs
   Reg  #(Bool)       rg_hready    <- mkReg(True);
   Reg  #(AHBL_Resp)  rg_hresp     <- mkReg(AHBL_OKAY);

   Reg #(Bit #(32))   rg_haddr     <- mkRegU;
   Reg #(AHBL_Size)   rg_hsize     <- mkReg (AHBL_BITS32);
   Reg #(AHBL_Trans)  rg_htrans    <- mkReg (AHBL_NONSEQ);
   Reg #(Bool)        rg_hwrite    <- mkReg (False);

   // ----------------
   Reg #(Tgt_State)   rg_state     <- mkReg (RDY);
   Reg #(Bit #(IOWordLength))    rg_gpio_out       <- mkReg(0);


   Fabric_Addr  addr_mask = 32'hff;

   // ----------------
   // Is the address okay? Use the raw address from the bus as this check is done
   // in the first phase.
   let addr_is_ok = fn_ahbl_is_aligned (w_haddr[1:0], w_hsize);
   
   // Generate the new word (on writes)
   let word_addr    = rg_haddr [31:2];
   let byte_in_word = rg_haddr [1:0];
   let new_word = fn_replace_bytes (byte_in_word, rg_hsize, extend (rg_gpio_out), w_hwdata);

   // ================================================================
   // BEHAVIOR

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_new_req (   (rg_state == RDY)
                    && (w_hsel && w_hready_in && (w_htrans == AHBL_NONSEQ)));

      // Register fresh address-and-control inputs
      rg_haddr     <= w_haddr;
      rg_hsize     <= w_hsize;
      rg_htrans    <= w_htrans;
      rg_hwrite    <= w_hwrite;


      if (addr_is_ok) begin
         rg_state    <= RSP;
         rg_hready   <= True;
         rg_hresp    <= AHBL_OKAY;
      end

      // Error case (two cycle response)
      else begin
         rg_state    <= ERR;
         rg_hready   <= False;
         rg_hresp    <= AHBL_ERROR;
      end

      if (verbosity != 0)
         $display ("%06d:[D]:%m.rl_new_req:(haddr 0x%08h)", cur_cycle, w_haddr
            , "(hsize ", fshow (w_hsize)
            , ")(hwrite ", fshow (w_hwrite)
            , ")(htrans ", fshow (w_htrans), ")");
   endrule

   rule rl_data (rg_state == RSP);
      // Writes
      if (rg_hwrite) begin
         rg_gpio_out <= truncate (new_word);
         if (verbosity != 0)
            $display ("    write: [0x%08h]: 0x%08h <= 0x%08h", {word_addr, 2'b0} , rg_gpio_out, new_word);

      end

      // Reads
      else begin 
         if (verbosity != 0)
            $display ("    read: [0x%08h] => rdata 0x%08h", {word_addr, 2'b0} , rg_gpio_out);

      end
      rg_state <= RDY;
      rg_hready <= True;
   endrule

   rule rl_idle (   (rg_state == RDY)
                 && (w_hsel && (w_htrans == AHBL_IDLE)));
      rg_hready <= True;
   endrule

   rule rl_error (rg_state == ERR);
      rg_state <= RDY;
      rg_hready <= True;
      rg_hresp  <= AHBL_OKAY;
   endrule

   // ================================================================
   // INTERFACE

   method Bit #(IOWordLength) out = rg_gpio_out;

   interface AHBL_Slave_IFC target;
      // ----------------
      // Inputs

      method Action hsel (Bool sel);
         w_hsel <= sel;
      endmethod

      method Action hready (Bool hready_in);
         w_hready_in <= hready_in;
      endmethod

      method Action haddr (Bit #(32) addr);
         w_haddr <= addr;
      endmethod

      method Action hburst (AHBL_Burst burst);
         w_hburst <= burst;
      endmethod

      method Action hmastlock (Bool mastlock);
         w_hmastlock <= mastlock;
      endmethod

      method Action hprot (AHBL_Prot prot);
         w_hprot <= prot;
      endmethod

      method Action hsize (AHBL_Size size);
         w_hsize <= size;
      endmethod

      method Action htrans (AHBL_Trans trans);
         w_htrans <= trans;
      endmethod

      method Action hwdata(Bit #(32) data);
         w_hwdata <= data;
      endmethod

      method Action hwrite (Bool write);
         w_hwrite <= write;
      endmethod

      // ----------------
      // Outputs

      method Bool       hreadyout = rg_hready;
      method AHBL_Resp  hresp     = rg_hresp;
      method Bit #(32)  hrdata    = extend (rg_gpio_out);
   endinterface
endmodule

// ================================================================
// AHBL data is aligned to byte lanes based on addr lsbs.
// This function replaces the appropriate bytes of 'old_word'
// with the appropriate bytes of HWDATA depending on the address LSBs and transfer size.
// Also returns err=True for unsupported 'size' and misaligned addrs.

function Bool fn_is_aligned (Bit #(2) addr_lsbs, AHBL_Size size);
   let is_aligned = True;
   case (size)
      AHBL_BITS8  : return (True);
      AHBL_BITS16 : case (addr_lsbs)
		       2'b00: return (True);
		       2'b10: return (True);
		       default: return (False);
		    endcase
      AHBL_BITS32 : case (addr_lsbs)
		       2'b00: return (True);
		       default: return (False);
		    endcase
      default: return (False);
   endcase
endfunction

function Bit #(32) fn_replace_bytes (  Bit #(2) addr_lsbs
                                     , AHBL_Size  size
                                     , Bit #(32)  old_word
                                     , Bit #(32)  hwdata);

   let new_word = old_word;
   case (size)
      AHBL_BITS8:  case (addr_lsbs)
		      2'b00: new_word = { old_word [31:24], old_word [23:16], old_word [15:8], hwdata   [7:0] };
		      2'b01: new_word = { old_word [31:24], old_word [23:16], hwdata   [15:8], old_word [7:0] };
		      2'b10: new_word = { old_word [31:24], hwdata   [23:16], old_word [15:8], old_word [7:0] };
		      2'b11: new_word = { hwdata   [31:24], old_word [23:16], old_word [15:8], old_word [7:0] };
		   endcase
      AHBL_BITS16: case (addr_lsbs)
		      2'b00: new_word = { old_word [31:16], hwdata   [15:0] };
		      2'b10: new_word = { hwdata   [31:16], old_word [15:0] };
		   endcase
      AHBL_BITS32: case (addr_lsbs)
		      2'b00: new_word = hwdata;
		   endcase
   endcase
   return new_word;
endfunction

endpackage
