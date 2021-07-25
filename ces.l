%{
    #include "heading.h"
    #include "tok.h"
    extern "C" int yylex();
    int yyerror(char *s);

    /*enum yytokentype {
        keyword = 1,
        num = 2,
        id = 3,
        add = 4,
        mul = 5,
        rel = 6,
        assign = 7,
        par_beg = 8,
        par_end = 9,
        sbr_beg = 10,
        sbr_end = 11,
        cbr_beg = 12,
        cbr_end = 13,
        comma = 14,
        eos = 15,
        error = 100
    };*/
%}

%option yylineno

ws      [ \t]+
alpha   [A-Za-z]
digit   [0-9]
id      ({alpha})({alpha})*
number  ({digit})({digit})*

%%

{ws}    /* skip blanks and tabs */

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] {/*comment*/}

\n          {/*newline*/}

"entero"    {return ENTERO;}

"sin_tipo"  {return SIN_TIPO;}

"retorno"   {return RETORNO;}

"mientras"  {return MIENTRAS;}

"si"        {return SI;}

"sino"      {return SINO;}

"main"      {return MAIN;}

{number}    {return NUM;}

{id}        {return ID;}

"+"         {return SUM;}

"-"         {return SUB;}

"*"         {return MUL;}

"/"         {return DIV;}

"<"         {return LT;}

"<="        {return LEQ;}

">"         {return GT;}

">="        {return GEQ;}

"=="        {return EQ;}

"!="        {return NEQ;}

"="         {return ASSIGN;}

"("         {return PAR_BEG;}

")"         {return PAR_END;}

"["         {return COR_BEG;}

"]"         {return COR_END;}

"{"         {return LLA_BEG;}

"}"         {return LLA_END;}

","         {return COMMA;}

";"         {return EOS;}

.           {
                //printf("Error en la linea %i. Caracter '%s' invalido\n", yylineno, YYText()); 
                yyerror("lexic error");
                exit(1);
            }

%%
