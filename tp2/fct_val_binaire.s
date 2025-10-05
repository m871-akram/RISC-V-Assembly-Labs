/*
uint16_t val_binaire(uint8_t b15, uint8_t b14, uint8_t b13, uint8_t b12,
                     uint8_t b11, uint8_t b10, uint8_t b9, uint8_t b8,
                     uint8_t b7, uint8_t b6, uint8_t b5, uint8_t b4,
                     uint8_t b3, uint8_t b2, uint8_t b1, uint8_t b0)
{
    return
      (b15 << 15) | (b14 << 14) | (b13 << 13) | (b12 << 12) | (b11 << 11) | (b10 << 10) | (b9 << 9) | (b8 << 8)
      | (b7 << 7) | (b6 << 6) | (b5 << 5) | (b4 << 4) | (b3 << 3) | (b2 << 2) | (b1 << 1) | b0;
}
*/

    .text
    .globl val_binaire
    /*
    uint16_t val_binaire(uint8_t b15, uint8_t b14, uint8_t b13, uint8_t b12,
                         uint8_t b11, uint8_t b10, uint8_t b9, uint8_t b8,
                         uint8_t b7, uint8_t b6, uint8_t b5, uint8_t b4,
                         uint8_t b3, uint8_t b2, uint8_t b1, uint8_t b0); */
    /* DEBUT DU CONTEXTE
    Fonction :
        val_binaire : feuille
    Contexte :
        b15 : registre a0
        b14 : registre a1
        b13 : registre a2
        b12 : registre a3
        b11 : registre a4
        b10 : registre a5
        b9  : registre a6
        b8  : registre a7
        b7  : pile *(sp+0)
        b6  : pile *(sp+4)
        b5  : pile *(sp+8)
        b4  : pile *(sp+12)
        b3  : pile *(sp+16)
        b2  : pile *(sp+20)
        b1  : pile *(sp+24)
        b0  : pile *(sp+28)
    FIN DU CONTEXTE */
val_binaire:
val_binaire_fin_prologue:
    # return (b15 << 15) | ... | b0;
    # on commence par b15
    slli t0, a0, 15       
    mv a0, zero           
    or a0, a0, t0               

    # b14
    slli t0, a1, 14       
    or a0, a0, t0         

    # b13
    slli t0, a2, 13       
    or a0, a0, t0         

    # b12
    slli t0, a3, 12       
    or a0, a0, t0         

    # b11
    slli t0, a4, 11       
    or a0, a0, t0         

    # b10
    slli t0, a5, 10       
    or a0, a0, t0         

    # b9
    slli t0, a6, 9       
    or a0, a0, t0         

    # b8
    slli t0, a7, 8       
    or a0, a0, t0         

    # b7 (from stack)
    lb t0, 0(sp)          
    slli t0, t0, 7        
    or a0, a0, t0         

    # b6
    lb t0, 4(sp)          
    slli t0, t0, 6        
    or a0, a0, t0         

    # b5
    lb t0, 8(sp)          
    slli t0, t0, 5        
    or a0, a0, t0         

    # b4
    lb t0, 12(sp)         
    slli t0, t0, 4        
    or a0, a0, t0         

    # b3
    lb t0, 16(sp)         
    slli t0, t0, 3        
    or a0, a0, t0         

    # b2
    lb t0, 20(sp)         
    slli t0, t0, 2        
    or a0, a0, t0         

    # b1
    lb t0, 24(sp)         
    slli t0, t0, 1        
    or a0, a0, t0         

    # b0
    lb t0, 28(sp)         
    or a0, a0, t0         

val_binaire_debut_epilogue:
    ret