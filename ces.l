%{
    #include "heading.h"
    #include "tok.h"
    extern "C" int yylex();
    int yyerror(char *s);
%}

%option yylineno

ws      [ \t]+
alpha   [A-Za-z]
digit   [0-9]
id      {alpha}+
number  {digit}+

%%

{ws}        {/*skip blanks and tabs*/}

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] {/*comment*/}
\n          {/*newline*/}

"entero"    {yylval.op_val = new std::string(yytext); return ENTERO;}
"sin_tipo"  {yylval.op_val = new std::string(yytext); return SIN_TIPO;}
"retorno"   {yylval.op_val = new std::string(yytext); return RETORNO;}
"mientras"  {yylval.op_val = new std::string(yytext); return MIENTRAS;}
"si"        {yylval.op_val = new std::string(yytext); return SI;}
"sino"      {yylval.op_val = new std::string(yytext); return SINO;}

"+"         {yylval.op_val = new std::string(yytext); return SUM;}
"-"         {yylval.op_val = new std::string(yytext); return SUB;}
"*"         {yylval.op_val = new std::string(yytext); return MUL;}
"/"         {yylval.op_val = new std::string(yytext); return DIV;}

"<"         {yylval.op_val = new std::string(yytext); return LT;}
"<="        {yylval.op_val = new std::string(yytext); return LEQ;}
">"         {yylval.op_val = new std::string(yytext); return GT;}
">="        {yylval.op_val = new std::string(yytext); return GEQ;}
"=="        {yylval.op_val = new std::string(yytext); return EQ;}
"!="        {yylval.op_val = new std::string(yytext); return NEQ;}

"="         {yylval.op_val = new std::string(yytext); return ASSIGN;}
"("         {yylval.op_val = new std::string(yytext); return PAR_BEG;}
")"         {yylval.op_val = new std::string(yytext); return PAR_END;}
"["         {yylval.op_val = new std::string(yytext); return COR_BEG;}
"]"         {yylval.op_val = new std::string(yytext); return COR_END;}
"{"         {yylval.op_val = new std::string(yytext); return LLA_BEG;}
"}"         {yylval.op_val = new std::string(yytext); return LLA_END;}
","         {yylval.op_val = new std::string(yytext); return COMMA;}
";"         {yylval.op_val = new std::string(yytext); return EOS;}

{number}    {yylval.int_val = atoi(yytext); return NUM;}
{id}        {yylval.id_val = new std::string(yytext); return ID;}

.           {
                char* error = (char *) "Lexic error";
                yyerror(error);
                exit(1);
            }

%%
