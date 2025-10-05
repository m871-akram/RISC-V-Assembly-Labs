/*
bool abr_est_present_tail_call(uint32_t val, struct noeud_t *abr)
{
   if (abr == NULL) {
       return false;
   } else if (val == abr->val) {
       return true;
   } else if (val < abr->val) {
       return abr_est_present_tail_call(val, abr->fg);
   } else {
       return abr_est_present_tail_call(val, abr->fd);
   }
}
*/
.text
.globl abr_est_present_tail_call

/* DEBUT DU CONTEXTE
Fonction :
    abr_est_present_tail_call : feuille
Contexte :
    val   : registre a0
    abr   : registre a1
FIN DU CONTEXTE */

abr_est_present_tail_call:
abr_est_present_tail_call_fin_prologue:
    /*  abr == NULL */
    beqz    a1, return_false    

    /*  abr->val dans t0 pour comparaison */
    lw      t0, 0(a1)           

    /*  val == abr->val */
    beq     a0, t0, return_true 
    /* val < abr->val */
    bltu    a0, t0, search_left

    /* Sinon recherche dans fils droit */
    lw      a1, 8(a1)           
    j       abr_est_present_tail_call

search_left:
    lw      a1, 4(a1)           
    j       abr_est_present_tail_call 

return_true:
    li      a0, 1             
    j       abr_est_present_tail_call_debut_epilogue 

return_false:
    li      a0, 0               
                                

abr_est_present_tail_call_debut_epilogue:
    ret                       