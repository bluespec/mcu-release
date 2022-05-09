###  -*-Makefile-*-

# *** DO NOT EDIT! ***
# *** This file is program-generated, not hand-written. ***
# ================================================================

ARCH = RV32IMC

# What is the size of the TCM in KB? Changing this would require
# recompilation of the SW application and using the appropriate RTL.
MEMSIZE ?= 16

# What is the start location of the TCM? Changing this would require
# recompilation of the SW application and changes to mkSoC_Map.v
IBASE_ADDR ?= 0xc0000000
DBASE_ADDR ?= 0xc8000000

# Pointer to simulation sources
SIM_RTL ?= Sim_RTL

#================================================================
# Common boilerplate rules

include ../scripts/makefiles/Include_Common.mk

#================================================================
# Makefile rules for building for specific simulator: verilator

include ../scripts/makefiles/Include_verilator.mk
