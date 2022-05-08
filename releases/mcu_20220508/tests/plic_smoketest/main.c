/*
 * The smoke-test to check PLIC register functionality.
 *
 * Tests the following functionality:
 *    - rv32i and rv32ic fetches
 *    - byte, halfword and word reads and writes to DMem
 *    - MMIO accesses through reads and writes to the GPIO
 */

#include <stdio.h>

//for read_cycle
#include "riscv_counters.h"

// for PRIu64
#include <inttypes.h>

// ----- CHANGE ME -----
// The following definition points to the base address of the GPIO device
// This should match the address in the CLINT device in mkSoC_Map.v
//
#define CLINT_MSIP     (0x02000000ULL)
#define CLINT_MTIMECMP (0x02004000ULL)
#define CLINT_MTIME    (0x0200BFF8ULL)
#define GPIO_BASE      (0x6fff0000ULL)
#define PLIC_IP        (0x0C001000ULL)
#define PLIC_PRIORITY  (0x0C000000ULL)
#define PLIC_THRESHOLD (0x0C200000ULL)
#define PLIC_IE        (0x0C002000ULL)
#define PLIC_CLAIM     (0x0C200004ULL)

// Change the DLY value to have longer delays between LED updates.
// 1,000,000 is a suitable value for simulation. While 200,000,000
// is more suitable for FPGA (assuming 100 MHz operating frequency)
#ifdef FPGA
#define TIMERDLY (200000000)
#define DLY (1024*1024)
#else
#define DLY 4096
#endif
// ----- CHANGE ME -----
//
// Global Data
unsigned char g_ext_intr = 0;
unsigned char g_timer_intr = 0;
unsigned char g_sw_intr = 0;
extern void csrw_mstatus (uint32_t x);
extern void csrw_mie (uint32_t x);

// --- The main function ---
int main (int argc, char ** argv)
{
   volatile unsigned int  * plic_thres = (void *)PLIC_THRESHOLD;
   volatile unsigned int  * plic_prio  = (void *)PLIC_PRIORITY;
   volatile unsigned int  * plic_IP    = (void *)PLIC_IP;
   volatile unsigned int  * plic_IE    = (void *)PLIC_IE;
   volatile unsigned int  * plic_claim = (void *)PLIC_CLAIM;
   volatile unsigned int  * msip       = (void*)CLINT_MSIP;

   uint32_t mstatus = 0x8; // enable MSTATUS.MIE
   csrw_mstatus (mstatus);
   uint32_t mie = 0x800;   // enable MIE.MEIE
   csrw_mie (mie);
   uint32_t plicie = 0xff; // enable MIE.MEIE
   *plic_IE = plicie;

   // Set up the priorities of the interrupt sources
   // Arbitrarily assigning increasing priorities
   for (unsigned int idx=1; idx<=4; idx++)
      *(plic_prio + idx) = idx;

   // Zero the priority threshold for this target to allow all non-zero priority
   // interrupts through
   *plic_thres = 0;

   // A delay loop - stay in the loop waiting to catch interrupts
   unsigned short delay;
   for (delay = 0; delay < DLY; delay++)
      __asm__ __volatile__ ("" ::: "memory");

   if (g_ext_intr == 0) {
      // We expect interupts by the time we get here
      __asm__ __volatile__ ("li a0, 0x3\n");
      TEST_FAIL
      return (0);
   } else { 
      // At least some external interrupt has happened
      // successful end of test
      TEST_PASS
      return (0);
   }
}
