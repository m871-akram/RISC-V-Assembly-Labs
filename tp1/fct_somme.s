/*
uint32_t somme(void)
{
    uint32_t i;
    uint32_t res = 0;
    for (i = 1; i <= 10; i++) {
        res = res + i;
    }
    return res;
}
*/

    .text
    .globl somme

/* DEBUT DU CONTEXTE
Fonction :
    somme : feuille
Contexte :
    i : registre t0
    res : registre t1
FIN DU CONTEXTE */

somme:
somme_fin_prologue:
    # uint32_t res = 0;
    li t1, 0              

    # for (i = 1; i <= 10; i++)
    # Initialisation: i = 1
    li t0, 1             

loop_start:
    # Condition: i <= 10
    li t2, 10             
    bgt t0, t2, loop_end  

    # res = res + i
    add t1, t1, t0        

    # Incrementer : i++
    addi t0, t0, 1       

    j loop_start         

loop_end:
    # return res;
    mv a0, t1            

somme_debut_epilogue:
    ret