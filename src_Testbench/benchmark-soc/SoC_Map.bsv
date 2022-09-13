// Copyright (c) 2013-2020 Bluespec, Inc. All Rights Reserved

package SoC_Map;

// ================================================================
// This module defines the overall 'address map' of the SoC,
// showing the addresses serviced by each target IP, and which
// addresses are memory vs. I/O.

// ***** WARNING! WARNING! WARNING! *****

// During system integration, this address map should be identical
// to the system interconnect settings (e.g., routing of requests
// between initiators and targets).  This map is also needed by
// software so that it knows how to address various IPs.

// This module contains no state; it just has constants, and so can
// be freely instantiated at multiple places in the SoC module
// hierarchy at no hardware cost.  It allows this map to be defined
// in one place and shared across the SoC.

// ================================================================
// Exports

export  SoC_Map_IFC (..), mkSoC_Map;

export  Num_Initiators;
export  cpu_ini_num;

export  Num_Trgts;
export  uart_trgt_num;
export  gpio_trgt_num;

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

   (* always_ready *)   method  Fabric_Addr  m_uart_addr_base;
   (* always_ready *)   method  Fabric_Addr  m_uart_addr_size;
   (* always_ready *)   method  Fabric_Addr  m_uart_addr_lim;

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
   Fabric_Addr clint_addr_base   = 'h_1000_0000;
   Fabric_Addr clint_addr_size   = 'h_0000_C000;
   Fabric_Addr clint_addr_lim    = 'h_1000_C000;

   // UART 0
   Fabric_Addr uart_addr_base    = 'h_6230_0000;
   Fabric_Addr uart_addr_size    = 'h_0000_1000;    // 128
   Fabric_Addr uart_addr_lim     = 'h_6230_1000;

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

   method  Fabric_Addr  m_uart_addr_base = uart_addr_base;
   method  Fabric_Addr  m_uart_addr_size = uart_addr_size;
   method  Fabric_Addr  m_uart_addr_lim  = uart_addr_lim;

endmodule

// ================================================================
// Count and master-numbers of masters in the fabric.

typedef 1 Num_Initiators;
Integer cpu_ini_num = 0;

// ================================================================
// Count and slave-numbers of slaves in the fabric.

typedef 2 Num_Trgts;
Integer uart_trgt_num  = 0;
Integer gpio_trgt_num  = 1;

// ================================================================

endpackage
