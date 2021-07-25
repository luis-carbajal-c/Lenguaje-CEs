
%{
    #include "heading.h"
    int yyerror(char *s);
    extern "C" int yylex();
%}

%union{
    int		int_val;
    string* op_val;
    string* id_val;
}

%start programa 

%token <op_val>     ENTERO
%token <op_val>     SIN_TIPO
%token <op_val>     RETORNO
%token <op_val>     MIENTRAS
%token <op_val>     SI
%token <op_val>     SINO
//%token <op_val>     MAIN
//"main"      {yylval.op_val = new std::string(yytext); return MAIN;}

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

%token <int_val>    NUM
%token <id_val>     ID

%left PLUS
%left MULT

%%

programa:
    lista_declaracion
    ;

lista_declaracion:  
    lista_declaracion declaracion
    | declaracion
    ;

declaracion:
    var_declaracion
    | fun_declaracion
    ;

var_declaracion:
    ENTERO ID EOS
    | ENTERO ID COR_BEG NUM COR_END EOS
    ;

tipo:
    ENTERO
    | SIN_TIPO
    ;

fun_declaracion:
    tipo ID PAR_BEG params PAR_END sent_compuesta
    ;

params:
    lista_params
    | SIN_TIPO
    ;

lista_params:
    lista_params COMMA param
    | param
    ;

param:
    tipo ID
    | tipo ID COR_BEG COR_END
    ;

sent_compuesta:
    LLA_BEG declaracion_local lista_sentencias LLA_END
    ;

declaracion_local:
    declaracion_local var_declaracion
    | /*empty*/
    ;

lista_sentencias:
    lista_sentencias sentencia
    | /*empty*/
    ;

sentencia:
    

%%

int yyerror(string s)
{
    extern int yylineno;
    extern char *yytext;
    
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
    cerr << "\" on line " << yylineno << endl;
    exit(1);
}

int yyerror(char *s)
{
    return yyerror(string(s));
}
