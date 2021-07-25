/*#include <FlexLexer.h>
#include <iostream>

using namespace std;

// separar terminales en flex (relop, addop, mulop)

int main() {
    FlexLexer* lexer = new yyFlexLexer;

    int type;
    cout << "Reading tokens...\n";
    while (type = lexer->yylex()) {
        string token;
        switch (type) {
            case 2: token = "num"; break;
            case 3: token = "id"; break;
            case 100: return 0;
            default: token = lexer->YYText(); break;
        }

        cout << token << endl;
    }

    return 0;
}*/

#include "heading.h"

int yyparse();

int main(int argc, char **argv)
{
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
    return 1;
  }
  
  yyparse();

  return 0;
}
