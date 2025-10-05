/*
void tri_min(int32_t tab[], uint32_t taille)
{
    uint32_t i, j, ix_min;
    int32_t tmp;
    for (i = 0; i < taille - 1; i++) {
        for (ix_min = i, j = i + 1; j < taille; j++) {
            if (tab[j] < tab[ix_min]) {
                ix_min = j;
            }
        }
        tmp = tab[i];
        tab[i] = tab[ix_min];
        tab[ix_min] = tmp;
    }
}
*/
    .text
    .globl tri_min
    /* void tri_min(int32_t tab[], uint32_t taille) */
    /* DEBUT DU CONTEXTE
    Fonction :
        tri_min : feuille
    Contexte :
        tab     : registre a0  
        taille  : registre a1  
        i       : registre t0  # variable locale
        j       : registre t1  # variable locale 
        ix_min  : registre t2  # variable locale 
        tmp     : registre t3  # variable locale
    FIN DU CONTEXTE */
tri_min:
tri_min_fin_prologue:
    # for (i = 0; i < taille - 1; i++)
    li t0, 0              
    addi t4, a1, -1      
boucle_externe:
    bgeu t0, t4, fin      

    # for (ix_min = i, j = i + 1; j < taille; j++)
    mv t2, t0             
    addi t1, t0, 1        
boucle_interne:
    bgeu t1, a1, fin_interne  

    # if (tab[j] <= tab[ix_min])  
    slli t5, t1, 2        
    add t5, a0, t5       
    lw t6, 0(t5)         

    slli t5, t2, 2       
    add t5, a0, t5        
    lw t5, 0(t5)         

    bgt t6, t5, skip      
    mv t2, t1            

skip:
    addi t1, t1, 1        
    bltu t1, a1, boucle_interne  

fin_interne:
    beq t2, t0, skip_2

    #  tmp = tab[i];
    slli t5, t0, 2       
    add t5, a0, t5        
    lw t3, 0(t5)          

    # tab[i] = tab[ix_min];
    slli t6, t2, 2        
    add t6, a0, t6        
    lw t4, 0(t6)          
    sw t4, 0(t5)          

    # tab[ix_min] = tmp;
    sw t3, 0(t6)          

skip_2:
    addi t0, t0, 1        
    bltu t0, t4, boucle_externe  

fin:

tri_min_debut_epilogue:
    ret