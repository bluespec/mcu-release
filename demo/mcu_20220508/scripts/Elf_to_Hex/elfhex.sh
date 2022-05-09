#!/bin/bash

# -------------------------------------------------------------------------
# Runs the elf-to-hex script for split memories.
# MCU_INSTALL points to the new release. All paths are relative to
# it. This script and friends are housed in $MCU_INSTALL/tools/Elf_to_Hex
# -------------------------------------------------------------------------

usage()
{
    echo "usage: elfhex.sh [[-e elf_file ] [-m mem-size] [-b mem-base] [-w mem-width] | [-h]]"
    echo "Please ensure MCU_INSTALL points to your MCU installation folder" 
}


# Command line processing
while [ "$1" != "" ]; do
    case $1 in
        -e | --elf )       shift  # path to elf-file
	                   elf_input=$1
                           ;;
        -m | --mem-size )  shift  # memory size in KB
	                   mem_size=$1
                           ;;
        -w | --mem-width)  shift  # memory width in bits
	                   mem_width=$1
                           ;;
        -i | --imem-base)  shift  # base address of imemory
	                   imem_base=$1
                           ;;
        -d | --dmem-base)  shift  # base address of dmemory
	                   dmem_base=$1
                           ;;
        -h | --help )      usage
                           exit
                           ;;
        * )                usage
                           exit 1
    esac
    shift
done

TOOLS_DIR=$MCU_INSTALL/scripts

# Step 1. Split elf into section wise hex files (32-bit hex)
${TOOLS_DIR}/Elf_to_Hex/Elf_to_Hex32.exe ${elf_input}

# Step 2a. Combine text sections into a single elf file
${TOOLS_DIR}/Elf_to_Hex/Merge_Elfhex.py --source .startup.hex32 \
                                        --source .text.startup.hex32 \
                                        --source .text.hex32 --out I.hex32

# Step 2b. Combine data sections into a single elf file
${TOOLS_DIR}/Elf_to_Hex/Merge_Elfhex.py --source .rodata.hex32 \
                                        --source .data.hex32 \
                                        --source .sdata.hex32 \
                                        --source .eh_frame.hex32 \
                                        --source .init_array.hex32 \
                                        --source .fini_array.hex32  \
                                        --source .sbss.hex32 \
                                        --source .bss.hex32 --out D.hex32

let memsz_bytes=${mem_size}*1024

# Step 3a. Generate ITCM memory image from I.hex32
${TOOLS_DIR}/Elf_to_Hex/Elfhex_to_Memhex.py /tmp/itcm.mem ${mem_width} ${imem_base} ${memsz_bytes} I.hex32

# Step 3b. Generate ITCM memory image from D.hex32
${TOOLS_DIR}/Elf_to_Hex/Elfhex_to_Memhex.py /tmp/dtcm.mem ${mem_width} ${dmem_base} ${memsz_bytes} D.hex32
