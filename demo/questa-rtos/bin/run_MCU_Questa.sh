#! /bin/bash
##############################################
# Run this script from the 'build' directory #
##############################################


# convert elf file to mem hex file for Verilog memory load
../tools/Elf_to_Hex/elfhex.sh -e ../programs/main_blinky.elf -m 1024 -i 0xC0000000 -d 0xC8000000 -w 32

rm .*.hex32
rm *.hex32

# run the Questa simulation
./exe_HW_sim    +exit +v0
