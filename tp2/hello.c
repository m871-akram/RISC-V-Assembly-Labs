#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern void hello(void);

// La fonction affiche_HelloWorld n'est pas 'static' car elle est appelée depuis hello.
void affiche_HelloWorld()
{
   printf("Hello world!\n");
}

int main(void)
{
   hello();
   return 0;
}
