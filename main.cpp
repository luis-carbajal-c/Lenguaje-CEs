#include <FlexLexer.h>
#include <iostream>

using namespace std;

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
}