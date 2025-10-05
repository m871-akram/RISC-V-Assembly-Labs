/*
uint32_t x, y;

uint32_t mult_native(void)
{
    return x*y;
}
*/

    .text
    .globl mult_native

/* DEBUT DU CONTEXTE
Fonction :
    mult_native : feuille
Contexte :
    x : mémoire, section .data
    y : mémoire, section .data
FIN DU CONTEXTE */

mult_native:
mult_native_fin_prologue:
    
    la t2, x             
    la t3, y             

    
    lw t0, 0(t2)         
    lw t1, 0(t3)          

    # return x * y;
    mul a0, t0, t1        

mult_native_debut_epilogue:
    ret
