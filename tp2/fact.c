#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern uint32_t fact(uint32_t);

int main()
{
   uint32_t n = 9;
   printf("Fact(%" PRIu32 ") = %" PRIu32 "\n", n, fact(n));
   return 0;
}
