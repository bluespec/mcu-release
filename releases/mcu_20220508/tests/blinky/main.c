/*
 * The "blinky" smoke-test to check basic CPU functionality
 * Writes to LEDs connected to a GPIO device on the SoC and sorts
 * through an array of 8 numbers to carry out basic read-write
 * testing of the DMem. Self-checking test in simulation and
 * indicates pass/fail status using LEDs on FPGA.
 *
 * The program assumes that there are 4 on-off LEDs and 4 RGB LEDs
 * in the system, totaling 16-bits. The GPIO device is assumed to
 * be at: 0x6fff0000, and the GPIO register placed at offset 0x0.
 *
 * Tests the following functionality:
 *    - rv32i and rv32ic fetches
 *    - byte, halfword and word reads and writes to DMem
 *    - MMIO accesses through reads and writes to the GPIO
 */

#include <stdio.h>

//for read_cycle
#include "riscv_counters.h"

// for "sort" application
#include "sort.h"

// for PRIu64
#include <inttypes.h>

// ----- CHANGE ME -----
// The following definition points to the base address of the GPIO device
// This should match the address in the GPIO device
#define GPIO_BASE (0x6fff0000ULL)

// Change the DLY value to have longer delays between LED updates.
// 256 is a suitable value for simulation
#define DLY (256)
// ----- CHANGE ME -----

// ---- Global Data ----
#define DTCM_BASE (0xc8000000ULL)
unsigned char data [8] = { 4, 7, 3, 8, 2, 1, 5, 6 };


// --- The main function ---
int main (int argc, char ** argv)
{
   volatile unsigned short * gpio_addr = (void*)GPIO_BASE;
   unsigned int val = 0;
   unsigned int delay = 0;

   // Indicate SoT - RGB LED glows blue
   (*gpio_addr) = 0x10;

   // A delay loop
   for (delay = 0; delay < DLY; delay++)
      __asm__ __volatile__ ("" ::: "memory");

   // The LED loop
   for (val = 0; val < 16; val++) {
      // increment the gpio val cycling through all LED combns
      (*gpio_addr)++;

      // adjust the delay depending on simulation/emulation
      for (delay = 0; delay < DLY; delay++)
	      __asm__ __volatile__ ("" ::: "memory");
   }

   fn_bubble_sort ();
   unsigned short sort_is_good = fn_verify_sort ();

   if (sort_is_good == 1) {

      // Indicate EOT - RGB LED glows green
      *gpio_addr = 0x20;

      // Will end the test in case of simulations
      TEST_PASS

      return (0);
   } else {
      // Indicate EOT - RGB LED glows red indicating failure
      *gpio_addr = 0x40;

      // Will end the test in case of simulations
      TEST_FAIL

      return (1);
   }
}
