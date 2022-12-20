#!/usr/bin/env python3

import sys
import math
import argparse

# The following may need installation:
#    pip3  install  pyelftools    ('pip3' For Python 3)
from elftools.elf.elffile import ELFFile
from elftools.elf.constants import SH_FLAGS

parser = argparse.ArgumentParser()
parser.add_argument('elf_binary', help='input ELF binary')
parser.add_argument('output_image', help='output load image')

args = parser.parse_args()

def include_section(s):
    return ((s['sh_flags'] & SH_FLAGS.SHF_ALLOC) != 0) and (s['sh_type'] != 'SHT_NOBITS')

with open(args.output_image, 'w') as out:
    with open(args.elf_binary, 'rb') as f:
        ef = ELFFile(f)
        print("entry point at 0x{0:x}".format(ef.header["e_entry"]))
        #	  for s in ef.iter_segments():
        #	      print("segment at 0x{0:x}, for 0x{1:x} bytes".format(s["p_vaddr"], s["p_filesz"]))
        entry_point = ef.header["e_entry"]
        section_count = 0
        for s in ef.iter_sections():
            if include_section(s):
                print("section {0} at 0x{1:x}, for 0x{2:x} bytes".format(s.name, s["sh_addr"], s["sh_size"]))
                section_count = section_count + 1

        for s in ef.iter_sections():
            if include_section(s):
                section_bytes = s.data()
                section_numbytes = len(section_bytes)
                print("section {} contains {} bytes.".format(s.name, section_numbytes))

                print("@{:x}".format(s["sh_addr"]), file=out)

                # 1..4 bytes will loop once, 5..8 bytes will loop twice, etc.
                for w in range(math.ceil(section_numbytes / 4)): # w is 32-bit word number
                    b0 = section_bytes[w * 4]
                    b1 = section_bytes[(w * 4) + 1] if section_numbytes > ((w * 4) + 1) else 0
                    b2 = section_bytes[(w * 4) + 2] if section_numbytes > ((w * 4) + 2) else 0
                    b3 = section_bytes[(w * 4) + 3] if section_numbytes > ((w * 4) + 3) else 0
                    print("{:02x}{:02x}{:02x}{:02x}".format(b3, b2, b1, b0), file=out)
