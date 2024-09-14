%{
#include "parser.tab.h"
#include "symbol_table.h"
#include <string.h>
int yywrap(void);
%}

%%
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }
"="                     { return '='; }
[ \t\n]                 { /* ignore whitespace */ }
.                       { /* handle other characters */ }
%%

int yywrap(void) {
    return 1;
}
