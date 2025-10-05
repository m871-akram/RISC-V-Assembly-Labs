YACC = bison
LEX = flex
contexte : contexte.tab.o contexte.yy.o
	$(CC) -o $@ $^
contexte.tab.o : contexte.tab.c
contexte.tab.c contexte.tab.h : contexte.y
	$(YACC) -d contexte.y
contexte.yy.o : contexte.yy.c contexte.tab.h
contexte.yy.c : contexte.l
	$(LEX) -i contexte.l
clean :
	$(RM) contexte.yy.c contexte.yy.o \
		contexte.tab.c contexte.tab.h contexte.tab.o \
		contexte
