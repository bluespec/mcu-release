# This is an input file for Mk_Page_Table.py
# Each spec is for a leaf page: (phys addr, VPNs (PT indexes), PTE LSBs)

page_specs = [
    # Normal/kilo pages (4KiB)
    (0x_C020_1000, [0x1,0x1,0x1], "DAG...R"),
    (0x_C020_2000, [0x1,0x1,0x2], "DAG..WR"),
    (0x_C020_3000, [0x1,0x1,0x3], "DAG.X.."),
    (0x_C020_4000, [0x1,0x1,0x4], "DAG.X.R"),
    (0x_C020_5000, [0x1,0x1,0x5], "DAG.XWR"),
    (0x_C020_6000, [0x1,0x1,0x6], "DAGU..R"),
    (0x_C020_7000, [0x1,0x1,0x7], "DAGU.WR"),
    (0x_C020_8000, [0x1,0x1,0x8], "DAGUX.."),
    (0x_C020_9000, [0x1,0x1,0x9], "DAGUX.R"),
    (0x_C020_A000, [0x1,0x1,0xA], "DAGUXWR"),

    # Megapages (2MiB)
    (0x_C000_0000, [0x1,0x0],     "DA..XWR"),

    # Gigapages (1GiB)
    (0x_8000_0000, [0x0],         "DA..XWR") ]

# Page-table nodes (4KB each) will be allocated from this addr onward

ptn_alloc_addr = 0xC040_0000
