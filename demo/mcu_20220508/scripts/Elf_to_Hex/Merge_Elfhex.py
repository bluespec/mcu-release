#!/usr/bin/python3

# Copyright (c) 2020 Bluespec, Inc., All Rights Reserved

import os
import sys
import argparse


#------------------------
# Parse the input .hex32 and populate a dictionary of .hex32 files where the keys are the
# RAM indices of the .hex32. NOTE that only a single index line can be in .hex32. 
def fn_create_hex_dict (sources) :
    hex_dict = {}
    for src in sources :
        if not os.path.isfile (src) :
            sys.stdout.write ("WARN: Input file '%s' does not exist. Ignoring.\n" % src)

        else :
            # .hex32 file exists
            src_file = open (src, 'r')
            for line in src_file :
                line = line.lstrip()
                words = line.split()

                # the line with the mem-idx
                if line.startswith ('@') :
                    # the mem index is in hex (hence the 16)
                    new_ram_idx = int (words [0][1:], 16)

                    # populate the dictionary
                    hex_dict[new_ram_idx] = src

            src_file.close ()

    return hex_dict


#------------------------
# Merge the .hex32 into the output file. At its simplest, it just copies contents into
# the merged file. Skips the index line if it is continuing from where the previous
# section left off

def fn_merge_hex32 (src_idx, source, outf, cur_idx) :
    src_file = open (source, 'r')
    for line in src_file :
        line = line.lstrip()
        words = line.split()

        if line.startswith ('@') :
            # At the beginning of a section the cur_idx points to the idx of the last
            # word in the precvious section.  
            if ((src_idx == cur_idx) and (cur_idx != 0)) :
                # Do not start a new section in the merged file as the new section
                # continues from where the last one left off
                sys.stdout.write ("INFO: Continuing section (src_idx: %d) (cur_idx: %d)\n"
                        % (src_idx, cur_idx))
                pass

            else :
                outf.write (line)
                cur_idx = src_idx   # reset the cur_idx to the start of the source

        elif ishexnum (words [0]) :
            outf.write (line)
            cur_idx += 1            # increment the index by 1 as we are handling .hex32 indices

        else : pass


    src_file.close ()
    return cur_idx


#------------------------
def main (argv):
    # Command-line parsing
    parser = argparse.ArgumentParser (
              formatter_class=argparse.RawDescriptionHelpFormatter
            , description="Merges individual hex32 sections into one")

    parser.add_argument (
              '--source'
            , action="append"
            , dest='sourceL'
            , default=None
            , help='List of section .hex32s for merging')

    parser.add_argument (
              '--out'
            , action="store"
            , dest='merged_hex32'
            , default=None
            , help='Merged .hex32 file')

    args = parser.parse_args()

    # --------
    # Create the merged file
    try :
        merged_out = open (args.merged_hex32, 'w')

    except :
        sys.stderr.write ("ERROR: Unable to open '%s' for writing\n" % args.merged_hex32)
        sys.exit (1)

    # --------
    # Create a dictionary of start-idx, hex-file pairs
    hex_dict = fn_create_hex_dict (args.sourceL)

    # The keys in the hex_dict are the start indices
    # Process the .hex32 files in the ascending order of the keys
    dot_idx = 0
    for idx in sorted (hex_dict) :
        dot_idx = fn_merge_hex32 (idx, hex_dict[idx], merged_out, dot_idx)

    merged_out.close ()
    return


#------------------------
# Utility fn to detect if the string is a hex number

def ishexnum (s):
    if len (s) == 0:
        return False
    for x in s:
        if x not in "0123456789abcdefABCDEF": return False
    return True

# ================================================================
# For non-interactive invocations, call main() and use its return value
# as the exit code.
if __name__ == '__main__':
  sys.exit (main (sys.argv))
