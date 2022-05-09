Elf_to_Hex32.exe: Elf_to_Hex32.c
	cc  -o Elf_to_Hex32.exe  Elf_to_Hex32.c  -lelf

test: Elf_to_Hex32.exe
	./Elf_to_Hex32.exe  ../GFE/FreeBSD_2020-09-03/kernel-riscv64.GFE-NODEBUG  foo.Mem.hex32

.PHONY: clean
clean:
	rm -f  *~

.PHONY: full_clean
full_clean:
	rm -f  *~  *.exe
