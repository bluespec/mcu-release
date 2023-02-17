// Copyright (c) 2013-2019 Bluespec, Inc. All Rights Reserved

package SoC_Fabric;

// ================================================================
// Defines a SoC Fabric that is a specialization of AXI4_Fabric
// for this particular SoC.

// ================================================================
// Project imports

import AXI4_Types  :: *;
import AXI4_Fabric :: *;

import Fabric_Defs :: *;    // for Wd_Addr, Wd_Data, Wd_User
import SoC_Map     :: *;    // for Num_Masters, Num_Trgts

// ================================================================
// Trgt address decoder
// Identifies whether a given addr is legal and, if so, which  slave services it.

typedef Bit#(TLog#(Num_Trgts)) Trgt_Num;

// ================================================================
// Specialization of parameterized AXI4 fabric for this SoC.

typedef AXI4_Fabric_IFC #(Num_Initiators,
			  Num_Trgts,
			  Wd_Id,
			  Wd_Addr,
			  Wd_Data,
			  Wd_User)  Fabric_AXI4_IFC;

// ----------------

(* synthesize *)
module mkFabric_AXI4 (Fabric_AXI4_IFC);

   SoC_Map_IFC soc_map <- mkSoC_Map;

   function Tuple2 #(Bool, Trgt_Num) fn_addr_to_trgt_num  (Fabric_Addr addr);
      // UART
      if (   (soc_map.m_uart_addr_base <= addr)
	  && (addr < soc_map.m_uart_addr_lim))
	 return tuple2 (True, fromInteger (uart_trgt_num));

      // GPIO
      else if (   (soc_map.m_gpio_addr_base <= addr)
	       && (addr < soc_map.m_gpio_addr_lim))
	 return tuple2 (True, fromInteger (gpio_trgt_num));

      else
	 return tuple2 (False, ?);
   endfunction

   Fabric_AXI4_IFC fabric <- mkAXI4_Fabric (fn_addr_to_trgt_num);

   return fabric;
endmodule

// ================================================================

endpackage
