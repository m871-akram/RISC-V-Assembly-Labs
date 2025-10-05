#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern uint32_t mult_native(void);
static uint32_t mult_c(void);

uint32_t x, y;

static uint32_t mult_c(void)
{
   return x * y;
}

static void test(uint32_t xi, uint32_t yi)
{
   printf("Multiplication de %" PRIu32 " par %" PRIu32 ":\n", xi, yi);
   x = xi;
   y = yi;
   printf("Résultat attendu : %" PRIu32 "\n", mult_c());
   x = xi;
   y = yi;
   printf("Résultat de mult_native: %" PRIu32 "\n\n", mult_native());
}

int main(void)
{
   test(8, 7);
   test(5, 16);
   test(20, 54);

   return 0;
}
