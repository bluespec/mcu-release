	.text
	.globl	_reset

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

	// Set MSTATUS
	// Disable MSTATUS.MIE, MSTATUS.SIE, MSTATUS.UIE
	// Set MSTATUS.FS to 2 = Dirty
	li      s0, 0x6000
	csrw    mstatus, s0

	// Set MTVEC to point at mtvec_handler
	.extern	mtvec_handler
	la	s0, mtvec_handler
	csrw	mtvec, s0

        // jump to main program and return to a self-loop
	jal	main
stay:   j       stay
