
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

%token	<int_val>	INTEGER_LITERAL
%type	<int_val>	exp
%left	PLUS
%left	MULT

%%

input:	/* empty */
		| exp
		;

exp:    INTEGER_LITERAL
		| exp PLUS exp
		| exp MULT exp
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
