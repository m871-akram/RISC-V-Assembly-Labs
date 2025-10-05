/*
void tri_nain(int32_t tab[], uint32_t taille)
{
    uint32_t i = 0;
    while(i < taille - 1) {
        if (tab[i] > tab[i+1]) {
            int32_t tmp = tab[i];
            tab[i] = tab[i+1];
            tab[i + 1] = tmp;
            if (i > 0) {
                i = i - 1;
            }
        } else {
            i = i + 1;
        }
    }
}
*/

    .text
    .globl tri_nain_superopt
/* Version encore plus optimisée sans rien respecter (tout se perd ma bonne dame !).

Optimisations effectuées:
  - Partage des lectures mémoires et des calculs d'adresses
  - Calcul de taille - 1 en dehors de la boucle
  - À compléter avec vos autres optimisations

.text
.globl tri_nain_superopt

/* DEBUT DU CONTEXTE
Fonction :
    tri_nain_superopt : feuille
Contexte :
#   tab          : registre a0
#   taille       : registre a1
#   taille_moins_1 : registre s0
#   i            : registre s1  ; pile *(sp+0)
#   addr         : registre s2  ; pile *(sp+4)
#   val_i        : registre s3
#   val_i_plus_1 : registre s4
FIN DU CONTEXTE */

tri_nain_superopt:
    addi    sp, sp, -8         
    sw      s1, 0(sp)        
    sw      s2, 4(sp)           
tri_nain_superopt_fin_prologue:

    addi    s0, a1, -1          /* taille_moins_1 = taille - 1 (invariant) */
    li      s1, 0               /* i = 0 */
    mv      s2, a0              /* addr = tab (adresse de tab[0]) */

loop:
    bgeu    s1, s0, end        

    /* 2 accès mémoire*/
    lw      s3, 0(s2)        
    lw      s4, 4(s2)          

    /*  tab[i] > tab[i+1] */
    ble     s3, s4, increment   

    /* echange */
    sw      s4, 0(s2)           /* tab[i] = val_i_plus_1 */
    sw      s3, 4(s2)           /* tab[i+1] = val_i */

    /* Reculer si i > 0 */
    beqz    s1, loop            /* i == 0, boucler sans reculer */
    addi    s1, s1, -1          /* i = i - 1 */
    addi    s2, s2, -4          /* addr = addr - 4 */
    j       loop                /* Retour à la boucle */

increment:
    addi    s1, s1, 1           /* i = i + 1 */
    addi    s2, s2, 4           /* addr = addr + 4 */
    j       loop                /* Retour à la boucle */

end:
tri_nain_superopt_debut_epilogue:
    lw      s1, 0(sp)           
    lw      s2, 4(sp)          
    addi    sp, sp, 8           
    ret                        