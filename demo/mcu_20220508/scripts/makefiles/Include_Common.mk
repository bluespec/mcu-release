###  -*-Makefile-*-

# Copyright (c) 2018-2019 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles

# It contains common defs used by Makefiles generated for specific
# RISC-V implementations that differ in RISC-V architectural-feature
# choices, hardware implementation choices and simulator choices.

# ================================================================

.PHONY: help
help:
	@echo 'Please ensure that you define MCU_DEMO and TEST'
	@echo ''
	@echo '    make  simulator    Compiles and links intermediate files/RTL to create simulation executable'
	@echo '                           (Bluesim, verilator or iverilog)'
	@echo '    make  run_test     Runs simulation executable on ELF given by TEST'
	@echo ''
	@echo '    make  run_test_waves Runs simulation executable on ELF given by TEST and dumps VCD waveforms'
	@echo ''
	@echo '    make  clean        Remove intermediate build-files unnecessary for execution'

.PHONY: all
all: compile  simulator

# ================================================================
# User defined variables
MCU_DEMO ?= $$MCU_DEMO
TEST ?= PLEASE_DEFINE_PATH_TO_ELF

# ================================================================
# Other variables
RV_DV_TEST = $(MCU_DEMO)/tests/generated
TOPMODULE = mkTop_HW_Side

# ================================================================
# Runs simulation executable on ELF specified by the variable TEST

VERBOSITY ?= v0

.PHONY: run_test
run_test:
	$(MCU_DEMO)/scripts/Elf_to_Hex/elfhex.sh -e $(TEST) -m $(MEMSIZE) -i $(IBASE_ADDR) -d $(DBASE_ADDR) -w 32
	rm .*.hex32
	rm *.hex32
	./exe_HW_sim  +exit +tohost +$(VERBOSITY)

.PHONY: run_test_waves
run_test_waves:
	$(MCU_DEMO)/scripts/Elf_to_Hex/elfhex.sh -e $(TEST) -m $(MEMSIZE) -i $(IBASE_ADDR) -d $(DBASE_ADDR) -w 32
	rm .*.hex32
	rm *.hex32
	./exe_HW_sim  +exit +trace +tohost

# ================================================================
# Runs simulation executable on ELF specified by the variable TEST for
# pseudo-random tests
#
.PHONY: run_riscv_dv_test
run_riscv_dv_test:
	@echo "Running pseudo-random RISC-V DV test pattern"
	@echo "Running $(TEST) on HW"
	$(MCU_DEMO)/scripts/Elf_to_Hex/elfhex.sh -e $(RV_DV_TEST)/asm_test/$(TEST).o -m $(MEMSIZE) -d $(DBASE_ADDR) -i $(IBASE_ADDR) -w 32
	./exe_HW_sim +exit +tohost | grep "instret" | awk '{ print $$2, $$3 }' | tee -a ./$(TEST).hw.log
	sed -i 's/instr://' ./$(TEST).hw.log
	sed -i 's/PC://'    ./$(TEST).hw.log
	@echo "Running $(TEST) on Spike"
	$(MCU_DEMO)/scripts/run_and_cmp_spike $(RV_DV_TEST)/asm_test/$(TEST).o ./$(TEST).spike.log ./$(TEST).hw.log


# ================================================================

.PHONY: clean
clean:
	rm -r -f  *~  Makefile_*  symbol_table.txt  build_dir  obj_dir *.log

# ================================================================
