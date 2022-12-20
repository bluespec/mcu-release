# Makefile to convert an ELF to memhex files for specific platforms (WindSoC, DARPA SSITH GFE, Awsteria, ...)

FILE ?= Please_Define_FILE

ELF_TO_HEX_DIR = $(HOME)/git_clones/RISCV_Tests/Elf_to_Hex

# Generic memhex32 file, not for any specific platform
$(FILE).memhex32:
	$(ELF_TO_HEX_DIR)/Elf_to_Hex32.exe  $(FILE)  $(FILE).memhex32

# For WindSoC
.PHONY: WindSoC
WindSoC:
	@echo "TODO: fill in details for WindSoC memhex generation"

# For GFE
.PHONY: memhex_GFE
memhex_GFE:
	@echo "TODO: fill in details for DARPA SSITH GFE memhex generation"

# For AWSteria
.PHONY: memhex_AWSteria
memhex_AWSteria:
	$(ELF_TO_HEX_DIR)/Elfhex_to_Memhex.py  $(FILE).memhex512  512  0  0x_0400_0000  $(FILE).memhex32
