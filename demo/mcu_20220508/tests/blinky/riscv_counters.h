// Copyright (c) 2013 Bluespec, Inc.  All Rights Reserved

#pragma once

// ----------------------------------------------------------------
// For 64-bit:
// The following are interfaces to inline RISC-V assembly instructions
//     RDCYCLE
// For all of them, the result is left in v0 (= x16) per calling convention

// For 32-bit, we get cycle counter out of MCYCLE / MCYCLEH CSRs,
// because some processors, e.g., Rocket32p, do not implement
// RDCYCLEH.

extern uint64_t  read_cycle    (void);    // RDCYCLE

// ================================================================
// // Pass/Fail macros. This is a temporary place-holder. To be moved to an
// // appropriate location under the env directory structure once we can converge
// // on a unified build environment for all tests
//
#define TEST_PASS asm volatile ("li a0, 0x1"); \
                  asm volatile ("sw a0, tohost, t0");
#define TEST_FAIL asm volatile ("li a0, 0x3"); \
                  asm volatile ("sw a0, tohost, t0");
