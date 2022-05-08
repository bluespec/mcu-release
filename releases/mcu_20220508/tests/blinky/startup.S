	.text
	.globl	_reset
	.globl  _sp

_reset:
        // sp set to last word of a 8K DTCM. This value is
        // selected as 8K is the smallest TCM size supported, and
        // the blinky example is small enough to not require more
        // than a few bytes of the DTCM
	li	sp, 0xC8001ff0

	// Place an illegal instruction (0) at the stack pointer
	// so that the program ends if the value is used
	sw	zero, 0(sp)
	sw	zero, -4(sp)

        // Set MTVEC to the reset address, so that the program
        // restarts on a trap
	la	s0, _reset
	csrw	mtvec, s0

        // jump to main program and return to a self-loop
	jal	main
        j       stay

trap:   la      s0, 0x6fff0000
        li      s1, 0x9240
        sh      s1, 0(s0)
stay:   j       stay
