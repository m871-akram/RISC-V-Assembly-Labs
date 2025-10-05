BADGES_TARGET = niv1__age niv1__hello niv1__affine niv1__fact niv3__fact_papl niv2__val_binaire
BINS = pgcd mult fibo
CONTEXTS := ${BINS:=.ctxt}


COMMON := ../common
include $(COMMON)/rules.mk

pgcd: pgcd.o fct_pgcd.o

fact: ASFLAGS += -march=rv32im
fact: fact.o fct_fact.o fct_mult.o

fact_papl: ASFLAGS += -march=rv32im
fact_papl: fact_papl.o fct_fact_papl.o

age: age.o fct_age.o

hello: hello.o fct_hello.o

affine: affine.o fct_affine.o fct_mult.o

fibo: fibo.o fct_fibo.o

val_binaire: val_binaire.o fct_val_binaire.o

mult: mult.o fct_mult.o
