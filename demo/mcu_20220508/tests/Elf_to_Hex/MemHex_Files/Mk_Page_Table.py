#!/usr/bin/python3 -B

# Copyright (c) 2020 Rishiyur S. Nikhil and Bluespec, Inc. All Rights Reserved.

# ================================================================
# Generate a RISC-V page table, per a declarative spec:
# - list of desired leaf pages (addr, PTE.GUXWR bits)
# - base addr area for allocation of page table nodes.

# WARNING: only for Sv39 so far

# ================================================================
# TODO:
# - parameterize for Sv32 (and possibly Sv48) as well

# ================================================================

import sys
import importlib

# ================================================================

def print_usage (argv): sys.stdout.write (
    "Usage:    {0}  <spec_file>.py\n".format (argv [0]) +
    "\n" +
    "  <spec_file>.py    Spec (desired pages etc.; see examples)\n" +
    "  Generates files (first two are alternative representations; latter is for info)\n" +
    "    <spec_file>.memhex32:       Page table image for loading into a memory.\n" +
    "    <spec_file>.carnyx_script:  Carnyx script to build the page table.\n" +
    "    <spec_file>.PT_map:         For information: Summary information about the page table.\n"
)

# ================================================================
# Example of contents of <spec_file>.py

# These are here for illustration only, and not used in this module,
# but you could cut-and-paste this into a <spec_file>.py to try it out.

# Each spec is for a leaf page: (phys addr, VPNs (PT indexes), PTE LSBs)

eg_page_specs = [
    # Normal/kilo pages (4KiB)
    (0x_8020_1000, [0x0,0x1,0x1], "DAG...R"),
    (0x_8020_2000, [0x0,0x1,0x2], "DAG..WR"),
    (0x_8020_3000, [0x0,0x1,0x3], "DAG.X.."),
    (0x_8020_4000, [0x0,0x1,0x4], "DAG.X.R"),
    (0x_8020_5000, [0x0,0x1,0x5], "DAG.XWR"),
    (0x_8020_6000, [0x0,0x1,0x6], "DAGU..R"),
    (0x_8020_7000, [0x0,0x1,0x7], "DAGU.WR"),
    (0x_8020_8000, [0x0,0x1,0x8], "DAGUX.."),
    (0x_8020_9000, [0x0,0x1,0x9], "DAGUX.R"),
    (0x_8020_A000, [0x0,0x1,0xA], "DAGUXWR"),

    # Megapages (2MiB)
    (0x_8000_0000, [0x0,0x0],     "DA..XWR"),

    # Gigapages (1GiB)
    (0x_C000_0000, [0x1],         "DA..XWR") ]

# Page-table nodes (4KB each) will be allocated from this addr onward

eg_ptn_alloc_addr = 0x8040_0000

# ================================================================

PTES_PER_PTN = 512    # For SV39

# ================================================================
# Recursive tree data structure:
#    obj = { PTN,  addr, [(PTE, child_obj), (PTE, child_obj), ...] }
#    obj = { PAGE, addr, lsbs }

def mkObj (objtype, addr, pt_indexes, contents):
    return { "type"      : objtype,
             "addr"      : addr,
             "pt_indexes": pt_indexes,
             "contents"  : contents }

# ================================================================
# Check that specs has type List (Tuple3 (Int, List [int], String))

def typecheck (specs):
    for spec in specs:
        if type (spec) != tuple: return ("spec is not a tuple: " + str (spec))
        elif len (spec)  != 3:   return ("spec is not a 3-tuple: " + str (spec))
        else:
            (pa, vpn_indexes, lsbs) = spec
            if type (pa)   != int:           return ("spec phys addr is not a number: " + str (spec))
            elif type (vpn_indexes) != list: return ("spec vpn_indexes is not a list: " + str (spec))
            elif ((len (vpn_indexes) < 1) or
                  (len (vpn_indexes) > 3)):  return ("spec vpn_indexes list is not of length 1,2 or 3: " + str (spec))
            elif not (all ([ (type (j) == int) for j in vpn_indexes])):
                                             return ("spec vpn_indexes is not a list of ints: " + str (spec))
            elif type (lsbs) != str:         return ("spec PTE lsb spec is not a string: " + str (spec))

    return "ok"

