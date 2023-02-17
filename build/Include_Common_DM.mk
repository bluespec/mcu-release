###  -*-Makefile-*-

# ================================================================

.PHONY: help
help:
	@echo '------------------------'
	@echo 'MCU Makefile for configurations with Debug Module and Catalyst Accelerator'
	@echo 'TCM memories may be preloaded using memory files in simulation'
	@echo '------------------------'
	@echo ''
	@echo 'Synthesis Targets'
	@echo '    make  compile_core 		Generate MCU (MCUTop) RTL'
	@echo '    make  compile_soc  		Generate SoC to test basic function'
	@echo ''
	@echo 'Simulation Targets'
	@echo '    make  compile_sim  		Generate Sim SoC to basic function'
	@echo ''
	@echo '    make  clean        		Remove intermediate build-files'
	@echo '    make  full_clean   		Restore this directory to pristine state'
	@echo ''
	@echo '   NOTE: All compile targets need the Bluespec bsc compiler'
	@echo '   NOTE: CATALYST_INSTALL points to top-level of the release'
	@echo '   NOTE: CATALYST_WORK    points to work-area'
	@echo '   NOTE: BSC              points to the bluespec compiler'


# ================================================================
# Search path for bsc for .bsv files

CORE_DIRS = $(CORE_REPO)/Sys:$(CORE_REPO)/CPU:$(CORE_REPO)/ISA:$(CORE_REPO)/RegFiles:$(CORE_REPO)/Core:$(NMT_REPO)/src:$(FABRIC_REPO)/src:$(CORE_REPO)/BSV_Additional_Libs

IP_DIRS = $(CLINT_REPO)/src:$(PLIC_REPO)/src:$(DEBUG_REPO)/src

CATALYST_DIRS = $(CATALYST_RUNDIR)/src/bsv

FABRIC_DIRS = $(REPO)/src_Testbench/Fabrics/AXI4:$(REPO)/src_Testbench/Fabrics/AXI4_Lite

TESTBENCH_DIRS = $(REPO)/src_Testbench/$(SoC):$(REPO)/src_Testbench/common


BSC_PATH = -p $(CORE_DIRS):$(IP_DIRS):$(CATALYST_DIRS):$(FABRIC_DIRS):$(TESTBENCH_DIRS):+:%/Libraries/AMBA_TLM3/TLM3:%/Libraries/AMBA_TLM3/Axi:%/Libraries/AMBA_TLM3/Axi4:%/Libraries/Bus

# ----------------
# Top-level file and module

SYS_TOP_FILE   = $(CORE_REPO)/Sys/MCUTop.bsv

SoC_TOP_FILE   = $(REPO)/src_Testbench/$(SoC)/SoC_Top.bsv
SoC_TOP_MODULE = mkSoC_Top

SIM_TOP_FILE   = $(REPO)/src_Testbench/common/Top_HW_Side.bsv
SIM_TOP_MODULE = mkTop_HW_Side
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

build_dir:
	mkdir -p $@

Core_RTL:
	mkdir -p $@

Sim_RTL:
	mkdir -p $@

SoC_RTL:
	mkdir -p $@

.SILENT:
.PHONY: compile_core
compile_core: build_dir Core_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating MCU Core (mkMCUTop) RTL ..."
	$(BSC) -u -elab -verilog -vdir Core_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D SYNTHESIS $(BSC_PATH)  $(SYS_TOP_FILE)
	rm Core_RTL/mkDummy_Mem_Server.v Core_RTL/mkShifter_Box.v
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp $(SRC_BSC_LIB_DIR)/$$f Core_RTL/; done
	date +"(%F %T) Generated RTL into Core_RTL"
	@echo '-------------------------'

.PHONY: compile_sim
compile_sim: build_dir Sim_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating Sim RTL to test basic functionalty ..."
	$(BSC) -u -elab -verilog -vdir Sim_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D WATCH_TOHOST -D TEST_GPIO -D TEST_UART $(BSC_PATH) $(SIM_TOP_FILE)
	rm Sim_RTL/mkDummy_Mem_Server.v Sim_RTL/mkShifter_Box.v
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_RTL/
	date +"(%F %T) Generated RTL into Sim_RTL"
	@echo '-------------------------'

.PHONY: compile_sim_mem_test
compile_sim_mem_test: build_dir Sim_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating Sim RTL to test basic functionalty with self-mem-test..."
	$(BSC) -u -elab -verilog -vdir Sim_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D SIM_MEM_TEST -D WATCH_TOHOST -D TEST_GPIO -D TEST_UART $(BSC_PATH) $(SIM_TOP_FILE)
	rm Sim_RTL/mkDummy_Mem_Server.v Sim_RTL/mkShifter_Box.v
	cp $(REPO)/src_Testbench/common/src_verilog/* Sim_RTL/
	date +"(%F %T) Generated RTL into Sim_RTL"
	@echo '-------------------------'

.PHONY: compile_soc
compile_soc: build_dir SoC_RTL
	@echo '-------------------------'
	date +"(%F %T) Generating SoC RTL with GPIO to emulate basic functionality ..."
	$(BSC) -u -elab -verilog -vdir SoC_RTL $(RTL_BDIRS) $(BSC_COMPILATION_FLAGS) -D TEST_GPIO -D SYNTHESIS $(BSC_PATH) $(SoC_TOP_FILE)
	for f in FIFO2.v FIFO20.v FIFO10.v FIFO1.v SizedFIFO.v BRAM2.v BRAM2BE.v RegFile.v MakeResetA.v SyncResetA.v; do cp $(SRC_BSC_LIB_DIR)/$$f SoC_RTL/; done
	for f in SyncFIFOLevel.v ASSIGN1.v ResetInverter.v SyncHandshake.v SyncWire.v; do cp $(SRC_BSC_LIB_DIR)/$$f SoC_RTL/; done
	date +"(%F %T) Generated RTL into SoC_RTL"
	@echo '-------------------------'

# ================================================================

.PHONY: clean
clean:
	rm -r -f *~ build_dir

.PHONY: full_clean
full_clean: clean
	rm -r -f *.log CLINT_RTL PLIC_RTL DM_RTL

# ================================================================
