/*
bool abr_est_present(uint32_t val, struct noeud_t *abr)
{
   if (abr == NULL) {
       return false;
   } else if (val == abr->val) {
       return true;
   } else if (val < abr->val) {
       return abr_est_present(val, abr->fg);
   } else {
       return abr_est_present(val, abr->fd);
   }
}
*/

.text
.globl abr_est_present

/* DEBUT DU CONTEXTE
Fonction :
    abr_est_present : non feuille
Contexte :
    val   : registre a0  ; pile *(sp+0)
    abr   : registre a1  ; pile *(sp+4)
    ra    : pile *(sp+8)
FIN DU CONTEXTE */

abr_est_present:
    addi    sp, sp, -12        
    sw      ra, 8(sp)           
    sw      a1, 4(sp)           
    sw      a0, 0(sp)           
abr_est_present_fin_prologue:

    /* si abr == NULL */
    beqz    a1, return_false   

    /* abr->val dans t0 pour comparaison */
    lw      t0, 0(a1)          

    /* Comparaison val == abr->val */
    beq     a0, t0, return_true 

    /* Comparaison val < abr->val */
    bltu    a0, t0, search_left 

    /* Sinon recherche dans fils droit */
    lw      a1, 8(a1)          
    jal     abr_est_present    
    j       abr_est_present_debut_epilogue 

search_left:
    lw      a1, 4(a1)           
    jal     abr_est_present   
    j       abr_est_present_debut_epilogue

return_true:
    li      a0, 1               
    j       abr_est_present_debut_epilogue 

return_false:
    li      a0, 0              
                                

abr_est_present_debut_epilogue:
    lw      ra, 8(sp)          
    addi    sp, sp, 12         
    ret                        

