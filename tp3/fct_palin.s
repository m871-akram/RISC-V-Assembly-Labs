/*
bool palin(const char *ch)
{
    uint32_t inf, sup;
    inf = 0;
    sup = strlen(ch) - 1;
    while (inf < sup && ch[inf] == ch[sup]) {
        inf++;
        sup--;
    }
    return inf >= sup;
}
*/
       .text
    .globl palin
    .type palin, @function

    /* DEBUT DU CONTEXTE
    Fonction :
        palin : non feuille
    Contexte :
        ch    : registre a0  ; pile *(sp+0)
        inf   : pile *(sp+4)
        sup   : pile *(sp+8)
        ra    : pile *(sp+12)
    FIN DU CONTEXTE */


palin:
    
    addi sp, sp, -16    
    sw ra, 12(sp)        
    sw a0, 0(sp)         

palin_fin_prologue:
    # Initialisation
    li t0, 0 
    sw t0, 4(sp)            
    mv t2, a0           
    jal strlen           
    mv t1, a0             
    addi t1, t1, -1
    sw t1, 8(sp)      

loop:
    lw t0, 4(sp)          
    lw t1, 8(sp) 
    bge t0, t1, end_true  

    # Load and compare characters
    add t3, t2, t0 
       # Address of ch[inf]
    lb t3, 0(t3)          
    add t4, t2, t1        
    lb t4, 0(t4)         

    bne t3, t4, end_false 

    # Increment inf, decrement sup
    addi t0, t0, 1 
    sw t0, 4(sp)      
    addi t1, t1, -1  
    sw t1, 8(sp)   
    j loop

end_true:
    li a0, 1             
    j palin_debut_epilogue

end_false:
    li a0, 0            

palin_debut_epilogue:
    lw ra, 12(sp)        
    addi sp, sp, 16      
    ret

.size palin, . - palin     

