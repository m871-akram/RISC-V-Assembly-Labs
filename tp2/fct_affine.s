/*
uint32_t affine(uint32_t a, uint32_t b, uint32_t x)
{
   return mult(x, a) + b;
}
*/
    .text
    .globl affine
    /* uint32_t affine(uint32_t a, uint32_t b, uint32_t x) */
    /* DEBUT DU CONTEXTE
    Fonction :
        affine : non feuille
    Contexte :
        a  : registre a0 ; pile *(sp+0)
        b  : registre a1 ; pile *(sp+4)
        x  : registre a2 ; pile *(sp+8)
        ra : pile *(sp+12)
    FIN DU CONTEXTE */
affine:
    # allocation de 16 octets pour  a, b, x et  ra 
    addi sp, sp, -16      
    sw a0, 0(sp)          
    sw a1, 4(sp)          
    sw a2, 8(sp)         
    sw ra, 12(sp)         
affine_fin_prologue:
    # return mult(x, a) + b;
    lw a0, 8(sp)          
    lw a1, 0(sp)          
    jal mult              
    lw t0, 4(sp)          
    add a0, a0, t0        
affine_debut_epilogue:
    lw ra, 12(sp)         
    addi sp, sp, 16       
    ret