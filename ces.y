
%{
    #include "heading.h"
    int yyerror(char *s);
    extern "C" int yylex();

    struct type_val{
        int type;
        int val;
    };

    struct SymbolTable {
        queue<map<string, type_val> > tables;

        SymbolTable() {
            tables.push(map<string, type_val>());
        }

        void insert_symbol(string id, type_val val) {
            map<string, type_val> &current = tables.front();
            current.insert(pair<string, type_val>(id, val));
        }

        bool search_symbol(string id) {
            map<string, type_val> &current = tables.front();
            return current.find(id) != current.end();
        }

        void update_symbol(string id, type_val new_val) {
            map<string, type_val> &current = tables.front();
            current[id] = new_val;
        }
    };

    SymbolTable symbolTable;
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

//%left PLUS
//%left MULT

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

/*
tipo:
    ENTERO
    | SIN_TIPO
    ;
*/

fun_declaracion:
    ENTERO ID PAR_BEG params PAR_END sent_compuesta
    | SIN_TIPO ID PAR_BEG params PAR_END sent_compuesta
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
    ENTERO ID
    | ENTERO ID COR_BEG COR_END
    ;

sent_compuesta:
    LLA_BEG declaracion_local lista_sentencias LLA_END
    ;

declaracion_local:
    /*empty*/
    | declaracion_local var_declaracion
    ;

lista_sentencias:
    /*empty*/
    | lista_sentencias sentencia
    ;

sentencia:
    sentencia_expresion 
    | sentencia_seleccion
    | sentencia_iteracion
    | sentencia_retorno
    ;

sentencia_expresion:
    expresion EOS
    | EOS
    ;

sentencia_seleccion:
    SI PAR_BEG expresion PAR_END sentencia
    | SI PAR_BEG expresion PAR_END sentencia SINO sentencia
    ;

sentencia_iteracion:
    MIENTRAS PAR_BEG expresion PAR_END LLA_BEG lista_sentencias LLA_END
    ;

sentencia_retorno:
    RETORNO EOS
    | RETORNO expresion EOS
    ;

expresion:
    var ASSIGN expresion
    | expresion_simple
    ;

var:
    ID
    | ID COR_BEG expresion COR_END
    ;

expresion_simple:
    expresion_aditiva relop expresion_aditiva
    | expresion_aditiva
    ;

relop:
    LT
    | LEQ
    | GT
    | GEQ
    | EQ
    | NEQ
    ;

expresion_aditiva:
    expresion_aditiva addop term
    | term
    ;

addop:
    SUM
    | SUB
    ;

term:
    term mulop factor
    | factor
    ;

mulop:
    MUL
    | DIV
    ;

factor:
    PAR_BEG expresion PAR_END 
    | var
    | call
    | NUM
    ;

call:
    ID PAR_BEG args PAR_END
    ;

args:
    /*empty*/
    | lista_arg
    ;

lista_arg:
    lista_arg COMMA expresion
    | expresion
    ;

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
