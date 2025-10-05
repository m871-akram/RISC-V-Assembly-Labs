/*
uint32_t taille_chaine(const char *chaine)
{
    uint32_t taille = 0;
    while (chaine[taille] != '\0') {
        taille++;
    }
    return taille;
}
*/
    .text
    .globl taille_chaine
    /* uint32_t taille_chaine(const char *chaine) */
    /* DEBUT DU CONTEXTE
    Fonction :
        taille_chaine : feuille
    Contexte :
        chaine : registre a0  
        taille : registre t0  # variable locale 
    FIN DU CONTEXTE */
taille_chaine:
taille_chaine_fin_prologue:
    # uint32_t taille = 0;
    li t0, 0              

loop:
    # while (chaine[taille] != '\0')
    add t1, a0, t0        
    lbu t2, 0(t1)         
    beq t2, zero, end     

    # taille++;
    addi t0, t0, 1       
    j loop                

end:
    #  return taille;
    mv a0, t0             

taille_chaine_debut_epilogue:
    ret