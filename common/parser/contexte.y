%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "contexte.tab.h"
extern int yylex(YYSTYPE *lvalp, YYLTYPE *llocp);
extern void yyerror(YYLTYPE *locp, const char *s);

/*
 * La syntaxe avec la génération d'un nom de variable par "localisation"
 * nous oblige plus ou moins à avoir le nom de la variable à traiter
 * en global
 */
static char *base;
static bool  locs;

/*
 * macro pour générer la bonne chaîne sans répéter 5 fois presque la
 * même chose.
 * Et en plus on utilise le préprocesseur cryptiquement, c'est toujours
 * un plaisir.
 * cv : concat variables. Chaînification si une seule, concatenation
 *      avec _ et chaînification si 2
 * gdb_set : rs est la localisation, registre ou pile, et l'argument optionel
 *           hi ou lo
 */
#define cv(reg_stack, ...) \
    #reg_stack __VA_OPT__("_") #__VA_ARGS__
#define gdb_set(rs, ...) \
    "set $%s_" cv(rs, __VA_ARGS__)  " = \"$%s\"\n"
%}

%union {
    char  c;
    int   i;
    char *s;
}

%token    FONCTION
%token    CONTEXTE
%token<s> RA
%token<s> SP
%token<c> SIGNE
%token    TYPE
%token    SEPARATEUR
%token    PILE
%token    REGISTRE
%token    REGISTRES
%token    SECTION
%token    SEGMENT
%token<s> MEMOIRE
%token<s> NOMSIMPLE
%token<s> NOMCOMPOSE
%token<i> INT
%token    RETOUR
%token<s> IDREG
%type<s>  variable
%type<s>  adresse
%type<s>  localisation
%type<s>  localisations

%locations
%define api.pure full

%%
contexte :
    FONCTION ':' retour
    NOMSIMPLE ':' TYPE retour
    CONTEXTE ':' retour
    liste_contexte
    ;

retour : // on autorise plusieurs retours à la ligne pour les commentaires
      RETOUR
    | retour RETOUR
    ;

liste_contexte :
      // on autorise les contextes vides pour les interruptions
    | liste_contexte element_contexte
    ;

variable :
      RA
    | NOMSIMPLE
    | NOMCOMPOSE
    ;

element_contexte :
      variable
      {
          base = $1;
          locs = false;
      }
      ':' localisations retour
      {
         if (locs == false) {
             printf("%s", $4);
         } else {
             char *s = $4;
             int n = 0;
             do {
                 if (*s == '=')
                     n++;
             } while (*s++);
             if (n > 1) {
                 char *t = malloc(strlen($4) + n * 2 + 1);
                 char *v = t;
                 s = $4;
                 n = 0;
                 do {
                     if (*s == '=') {
                         *(t - 1) = '_';
                         *t++ = '0' + n++;
                         *t++ = ' ';
                     }
                     *t++ = *s++;
                 } while (*s);
                 printf("%s", v);
		 free(v);
             } else {
                 printf("%s", $4);
		 free($4);
             }
         }
         free(base);
      }
    ;

localisations :
      localisation
      {
         $$ = $1;
      }
    | localisations ';' localisation
      {
         char *s = malloc(strlen($1) + strlen($3) + 10 + 1);
         sprintf(s, "%s%s", $1, $3);
         $$ = s;
         locs = true;
	 /* le cas 'mémoire' retourne une chaîne statique vide, pas de free donc */
	 if (*$1)
             free($1);
	 if (*$3)
             free($3);
      }
    ;


localisation :
      REGISTRE IDREG
      {
          char tmp[BUFSIZ];
          sprintf(tmp, gdb_set(reg), base, $2);
          free($2);
          $$ = strdup(tmp);
      }
    | REGISTRES IDREG SEPARATEUR IDREG
      {
          char tmp[BUFSIZ];
          int n;
          n = sprintf(tmp, gdb_set(reg, lo), base, $2);
          sprintf(tmp + n, gdb_set(reg, hi), base, $4);
          free($2);
          free($4);
          $$ = strdup(tmp);
      }
    | PILE '*' '(' adresse ')'
      {
          char tmp[BUFSIZ];
          sprintf(tmp, gdb_set(stack), base, $4);
          free($4);
          $$ = strdup(tmp);
      }
    | PILE '*' '(' adresse ')' SEPARATEUR '*' '(' adresse ')' // mot 64 bits sur la pile
      {
          char tmp[BUFSIZ];
          int n;
          n = sprintf(tmp, gdb_set(stack, lo), base, $4);
          sprintf(tmp + n, gdb_set(stack, hi), base, $9);
          free($4);
          free($9);
          $$ = strdup(tmp);
      }
    | MEMOIRE
      {
          $$ = "";
      }
    | MEMOIRE ',' SECTION SEGMENT
      {
          $$ = "";
      }
    ;

adresse :
      SP
      {
          $$ = $1;
      }
    | SP SIGNE INT
      {
          char tmp[BUFSIZ];
          sprintf(tmp, "%s %c %d", $1, $2, $3);
          free($1);
          $$ = strdup(tmp);
      }
    ;
