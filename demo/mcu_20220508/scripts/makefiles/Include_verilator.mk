###  -*-Makefile-*-

# Copyright (c) 2018-2019 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles
#
SIM_EXE_FILE = exe_HW_sim

# ================================================================
# Compile and link Verilog RTL sources into an verilator executable

# Verilator flags: notes
#    stats              Dump stats on the design, in file {prefix}__stats.txt
#    -O3                Verilator optimization level
#    -CFLAGS -O3        C++ optimization level
#    --x-assign fast    Optimize X value
#    --x-initial fast   Optimize uninitialized value
#    --noassert         Disable all assertions

#VERILATOR_FLAGS = --stats -O3 -CFLAGS -O3 -LDFLAGS -static --x-assign fast --x-initial fast --noassert
VERILATOR_FLAGS = --stats -O3 -CFLAGS -O3 --x-assign fast --x-initial fast --noassert

# Verilator flags: use the following to include code to generate VCDs
# Select trace-depth according to your module hierarchy
VERILATOR_FLAGS += --trace  --trace-depth 20  -CFLAGS -DVM_TRACE

VTOP                = V$(TOPMODULE)_edited
VERILATOR_RESOURCES = $(MCU_DEMO)/scripts/makefiles/Verilator_resources

.PHONY: simulator
simulator:
	@echo "INFO: Verilating Verilog files (in newly created obj_dir)"
	sed  -f $(VERILATOR_RESOURCES)/sed_script.txt  $(SIM_RTL)/$(TOPMODULE).v > tmp1.v
	cat  $(VERILATOR_RESOURCES)/verilator_config.vlt \
	     $(VERILATOR_RESOURCES)/import_DPI_C_decls.v \
	     tmp1.v                                     > $(SIM_RTL)/$(TOPMODULE)_edited.v
	rm   -f  tmp1.v
	verilator \
                -Wno-CASEINCOMPLETE -Wno-LITENDIAN -Wno-UNOPT \
                -Wno-UNOPTFLAT -Wno-WIDTH -Wno-fatal -Wno-BLKANDNBLK \
		-I$(SIM_RTL) \
		$(VERILATOR_FLAGS) \
		--cc  $(TOPMODULE)_edited.v \
		--exe  sim_main.cpp \
		$(VERILATOR_RESOURCES)/src_C/sim_socket.c \
		$(VERILATOR_RESOURCES)/src_C/sim_dmi.c \
		$(VERILATOR_RESOURCES)/src_C/bluenoc_tcp.c \
		$(VERILATOR_RESOURCES)/src_C/C_Imported_Functions.c
	@echo "INFO: Linking verilated files"
	cp  -p  $(VERILATOR_RESOURCES)/src_C/sim_main.cpp  obj_dir/sim_main.cpp
	cd obj_dir; \
	   make -j -f V$(TOPMODULE)_edited.mk  $(VTOP); \
	   cp -p  $(VTOP)  ../$(SIM_EXE_FILE)
	@echo "INFO: Created verilator executable:    $(SIM_EXE_FILE)"

# ================================================================
