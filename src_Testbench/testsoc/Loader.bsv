package Loader;

import Connectable :: *;
import Tiny_Flash  :: *;
import AXI4_Types  :: *;
import Fabric_Defs :: *;
import Core_Map    :: *;
import StmtFSM     :: *;
import Semi_FIFOF  :: *;

// ================================================================
// Skeleton values for structs

AXI4_Wr_Addr #(Wd_Id, Wd_Addr, Wd_User) def_wr_addr =
      AXI4_Wr_Addr {awid:     0,
		    awaddr:   (?),
		    awlen:    0,
		    awsize:   axsize_4,
		    awburst:  axburst_incr,
		    awlock:   axlock_normal,
		    awcache:  awcache_dev_nonbuf,
		    awprot:   0,
		    awqos:    0,
		    awregion: 0,
		    awuser:   0};

AXI4_Wr_Data #(Wd_Data, Wd_User) def_wr_data =
      AXI4_Wr_Data {wdata: (?),
		    wstrb: 'hF,
		    wlast: True,
		    wuser: 0};

AXI4_Rd_Addr #(0, Wd_Addr, Wd_User) def_rd_addr =
      AXI4_Rd_Addr {arid:     0,
		    araddr:   (?),
		    arlen:    0,
		    arsize:   axsize_4,
		    arburst:  axburst_incr,
		    arlock:   axlock_normal,
		    arcache:  arcache_dev_nonbuf,
		    arprot:   0,
		    arqos:    0,
		    arregion: 0,
		    aruser:   0};

// ================================================================
// Interface

interface Loader_Control_IFC;
   // This is where the loader gets the load from (not shown in NG's diagram):
   interface AXI4_Master_IFC #(0, Wd_Addr, Wd_Data, Wd_User)     toFlash;
   interface Loader_IFC cpu_ifc;
endinterface

interface Loader_IFC;
   // These are the interface components shown in NG's diagram:
   interface AXI4_Master_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) toFabric;
   (*always_ready*)                    method Bool               cpu_halt;
   (*always_ready, always_enabled*)    method Action             reset_done(Bool x);
endinterface

// ================================================================

(*synthesize*)
module mkLoader (Loader_IFC);
   Loader_Control_IFC ctrler <- mkLoad_Control;
   let flash  <- mkFlash;
   mkConnection (ctrler.toFlash, flash.slave);

   interface AXI4_Master_IFC toFabric = ctrler.cpu_ifc.toFabric;
   method Bool cpu_halt = ctrler.cpu_ifc.cpu_halt;
   method Action reset_done (Bool x);
      ctrler.cpu_ifc.reset_done (x);
   endmethod
endmodule