# ================================================================

def main (argv = None):

    global ptn_alloc_addr

    if ((len (argv) != 2)
        or ("-h" in argv)
        or ("--help" in argv)):
        print_usage (argv)
        return 0

    input_filename  = argv [1]
    if not input_filename.endswith (".py"):
        sys.stderr.write ("ERROR: input filename must end in .py:  {0}\n".format (input_filename))
        sys.exit (1)

    input_modulename       = input_filename [:-3]
    memhex32_filename      = input_modulename + ".memhex32"
    carnyx_script_filename = input_modulename + ".carnyx_script"
    map_filename           = input_modulename + ".PT_map"

    # Read the spec
    try:
        vmspec = importlib.import_module (input_modulename)

    except:
        sys.stderr.write ("ERROR: Unable to import module {0}\n".format (input_filename))
        return 1

    # Typecheck the spec
    x = typecheck (vmspec.page_specs)
    if x != "ok":
        sys.stdout.write ("ERROR: {:s}\n".format (x))
        return 1

    # Create PT data structure
    sys.stdout.write ("Inserting specs\n")
    ptn2 = mkNew_PTN ()
    for leaf_spec in vmspec.page_specs:
        (leaf_pa, vpn_indexes, lsbs) = leaf_spec
        insert_leaf_spec (ptn2, vpn_indexes, leaf_pa, lsbs)

    # Allocate addresses for PTNs
    sys.stdout.write ("Allocate PTN addresses\n")
    alloc_PTN_pas (ptn2, vmspec.ptn_alloc_addr)

    # Display the page table, for reference
    sys.stdout.write ("Writing page table map file: {0}\n".format (map_filename))
    with open (map_filename, "w") as fout:
        display_PT (fout, ptn2)

    # Generate a MemHex32 file
    sys.stdout.write ("Generating page table MemHex32 file: {0}\n".format (memhex32_filename))
    with open (memhex32_filename, "w") as fout:
        gen_memhex32 (fout, ptn2)

    # Generate a Carnyx script file
    sys.stdout.write ("Generating Carnyx script file to construct page table: {0}\n".format (carnyx_script_filename))
    with open (carnyx_script_filename, "w") as fout:
        gen_carnyx_script (fout, ptn2)

    return 0

# ================================================================
# Insert leaf-page spec into page table

def insert_leaf_spec (ptn, vpn_indexes, leaf_pa, lsbs):
    indexes = vpn_indexes
    level   = 2
    while indexes != []:
        j           = indexes [0]
        indexes     = indexes [1:]
        ptn_entries = ptn ["entries"]
        entry_j     = ptn_entries [j]
        if indexes == []:
            # Leaf
            if entry_j == None:
                ptn_entries [j] = mkLeaf_PTE (level, leaf_pa, lsbs)
            else:
                sys.stdout.write ("ERROR: Duplicate spec: {:_x}, {:s}, {:s}\n"
                                  .format (leaf_pa, str (vpn_indexes), lsbs))
                sys.exit (1)
        else:
            # Non-leaf
            if entry_j == None:
                entry_j = mkNew_PTN()
                ptn_entries [j] = entry_j
            ptn     = entry_j
            level  -= 1
            continue

# ================================================================
# Traverse the PT and allocate PAs for each PT node

