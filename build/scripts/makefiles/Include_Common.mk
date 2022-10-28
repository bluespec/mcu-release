###  -*-Makefile-*-

# Copyright (c) 2018-2019 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles

# It contains common defs used by Makefiles generated for specific
# RISC-V implementations that differ in RISC-V architectural-feature
# choices, hardware implementation choices and simulator choices.

# ================================================================

.PHONY: help
help:
	@echo 'Please ensure that you define CATALYST_INSTALL and TEST'
	@echo ''
	@echo '    make  simulator    Compiles and links intermediate files/RTL to create simulation executable'
	@echo '                           (Bluesim, verilator or iverilog)'
	@echo '    make  run_test     Runs simulation executable on ELF given by TEST'
	@echo ''
	@echo '    make  run_test_waves Runs simulation executable on ELF given by TEST and dumps VCD waveforms'
	@echo ''
	@echo '    make  clean        Remove intermediate build-files unnecessary for execution'

.PHONY: all
all: simulator

# ================================================================
# User defined variables
TEST ?= PLEASE_DEFINE_PATH_TO_ELF

# ================================================================
# Other variables
TOPMODULE = mkTop_HW_Side

# ================================================================
# Runs simulation executable on ELF specified by the variable TEST
# Change verbosity to v1 for instruction trace
VERBOSITY ?= v0

.PHONY: run_test
run_test:
	$(SCRIPTS_DIR)/Elf_to_Hex/elfhex.sh -e $(TEST) -o $(CATALYST_RUNDIR) -m $(MEMSIZE) -i $(IBASE_ADDR) -d $(DBASE_ADDR) -w 32
	rm .*.hex32
	rm *.hex32
	./exe_HW_sim  +exit +tohost +$(VERBOSITY)

.PHONY: run_test_waves
run_test_waves:
	$(SCRIPTS_DIR)/Elf_to_Hex/elfhex.sh -e $(TEST) -o $(CATALYST_RUNDIR) -m $(MEMSIZE) -i $(IBASE_ADDR) -d $(DBASE_ADDR) -w 32
	rm .*.hex32
	rm *.hex32
	./exe_HW_sim  +exit +trace +tohost +$(VERBOSITY)

# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  Makefile_*  symbol_table.txt  build_dir  obj_dir *.log

# ================================================================
