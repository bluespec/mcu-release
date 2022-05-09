#include <stdio.h>

extern unsigned char data [8];

// Sort the data array
void fn_bubble_sort (void) {
   unsigned short outer = 0;
   unsigned short inner = 0;
   unsigned char tmp = 0;
   for (outer = 0 ; outer < 7; outer ++) {
      for (inner = 0; inner < (8-outer-1); inner++) {
         if (data[inner] > data[inner+1]) { /* Swap */
            tmp = data[inner];
            data[inner] = data[inner+1];
            data[inner+1] = tmp;
         }
      }
   }
}

// Check if data array is sorted
unsigned short fn_verify_sort (void) {
   unsigned short array_is_good = 1;
   unsigned short idx = 0;
   for (idx = 0 ; idx < 7; idx ++) {
      if (data[idx] < data[idx+1]) {
         array_is_good = 1;
      } else {
         array_is_good = 0;
         break;
      }
   }
   return (array_is_good);
}

