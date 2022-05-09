###  -*-Makefile-*-

# ================================================================

.PHONY: help
help:
	@echo '   make  compile_core      Compile MCU Core into Core_RTL (MEMSIZE controls memory size in KB)'
	@echo '   make  compile_dm        Compile Debug Module into DM_RTL'
	@echo '   make  compile_clint     Compile CLINT module into CLINT_RTL'
	@echo '   make  compile_plic      Compile PLIC module into PLIC_RTL'
	@echo '   make  compile_soc       Compile a synthesizable SoC integrating the core, debug module and a GPIO device'
	@echo '   make  compile_sim       Compile the SoC for simulation using Verilator'
	@echo '   make  compile_sim_plic  Compile a SoC that includes the PLIC for simulation using Verilator'
	@echo '   make  compile_sim_clint Compile a SoC that includes the CLINT for simulation using Verilator'
	@echo ''                          
	@echo '   make  clean        	  Remove intermediate build-files'
	@echo '   make  full_clean   	  Reset this directory to pristine state'
	@echo ''                          
	@echo '   NOTE: All compile targets need the Bluespec bsc compiler'
	@echo '   NOTE: needs MCU_REPO to point to top-level of release repository'
	@echo '   NOTE: Run this makefile from the MCU_REPO/build directory only'

# ================================================================
# User-variables
REPO ?= $$MCU_REPO
DEBUG_REPO = $(REPO)/Debug_Module
CLINT_REPO ?= $(REPO)/CLINT
PLIC_REPO ?= $(REPO)/PLIC
CORE_REPO = $(REPO)/MCU_Core
NMT_REPO = $(REPO)/Tiny_TCM
FABRIC_REPO = $(NMT_REPO)/fabrics/$(FABRIC)
SoC = testsoc
ARCH ?= RV32IMC
MEMSIZE ?= 16K
FABRIC ?= AHBL

# ================================================================
# RISC-V config macros passed into Bluespec 'bsc' compiler

BSC_COMPILATION_FLAGS += \
	-D RV32 \
	-D ISA_PRIV_M  \
	-D ISA_I \
	-D ISA_M \
	-D ISA_C \
	-D MULT_SERIAL    \
	-D SHIFT_SERIAL    \
	-D SHIFT_LOGARITHMIC \
	-D Near_Mem_TCM    \
	-D TCM_$(MEMSIZE) \
	-D NM32 \
	-D FABRIC32    \
	-D FABRIC_$(FABRIC) \
	-D RELEASE \
	-D MIN_CSR \
	-D INCLUDE_GDB_CONTROL \
	-D TCM_LOADER \
	-D JTAG_TAP \
	-D MICROSEMI \
	-D XILINX_BSCAN \
	-D XILINX_XC7K325T \

# ================================================================
# Search path for bsc for .bsv files

CORE_DIRS = $(CORE_REPO)/Sys:$(CORE_REPO)/CPU:$(CORE_REPO)/ISA:$(CORE_REPO)/RegFiles:$(CORE_REPO)/Core:$(NMT_REPO)/src:$(FABRIC_REPO)/src:$(CORE_REPO)/BSV_Additional_Libs

IP_DIRS = $(CLINT_REPO)/src:$(PLIC_REPO)/src:$(DEBUG_REPO)/src

TESTBENCH_DIRS = $(REPO)/src_Testbench/Fabrics/AXI4:$(REPO)/src_Testbench/$(SoC):$(REPO)/src_Testbench/common

BSC_PATH = -p $(CORE_DIRS):$(IP_DIRS):$(TESTBENCH_DIRS):+:%/Libraries/AMBA_TLM3/TLM3:%/Libraries/AMBA_TLM3/Axi:%/Libraries/AMBA_TLM3/Axi4:%/Libraries/Bus

# ----------------
# Top-level file and module

CORE_TOP_FILE   = $(CORE_REPO)/Sys/BSCore.bsv
CORE_TOP_MODULE = mkBSCore

SoC_TOP_FILE   = $(REPO)/src_Testbench/$(SoC)/SoC_Top.bsv
SoC_TOP_MODULE = mkSoC_Top

SIM_TOP_FILE   = $(REPO)/src_Testbench/common/Top_HW_Side.bsv
SIM_TOP_MODULE = mkTop_HW_Side

DM_TOP_FILE   = $(DEBUG_REPO)/src/BSDebug.bsv
DM_TOP_MODULE = mkBSDebug

CLINT_TOP_FILE   = $(CLINT_REPO)/src/CLINT_AHBL.bsv
CLINT_TOP_MODULE = mkCLINT_AHBL

PLIC_TOP_FILE   = $(PLIC_REPO)/src/PLIC_16_1_7.bsv
PLIC_TOP_MODULE = mkPLIC_16_1_7

# ================================================================
# bsc compilation flags

BSC_COMPILATION_FLAGS += \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing -no-show-timestamps \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_BDIRS = -bdir build_dir  -info-dir build_dir

build_dir:
	mkdir -p $@

DM_RTL:
	mkdir -p $@

PLIC_RTL:
	mkdir -p $@

CLINT_RTL:
	mkdir -p $@

Core_RTL:
	mkdir -p $@
	mkdir -p MCU.$(MEMSIZE).AHBL.DM

