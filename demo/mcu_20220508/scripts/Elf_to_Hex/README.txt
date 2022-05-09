Copyright (c) 2020 Bluespec, Inc. All Rights Reserved

>----------------
Elf_to_Hex32.c

This standalone C program takes two command-line arguments, an ELF
filename and a Mem Hex filename.  It reads the ELF file and writes out
the Mem Hex file.

See 'MAX_MEM_SIZE' in .c program for maximum address supported.

Output is always a 32-bit-wide Mem.hex32 file.

Use Elfhex_to_Memhex.py for 'reshaping' this Mem.hex32 file to a
Mem.hex<W> file for a different memory-width W and different base
offset.

>----------------
Elfhex_to_Memhex.py

Converts the Mem.hex32 file (e.g., created by Elf_to_Hex32.c) for a
memory array with a different width, base, size, etc.

>----------------

Mem0.hex is a dummy memory hex file where the memory is all zeros.
It can be used to load a 256-bit wide memory which is 256MB.
