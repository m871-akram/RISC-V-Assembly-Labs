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
    /* void tri_nain_opt(int32_t tab[], uint32_t taille) */
    .globl tri_nain_opt
/* Version du tri optimisée sans respecter la contrainte de la traduction
   systématique pour les accès mémoire (et le calcul de leurs adresses)
   Complétez le contexte ci-dessous en indiquant les registres qui contiendront
   des variables temporaires.  */
/* DEBUT DU CONTEXTE
Fonction :
    tri_nain_opt : feuille
Contexte :
    tab          : registre a0
    taille       : registre a1
    i            : registre t0  ; pile *(sp+0)
    addr         : registre t1  ; pile *(sp+4)
    val_i        : registre t2  ; pile *(sp+8)
    val_i_plus_1 : registre t3  ; pile *(sp+12)
FIN DU CONTEXTE */

tri_nain_opt:
tri_nain_opt_fin_prologue:          /* Prologue vide */

    li      t0, 0                   /* i = 0 */
    mv      t1, a0                  /* addr = tab */
    addi    t4, a1, -1              /* t4 = taille - 1 */

loop:
    bgeu    t0, t4, end             /* Si i >= taille - 1, sortir */

    /* Deux accès mémoire */
    lw      t2, 0(t1)               /* val_i = tab[i] */
    lw      t3, 4(t1)               /* val_i_plus_1 = tab[i+1] */

    /* Comparaison : tab[i] > tab[i+1] */
    ble     t2, t3, increment       /* Si val_i <= val_i_plus_1, avancer */

    /* Échange */
    sw      t3, 0(t1)               /* tab[i] = val_i_plus_1 */
    sw      t2, 4(t1)               /* tab[i+1] = val_i */

    /* Si i > 0 */
    beqz    t0, loop                /* Si i == 0, boucler */
    addi    t0, t0, -1              /* i = i - 1 */
    addi    t1, t1, -4              /* addr = addr - 4 */
    j       loop

increment:
    addi    t0, t0, 1               /* i = i + 1 */
    addi    t1, t1, 4               /* addr = addr + 4 */
    j       loop

end:
tri_nain_opt_debut_epilogue:        /* Épilogue vide */
    ret
    