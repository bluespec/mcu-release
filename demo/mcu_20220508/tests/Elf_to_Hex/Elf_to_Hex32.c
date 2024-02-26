// Copyright (c) 2013-2020 Bluespec, Inc. All Rights Reserved

// This program reads an ELF file into an in-memory byte-array,
// and writes out a Mem.hex32 file

// ================================================================
// Standard C includes

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <gelf.h>

// ================================================================
// Features of the ELF binary

typedef struct {
    uint8_t  *mem_buf;
    int       bitwidth;
    uint64_t  min_paddr;
    uint64_t  max_paddr;

    uint64_t  pc_start;       // Addr of label  '_start'
    uint64_t  pc_exit;        // Addr of label  'exit'
    uint64_t  tohost_addr;    // Addr of label  'tohost'
} Elf_Features;

// ================================================================
// Read the ELF file into the array buffer

#define  RESULT_OK   0
#define  RESULT_ERR  1

// ================================================================

// From /usr/include/gelf.h
//    typedef Elf64_Phdr GElf_Phdr;

// From /usr/include/elf.h
//    typedef struct
//    {
//      Elf64_Word    p_type;                 /* Segment type */
//      Elf64_Word    p_flags;                /* Segment flags */
//      Elf64_Off     p_offset;               /* Segment file offset */
//      Elf64_Addr    p_vaddr;                /* Segment virtual address */
//      Elf64_Addr    p_paddr;                /* Segment physical address */
//      Elf64_Xword   p_filesz;               /* Segment size in file */
//      Elf64_Xword   p_memsz;                /* Segment size in memory */
//      Elf64_Xword   p_align;                /* Segment alignment */
//    } Elf64_Phdr;

static
uint64_t fn_vaddr_to_paddr (Elf *e, uint64_t vaddr, uint64_t size)
{
    GElf_Phdr phdr;    // = Elf64_Phdr
    int index = 0;

    /*
    fprintf (stdout, "%16s", "Virtual address");
    fprintf (stdout, " %16s", "Virt addr lim");
    fprintf (stdout, "    ");
    fprintf (stdout, " %9s", "Type");
    fprintf (stdout, " %5s", "Flags");
    fprintf (stdout, " %16s", "File offset");
    fprintf (stdout, " %8s", "Phy addr");
    fprintf (stdout, " %8s", "Sz file");
    fprintf (stdout, " %8s", "Sz mem");
    fprintf (stdout, " %8s", "Alignment\n");
    */

    while (gelf_getphdr (e, index, & phdr) != NULL) {
	/*
	fprintf (stdout, "%016lx",  phdr.p_vaddr);
	fprintf (stdout, " %016lx",  phdr.p_vaddr + phdr.p_memsz);

	fprintf (stdout, " [%02d]", index);
	fprintf (stdout, " %8x",    phdr.p_type);
	fprintf (stdout, " %5x",    phdr.p_flags);
	fprintf (stdout, " %16lx",  phdr.p_offset);
	fprintf (stdout, " %8lx",   phdr.p_paddr);
	fprintf (stdout, " %8lx",   phdr.p_filesz);
	fprintf (stdout, " %8lx",   phdr.p_memsz);
	fprintf (stdout, " %8lx\n", phdr.p_align);
	*/

	if ((phdr.p_vaddr <= vaddr) && (size <= phdr.p_memsz)) {
	    return (vaddr - phdr.p_vaddr) + phdr.p_paddr;
	}
	index++;
    }
    // Did not find segment for this.
    fprintf (stdout, "ERROR: %s: Could not find segment containing given virtual range\n", __FUNCTION__);
    fprintf (stdout, "    vaddr %0" PRIx64 "  size %0" PRIx64 "\n", vaddr, size);
    exit (1);
}

// ================================================================
// Scan the ELF file
// Called twice:
// Pass 1: with p_features->mem_buf == NULL: for analysis only
// Pass 2: with p_features->mem_buf != NULL: fills data starting at min_paddr

