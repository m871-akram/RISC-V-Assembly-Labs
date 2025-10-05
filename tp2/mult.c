#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern uint32_t mult(uint32_t, uint32_t);

int main(void)
{
   uint32_t a, b;
   a = 8;
   b = 7;
   printf("%" PRIu32 " x %" PRIu32 " = %" PRIu32 "\n", a, b, mult(a, b));
   return 0;
}
