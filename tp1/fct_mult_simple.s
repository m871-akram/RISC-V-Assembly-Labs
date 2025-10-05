/*
uint32_t x, y;  // dans la mémoire globale et allouées dans le fichier C
uint32_t res;   // dans la mémoire globale et à allouer en langage d'assemblage

uint32_t mult_simple(void)
{
    res = 0;
    while (y != 0) {
        res = res + x;
        y--;
    }
    return res;
}
*/

    .text
    .globl mult_simple

/* DEBUT DU CONTEXTE
Fonction :
    mult_simple : feuille
Contexte :
    x : mémoire, section .data
    y : mémoire, section .data
    res : mémoire, section .data
FIN DU CONTEXTE */

mult_simple:
mult_simple_fin_prologue:
    
    la t3, x              
    la t4, y              
    la t5, res            

    # res = 0;
    li t2, 0              
    sw t2, 0(t5)          

    
    lw t0, 0(t3)          
    lw t1, 0(t4)          

loop_start:
    # Condition: while (y != 0)
    beq t1, zero, loop_end  

    #  res = res + x
    lw t2, 0(t5)          
    add t2, t2, t0        
    sw t2, 0(t5)         

    # y--;
    addi t1, t1, -1       
    sw t1, 0(t4)         

    j loop_start          

loop_end:
    # return res;
    lw t2, 0(t5)         
    mv a0, t2             

mult_simple_debut_epilogue:
    ret

    .data
    .globl res
res:
    .word 0    
/* uint32_t res; */