static
int scan_elf (Elf           *e,
	       GElf_Ehdr     *ehdr,
	       const char    *start_symbol,
	       const char    *exit_symbol,
	       const char    *tohost_symbol,

	       Elf_Features  *p_features, Elf_Scn *scn, GElf_Shdr shdr)
{
    bool pass1 = (p_features->mem_buf == NULL);
    bool pass2 = (p_features->mem_buf != NULL);

    Elf_Data *data = 0;
    // If we find an 'ALLOC' type section, it belongs in the memhex
    if (shdr.sh_flags & SHF_ALLOC) {
        data = elf_getdata (scn, data);

        // data->sh_addr may be virtual; find the phys addr from the segment table
        uint64_t section_paddr = fn_vaddr_to_paddr (e, shdr.sh_addr, data->d_size);
        if (pass1) {
            fprintf (stdout, "vaddr %16" PRIx64 " to vaddr %16" PRIx64 "; size 0x%lx (= %0ld) bytes\n",
                     shdr.sh_addr, shdr.sh_addr + data->d_size, data->d_size, data->d_size);
            fprintf (stdout, "                              paddr %16" PRIx64 "\n", section_paddr);
        }

        if (data->d_size == 0) {
            if (pass1) {
                fprintf (stdout, "    Empty section (0-byte size), ignoring\n");
                // Do not allocate this section to memory
                return (1);
            }
        }
        else if (pass1) {
            if (section_paddr < p_features->min_paddr)
                p_features->min_paddr = section_paddr;
            if (p_features->max_paddr < (section_paddr + data->d_size - 1))
                p_features->max_paddr = section_paddr + data->d_size - 1;
        }
        else if (pass2 && (shdr.sh_type != SHT_NOBITS)) {
            // fprintf (stdout, "Section %-20s: ", sec_name);
            fprintf (stdout, " Copying data from ELF into mem_buf: addr 0x%0lx bytes 0x%0lx (%0ld)\n",
                     section_paddr, data->d_size, data->d_size);
            memcpy (& (p_features->mem_buf [section_paddr - p_features->min_paddr]),
                    data->d_buf,
                    data->d_size);

            /* DEBUGGING
            for (int j = 0; j < data->d_size; j += 64) {
                fprintf (stdout, "  ");
                for (int k = 0; k < 64; k++)
                    if (j + k < data->d_size)
                        fprintf (stdout, "%2x",
                                 p_features->mem_buf [section_paddr - p_features->min_paddr + j + k]);
                fprintf (stdout, "\n");
            } */
        }
    }

    // If we find the symbol table, search for symbols of interest (on pass 1)
    else if ((shdr.sh_type == SHT_SYMTAB) && pass1) {
        fprintf (stdout, "Searching for addresses of '%s', '%s' and '%s' symbols\n",
                 start_symbol, exit_symbol, tohost_symbol);

        // Get the section data
        data = elf_getdata (scn, data);

        // Get the number of symbols in this section
        int symbols = shdr.sh_size / shdr.sh_entsize;

        // search for the uart_default symbols we need to potentially modify.
        GElf_Sym sym;
        int i;
        for (i = 0; i < symbols; ++i) {
            // get the symbol data
            gelf_getsym (data, i, &sym);

            // get the name of the symbol
            char *name = elf_strptr (e, shdr.sh_link, sym.st_name);

            // Look for, and remember PC of the start symbol
            if (strcmp (name, start_symbol) == 0) {
                p_features->pc_start = fn_vaddr_to_paddr (e, sym.st_value, 4);
            }
            // Look for, and remember PC of the exit symbol
            else if (strcmp (name, exit_symbol) == 0) {
                p_features->pc_exit = fn_vaddr_to_paddr (e, sym.st_value, 4);
            }
            // Look for, and remember addr of 'tohost' symbol
            else if (strcmp (name, tohost_symbol) == 0) {
	      if (sym.st_info == ELF64_ST_INFO(STB_GLOBAL, STT_NOTYPE)) {
                p_features->tohost_addr = sym.st_value;
	      } else {
                p_features->tohost_addr = fn_vaddr_to_paddr (e, sym.st_value, 4);
	      }
            }
        }

        fprintf (stdout, "Symbols of interest\n");

        fprintf (stdout, "    _start");
        if (p_features->pc_start == -1)
            fprintf (stdout, "    Not found\n");
        else
            fprintf (stdout, "    0x%0" PRIx64 "\n", p_features->pc_start);

        fprintf (stdout, "    exit  ");
        if (p_features->pc_exit == -1)
            fprintf (stdout, "    Not found\n");
        else
            fprintf (stdout, "    0x%0" PRIx64 "\n", p_features->pc_exit);

        fprintf (stdout, "    tohost");
        if (p_features->tohost_addr == -1)
            fprintf (stdout, "    Not found\n");
        else
            fprintf (stdout, "    0x%0" PRIx64 "\n", p_features->tohost_addr);

        // This section does not allocate to memory
        return (1);
    }
    else {
        if (pass1) {
            fprintf (stdout, "ELF section ignored\n");
            // This section does not allocate to memory
            return (1);
        }
    }
    return (0);
}

