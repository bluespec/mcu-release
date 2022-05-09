#include <stdio.h>

// From the Privileged Spec
#define MCAUSE_EXCEPTION_CODE_MASK (0x7FFFFFFFUL)
#define MCAUSE_INTERRUPT_MASK      (0x80000000UL)

// A synthetic interrupt injector device (3 interrupt sources)
unsigned int  * injector_base    = (unsigned int *)0x6FFE0000;

#define GPIO_INTERRUPT  (0x1)  // connected to source 1
#define INJ0_INTERRUPT  (0x2)  // connected to source 2
#define INJ1_INTERRUPT  (0x3)  // connected to source 3
#define INJ2_INTERRUPT  (0x4)  // connected to source 4

extern unsigned char g_timer_intr;
extern unsigned char g_sw_intr;

void exception_handler (  unsigned int mstatus
                        , unsigned int mepc
                        , unsigned int mcause
                        , unsigned int mtval) {

   // From the SoC Map
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
            case GPIO_INTERRUPT :
               // do something to service the interrupt
               // ...
               // indicate completion
               *plic_claim = interrupt_source;
               break;
            
            case INJ0_INTERRUPT :
               // service the interrupt by writing to the clear bit of the source
               // inside the injector (injector_base + 0x8). Increment of 2
               // translates to 0x8 as it is unsigned int
               *(injector_base+2) = 1;

               // indicate completion
               *plic_claim = interrupt_source;
               break;

            case INJ1_INTERRUPT :
               // service the interrupt by writing to the clear bit of the source
               // inside the injector (injector_base + 0x10). Increment of 4
               // translates to 0x10 as it is unsigned int
               *(injector_base+4) = 1;

               // indicate completion
               *plic_claim = interrupt_source;
               break;

            case INJ2_INTERRUPT :
               // service the interrupt by writing to the clear bit of the source
               // inside the injector (injector_base + 0x18). Increment of 6
               // translates to 0x18 as it is unsigned int
               *(injector_base+6) = 1;

               // indicate completion
               *plic_claim = interrupt_source;
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
