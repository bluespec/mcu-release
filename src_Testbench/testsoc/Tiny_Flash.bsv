// Copyright (c) 2016-2019 Bluespec, Inc. All Rights Reserved

package Tiny_Flash;
/*
This version is for preloading the tcms in the MicroSemi version
of NG's xSoC
 */
// ================================================================
// This package implements a Flash IP that is a ROM of
// 64K 32b locations.
// - Ignores all writes, always responsing OKAY
// - Assumes all reads are 4-byte aligned requests for 4-bytes

// ================================================================
// BSV library imports

import ConfigReg :: *;
import RegFile   :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;
import Semi_FIFOF :: *;

// ================================================================
// Project imports

import AXI4_Types  :: *;
import Fabric_Defs :: *;

// The ROM "image"
`include  "fn_read_ROM_RV32.bsvi"

// ================================================================
// Interface

Fabric_Addr flash_size = 'h_40; // (in bytes) 64

interface Flash_IFC;
   // Main Fabric Reqs/Rsps
   interface AXI4_Slave_IFC #(0, Wd_Addr, Wd_Data, Wd_User) slave;
endinterface

// ================================================================

(* synthesize *)
module mkFlash (Flash_IFC);

   // Verbosity: 0: quiet; 1: reads/writes
   Integer verbosity = 0;

   Reg #(Bool) rg_module_ready <- mkReg (True);

   Reg #(Fabric_Addr)  rg_addr_base <- mkReg(0);
   Reg #(Fabric_Addr)  rg_addr_lim  <- mkReg(flash_size); // 64B

   // ----------------
   // Connector to fabric

   AXI4_Slave_Xactor_IFC #(0, Wd_Addr, Wd_Data, Wd_User) slave_xactor <- mkAXI4_Slave_Xactor;

   // ----------------

   function Bool fn_addr_is_aligned (Fabric_Addr addr, AXI4_Size size);
      case (size)
	 axsize_8: return (addr [2:0] == 0);
	 axsize_4: return (addr [1:0] == 0);
	 axsize_2: return (addr [0] == 0);
	 axsize_1: return (True);
	 default:  return (False);
      endcase
   endfunction

   function Bool fn_addr_is_in_range (Fabric_Addr base, Fabric_Addr addr, Fabric_Addr lim);
      return ((base <= addr) && (addr < lim));
   endfunction

   function Bool fn_addr_is_ok (Fabric_Addr addr, AXI4_Size size, Fabric_Addr base, Fabric_Addr lim);
      return (   fn_addr_is_aligned (addr, size)
	      && fn_addr_is_in_range (base, addr, lim));
   endfunction

   // ================================================================
   // BEHAVIOR

   // ----------------------------------------------------------------
   // Handle fabric read requests

   rule rl_process_rd_req (rg_module_ready);
      let rda <- pop_o (slave_xactor.o_rd_addr);

      let raw_byte_addr = (rda.araddr - rg_addr_base);
      Bit #(8) rom_addr = truncate (raw_byte_addr);
      Bit #(Wd_Data) rdata = fn_read_ROM_0 (rom_addr);

      AXI4_Resp  rresp  = axi4_resp_okay;
      if (! fn_addr_is_ok (raw_byte_addr, rda.arsize, rg_addr_base, rg_addr_lim)) begin
	 rresp = axi4_resp_slverr;
	 $display ("%0d: ERROR: Flash.rl_process_rd_req: unrecognized or misaligned addr",  cur_cycle);
	 $display ("    ", fshow (rda));
      end

      let rdr = AXI4_Rd_Data {rid:   rda.arid,
			      rdata: rdata,
			      rresp: rresp,
			      rlast: True,
			      ruser: rda.aruser};
      slave_xactor.i_rd_data.enq (rdr);

      if (verbosity > 0) begin
	 $display ("%0d: Flash.rl_process_rd_req: ", cur_cycle);
	 $display ("        ", fshow (rda));
	 $display ("     => ", fshow (rdr));
      end
   endrule

   // ----------------------------------------------------------------
   // Handle fabric write requests: ignore all of them (this is a ROM)

   rule rl_process_wr_req (rg_module_ready);
      let wra <- pop_o (slave_xactor.o_wr_addr);
      let wrd <- pop_o (slave_xactor.o_wr_data);

      AXI4_Resp  bresp = axi4_resp_okay;
      if (! fn_addr_is_ok (wra.awaddr, wra.awsize, rg_addr_base, rg_addr_lim)) begin
	 bresp = axi4_resp_slverr;
	 $display ("%0d: ERROR: Flash.rl_process_wr_req: unrecognized addr",  cur_cycle);
	 $display ("    ", fshow (wra));
      end

      let wrr = AXI4_Wr_Resp {bid:   wra.awid,
			      bresp: bresp,
			      buser: wra.awuser};
      slave_xactor.i_wr_resp.enq (wrr);

      if (verbosity > 0) begin
	 $display ("%0d: Flash.rl_process_wr_req; ignoring all writes", cur_cycle);
	 $display ("        ", fshow (wra));
	 $display ("        ", fshow (wrd));
	 $display ("     => ", fshow (wrr));
      end
   endrule

   // ================================================================
   // INTERFACE

   // Main Fabric Reqs/Rsps
   interface  slave = slave_xactor.axi_side;
endmodule

// ================================================================

endpackage
