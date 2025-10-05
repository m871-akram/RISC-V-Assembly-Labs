/*
void abr_vers_tab(struct noeud_t *abr)
{
    struct noeud_t *fd;
    if (abr != NULL) {
        abr_vers_tab(abr->fg);
        *ptr = abr->val;
        ptr++;
        fd = abr->fd;
        free(abr);
        abr_vers_tab(fd);
    }
}
*/

.text
.globl abr_vers_tab

/* DEBUT DU CONTEXTE
Fonction :
    abr_vers_tab : non feuille
Contexte :
    abr   : registre a0  ; pile *(sp+0)
    fd    : pile *(sp+4)
    ra    : pile *(sp+8)
    ptr   : mémoire
FIN DU CONTEXTE */

abr_vers_tab:
    addi    sp, sp, -12         
    sw      ra, 8(sp)           
    sw      a0, 0(sp)        
abr_vers_tab_fin_prologue:

    /* Si abr == NULL, retourner */
    beqz    a0, abr_vers_tab_debut_epilogue 

    /* parcours récursif du fils gauche */
    lw      a0, 4(a0)          
    jal     abr_vers_tab       

    /* Restaurer abr  */
    lw      a0, 0(sp)          

    /* Copier abr->val  */
    lw      t0, 0(a0)          
    lw      t1, ptr            
    sw      t0, 0(t1)          
    addi    t1, t1, 4         
    la      t2, ptr           
    sw      t1, 0(t2)        

    /* Sauvegarder abr->fd  */
    lw      t0, 8(a0)          
    sw      t0, 4(sp)         

    jal     free                

    /* parcours récursif du fils droit */
    lw      a0, 4(sp)          
    jal     abr_vers_tab        

abr_vers_tab_debut_epilogue:
    lw      ra, 8(sp)          
    addi    sp, sp, 12         
    ret                         

.data
.globl ptr
ptr:    .word 0                 /* Allocation de ptr dans .data ( correction de l erreur de la question precedente)  */
