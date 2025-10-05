/*
uint8_t res8;

uint8_t somme8(void)
{
    uint8_t i;
    res8 = 0;
    for (i = 1; i <= 30; i++) {
        res8 = res8 + i;
    }
    return res8;
}
*/

    .text
    .globl somme8

/* DEBUT DU CONTEXTE
Fonction :
    somme8 : feuille
Contexte :
    i : registre t0
    res8 : mémoire, section .data
FIN DU CONTEXTE */

somme8:
somme8_fin_prologue:
    
    la t2, res8          

    # res8 = 0;
    li t1, 0              
    sb t1, 0(t2)          

    # for (i = 1; i <= 30; i++)
    # Initialisation: i = 1
    li t0, 1              

loop_start:
    # Condition: i <= 30
    li t3, 30             
    bgt t0, t3, loop_end  

    # res8 = res8 + i
    lbu t1, 0(t2)         
    add t1, t1, t0        
    sb t1, 0(t2)          

    # Incrementer : i++
    addi t0, t0, 1        

    j loop_start          

loop_end:
    # return res8;
    lbu a0, 0(t2)        

somme8_debut_epilogue:
    ret

    .data
    .globl res8
res8:
    .byte 0    