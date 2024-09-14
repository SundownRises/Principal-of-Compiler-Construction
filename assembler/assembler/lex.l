%{
#include "parser.tab.h"
#include <string.h>
%}

%%
[ \t]+          { /* Ignore whitespace */ }
\n              { return NEWLINE; }
:               { return COLON; }
,               { return COMMA; }
A|B|C|D|E|H|L   { 
                  yylval.str = strdup(yytext);
                  return REGISTER;
                }
[a-zA-Z_][a-zA-Z0-9_]* { 
                  yylval.str = strdup(yytext);
                  return IDENTIFIER;
                }
[0-9]+          { 
                  yylval.num = atoi(yytext);
                  return NUMBER;
                }
.               { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}