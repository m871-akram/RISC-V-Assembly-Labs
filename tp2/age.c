#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern uint32_t age(uint32_t);

int main(void)
{
   uint32_t annee = 1964;
   printf("Né(e) en %" PRIu32 ", vous aviez donc %" PRIu32 " ans en l'an 2000 !\n", annee, age(annee));
   return 0;
}
