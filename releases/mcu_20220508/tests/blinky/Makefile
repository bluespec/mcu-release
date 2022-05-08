# -*- makefile -*-

ARCH ?= rv32imc
ifeq ($(ARCH),)
$(error ERROR: need to specify ARCH)
endif

ABI ?= ilp32
ifeq ($(ABI),)
$(error ERROR: need to specify ABI)
endif

# needed for uart.c
CLOCK_KHZ ?= 25000
ifeq ($(CLOCK_KHZ),)
$(error ERROR: need to specify CLOCK_KHZ)
endif

XLEN ?= 32
ifeq ($(XLEN),)
$(error ERROR: need to specify XLEN)
endif

CMODEL ?= medlow
ifeq ($(CMODEL),)
$(error ERROR: need to specify CMODEL)
endif

BASE_ADDR ?= 0xc0000000
ifeq ($(BASE_ADDR),)
$(error ERROR: need to specify BASE_ADDR)
endif

# Must have a / at the end
# Can be blank if you just want to use PATH
TOOLCHAIN ?= $(RISCVEXPLORER_TOOLCHAIN)

CROSS_COMPILE ?= riscv$(XLEN)-unknown-elf-

AR = $(TOOLCHAIN)$(CROSS_COMPILE)ar
CC = $(TOOLCHAIN)$(CROSS_COMPILE)gcc
CXX = $(TOOLCHAIN)$(CROSS_COMPILE)g++
LD = $(TOOLCHAIN)$(CROSS_COMPILE)ld
OBJCOPY = $(TOOLCHAIN)$(CROSS_COMPILE)objcopy
OBJDUMP = $(TOOLCHAIN)$(CROSS_COMPILE)objdump
STRIP = $(TOOLCHAIN)$(CROSS_COMPILE)strip

ASFLAGS += -march=$(ARCH) -mabi=$(ABI)

CFLAGS += -march=$(ARCH) -mabi=$(ABI)
CFLAGS += -specs=bare.specs

# omit debugging symbols to decrease code size
#CFLAGS += -g

# more flags to decrease code size
#CFLAGS += -ffunction-sections -fdata-sections -Os
#CFLAGS += -fdata-sections -Os
CFLAGS += -Os

# decrease code size
LDFLAGS += -Wl,--strip-debug
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,-N -ffreestanding -nostdlib -nostartfiles

CFLAGS += -DCLOCK_KHZ=$(CLOCK_KHZ)
CFLAGS += -mcmodel=$(CMODEL)

# needed for riscv_counters.c
CFLAGS += -DRV$(XLEN)

# We use the 'mcountinhibited' field in the cores database to define
# MCOUNT_ENABLE, which manually enables MCYCLE performance counters
# (used by riscv_counters.c).  Currently only CV32E40P comes out of
# reset with its performance counters disabled (those cores are
# annotated mcountinhibited=True in the database), so we manually enable
# them at the start of program execution in startup.S .  The other
# processors have performance counters automatically enabled, and any
# attempt to modify that state will result in an unhandled interrupt
# (so you should not try to manually enable or disable them).
#
# If you do not need the performance counters on CV32E40P -- not using
# them saves power -- then you can set MCOUNT_ENABLE to 0.
# read_cycle() on CV32E40P will then always return 0.
# Please see User Guide for more information.

MCOUNT_ENABLE ?= $(RISCVEXPLORER_MCOUNTINHIBITED)
ifeq ($(MCOUNT_ENABLE),1)
ASFLAGS += -DMCOUNT_ENABLE
endif

LDLIBS += -lm

LDFLAGS += -march=$(ARCH) -mabi=$(ABI)
LDFLAGS += -Wl,-e,_reset
LDFLAGS += -Wl,-Tbare.lds
LDFLAGS += -Wl,-Ttext-segment=$(BASE_ADDR)
LDFLAGS += -specs=bare.specs

.PHONY: default
default:
	@echo
	@echo no default target, try \'make help\'
	@echo
	@false

.PHONY: help
help:
	@echo
	@echo "Usage:"
	@echo "    make all        # compile exectable 'main'"
	@echo "    make clean      # remove executable and object files"
	@echo "    make sim        # run executable under simulation"
	@echo "    make cleanrun   # remove files created by simulation and gdb"
	@echo "    make fullclean  # do 'clean' and 'cleanrun'"
	@echo
	@echo "Use the program 'riscvexplorer-findcore' to select a core and"
	@echo "set environment variables needed for this Makefile."
	@echo

MAIN = main

.PHONY: all
all: $(MAIN)

.PHONY:clean
clean:
	$(RM) $(MAIN) *.o $(MAIN).text

$(MAIN).o: startup.o syscalls.o riscv_counters.o sort.o
$(MAIN).o: riscv_counters.h sort.h

$(MAIN): $(MAIN).o riscv_counters.o sort.o

# create disassembly with "make main.text"
%.text: %
	$(OBJDUMP) --all-headers --disassemble --source $^ > $@

.PHONY: cleanrun
cleanrun:
	rm -f Mem.hex init.gdb openocd.cfg symbol_table.txt target.cfg trace_out.dat logs/openocd.log logs/gdb-client.log logs/gdb-remote.log
	-rmdir logs
# do not force-delete logs directory if it is not empty; just leave it, ignoring the error of trying to delete a nonempty directory

.PHONY: fullclean
fullclean: clean cleanrun

.PHONY: size
size: $(MAIN)
	$(TOOLCHAIN)$(CROSS_COMPILE)size $^
