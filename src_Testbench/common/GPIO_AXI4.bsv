// Copyright (c) 2016-2019 Bluespec, Inc. All Rights Reserved

package GPIO_AXI4;

// ================================================================
/*
16-bit GPIO behind 32-bit AXI4 interface
Word-addressed
Single 16-bit register at offset 0x0
Word writes at offset 0x0 will ignore upper 16 bits
Byte/Half-Word/Word reads at offset 0x0 are okay
All R/W accesses at non-0x0 offset will trigger error response
*/

// ================================================================
// BSV library imports

import ConfigReg :: *;
import Clocks    :: *;
import Vector    :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;
import Semi_FIFOF :: *;

// ================================================================
// Project imports

import AXI4_Types  :: *;
import Fabric_Defs :: *;
import SoC_Map     :: *;

// ================================================================
// Parameter

typedef 16 IOWordLength;
typedef 32 HostWordLength;

// ================================================================
// Functions

function Bit#(n) maskdata(Bit#(n) origdata, Bit#(n) newdata, Bit#(1) mask)
   provisos (Add#(1,_x,n));
   return (newdata & signExtend(mask)) | (origdata & ~ signExtend(mask));
endfunction

function Bit#(d) updateDataWithStrobe(Bit#(d) origdata, Bit#(d) newdata, Bit#(d8) strobe)
   provisos(Mul#(d8, 8, d));
   return pack(zipWith3(maskdata, unpack(zeroExtend(origdata)), unpack(zeroExtend(newdata)), unpack(strobe)));
endfunction

// ================================================================
// Interface

interface GPIO_IFC;
   // Main Fabric Reqs/Rsps
   interface AXI4_Slave_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) axi4;

   // to external world
   (* always_ready *) method Bit #(IOWordLength) out;
endinterface

// ================================================================

(*doc="16-bit GPIO behind 32-bit AXI4 interface"*)
(*doc="Word-addressed"*)
(*doc="Single 16-bit register at offset 0x0"*)
(*doc="Word writes at offset 0x0 will ignore upper 16 bits"*)
(*doc="Byte/Half-Word/Word reads at offset 0x0 are okay"*)
(*doc="All R/W accesses at non-0x0 offset will trigger error response"*)
(* synthesize *)
module mkGPIO (GPIO_IFC);

   // Verbosity: 0: quiet; 1: reads/writes
   Integer verbosity = 0;

   SoC_Map_IFC soc_map <- mkSoC_Map;

   // ----------------
   // Connector to fabric

   AXI4_Slave_Xactor_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) slave_xactor <- mkAXI4_Slave_Xactor;

   // ----------------

   function Bool fn_addr_is_aligned (Fabric_Addr addr);
      return (addr [1:0] == 2'b_00);
   endfunction

   function Bool fn_addr_is_ok (Fabric_Addr base, Fabric_Addr addr);
      return (fn_addr_is_aligned (addr) && (addr == base));
   endfunction

   // ================================================================
   // BEHAVIOR

   Reg #(Bit #(IOWordLength))     rg_bitsIn  <- mkReg(0);
   Reg #(Bit #(IOWordLength))    rg_bitsOut  <- mkReg(0);

   Reg #(Bit #(HostWordLength))   rg_toHost  <- mkReg(0);
   Reg #(Bit #(HostWordLength)) rg_fromHost  <- mkReg(0);

   Reg #(Bit #(IOWordLength)) rg_last_bitsIn <- mkReg(0);
   
   // ----------------------------------------------------------------
   // Handle fabric read requests

   rule rl_process_rd_req;
      let rda <- pop_o (slave_xactor.o_rd_addr);

      let base_addr = soc_map.m_gpio_addr_base;
      let byte_addr = rda.araddr - base_addr;

      AXI4_Resp  rresp = axi4_resp_okay;
      if (! fn_addr_is_ok (base_addr, rda.araddr)) begin
	 rresp = axi4_resp_slverr;
	 $display ("%06d:[E]:%m.rl_process_rd_req: Invalid addr", cur_cycle);
	 $display ("    ", fshow (rda));
      end

      let rdr = AXI4_Rd_Data {rid:   rda.arid,
			      rdata: zeroExtend (rg_bitsOut),
			      rresp: rresp,
			      rlast: True,
			      ruser: rda.aruser};
      slave_xactor.i_rd_data.enq (rdr);
   endrule

   // ----------------------------------------------------------------
   // Handle fabric write requests: rg_bitsOut only valid address

   rule rl_process_wr_req;
      let wra <- pop_o (slave_xactor.o_wr_addr);
      let wrd <- pop_o (slave_xactor.o_wr_data);

      let base_addr = soc_map.m_gpio_addr_base;
      AXI4_Resp  bresp = axi4_resp_okay;

      if (! fn_addr_is_ok (base_addr, wra.awaddr)) begin
	 bresp = axi4_resp_slverr;
	 $display ("%06d:[E]:%m.rl_process_wr_req: Invalid addr", cur_cycle);
	 $display ("    ", fshow (wra));
      end
      else begin
         rg_bitsOut  <= updateDataWithStrobe (
            rg_bitsOut,  truncate (wrd.wdata), truncate(wrd.wstrb));
      end

      let wrr = AXI4_Wr_Resp {bid:   wra.awid,
			      bresp: bresp,
			      buser: wra.awuser};
      slave_xactor.i_wr_resp.enq (wrr);

      if (verbosity > 0) begin
	 $display ("%06d:[D]:%m.rl_process_wr_req:", cur_cycle);
	 $display ("        ", fshow (wra));
	 $display ("        ", fshow (wrd));
	 $display ("     => ", fshow (wrr));
      end
   endrule

   // ================================================================
   // INTERFACE

   // Main Fabric Reqs/Rsps
   interface  axi4 = slave_xactor.axi_side;

   method Bit #(IOWordLength) out = rg_bitsOut;
endmodule

// ================================================================

endpackage
