/*
uint32_t fact_papl(uint32_t n)
{
    if (n <= 1) {
        return 1;
    } else {
        uint64_t tmp = (uint64_t)n*fact_papl(n-1);
        if ((tmp >> 32) > 0)
            erreur_fact(n);
        return (uint32_t)tmp;
    }
}
*/

    .text
    .globl fact_papl
    /* uint32_t fact_papl(uint32_t n) */
    /* DEBUT DU CONTEXTE
    Fonction :
        fact_papl :  non feuille
    Contexte :
        n  : registre a0 ; pile *(sp+0)
        ra : pile *(sp+12)
        tmp : pile *(sp+4)  
    FIN DU CONTEXTE */
fact_papl:
    # allocatiion de 16 octets pour n, tmp , and ra 
    addi sp, sp, -16      
    sw a0, 0(sp)          
    sw ra, 12(sp)         
fact_papl_fin_prologue:
    #  if (n <= 1)
    mv t0, a0             
    li t1, 1              
    ble t0, t1, then      

    #  else { uint64_t tmp = (uint64_t)n * fact_papl(n-1);
    addi a0, t0, -1       
    jal fact_papl         
    # Calcule de  (uint64_t)n * fact_papl(n-1)
    lw t0, 0(sp)          
    mv t1, a0             
    mul t2, t0, t1        
    mulhu t3, t0, t1      
    sw t2, 4(sp)          
    sw t3, 8(sp)          

    # if ((tmp >> 32) > 0)
    lw t3, 8(sp)          
    bgtz t3, overflow     

    # return (uint32_t)tmp;
    lw a0, 4(sp)          
    j fact_papl_debut_epilogue 

then:
    # return 1;
    li a0, 1              
    j fact_papl_debut_epilogue 

overflow:
    # erreur_fact(n);
    lw a0, 0(sp)          
    jal erreur_fact      

fact_papl_debut_epilogue:
    lw ra, 12(sp)         
    addi sp, sp, 16       
    ret