###  -*-Makefile-*-

# ================================================================

.PHONY: help
help:
	@echo '------------------------'
	@echo 'MCU Makefile for configurations without Debug Module, with TCM Loader'
	@echo 'TCM memories cannot be preloaded using memory files in simulation'
	@echo '------------------------'
	@echo ''
	@echo 'Synthesis Targets'
	@echo '    make  compile_core 		Generate MCU (BSCore) RTL'
	@echo '    make  compile_clint		Generate CLINT RTL'
	@echo '    make  compile_plic 		Generate PLIC RTL'
	@echo '    make  compile_all_ip		Generate BSCore, CLINT, PLIC RTL'
	@echo '    make  compile_soc  		Generate SoC to test basic function'
	@echo ''
	@echo 'Simulation Targets'
	@echo '    make  compile_sim_clint	Generate Sim SoC to test with CLINT'
	@echo '    make  compile_sim_plic 	Generate Sim SoC to test with PLIC'
	@echo '    make  compile_sim  		Generate Sim SoC to basic function'
	@echo ''
	@echo '    make  clean        		Remove intermediate build-files'
	@echo '    make  full_clean   		Restore this directory to pristine state'
	@echo ''                          
	@echo '   NOTE: All compile targets need the Bluespec bsc compiler'
	@echo '   NOTE: needs MCU_REPO to point to top-level of release repository'
	@echo '   NOTE: Run this makefile from the MCU_REPO/build directory only'

# ================================================================
# User-variables
REPO ?= $$MCU_REPO
DEBUG_REPO = $(REPO)/Debug_Module
CLINT_REPO = $(REPO)/CLINT
PLIC_REPO = $(REPO)/PLIC
CORE_REPO = $(REPO)/MCU_Core
NMT_REPO = $(REPO)/Tiny_TCM
FABRIC_REPO = $(NMT_REPO)/fabrics/$(FABRIC)
SoC ?= testsoc
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
	-D MIN_CSR \
	-D MICROSEMI \
	-D TCM_LOADER \

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

CFG_DIR_NAME = MCU.$(MEMSIZE).AHBL.LDR.dm
SRC_BSC_LIB_DIR = $(REPO)/build/src_bsc_lib_rtl

# ================================================================
# bsc compilation flags

BSC_COMPILATION_FLAGS += \
	-keep-fires -aggressive-conditions -no-warn-action-shadowing -no-show-timestamps \
	-suppress-warnings G0020    \
	+RTS -K128M -RTS  -show-range-conflict

# ================================================================
# Generate Verilog RTL from BSV sources (needs Bluespec 'bsc' compiler)

RTL_BDIRS = -bdir build_dir  -info-dir build_dir

CFG_DIR:
	mkdir -p $(CFG_DIR_NAME)

build_dir:
	mkdir -p $@

PLIC_RTL:
	mkdir -p $@

CLINT_RTL:
	mkdir -p $@

Core_RTL:
	mkdir -p $@

Sim_CLINT_RTL:
	mkdir -p $@

Sim_PLIC_RTL:
	mkdir -p $@

Sim_RTL:
	mkdir -p $@

SoC_RTL:
	mkdir -p $@

.SILENT:
.PHONY: compile_core
compile_core: build_dir CFG_DIR Core_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating MCU Core (mkBSCore) RTL ..."
	bsc -u -elab -verilog -vdir Core_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D SYNTHESIS $(BSC_PATH) $(CORE_TOP_FILE)
	rm Core_RTL/mkShifter_Box.v
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp $(SRC_BSC_LIB_DIR)/$$f Core_RTL/; done
	mv Core_RTL $(CFG_DIR_NAME)/
	date +"(%F %T) Generated RTL into Core_RTL"
	@echo '-------------------------'

.PHONY: compile_clint
compile_clint: build_dir CLINT_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating CLINT RTL ..."
	bsc -u -elab -verilog -vdir CLINT_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) $(BSC_PATH) $(CLINT_TOP_FILE)
	for f in FIFO2.v; do cp $(SRC_BSC_LIB_DIR)/$$f CLINT_RTL/; done
	date +"(%F %T) Generated RTL into CLINT_RTL"
	@echo '-------------------------'

.PHONY: compile_plic
compile_plic: build_dir PLIC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating PLIC RTL ..."
	bsc -u -elab -verilog -vdir PLIC_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) $(BSC_PATH) $(PLIC_TOP_FILE)
	date +"(%F %T) Generated RTL into PLIC_RTL"
	@echo '-------------------------'

.PHONY: compile_all_ip
compile_all_ip: compile_core compile_clint compile_plic

.PHONY: compile_sim_clint
compile_sim_clint: build_dir CFG_DIR Sim_CLINT_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating Sim RTL to test with CLINT ..."
	bsc -u -elab -verilog -vdir Sim_CLINT_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D WATCH_TOHOST -D TEST_CLINT $(BSC_PATH) $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_CLINT_RTL/
	mv Sim_CLINT_RTL $(CFG_DIR_NAME)/
	date +"(%F %T) Generated RTL into Sim_CLINT_RTL"
	@echo '-------------------------'

.PHONY: compile_sim_plic
compile_sim_plic: build_dir CFG_DIR Sim_PLIC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating Sim RTL to test with PLIC ..."
	bsc -u -elab -verilog -vdir Sim_PLIC_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D WATCH_TOHOST -D TEST_PLIC $(BSC_PATH) $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_PLIC_RTL/
	mv Sim_PLIC_RTL $(CFG_DIR_NAME)/
	date +"(%F %T) Generated RTL into Sim_PLIC_RTL"
	@echo '-------------------------'

.PHONY: compile_sim
compile_sim: build_dir CFG_DIR Sim_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating Sim RTL to test basic functionalty ..."
	bsc -u -elab -verilog -vdir Sim_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D WATCH_TOHOST -D TEST_GPIO $(BSC_PATH) $(SIM_TOP_FILE)
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_RTL/
	mv Sim_RTL $(CFG_DIR_NAME)/
	date +"(%F %T) Generated RTL into Sim_RTL"
	@echo '-------------------------'

.PHONY: compile_soc
compile_soc: build_dir CFG_DIR SoC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating SoC RTL with GPIO to emulate basic functionality ..."
	bsc -u -elab -verilog -vdir SoC_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D TEST_GPIO -D SYNTHESIS $(BSC_PATH) $(SoC_TOP_FILE)
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp $(SRC_BSC_LIB_DIR)/$$f SoC_RTL/; done
	mv SoC_RTL $(CFG_DIR_NAME)/
	date +"(%F %T) Generated RTL into SoC_RTL"
	@echo '-------------------------'

# ================================================================

.PHONY: clean
clean:
	rm -r -f *~ build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f *.log CLINT_RTL PLIC_RTL $(CFG_DIR_NAME)

# ================================================================
