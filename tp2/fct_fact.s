/*
uint32_t fact(uint32_t n)
{
    if (n <= 1) {
        return 1;
    } else {
        return n * fact(n - 1);
    }
}
*/

    .text
    .globl fact
    /* uint32_t fact(uint32_t n) */
    /* DEBUT DU CONTEXTE
    Fonction :
        fact : non feuille
    Contexte :
        n  : registre a0 ;  pile *(sp+0)
        ra : pile *(sp+4)
    FIN DU CONTEXTE */
fact:
    # allocation de 8 octets pour n and ra 
    addi sp, sp, -8       
    sw a0, 0(sp)         
    sw ra, 4(sp)          
fact_fin_prologue:
    # if (n <= 1)
    mv t0, a0             
    li t1, 1              
    ble t0, t1, then      

    # else { return n * fact(n - 1); }
    addi a0, t0, -1       
    jal fact              
    # multiplication par n
    lw t0, 0(sp)          
    mul a0, t0, a0        
    j fact_debut_epilogue 

then:
    # return 1;
    li a0, 1              

fact_debut_epilogue:
    lw ra, 4(sp)          
    addi sp, sp, 8        
    ret