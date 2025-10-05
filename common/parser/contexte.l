%{
#include <string.h>
#include "contexte.tab.h"

#define  YY_USER_INIT \
    yylloc->first_line = yylloc->last_line = 1; \
    yylloc->first_column = yylloc->last_column = 1;

#define YY_USER_ACTION \
    yylloc->first_line = yylloc->last_line; \
    yylloc->first_column = yylloc->last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            yylloc->last_line++; \
            yylloc->last_column = 0; \
        } \
        else { \
            yylloc->last_column++; \
        } \
    }

void yyerror(YYLTYPE *l, const char *s)
{
    fprintf(stderr, "%s line %d, col %d-%d, on token '%s'\n",
            s, yylineno, l->first_column, l->last_column, yytext);
}

%}

/* Terminaux */

FONCTION    fonction
CONTEXTE    contexte
TYPE        (non[ \t]+)?feuille
SEPARATEUR  \/
PILE        pile
RA          ra
SP          sp
REGISTRE    registre
REGISTRES   registres
SECTION     section
SEGMENT     .data|.rodata|.text|.bss
/* Attention, m[eé]moire ne marche pas !!! */
MEMOIRE     memoire|mémoire
NOMSIMPLE   [a-zA-Z_][a-zA-Z_0-9]*
NOMCOMPOSE  &?[a-zA-Z_][a-zA-Z_0-9]*(\.[a-zA-Z_0-9]+)*(\[.*\])*
SIGNE       [+-]
INT         [0-9]+
RETOUR      \r?\n
IDREG       zero|[sgt]p|a[0-7]|t[0-6]|s[0-9]|s1[0-1]
/* ra retiré des registres car il apparaît à gauche */
%option noyywrap
%option yylineno
%option bison-bridge bison-locations
%option outfile="contexte.yy.c"

%%
(\#.*)?{RETOUR}  { return RETOUR;}
[ \t]+           { /* */ }
{FONCTION}       { return FONCTION; }
{CONTEXTE}       { return CONTEXTE; }
{TYPE}           { return TYPE; }
{SEPARATEUR}     { return SEPARATEUR; }
{PILE}           { return PILE; }
{RA}             { yylval->s = strdup(yytext); return RA; }
{SP}             { yylval->s = strdup(yytext); return SP; }
{SEGMENT}        { return SEGMENT; }
{SECTION}        { return SECTION; }
{MEMOIRE}        { yylval->s = strdup(yytext); return MEMOIRE; }
{REGISTRE}       { return REGISTRE; }
{REGISTRES}      { return REGISTRES; }
{IDREG}          { yylval->s = strdup(yytext); return IDREG; }
{SIGNE}          { yylval->c = *yytext; return SIGNE; }
{INT}            { yylval->i = strtol(yytext, NULL, 0); return INT; }
{NOMSIMPLE}      { yylval->s = strdup(yytext); return NOMSIMPLE; }
{NOMCOMPOSE}     { yylval->s = strdup(yytext); return NOMCOMPOSE; }
[:()\*,;]        { return *yytext; }
.                { yyerror(yylloc, "Caractère inattendu"); }
%%

int main(int argv, char **argc)
{
#if 0
    yydebug = 1;
#endif
    int r = yyparse();
    return r;
}