def alloc_PTN_pas (ptn2, pa):
    ptn2 ["pa"]  = pa
    sys.stdout.write ("    Lev 2 PTN @ {:_x}\n".format (ptn2 ["pa"]))
    pa          += (PTES_PER_PTN * 8)

    ptn_entries2 = ptn2 ["entries"]
    for j2 in range (len (ptn_entries2)):
        entry2 = ptn_entries2 [j2]
        if (entry2 == None):
            pass
        elif isLeaf_PTE (entry2):
            pass
        else:
            entry2 ["pa"] = pa
            pa           += (PTES_PER_PTN * 8)
            sys.stdout.write ("        Lev 1 PTN @ {:_x}\n".format (entry2 ["pa"]))

            ptn_entries1  = entry2 ["entries"]
            for j1 in range (len (ptn_entries1)):
                entry1 = ptn_entries1 [j1]
                if (entry1 == None):
                    pass
                elif isLeaf_PTE (entry1):
                    pass
                else:
                    entry1 ["pa"] = pa
                    pa           += (PTES_PER_PTN * 8)
                    sys.stdout.write ("            Lev 0 PTN @ {:_x}\n".format (entry1 ["pa"]))

# ================================================================
# Display the PT map information

def display_PT (fout, ptn2):
    mode = 8    # code for Sv39
    asid = 0
    satp = ((mode << 60) | (asid << 44) | (ptn2 ["pa"] >> 12))
    fout.write ("Page table: SATP = {:_x}\n".format (satp))

    pa2          = ptn2 ["pa"]
    ptn_entries2 = ptn2 ["entries"]
    fout.write ("    Lev 2 PTN @ {:_x}\n".format (pa2))

    for j2 in range (len (ptn_entries2)):
        entry2 = ptn_entries2 [j2]
        if (entry2 == None):
            pass
        elif isLeaf_PTE (entry2):
            fout.write ("        [{:_x}] Leaf PTE -> {:_x}  {:s}\n"
                        .format (j2, entry2 ["pa"], entry2 ["lsbs"]))
        else:
            pa1          = entry2 ["pa"]
            ptn_entries1 = entry2 ["entries"]
            fout.write ("        [{:_x}] Lev 1 PTN @ {:_x}\n".format (j2, pa1))
            for j1 in range (len (ptn_entries1)):
                entry1 = ptn_entries1 [j1]
                if (entry1 == None):
                    pass
                elif isLeaf_PTE (entry1):
                    fout.write ("                [{:_x},{:_x}] Leaf PTE -> {:_x}  {:s}\n"
                                .format (j2, j1, entry1 ["pa"], entry1 ["lsbs"]))
                else:
                    pa0          = entry1 ["pa"]
                    ptn_entries0 = entry1 ["entries"]
                    fout.write ("                [{:_x},{:_x}] Lev 0 PTN @ {:_x}\n".format (j2, j1, pa0))
                    for j0 in range (len (ptn_entries0)):
                        entry0 = ptn_entries0 [j0]
                        if (entry0 == None):
                            pass
                        elif isLeaf_PTE (entry0):
                            fout.write ("                        [{:_x},{:_x},{:_x}]: Leaf PTE -> {:_x}  {:s}\n"
                                        .format (j2, j1, j0, entry0 ["pa"], entry0 ["lsbs"]))
                        else:
                            sys.stdout.write ("ERROR: level 0 entry is not a PTE: {:_x}\n".format (entry0))
                            sys.stdout.write ("    At index {:d}, {:d}, {:d}\n".format (j0, j1, j2))

# ================================================================
# Generate a memhex32 for the PT.

