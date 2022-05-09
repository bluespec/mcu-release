/*
 * The "clint" smoke-test to check CLINT register functionality.
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

// Change the DLY value to have longer delays between LED updates.
// 1,000,000 is a suitable value for simulation. While 200,000,000
// is more suitable for FPGA (assuming 100 MHz operating frequency)
#ifdef FPGA
#define TIMERDLY (200000000)
#define DLY (1024*1024)
#else
#define TIMERDLY (1024)
#define DLY 1024
#endif
// ----- CHANGE ME -----
//
// Global Data
unsigned char g_timer_intr = 0;
unsigned char g_sw_intr = 0;
extern void csrw_mstatus (uint32_t x);
extern void csrw_mie (uint32_t x);

// --- The main function ---
int main (int argc, char ** argv)
{
   volatile unsigned short * gpio_addr = (void*)GPIO_BASE;
   volatile unsigned int   * msip      = (void*)CLINT_MSIP;
   volatile unsigned int   * mtime     = (void*)CLINT_MTIME;
   volatile unsigned int   * mtimecmp  = (void*)CLINT_MTIMECMP;

   // Indicate SoT - RGB LED glows blue
   // (*gpio_addr) = 0x10;

   // --- Reads --- 
   // TEST 1
   // Read MSIP
   if (*msip != 0) {
      // msip should be zero on reset. indicate failure and the 
      // failing check by switching on the first LED
      // (*gpio_addr) = 0x41;

      // Will end the test in case of simulations
      __asm__ __volatile__ ("li a0, 0x3\n");
      TEST_FAIL

      return (1);
   }

   // Read the time registers 
   // TEST 2
   unsigned int timeH = *(mtime+1);
   unsigned int timeL = (*mtime);
   if ((timeH == 0) && (timeL == 0)) {
      // time should be non-zero. indicate failure and the 
      // failing check by switching on the first LED
      // (*gpio_addr) = 0x42;

      // Will end the test in case of simulations
      __asm__ __volatile__ ("li a0, 0x5\n");
      TEST_FAIL

      return (1);
   }

   // Read the timecmp registers 
   // TEST 3
   unsigned int timecmpL = *mtimecmp;
   unsigned int timecmpH = *(mtimecmp+1);
   if ((timecmpL != 0) || (timecmpH != 0)) {
      // timecmp should be zero until written. indicate failure and the 
      // failing check by switching on the first LED
      // (*gpio_addr) = 0x43;

      // Will end the test in case of simulations
      __asm__ __volatile__ ("li a0, 0x7\n");
      TEST_FAIL

      return (1);
   }

   // --- Writes --- 
   // TEST 4
   // Write TIMERDLY to mtimemp. This should result in an interrupt in a little
   // over 2 second on the board. 
   (*mtimecmp) = TIMERDLY;
   uint32_t mstatus = 0x8; // enable MSTATUS.MIE
   csrw_mstatus (mstatus);
   uint32_t mie = 0x80;    // enable MIE.MTIE
   csrw_mie (mie);

   // A delay loop
   unsigned short delay;
   for (delay = 0; delay < DLY; delay++)
      __asm__ __volatile__ ("" ::: "memory");

   if (g_timer_intr == 0) {
      // We expect one timer interupt by the time we get here
      // (*gpio_addr) = 0x44;
      __asm__ __volatile__ ("li a0, 0x9\n");
      TEST_FAIL
      return (0);
   } 

   mie = 0x08;    // enable MIE.MSIE
   csrw_mie (mie);

   // Write to MSIP to trigger a software interrupt
   // TEST 5
   (*msip) = 1;

   // A delay loop
   for (delay = 0; delay < DLY; delay++)
      __asm__ __volatile__ ("" ::: "memory");
   
   if (g_sw_intr == 0) {
      // We expect a software interrupt by the time we get here
      // (*gpio_addr) = 0x45;
      __asm__ __volatile__ ("li a0, 0xB\n");
      TEST_FAIL
      return (0);
   } else {
      // Indicate EOT - RGB LED glows green - all tests have passed
      // *gpio_addr = 0x20;

      // At least one timer and one software interrupt has happened.
      // successful end of test
      TEST_PASS
      return (0);
   }
}
