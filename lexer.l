%{
    #include <iostream>
    using namespace std;
    int mylineno = 1;

    enum yytokentype {
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
    };
%}

%option noyywrap c++

ws      [ \t]+

keyword entero|retorno|sin_tipo|mientras|si|sino|main
alpha   [A-Za-z]
digit   [0-9]
id      ({alpha})({alpha})*
number  ({digit})({digit})*
addop   "+"|"-"
mulop   "*"|"/"
relop   "<"|"<="|">"|">="|"=="|"!="

%%

{ws}    /* skip blanks and tabs */

"/*"    {
        int c;

        while((c = yyinput()) != 0)
            {
            if(c == '\n')
                ++mylineno;

            else if(c == '*')
                {
                if((c = yyinput()) == '/')
                    break;
                else
                    unput(c);
                }
            }
        }

{keyword}   return keyword;

{number}    return num;

{id}        return id;

\n          mylineno++;

{addop}     return add;

{mulop}     return mul;

{relop}     return rel;

"="         return assign;

"("         return par_beg;

")"         return par_end;

"["         return sbr_beg;

"]"         return sbr_end;

"{"         return cbr_beg;

"}"         return cbr_end;

","         return comma;

";"         return eos;

.           {
                printf("Error en la linea %i. Caracter '%s' invalido\n", mylineno, YYText()); 
                return error;
            }

%%
