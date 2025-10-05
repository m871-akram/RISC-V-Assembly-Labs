/*
uint32_t res;

void sommeMem(void)
{
    uint32_t i;
    res = 0;
    for (i = 1; i <= 10; i++) {
        res = res + i;
    }
}
*/

    .text
    .globl sommeMem

/* DEBUT DU CONTEXTE
Fonction :
    sommeMem : feuille
Contexte :
    i : registre t0
    res : mémoire, section .data
FIN DU CONTEXTE */

sommeMem:
sommeMem_fin_prologue:
    # res = 0;
    la t2, res           
    li t1, 0              
    sw t1, 0(t2)          

    # for (i = 1; i <= 10; i++)
    # Initialisation: i = 1
    li t0, 1              

loop_start:
    # Condition: i <= 10
    li t3, 10             
    bgt t0, t3, loop_end  

    #  res = res + i
    lw t1, 0(t2)          
    add t1, t1, t0       
    sw t1, 0(t2)          

    # Incrementer: i++
    addi t0, t0, 1        

    j loop_start          

loop_end:
    # la fonction retourne le vide 

sommeMem_debut_epilogue:
    ret

    .data
    .globl res
res:
    .word 0    
/* uint32_t res;
  La variable globale res étant définie dans ce fichier, il est nécessaire de
  la définir dans la section .data du programme assembleur.
*/
