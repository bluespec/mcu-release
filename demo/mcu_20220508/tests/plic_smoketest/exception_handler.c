#include <stdio.h>

// From the Privileged Spec
#define MCAUSE_EXCEPTION_CODE_MASK (0x7FFFFFFFUL)
#define MCAUSE_INTERRUPT_MASK      (0x80000000UL)

#define INJ0_INTERRUPT  (0x1)  // connected to source 1
#define INJ1_INTERRUPT  (0x2)  // connected to source 2
#define INJ2_INTERRUPT  (0x3)  // connected to source 3
#define INJ3_INTERRUPT  (0x4)  // connected to source 4

extern unsigned char g_ext_intr;
extern unsigned char g_sw_intr;
extern unsigned char g_timer_intr;

void exception_handler (  unsigned int mstatus
                        , unsigned int mepc
                        , unsigned int mcause
                        , unsigned int mtval) {

   // From the SoC Map
   unsigned int  * plic_IE          = (unsigned int *)0x0c002000;
   unsigned int  * plic_IP          = (unsigned int *)0x0C001000;
   unsigned int  * plic_claim       = (unsigned int *)0x0C200004;
   unsigned int  * clint_mtimecmp   = (unsigned int *)0x02004000;
   unsigned int  * clint_msip       = (unsigned int *)0x02000000;

   unsigned int exception_code = mcause & MCAUSE_EXCEPTION_CODE_MASK;
   unsigned int interrupt_source = 0;

   if ((mcause & MCAUSE_INTERRUPT_MASK) != 0) {
      // printf ("Received interrupt\n");
      if (exception_code == 11) {
         // printf ("Machine External Interrupt\n");
         // claim the interrupt, interrupt_source will have the ID of the
         // interrupt source.
         interrupt_source = *plic_claim;

         switch (interrupt_source) {
            case INJ0_INTERRUPT :
               // indicate completion
               *plic_claim = interrupt_source;

               // Increment interrupt counter
               g_ext_intr ++;

               // Disable interrupt from this source in PLIC
               *plic_IE = 0x00;
               break;

            case INJ1_INTERRUPT :
               // indicate completion
               *plic_claim = interrupt_source;

               // Increment interrupt counter
               g_ext_intr ++;
               break;

            case INJ2_INTERRUPT :
               // indicate completion
               *plic_claim = interrupt_source;

               // Increment interrupt counter
               g_ext_intr ++;
               break;

            case INJ3_INTERRUPT :
               // indicate completion
               *plic_claim = interrupt_source;

               // Increment interrupt counter
               g_ext_intr ++;
               break;

            default : break;
         }
      } else if (exception_code == 7) {
         // printf ("Machine Timer interrupts\n");
         // Write to the mtimecmp register to clear the interrupt
         (*clint_mtimecmp) = (*clint_mtimecmp) + (*clint_mtimecmp);
         g_timer_intr++;
      } else if (exception_code == 3) {
         // printf ("Machine Software interrupts\n");
         // Write to the msip register to clear the interrupt
         (*clint_msip) = 0;
         g_sw_intr++;
      }
   } else {
      // printf ("Received exception\n"); // Handling TBD
   }
   return;
}
