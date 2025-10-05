/*
void inverse_chaine(char *ptr, uint32_t taille)
{
    char tmp;
    int32_t dep = taille - 1;
    while (dep > 0) {
        tmp = *ptr;
        *ptr = ptr[dep];
        ptr[dep] = tmp;
        dep = dep - 2;
        ptr++;
    }
}
*/
    .text
    .globl inverse_chaine
    /* void inverse_chaine(char *ptr, uint32_t taille) */
    /* DEBUT DU CONTEXTE
    Fonction :
        inverse_chaine :  feuille
    Contexte :
        ptr     : registre a0  
        taille  : registre a1  
        tmp     : registre t0 
        dep     : registre t1  
    FIN DU CONTEXTE */
inverse_chaine:
inverse_chaine_fin_prologue:
    #  int32_t dep = taille - 1;
    addi t1, a1, -1       

loop:
    #  while (dep > 0)
    ble t1, zero, end     

    #  tmp = *ptr;
    lbu t0, 0(a0)         
    #  *ptr = ptr[dep];
    add t2, a0, t1        
    lbu t3, 0(t2)         
    sb t3, 0(a0)          

    #  ptr[dep] = tmp;
    sb t0, 0(t2)          

    #  dep = dep - 2;
    addi t1, t1, -2       

    #  ptr++;
    addi a0, a0, 1        
    j loop                

end:

inverse_chaine_debut_epilogue:
    ret