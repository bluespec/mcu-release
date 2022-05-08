// Copyright (c) 2013-2020 Bluespec, Inc. All Rights Reserved

package SoC_Map;

// ================================================================
// This module defines the overall 'address map' of the SoC, showing
// the addresses serviced by each slave IP, and which addresses are
// memory vs. I/O.

// ***** WARNING! WARNING! WARNING! *****

// During system integration, this address map should be identical to
// the system interconnect settings (e.g., routing of requests between
// masters and slaves).  This map is also needed by software so that
// it knows how to address various IPs.

// This module contains no state; it just has constants, and so can be
// freely instantiated at multiple places in the SoC module hierarchy
// at no hardware cost.  It allows this map to be defined in one
// place and shared across the SoC.

// ================================================================
// Exports

export  SoC_Map_IFC (..), mkSoC_Map;

// export  fn_addr_in_range;

export  Num_Masters;
export  dmem_master_num;

export  Num_Slaves;
export  gpio_slave_num;

// ================================================================
// Bluespec library imports

// None

// ================================================================
// Project imports

import Fabric_Defs   :: *; // Only for type Fabric_Addr

// ================================================================
// Interface and module for the address map

interface SoC_Map_IFC;
   (* always_ready *)   method  Fabric_Addr  m_gpio_addr_base;
   (* always_ready *)   method  Fabric_Addr  m_gpio_addr_size;
   (* always_ready *)   method  Fabric_Addr  m_gpio_addr_lim;

   (* always_ready *)   method  Fabric_Addr  m_plic_addr_base;
   (* always_ready *)   method  Fabric_Addr  m_plic_addr_size;
   (* always_ready *)   method  Fabric_Addr  m_plic_addr_lim;

   (* always_ready *)   method  Fabric_Addr  m_clint_addr_base;
   (* always_ready *)   method  Fabric_Addr  m_clint_addr_size;
   (* always_ready *)   method  Fabric_Addr  m_clint_addr_lim;
endinterface

// ================================================================

(* synthesize *)
module mkSoC_Map (SoC_Map_IFC);

   // ----------------------------------------------------------------
   // GPIO
   Fabric_Addr gpio_addr_base    = 'h6FFF_0000;
   Fabric_Addr gpio_addr_size    = 'h0000_0040;
   Fabric_Addr gpio_addr_lim     = 'h6FFF_0040;

   // PLIC
   Fabric_Addr plic_addr_base    = 'h_0C00_0000;
   Fabric_Addr plic_addr_size    = 'h_0040_0000;
   Fabric_Addr plic_addr_lim     = 'h_0C40_0000;

   // CLINT
   Fabric_Addr clint_addr_base   = 'h_0200_0000;
   Fabric_Addr clint_addr_size   = 'h_0000_C000;
   Fabric_Addr clint_addr_lim    = 'h_0200_C000;

   // ================================================================
   // INTERFACE

   method  Fabric_Addr  m_gpio_addr_base = gpio_addr_base;
   method  Fabric_Addr  m_gpio_addr_size = gpio_addr_size;
   method  Fabric_Addr  m_gpio_addr_lim  = gpio_addr_lim;

   method  Fabric_Addr  m_plic_addr_base = plic_addr_base;
   method  Fabric_Addr  m_plic_addr_size = plic_addr_size;
   method  Fabric_Addr  m_plic_addr_lim  = plic_addr_lim;

   method  Fabric_Addr  m_clint_addr_base = clint_addr_base;
   method  Fabric_Addr  m_clint_addr_size = clint_addr_size;
   method  Fabric_Addr  m_clint_addr_lim  = clint_addr_lim;
endmodule

// ================================================================
// Count and master-numbers of masters in the fabric.

Integer dmem_master_num   = 0;
typedef 1 Num_Masters;

// ================================================================
// Count and slave-numbers of slaves in the fabric.

typedef 3 Num_Slaves;

Integer gpio_slave_num  = 0;
Integer plic_slave_num  = 1;
Integer clint_slave_num = 2;

// ================================================================

endpackage
