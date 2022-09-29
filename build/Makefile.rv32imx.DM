###  -*-Makefile-*-


# ================================================================
# User-variables - set REPO correctly (depends on value of args.core)
REPO ?= ..
DEBUG_REPO = $(REPO)/Debug_Module
CLINT_REPO = $(REPO)/CLINT
PLIC_REPO = $(REPO)/PLIC
CORE_REPO = $(REPO)/MCU_Core
NMT_REPO = $(REPO)/Tiny_TCM
CATALYST_REPO = ${CATALYST_INSTALL}
FABRIC_REPO = $(NMT_REPO)/fabrics/$(FABRIC)
SoC ?= benchmark-soc
ARCH ?= RV32IM
MEMSIZE ?= 1024K
FABRIC ?= AXI4

# ================================================================
# RISC-V config macros passed into Bluespec 'bsc' compiler

BSC_COMPILATION_FLAGS += \
	-D RV32 \
	-D ISA_PRIV_M  \
	-D ISA_I \
	-D ISA_M \
	-D ISA_X \
	-D MULT_SERIAL    \
	-D SHIFT_SERIAL    \
	-D SHIFT_LOGARITHMIC \
	-D Near_Mem_TCM    \
	-D TCM_$(MEMSIZE) \
	-D MIN_CSR \
	-D NM32 \
	-D FABRIC32    \
	-D FABRIC_$(FABRIC) \
	-D INCLUDE_GDB_CONTROL \
	-D JTAG_TAP \
	-D XILINX_BSCAN \
	-D XILINX_XC7K325T \

# ================================================================
include ${CATALYST_WORK}/Include_CAT.mk

# ================================================================
include $(REPO)/build/Include_Common_DM.mk
