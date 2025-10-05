#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern uint32_t fibo(uint32_t);

int main()
{
   uint32_t n = 8;
   printf("Fibo(%" PRIu32 ") = %" PRIu32 "\n", n, fibo(n));
   return 0;
}