def gen_memhex32 (fout, ptn2):
    def show_ppns (ppns):
        fout.write ("    // [PPNs ")
        for k in range (len (ppns)):
            if (k > 0):
                fout.write (",")
            fout.write ("{:_x}".format (ppns [k]))
        fout.write ("]")

    def gen_ptn_memhex32 (ppns, level, ptn, va, va_incr):
        ptn_entries = ptn ["entries"]
        fout.write ("@{:016x}    // PTE\n".format (ptn ["pa"] >> 2))
        for j in range (len (ptn_entries)):
            entry = ptn_entries [j]
            if (entry == None):
                pte = invalid_pte
                fout.write ("{:08x}\n".format (pte         & 0x_FFFF_FFFF))
                fout.write ("{:08x}\n".format ((pte >> 32) & 0x_FFFF_FFFF))
            elif isLeaf_PTE (entry):
                pte = encode_leaf_PTE (level, entry ["pa"], entry ["lsbs"])

                fout.write ("{:08x}".format (pte         & 0x_FFFF_FFFF))
                show_ppns (ppns + [j])
                fout.write (": Leaf PTE -> {:016_x}  {:s}\n"
                            .format (entry ["pa"], entry ["lsbs"]))

                fout.write ("{:08x}".format ((pte >> 32) & 0x_FFFF_FFFF))
                fout.write ("    //                   va   {:016_x}\n".format (va))
            else:
                pte = encode_nonleaf_PTE (entry ["pa"])

                fout.write ("{:08x}".format (pte         & 0x_FFFF_FFFF))
                show_ppns (ppns + [j])
                fout.write (": Non-Leaf PTE -> {:016_x}\n"
                            .format (entry ["pa"]))

                fout.write ("{:08x}".format ((pte >> 32) & 0x_FFFF_FFFF))
                fout.write ("    //                   va   {:016_x}\n".format (va))
            va += va_incr

    pa2 = ptn2 ["pa"]
    # fout.write ("    Lev 0 PTN @ {:_x}\n".format (pa2))
    va2 = 0
    gen_ptn_memhex32 ([], 2, ptn2, va2, 0x_4000_0000)

    ptn_entries2 = ptn2 ["entries"]
    va1 = va2
    for j2 in range (len (ptn_entries2)):
        entry2 = ptn_entries2 [j2]
        if (entry2 == None):
            pass
        elif isLeaf_PTE (entry2):
            pass
        else:
            pa1 = entry2 ["pa"]
            # fout.write ("        Lev 1 PTN @ {:_x}\n".format (pa1))
            gen_ptn_memhex32 ([j2], 1, entry2, va1, 0x_20_0000)

            ptn_entries1 = entry2 ["entries"]
            va2 = va1
            for j1 in range (len (ptn_entries1)):
                entry1 = ptn_entries1 [j1]
                if (entry1 == None):
                    pass
                elif isLeaf_PTE (entry1):
                    pass
                else:
                    pa0 = entry1 ["pa"]
                    # fout.write ("            Lev 0 PTN @ {:_x}\n".format (pa0))
                    gen_ptn_memhex32 ([j2, j1], 0, entry1, va2, 0x_1000)

                va2 += 0x_20_0000

        va1 += 0x_4000_0000

# ================================================================
# Generate a Carnyx script to construct the PT

def gen_carnyx_script (fout, ptn2):
    def show_ppns (ppns):
        fout.write ("    # [PPNs ")
        for k in range (len (ppns)):
            if (k > 0):
                fout.write (",")
            fout.write ("{:_x}".format (ppns [k]))
        fout.write ("]")

    def gen_ptn_script (ppns, level, ptn, va, va_incr):
        ptn_entries = ptn ["entries"]
        ptn_pa      = ptn ["pa"]
        fout.write ("# PTN at @{:016x}\n".format (ptn_pa))
        for j in range (len (ptn_entries)):
            entry = ptn_entries [j]
            if (entry == None):
                fout.write ("SD {:09_x}  {:0_x}        ".format (ptn_pa + (j * 8), invalid_pte))
                # Informational comments
                show_ppns (ppns + [j])
                fout.write (": Invalid PTE  va {:0_x}\n"
                            .format (va))
            elif isLeaf_PTE (entry):
                pte = encode_leaf_PTE (level, entry ["pa"], entry ["lsbs"])
                fout.write ("SD {:09_x}  {:09_x}".format (ptn_pa + (j * 8), pte))
                # Informational comments
                show_ppns (ppns + [j])
                fout.write (": Leaf PTE -> {:0_x}  {:s}  va {:0_x}\n"
                            .format (entry ["pa"], entry ["lsbs"], va))
            else:
                pte = encode_nonleaf_PTE (entry ["pa"])
                fout.write ("SD {:09_x}  {:09_x}".format (ptn_pa + (j * 8), pte))
                # Informational comments
                show_ppns (ppns + [j])
                fout.write (": Non-Leaf PTE -> {:0_x}  va {:0_x}\n"
                            .format (entry ["pa"], va))
            va += va_incr

    fout.write ("# BEGIN PAGE TABLE CONSTRUCTION SCRIPT created by Mk_Page_Table.py\n")
    pa2 = ptn2 ["pa"]
    # fout.write ("#    Lev 0 PTN @ {:_x}\n".format (pa2))
    va2 = 0
    gen_ptn_script ([], 2, ptn2, va2, 0x_4000_0000)

    ptn_entries2 = ptn2 ["entries"]
    va1 = va2
    for j2 in range (len (ptn_entries2)):
        entry2 = ptn_entries2 [j2]
        if (entry2 == None):
            pass
        elif isLeaf_PTE (entry2):
            pass
        else:
            pa1 = entry2 ["pa"]
            # fout.write ("#        Lev 1 PTN @ {:_x}\n".format (pa1))
            gen_ptn_script ([j2], 1, entry2, va1, 0x_20_0000)

            ptn_entries1 = entry2 ["entries"]
            va2 = va1
            for j1 in range (len (ptn_entries1)):
                entry1 = ptn_entries1 [j1]
                if (entry1 == None):
                    pass
                elif isLeaf_PTE (entry1):
                    pass
                else:
                    pa0 = entry1 ["pa"]
                    # fout.write ("#            Lev 0 PTN @ {:_x}\n".format (pa0))
                    gen_ptn_script ([j2, j1], 0, entry1, va2, 0x_1000)

                va2 += 0x_20_0000

        va1 += 0x_4000_0000

    fout.write ("# END PAGE TABLE CONSTRUCTION SCRIPT created by Mk_Page_Table.py\n")

