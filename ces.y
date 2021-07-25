
%{
    #include "heading.h"
    int yyerror(char *s);
    extern "C" int yylex();
%}

%union{
    int		int_val;
    string* op_val;
}

%start	input 

%token <op_val>     ENTERO
%token <op_val>     SIN_TIPO
%token <op_val>     RETORNO
%token <op_val>     MIENTRAS
%token <op_val>     SI
%token <op_val>     SINO
%token <op_val>     MAIN
%token <int_val>    NUM
%token <op_val>     ID
%token <op_val>     SUM
%token <op_val>     SUB
%token <op_val>     MUL
%token <op_val>     DIV
%token <op_val>     LT
%token <op_val>     LEQ
%token <op_val>     GT
%token <op_val>     GEQ
%token <op_val>     EQ
%token <op_val>     NEQ
%token <op_val>     ASSIGN
%token <op_val>     PAR_BEG
%token <op_val>     PAR_END
%token <op_val>     COR_BEG
%token <op_val>     COR_END
%token <op_val>     LLA_BEG
%token <op_val>     LLA_END
%token <op_val>     COMMA
%token <op_val>     EOS

%left	PLUS
%left	MULT

%%

input:	/* empty */
		| exp
        | ENTERO
		;

exp:    ID
		;

%%

int yyerror(string s)
{
    extern int yylineno;	// defined and maintained in lex.c
    extern char *yytext;	// defined and maintained in lex.c
    
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
    cerr << "\" on line " << yylineno << endl;
    exit(1);
}

int yyerror(char *s)
{
    return yyerror(string(s));
}
