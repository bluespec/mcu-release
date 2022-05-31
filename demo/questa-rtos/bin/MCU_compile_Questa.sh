#! /bin/bash
##############################################
# Run this script from the 'build' directory #
##############################################


# compile VPI wrapper files
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -fpermissive -fPIC -c -o "../lib/C/C_Imported_Functions.o" "../lib/C/C_Imported_Functions.c"
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"../lib"/VPI -fpermissive -fPIC -c -o "../C_VPI/vpi_wrapper_c_end_timing.o" "../C_VPI/vpi_wrapper_c_end_timing.c"
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"../lib"/VPI -fpermissive -fPIC -c -o "../C_VPI/vpi_wrapper_c_get_symbol_val.o" "../C_VPI/vpi_wrapper_c_get_symbol_val.c"
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"../lib"/VPI -fpermissive -fPIC -c -o "../C_VPI/vpi_wrapper_c_start_timing.o" "../C_VPI/vpi_wrapper_c_start_timing.c"
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"../lib"/VPI -fpermissive -fPIC -c -o "../C_VPI/vpi_wrapper_c_trygetchar.o" "../C_VPI/vpi_wrapper_c_trygetchar.c"
cc -O3  -Wall -Wno-unused -D_FILE_OFFSET_BITS=64 -I"../lib"/VPI -fpermissive -fPIC -c -o "../C_VPI/vpi_startup_array.o" "../C_VPI/vpi_startup_array.c"

#compile Questa simulation
../bin/bsc_build_vsim_modelsim link exe_HW_sim mkTop_HW_Side \
-verbose \
-y ../MCU.1024K.AHBL/Sim_RTOS_RTL \
-y ../lib/Verilog \
../lib/Verilog/main.v \
../lib/C/C_Imported_Functions.o \
../C_VPI/vpi_wrapper_c_end_timing.o \
../C_VPI/vpi_wrapper_c_get_symbol_val.o \
../C_VPI/vpi_wrapper_c_start_timing.o \
../C_VPI/vpi_wrapper_c_trygetchar.o \
../C_VPI/vpi_startup_array.o

vlib work_mkTop_HW_Side

vlog -sv -work work_mkTop_HW_Side +libext+.v+.vqm  \
     -y ../MCU.1024K.AHBL/Sim_RTOS_RTL \
     -y ../lib/Verilog  \
     +define+TOP=mkTop_HW_Side \
     ../lib/Verilog/main.v

c++ -v   -shared \
    -o directc_mkTop_HW_Side.so \
    -Wl,-rpath,../lib/VPI/g++4_64 \
    -L../lib/VPI/g++4_64  \
    ../lib/C/C_Imported_Functions.o \
    ../C_VPI/vpi_wrapper_c_end_timing.o \
    ../C_VPI/vpi_wrapper_c_get_symbol_val.o \
    ../C_VPI/vpi_wrapper_c_start_timing.o \
    ../C_VPI/vpi_wrapper_c_trygetchar.o \
    ../C_VPI/vpi_startup_array.o -lbdpi
