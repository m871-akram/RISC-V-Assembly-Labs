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
/* void tri_nain(int32_t tab[], uint32_t taille) */
.globl tri_nain

/* DEBUT DU CONTEXTE
Fonction :
    tri_nain : feuille
Contexte :
    tab   : registre a0
    taille: registre a1
    i     : registre t0
    tmp   : registre t4
FIN DU CONTEXTE */

tri_nain:
tri_nain_fin_prologue:          

    li      t0, 0               /* i = 0 */

boucle:
    /* Calcul de taille - 1 */
    addi    t1, a1, -1          /* t1 = taille - 1 */
    bgeu    t0, t1, end         

    /* Calcul des adresse */
    slli    t2, t0, 2          
    add     t3, a0, t2          
    addi    t5, t3, 4          

    /* Charger pour comparaison */
    lw      t4, 0(t3)           
    lw      t6, 0(t5)           
    ble     t4, t6, incremente   

    /* Échange systématique */
    lw      t4, 0(t3)           /* tmp = tab[i] */
    lw      t6, 0(t5)           
    sw      t6, 0(t3)          
    sw      t4, 0(t5)           

    /* Si i > 0 */
    beqz    t0, boucle            /* Si i == 0, boucler */
    addi    t0, t0, -1          
    j       boucle

incremente:
    addi    t0, t0, 1           /* i = i + 1 */
    j       boucle

end:
tri_nain_debut_epilogue:        
    ret

