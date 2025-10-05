/*
uint32_t x, y;

uint32_t mult_egypt(void)
{
    uint32_t res = 0;
    while (y != 0) {
        if (y % 2 == 1) {
            res = res + x;
        }
        x = x << 1 ;
        y = y >> 1;
    }
    return res;
}
*/

    .text
    .globl mult_egypt

/* DEBUT DU CONTEXTE
Fonction :
    mult_egypt : feuille
Contexte :
    x : mémoire, section .data
    y : mémoire, section .data
    res : registre t0
FIN DU CONTEXTE */

mult_egypt:
mult_egypt_fin_prologue:
    # uint32_t res = 0;
    li t0, 0              

    
    la t3, x              
    la t4, y              

    
    lw t1, 0(t3)          
    lw t2, 0(t4)         

loop_start:
    # Condition: while (y != 0)
    beq t2, zero, loop_end  

    # if (y % 2 == 1)
    andi t5, t2, 1        
    beq t5, zero, skip_add  

    # res = res + x
    add t0, t0, t1        

skip_add:
    # x = x << 1
    slli t1, t1, 1        
    sw t1, 0(t3)          

    # y = y >> 1
    srli t2, t2, 1        
    sw t2, 0(t4)         

    j loop_start         

loop_end:
    # return res;
    mv a0, t0            

mult_egypt_debut_epilogue:
    ret