# ================================================================
# PTN data structure {type, pa, [PTE]}

def mkNew_PTN ():
    pa = 0    # fixed up in later traveral
    return {"type": "ptn", "pa": pa, "entries": PTES_PER_PTN * [None]}

# ================================================================
# Leaf PTE data structure {type, level, pa, lsbs}

def mkLeaf_PTE (level, pa, lsbs):
    return {"type": "leaf_pte", "level":level, "pa": pa, "lsbs": lsbs}

def isLeaf_PTE (x):
    return (type (x) == dict) and (x ["type"] == "leaf_pte")

# ================================================================
# Encode Leaf and Non-Leaf PTEs

invalid_pte = 0

def encode_leaf_PTE (level, pa, lsbs_spec):
    lsbs      = 1    # valid
    if "D" in lsbs_spec: lsbs = lsbs | 0x80
    if "A" in lsbs_spec: lsbs = lsbs | 0x40
    if "G" in lsbs_spec: lsbs = lsbs | 0x20
    if "U" in lsbs_spec: lsbs = lsbs | 0x10
    if "X" in lsbs_spec: lsbs = lsbs | 0x08
    if "W" in lsbs_spec: lsbs = lsbs | 0x04
    if "R" in lsbs_spec: lsbs = lsbs | 0x02
    shamt = (level * 9)

    # Check that the address is properly aligned
    mask = (1 << (12 + shamt)) - 1
    if ((pa & mask) != 0):
        sys.stdout.write ("ERROR: phys addr {:019_x} not aligned for level {:d} PTE\n".format (pa, level))
        sys.exit (1)

    ppn  = pa >> (12 + shamt)
    pte  = (ppn << (10 + shamt)) | lsbs
    return pte

def encode_nonleaf_PTE (pa):
    lsbs  = 1    # Valid bit only (non-leaf, pointer to child)

    # Check that the address is properly aligned
    mask = (1 << 12) - 1
    if ((pa & mask) != 0):
        sys.stdout.write ("ERROR: phys addr {:019_x} not aligned for level {:d} PTE\n".format (pa, level))
        sys.exit (1)

    ppn  = pa >> 12
    pte  = (ppn << 10) | lsbs
    return pte

# ================================================================
# For non-interactive invocations, call main() and use its return value
# as the exit code.
if __name__ == '__main__':
  sys.exit (main (sys.argv))
