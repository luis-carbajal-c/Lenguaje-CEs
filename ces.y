
%{
    #include "heading.h"
    int yyerror(char *s);
    int error_symbol(string s, string symbol);
    extern "C" int yylex();

    enum IDType {
        fun,
        var
    };

    enum FType {
        sin_tipo,
        entero
    };

    enum VType {
        simple,
        arreglo
    };

    struct attr{
        IDType idtype;
        FType ftype;
        VType vtype;
        int asize;
        int val;
    };

    struct SymbolTable {
        vector<map<string, attr> > tables;

        SymbolTable() {
            tables.push_back(map<string, attr>());
        }

        map<string, attr>& current() {
            return tables[tables.size() - 1];
        }

        void insert_symbol(string id, attr val) {
            map<string, attr> &curr = current();
            curr.insert(pair<string, attr>(id, val));
        }

        bool search_symbol_local(string id) {
            map<string, attr> &curr = current();
            return curr.find(id) != curr.end();
        }

        bool search_symbol_global(string id) {
            for (int i = 0; i < tables.size(); i++) {
                if (tables[i].find(id) != tables[i].end())
                    return true;
            }
            return false;
        }

        void update_symbol(string id, attr new_val) {
            map<string, attr> &curr = current();
            curr[id] = new_val;
        }

        void add_scope() {
            tables.push_back(map<string, attr>());
        }

        void remove_scope() {
            tables.pop_back();
        }
    };

    SymbolTable symbolTable;
%}

%union {
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

%type <id_val> declaracion
%type <id_val> var_declaracion
%type <id_val> fun_declaracion

//%left PLUS
//%left MULT

%%

programa:
    lista_declaracion
    ;

lista_declaracion:  
    declaracion lista_declaracion
    | declaracion {
        if (*$1 != "main") {
            error_symbol("Last program declaration should be main function", *$1);
        }
    }
    ;

declaracion:
    var_declaracion {$$ = $1;}
    | fun_declaracion {$$ = $1;}
    ;

var_declaracion:
    ENTERO ID EOS {
        $$ = $2;
        if (*$2 == "main") error_symbol("Keyword reserved for main function declaration", *$2);
        if (!symbolTable.search_symbol_local(*$2)) {
            attr a;
            a.idtype = var;
            a.vtype = simple;
            symbolTable.insert_symbol(*$2, a);
        }
        else error_symbol("Symbol already defined", *$2);
    }
    | ENTERO ID COR_BEG NUM COR_END EOS {
        $$ = $2;
        if (*$2 == "main") error_symbol("Keyword reserved for main function declaration", *$2);
        if (!symbolTable.search_symbol_local(*$2)) {
            attr a;
            a.idtype = var;
            a.vtype = arreglo;
            a.asize = $4;
            symbolTable.insert_symbol(*$2, a);
        }
        else error_symbol("Symbol already defined", *$2);
    }
    ;

fun_declaracion:
    ENTERO ID PAR_BEG params PAR_END sent_compuesta {
        $$ = $2;
        if (!symbolTable.search_symbol_local(*$2)) {
            attr a;
            a.idtype = fun;
            a.ftype = entero;
            symbolTable.insert_symbol(*$2, a);
        }
        else error_symbol("Symbol already defined", *$2);
    }
    | SIN_TIPO ID PAR_BEG params PAR_END sent_compuesta {
        $$ = $2;
        if (!symbolTable.search_symbol_local(*$2)) {
            attr a;
            a.idtype = fun;
            a.ftype = sin_tipo;
            symbolTable.insert_symbol(*$2, a);
        }
        else error_symbol("Symbol already defined", *$2);
    }
    ;

params:
    lista_params {cout << "params" << endl;}
    | SIN_TIPO {cout << "params" << endl;}
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
    RETORNO EOS {cout << "retorno" << endl;}
    | RETORNO expresion EOS {cout << "retorno" << endl;}
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

int yyerror(string s) {
    extern int yylineno;
    extern char *yytext;
    
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
    cerr << "\" on line " << yylineno << endl;
    exit(1);
}

int yyerror(char *s) {
    return yyerror(string(s));
}

int error_symbol(string s, string symbol) {
    extern int yylineno;
    extern char *yytext;
    
    cerr << "ERROR: " << s << " at symbol \"" << symbol;
    cerr << "\" on line " << yylineno << endl;
    exit(1);
}