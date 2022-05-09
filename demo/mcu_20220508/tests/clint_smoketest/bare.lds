OUTPUT_ARCH( "riscv" )

tohost = 0xC8001ff4;

MEMORY
  {
  rom (x)   : ORIGIN = 0xC0000080, LENGTH = 0x07FFFF80
  ram (wr!x)  : ORIGIN = 0xC8000000, LENGTH = 0x08000000
  }

SECTIONS
{
    .startup 0xC0000000: { KEEP(startup.o(.text)) }
}
