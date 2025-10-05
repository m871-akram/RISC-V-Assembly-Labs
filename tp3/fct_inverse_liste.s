/*
void inverse_liste(struct cellule_t **l)
{
   struct cellule_t *res, *suiv;
   res = NULL;
   while (*l != NULL) {
       suiv = (*l)->suiv;
       (*l)->suiv = res;
       res = *l;
       *l = suiv;
   }
   *l = res;
}
*/
    .text
    .globl inverse_liste
    /* void inverse_liste(struct cellule_t **l) */
    /* DEBUT DU CONTEXTE
    Fonction :
        inverse_liste : feuille
    Contexte :
        l      : registre a0  
        res    : registre t0  # variable locale 
        suiv   : registre t1  # variable locale 
    FIN DU CONTEXTE */
inverse_liste:
inverse_liste_fin_prologue:
    #  res = NULL;
    li t0, 0              

    # Charger *l
    lw t2, 0(a0)          
    beq t2, zero, fin    # Si *l == NULL ;  on termine 

boucle:
    #  suiv = (*l)->suiv;
    lw t1, 4(t2)          

    #  (*l)->suiv = res;
    sw t0, 4(t2)          

    #  res = *l;
    mv t0, t2             

    # *l = suiv;
    sw t1, 0(a0)          

    # Charger *l pour vérifier la condition
    lw t2, 0(a0)          
    bne t2, zero, boucle  # Si *l != NULL ; on boucle

fin:
    #  *l = res;
    sw t0, 0(a0)         
inverse_liste_debut_epilogue:
    ret

