/*
struct cellule_t *decoupe_liste(struct cellule_t *l, struct cellule_t **l1, struct cellule_t **l2)
{
    struct cellule_t fictif1, fictif2;
    *l1 = &fictif1;
    *l2 = &fictif2;
    while (l != NULL) {
        if (l->val % 2 == 1) {
            (*l1)->suiv = l;
            *l1 = l;
        } else {
            (*l2)->suiv = l;
            *l2 = l;
        }
        l = l->suiv;
    }
    (*l1)->suiv = NULL;
    (*l2)->suiv = NULL;
    *l1 = fictif1.suiv;
    *l2 = fictif2.suiv;
    return l;
}
*/
    .text
    .globl decoupe_liste
    /*
    Fonction feuille : A priori pile inchangée, mais besoin de l'adresse des
    variables locales => implantation des variables locales en pile.
    Besoin de 2*2 mots de 32 bits dans la pile (PILE+16)
    -> fictif1 à sp+0, fictif2 à sp+8
       (2 mots mémoire chacun : un pour le champ val, un pour le champ suiv)

    DEBUT DU CONTEXTE
    Fonction :
      decoupe_liste :  feuille
    Contexte :
      l             : registre a0    
      l1            : registre a1   
      l2            : registre a2    
      fictif2.suiv  : pile *(sp+12) 
      fictif2.val   : pile *(sp+8)   
      fictif1.suiv  : pile *(sp+4)   
      fictif1.val   : pile *(sp+0)   
    FIN DU CONTEXTE */
decoupe_liste:
    # Allocation de 16 octets sur la pile pour fictif1 et fictif2
    addi sp, sp, -16 
decoupe_liste_fin_prologue:
    # *l1 = &fictif1;
    mv t0, sp              
    sw t0, 0(a1)           

    # *l2 = &fictif2;
    addi t0, sp, 8        
    sw t0, 0(a2)          

    # erifier si la liste est vide
    beq a0, zero, fin  

boucle:
    #  l->val
    lw t0, 0(a0)          
    andi t1, t0, 1        
    
    # (val % 2 == 1)
    beqz t1, even    

odd:
    # (*l1)->suiv = l;
    lw t2, 0(a1)          
    sw a0, 4(t2)          

    # *l1 = l;
    sw a0, 0(a1)          
    beq zero, zero, iteration_suivante  

even:
    # (*l2)->suiv = l;
    lw t2, 0(a2)          
    sw a0, 4(t2)          

    # *l2 = l;
    sw a0, 0(a2)          

iteration_suivante:
    # l = l->suiv;
    lw a0, 4(a0)         
    bne a0, zero, boucle  # Tant que l != NULL on continu

fin:
    # (*l1)->suiv = NULL;
    lw t0, 0(a1)          
    sw zero, 4(t0)        

    # (*l2)->suiv = NULL;
    lw t0, 0(a2)          
    sw zero, 4(t0)        

    # *l1 = fictif1.suiv;
    lw t0, 4(sp)          
    sw t0, 0(a1)          

    # *l2 = fictif2.suiv;
    lw t0, 12(sp)         
    sw t0, 0(a2)         
decoupe_liste_debut_epilogue:
    addi sp, sp, 16
    ret