// ================================================================
// Load an ELF file.
// After opening the ELF object, does 2 passes, once for analysis and
// once for getting the image data.

static
int c_mem_load_elf (const char    *elf_filename,
		    const char    *start_symbol,
		    const char    *exit_symbol,
		    const char    *tohost_symbol,
		    Elf_Features  *p_features)
{
    int fd;
    // int n_initialized = 0;
    Elf *e;

    // Verify the elf library version
    if (elf_version (EV_CURRENT) == EV_NONE) {
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: Failed to initialize the libelf library.\n");
	return RESULT_ERR;
    }

    // Open the file for reading
    fd = open (elf_filename, O_RDONLY, 0);
    if (fd < 0) {
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: could not open elf input file: %s\n",
		 elf_filename);
	return RESULT_ERR;
    }

    // Initialize the Elf pointer with the open file
    e = elf_begin (fd, ELF_C_READ, NULL);
    if (e == NULL) {
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: elf_begin() initialization failed!\n");
	return RESULT_ERR;
    }

    // Verify that the file is an ELF file
    if (elf_kind (e) != ELF_K_ELF) {
        elf_end (e);
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: specified file '%s' is not an ELF file!\n",
		 elf_filename);
	return RESULT_ERR;
    }

    // Get the ELF header
    GElf_Ehdr ehdr;
    if (gelf_getehdr (e, & ehdr) == NULL) {
        elf_end (e);
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: get_getehdr() failed: %s\n",
		 elf_errmsg (-1));
	return RESULT_ERR;
    }

    // Is this a 32b or 64 ELF?
    if (gelf_getclass (e) == ELFCLASS32) {
	fprintf (stdout, "c_mem_load_elf: %s is a 32-bit ELF file\n", elf_filename);
	p_features->bitwidth = 32;
    }
    else if (gelf_getclass (e) == ELFCLASS64) {
	fprintf (stdout, "c_mem_load_elf: %s is a 64-bit ELF file\n", elf_filename);
	p_features->bitwidth = 64;
    }
    else {
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: ELF file '%s' is not 32b or 64b\n",
		 elf_filename);
	elf_end (e);
	return RESULT_ERR;
    }

    // Verify we are dealing with a RISC-V ELF
    if (ehdr.e_machine != 243) {
	// EM_RISCV is not defined, but this returns 243 when used with a valid elf file.
        elf_end (e);
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: %s is not a RISC-V ELF file\n",
		 elf_filename);
	return RESULT_ERR;
    }

    // Verify we are dealing with a little endian ELF
    if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB) {
        elf_end (e);
	fprintf (stdout,
		 "ERROR: c_mem_load_elf: %s is big-endian 64-bit RISC-V executable, not supported\n",
		 elf_filename);
	return RESULT_ERR;
    }

    // Iterate through each of the sections looking for code that should be loaded
    Elf_Scn  *scn   = 0;

    p_features->pc_start    = 0xFFFFFFFFFFFFFFFFllu;
    p_features->pc_exit     = 0xFFFFFFFFFFFFFFFFllu;
    p_features->tohost_addr = 0xFFFFFFFFFFFFFFFFllu;
    while ((scn = elf_nextscn (e,scn)) != NULL) {
       GElf_Shdr shdr;

       // Grab the string section index
       size_t shstrndx;
       shstrndx = ehdr.e_shstrndx;

       p_features->mem_buf     = NULL;
       p_features->bitwidth    = 0;
       p_features->min_paddr   = 0xFFFFFFFFFFFFFFFFllu;
       p_features->max_paddr   = 0x0000000000000000llu;

       // Pass 1: analysis and fill in p_features for the given section
       fprintf (stdout, ">================================================================\n");
       fprintf (stdout, "1: analyzing ELF\n");

       // get the header information for this section
       gelf_getshdr (scn, & shdr);
       char *sec_name = elf_strptr (e, shstrndx, shdr.sh_name);
       fprintf (stdout, "Section %-20s: ", sec_name);
       int ignore = scan_elf (e, & ehdr, start_symbol, exit_symbol, tohost_symbol, p_features, scn, shdr);

       // If the section is to be allocated to memory
       if (ignore == 0) {
          uint64_t mem_buf_size = p_features->max_paddr + 1 - p_features->min_paddr;
          fprintf (stdout, "Min paddr: 0x%016" PRIx64 "\n", p_features->min_paddr);
          fprintf (stdout, "Max paddr: 0x%016" PRIx64 "\n", p_features->max_paddr);
          fprintf (stdout, "Size:      0x%016" PRIx64 " (%0" PRId64 ") bytes\n", mem_buf_size, mem_buf_size);

          // Pass 2: create mem_buf and extract data into mem_buf
          fprintf (stdout, ">================================================================\n");
          fprintf (stdout, "2: getting payload\n");

          // Allocate mem_buf, sufficiently large, and zero it out.
          p_features->mem_buf = (uint8_t *) malloc (mem_buf_size);
          if (p_features->mem_buf == NULL) {
              fprintf (stdout, "ERROR: c_mem_load_elf: unable to malloc buf of above size\n");
              return RESULT_ERR;
          }

          bzero (p_features->mem_buf, mem_buf_size);
          fprintf (stdout, "c_mem_load_elf: created and zeroed mem_buf from %0lx through %0lx\n",
                   p_features->min_paddr, p_features->max_paddr);

          scan_elf (e, & ehdr, start_symbol, exit_symbol, tohost_symbol, p_features, scn, shdr);

          // Write out the mem_buf into a hex32 for this section
          // Write out Mem.hex32 file
          char *op_fn = (char *) malloc (20 * sizeof (char));
          sprintf (op_fn, "%s.hex32", sec_name);
          fprintf (stdout, "Writing Mem.hex32 file: %s\n", op_fn);
          FILE *fout = fopen (op_fn, "w");
          if (fout == NULL) {
              fprintf (stdout, "ERROR: unable to open file for writing: %s\n", op_fn);
              return 1;
          }

          uint64_t min_paddr = ((p_features->min_paddr >> 2) << 2);
          uint64_t max_paddr = (p_features->max_paddr | 0x3);

          fprintf (fout, "@%0lx\n", (min_paddr >> 2));
          uint64_t paddr;
          for (paddr = min_paddr; paddr <= max_paddr; paddr += 4) {
              uint32_t *p = (uint32_t *) (p_features->mem_buf + (paddr - min_paddr));
              fprintf (fout, "%08x    // %08lx\n", *p, paddr);
          }
          fclose (fout);
          free (p_features->mem_buf);
       }
    }

    FILE *fp_symbol_table = fopen ("symbol_table.txt", "w");
    if (fp_symbol_table != NULL) {
	fprintf (stdout, "Writing symbols to:    symbol_table.txt\n");
	if (p_features -> pc_start == -1)
	    fprintf (stdout, "    No '_start' label found\n");
	else
	    fprintf (fp_symbol_table, "_start    0x%0" PRIx64 "\n", p_features -> pc_start);

	if (p_features -> pc_exit == -1)
	    fprintf (stdout, "    No 'exit' label found\n");
	else
	    fprintf (fp_symbol_table, "exit      0x%0" PRIx64 "\n", p_features -> pc_exit);

	if (p_features -> tohost_addr == -1)
	    fprintf (stdout, "    No 'tohost' symbol found\n");
	else
	    fprintf (fp_symbol_table, "tohost    0x%0" PRIx64 "\n", p_features -> tohost_addr);

	fclose (fp_symbol_table);
    }
    elf_end (e);

    return RESULT_OK;
}

// ================================================================

int main (int argc, char *argv [])
{
    if (argc < 2) {
	fprintf (stdout, "Usage:    %s  <elf_file_name>\n", argv [0]);
	fprintf (stdout, "Generates section-wise breakup of the input elf file\n");
	return 1;
    }

    Elf_Features  elf_features;

    // Load ELF file into mem buf
    int retcode = c_mem_load_elf (argv [1], "_start", "exit", "tohost", & elf_features);
    if (retcode != 0)
	return 1;
    else
       return 0;
}
