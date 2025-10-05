    .section .text.init,"ax",@progbits
    .equ   STACK_SIZE,   1024
    .globl _start

_start:
    # adresse du vecteur/traitant d'interruption
    # mtvec[1:0] indique le "mode" du vecteur d'interruption et doit être à 0
    # pour nous (mode direct) => .align 2 dans le traitant avant l'étiquette
    la   t0, mon_vecteur
    csrw mtvec, t0

    # réservation d'une (petite) zone de mémoire pour la pile
    la   sp, stacks + STACK_SIZE

    # lance la bibliothèque minimaliste et appelle main
    j    libfemto_start_main

    .bss
    .align 4
    .global stacks
stacks:
    .skip STACK_SIZE
