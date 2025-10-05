#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAILLE 10000

int32_t tab[TAILLE];

extern void tri_nain_superopt(int32_t[], uint32_t);

static void init_tab(int32_t tab[], uint32_t taille) {
  for (uint32_t i = 0; i < taille; i++) {
    tab[i] = (random() % 198) - 99;
  }
}

int main(void) {
  uint32_t taille = TAILLE;
  srandom(0xbaffe);
  init_tab(tab, taille);
  tri_nain_superopt(tab, taille);
  return 0;
}
