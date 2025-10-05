BADGES_TARGET = niv1__pgcd niv1__somme niv1__sommeMem niv1__mult_simple niv2__mult_egypt niv3__mult_native niv2__somme8
BINS = put


COMMON := ../common
include $(COMMON)/rules.mk

pgcd: pgcd.o fct_pgcd.o

somme: somme.o fct_somme.o

sommeMem: sommeMem.o fct_sommeMem.o

somme8: somme8.o fct_somme8.o

mult_simple: ASFLAGS += -march=rv32im
mult_simple: CFLAGS += -march=rv32im
mult_simple: mult_simple.o fct_mult_simple.o

mult_egypt: ASFLAGS += -march=rv32im
mult_egypt: CFLAGS += -march=rv32im
mult_egypt: mult_egypt.o fct_mult_egypt.o

mult_native: ASFLAGS += -march=rv32im
mult_native: CFLAGS += -march=rv32im
mult_native: mult_native.o fct_mult_native.o

mult: ASFLAGS += -march=rv32im
mult: CFLAGS += -march=rv32im
mult: mult.o fct_mult_simple.o fct_mult_egypt.o fct_mult_native.o

put_error : put.c
	$(CC) -DCODE_FAUX -fsyntax-only $<


fct_% : fct_%.s %.c
	@echo "Il faut utiliser \"make $*\" et non \"make fct_$*\"."