Sim_CLINT_RTL:
	mkdir -p $@
	mkdir -p MCU.$(MEMSIZE).AHBL.DM

Sim_PLIC_RTL:
	mkdir -p $@
	mkdir -p MCU.$(MEMSIZE).AHBL.DM

Sim_RTL:
	mkdir -p $@
	mkdir -p MCU.$(MEMSIZE).AHBL.DM

SoC_RTL:
	mkdir -p $@
	mkdir -p MCU.$(MEMSIZE).AHBL.DM

.SILENT:
.PHONY: compile_core
compile_core:  build_dir  Core_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating MCU Core (BSCore) RTL ..."
	bsc -u -elab -verilog -vdir Core_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS) $(BSC_PATH)  $(CORE_TOP_FILE)
	rm Core_RTL/mkDummy_Mem_Server.v Core_RTL/mkShifter_Box.v
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp src_bsc_lib_rtl/$$f Core_RTL/; done
	mv Core_RTL MCU.$(MEMSIZE).AHBL.DM/
	date +"(%F %T) Generated RTL into Core_RTL"
	@echo '-------------------------'

.PHONY: compile_dm
compile_dm:  build_dir  DM_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating RISC-V Debug Module (BSDebug) RTL ..."
	bsc -u -elab -verilog -vdir DM_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS) $(BSC_PATH)  $(DM_TOP_FILE)
	rm DM_RTL/mkSoC_Map.v DM_RTL/mkJtag.v
	for f in FIFO2.v FIFO20.v FIFO1.v SyncFIFOLevel.v ASSIGN1.v ResetInverter.v SyncHandshake.v SyncWire.v SyncResetA.v MakeResetA.v; do cp src_bsc_lib_rtl/$$f DM_RTL/; done
	date +"(%F %T) Generated RTL into DM_RTL"
	@echo '-------------------------'

.PHONY: compile_clint
compile_clint:  build_dir  CLINT_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating CLINT RTL ..."
	bsc -u -elab -verilog -vdir CLINT_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS) $(BSC_PATH)  $(CLINT_TOP_FILE)
	for f in FIFO2.v; do cp src_bsc_lib_rtl/$$f CLINT_RTL/; done
	date +"(%F %T) Generated RTL into CLINT_RTL"
	@echo '-------------------------'

.PHONY: compile_plic
compile_plic:  build_dir  PLIC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating PLIC RTL ..."
	bsc -u -elab -verilog -vdir PLIC_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS) $(BSC_PATH)  $(PLIC_TOP_FILE)
	date +"(%F %T) Generated RTL into PLIC_RTL"
	@echo '-------------------------'

.PHONY: compile_sim_clint
compile_sim_clint:   build_dir  Sim_CLINT_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating RTL to test with CLINT ..."
	bsc -u -elab -verilog -vdir Sim_CLINT_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS)  -D WATCH_TOHOST  -D TEST_CLINT $(BSC_PATH)  $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_CLINT_RTL/
	mv Sim_CLINT_RTL MCU.$(MEMSIZE).AHBL.DM/
	date +"(%F %T) Generated RTL into Sim_CLINT_RTL"
	@echo '-------------------------'

.PHONY: compile_sim_plic
compile_sim_plic:  build_dir  Sim_PLIC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating RTL to test with PLIC ..."
	bsc -u -elab -verilog -vdir Sim_PLIC_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS)  -D WATCH_TOHOST  -D TEST_PLIC $(BSC_PATH)  $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_PLIC_RTL/
	mv Sim_PLIC_RTL MCU.$(MEMSIZE).AHBL.DM/
	date +"(%F %T) Generated RTL into Sim_PLIC_RTL"
	@echo '-------------------------'

.PHONY: compile_sim
compile_sim:  build_dir  Sim_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating RTL to test basic functionalty ..."
	bsc -u -elab -verilog -vdir Sim_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS)  -D WATCH_TOHOST  -D TEST_GPIO $(BSC_PATH)  $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_RTL/
	mv Sim_RTL MCU.$(MEMSIZE).AHBL.DM/
	date +"(%F %T) Generated RTL into Sim_RTL"
	@echo '-------------------------'

.PHONY: compile_soc
compile_soc:   build_dir SoC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating SoC RTL with GPIO to emulate basic functionality ..."
	bsc -u -elab -verilog -vdir SoC_RTL $(RTL_BDIRS)  $(BSC_COMPILATION_FLAGS) -D TEST_GPIO -D SYNTHESIS $(BSC_PATH)  $(SoC_TOP_FILE)
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp src_bsc_lib_rtl/$$f SoC_RTL/; done
	for f in SyncFIFOLevel.v ASSIGN1.v ResetInverter.v SyncHandshake.v SyncWire.v; do cp src_bsc_lib_rtl/$$f SoC_RTL/; done
	mv SoC_RTL MCU.$(MEMSIZE).AHBL.DM/
	date +"(%F %T) Generated RTL into SoC_RTL"
	@echo '-------------------------'

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  Makefile_*  build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f  *.log CLINT_RTL PLIC_RTL DM_RTL MCU.$(MEMSIZE).AHBL.DM

# ================================================================
