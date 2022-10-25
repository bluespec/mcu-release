###  -*-Makefile-*-

# Copyright (c) 2018-2019 Bluespec, Inc. All Rights Reserved

# This file is not a standalone Makefile, but 'include'd by other Makefiles
#
SIM_EXE_FILE = exe_HW_sim

# ================================================================
# Compile and link Verilog RTL sources into a questasim executable

QUESTA_RESOURCES = $(SCRIPTS_DIR)/makefiles/Questasim_resources

.PHONY: simulator
simulator:
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64                                 -fpermissive -fPIC -c -o "$(SIM_RTL)/C_Imported_Functions.o" 		"$(QUESTA_RESOURCES)/lib/C/C_Imported_Functions.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_c_end_timing.o"     	"$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_c_end_timing.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64                                 -fpermissive -fPIC -c -o "$(SIM_RTL)/sim_socket.o" 			"$(QUESTA_RESOURCES)/lib/C/sim_socket.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64                                 -fpermissive -fPIC -c -o "$(SIM_RTL)/sim_dmi.o" 			"$(QUESTA_RESOURCES)/lib/C/sim_dmi.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_c_end_timing.o"       "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_c_end_timing.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_c_get_symbol_val.o"   "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_c_get_symbol_val.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_c_start_timing.o"     "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_c_start_timing.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_c_trygetchar.o"       "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_c_trygetchar.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_sim_socket_open.o"    "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_sim_socket_open.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_sim_socket_accept.o"  "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_sim_socket_accept.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_sim_socket_getchar.o" "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_sim_socket_getchar.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_sim_socket_putchar.o" "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_sim_socket_putchar.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_vpidmi_request.o"     "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_vpidmi_request.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_wrapper_vpidmi_response.o"    "$(QUESTA_RESOURCES)/C_VPI/vpi_wrapper_vpidmi_response.c"
	cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"$(QUESTA_RESOURCES)/lib"/VPI -fpermissive -fPIC -c -o "$(SIM_RTL)/vpi_startup_array.o"              "$(QUESTA_RESOURCES)/C_VPI/vpi_startup_array.c"

#compile Questa simulation
	$(SCRIPTS_DIR)/makefiles/bsc_build_vsim_modelsim link $(SIM_EXE_FILE) mkTop_HW_Side \
	-verbose \
	-y $(USER_RTL_DIR) \
	-y $(SIM_RTL) \
	-y $(QUESTA_RESOURCES)/lib/Verilog \	$(QUESTA_RESOURCES)/lib/Verilog/main.v \
	$(SIM_RTL)/sim_socket.o \
	$(SIM_RTL)/C_Imported_Functions.o \
	$(SIM_RTL)/sim_dmi.o \
	$(SIM_RTL)/vpi_wrapper_sim_socket_open.o \
	$(SIM_RTL)/vpi_wrapper_sim_socket_accept.o \
	$(SIM_RTL)/vpi_wrapper_sim_socket_putchar.o \
	$(SIM_RTL)/vpi_wrapper_sim_socket_getchar.o \
	$(SIM_RTL)/vpi_wrapper_c_end_timing.o \
	$(SIM_RTL)/vpi_wrapper_c_get_symbol_val.o \
	$(SIM_RTL)/vpi_wrapper_c_start_timing.o \
	$(SIM_RTL)/vpi_wrapper_c_trygetchar.o \
	$(SIM_RTL)/vpi_wrapper_vpidmi_response.o \
	$(SIM_RTL)/vpi_wrapper_vpidmi_request.o \
	$(SIM_RTL)/vpi_startup_array.o


	vlib work_mkTop_HW_Side


	c++ -v   -shared \
	    -o directc_mkTop_HW_Side.so \
	    -Wl,-rpath,$(QUESTA_RESOURCES)/lib/VPI/g++4_64 \
	    -L $(QUESTA_RESOURCES)/lib/VPI/g++4_64  \
	    $(SIM_RTL)/C_Imported_Functions.o \
	    $(SIM_RTL)/sim_socket.o \
	    $(SIM_RTL)/sim_dmi.o \
	    $(SIM_RTL)/vpi_wrapper_c_end_timing.o \
	    $(SIM_RTL)/vpi_wrapper_c_get_symbol_val.o \
	    $(SIM_RTL)/vpi_wrapper_c_start_timing.o \
	    $(SIM_RTL)/vpi_wrapper_c_trygetchar.o \
	    $(SIM_RTL)/vpi_wrapper_sim_socket_open.o \
	    $(SIM_RTL)/vpi_wrapper_sim_socket_accept.o \
	    $(SIM_RTL)/vpi_wrapper_sim_socket_getchar.o \
	    $(SIM_RTL)/vpi_wrapper_sim_socket_putchar.o \
	    $(SIM_RTL)/vpi_wrapper_vpidmi_request.o \
	    $(SIM_RTL)/vpi_wrapper_vpidmi_response.o \
	    $(SIM_RTL)/vpi_startup_array.o -lbdpi