(*synthesize*)
module mkLoad_Control (Loader_Control_IFC);
   Core_Map_IFC addr_map <- mkCore_Map;

   // Register the methods:
   Reg #(Bool) rg_cpu_halt   <- mkReg(False);
   Reg #(Bool) rg_reset_done <- mkReg(False);

   AXI4_Master_Xactor_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) fabricXactor <- mkAXI4_Master_Xactor;
   AXI4_Master_Xactor_IFC #(0,     Wd_Addr, Wd_Data, Wd_User) flashXactor  <- mkAXI4_Master_Xactor;

   // FSM counters:
   Reg #(Fabric_Addr) req_cnt <- mkRegU;
   Reg #(Fabric_Addr) cpy_cnt <- mkRegU;
   Reg #(Fabric_Addr) dcpy_cnt <- mkRegU;
   Reg #(Fabric_Addr) rsp_cnt <- mkRegU;
   Reg #(Fabric_Addr) wrt_cnt <- mkRegU;

   Reg #(Fabric_Addr) rg_offset  <- mkReg('h_C000_0000);

   let itcm_size_words = (addr_map.m_itcm_addr_size >> 2);
   let dtcm_size_words = (addr_map.m_dtcm_addr_size >> 2);

   // FSM for loading tcms (note: no checking for errors yet):
   mkAutoFSM (
      seq
	 await (rg_reset_done);
	 // delay (initial_wait); // optional
	 action
	    rg_cpu_halt <= True;
	    // and initialize the counters:
	    req_cnt <= 0;
	    cpy_cnt <= 0;
	    dcpy_cnt <= 0;
	    rsp_cnt <= 0;
	    wrt_cnt <= 0;
	 endaction
	 await (!rg_reset_done);
	 action
	    await (rg_reset_done);
	    $display("Loading starting");
	 endaction
	 par
	    seq
	       // request data from flash:
	       while (req_cnt < flash_size)
		  action
		     let req = def_rd_addr;
`ifdef QUAD_SPI
		     req.araddr = req_cnt + 'h0040_0000;
`else
		     req.araddr = req_cnt;
`endif
		     flashXactor.i_rd_addr.enq (req);

		     req_cnt <= req_cnt + 4;
		  endaction
            endseq
	    seq
	       // copy data to tcms from ROM
	       while (cpy_cnt < flash_size)
		  action
		     let offset = rg_offset;

		     // get response from flash:
		     let rsp <- pop_o(flashXactor.o_rd_data);

		     let addr = cpy_cnt + offset;
		     // if address is a valid TCM address ...
		     if (    (addr_map.m_itcm_addr_base <= addr)
			  && (addr < addr_map.m_itcm_addr_lim))
			begin
			   // send to fabric, on AW and W channels:
			   let req = def_wr_addr;
			   req.awaddr = addr;
			   fabricXactor.i_wr_addr.enq (req);

			   let dta = def_wr_data;
			   dta.wdata = rsp.rdata;
			   fabricXactor.i_wr_data.enq (dta);

			   wrt_cnt <= wrt_cnt + 1;
			end

		     cpy_cnt <= cpy_cnt + 4;
//		     cpy_cnt <= cpy_cnt == 1024 ? (flash_size/2) : (cpy_cnt + 4);
		  endaction

               // fill up the rest of the ITCM with contents equal to addr
               while (cpy_cnt < itcm_size_words)
                  action
		     let offset = rg_offset;
		     let addr = cpy_cnt + offset;
		     cpy_cnt <= cpy_cnt + 4;
		     if (    (addr_map.m_itcm_addr_base <= addr)
                          && (addr < addr_map.m_itcm_addr_lim)) begin
			// send to fabric, on AW and W channels:
			let req = def_wr_addr;
			req.awaddr = addr;
			fabricXactor.i_wr_addr.enq (req);

			let dta = def_wr_data;
			dta.wdata = addr;
			fabricXactor.i_wr_data.enq (dta);

			wrt_cnt <= wrt_cnt + 1;
                     end
                  endaction

               // fill up the rest of the DTCM with contents equal to addr
               rg_offset <= 32'hc8000000;

               while (dcpy_cnt < dtcm_size_words)
                  action
		     let offset = rg_offset;
		     let addr = dcpy_cnt + offset;
		     dcpy_cnt <= dcpy_cnt + 4;
		     if (    (addr_map.m_dtcm_addr_base <= addr)
                          && (addr < addr_map.m_dtcm_addr_lim)) begin
			// send to fabric, on AW and W channels:
			let req = def_wr_addr;
			req.awaddr = addr;
			fabricXactor.i_wr_addr.enq (req);

			let dta = def_wr_data;
			dta.wdata = addr;
			fabricXactor.i_wr_data.enq (dta);

			wrt_cnt <= wrt_cnt + 1;
                     end
                  endaction
            endseq
	    seq
	       // field responses from fabric:
	       while (! (   (cpy_cnt  >= itcm_size_words)
                         && (dcpy_cnt >= dtcm_size_words)
                         && (rsp_cnt  == wrt_cnt)
                        ))
		  action
		     let rsp <- pop_o(fabricXactor.o_wr_resp);
		     rsp_cnt <= rsp_cnt + 1;
		  endaction
            endseq
	 endpar
	 rg_cpu_halt <= False;   // so that the processor remains halted
	 $display("Loading finished");
	 // Permanent wait, to prevent mkAutoFSM from ending and calling $finish:
	 await(False);
      endseq
	      );

   // Define the subinterfaces and methods:
   interface toFlash  = flashXactor.axi_side;
   interface Loader_IFC cpu_ifc;
      interface toFabric = fabricXactor.axi_side;
      method cpu_halt    = rg_cpu_halt;
      method reset_done  = rg_reset_done._write;
   endinterface
endmodule

endpackage
