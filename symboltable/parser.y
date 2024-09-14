%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"
int yylex(void);
void yyerror(const char *s);
void print_symbol_table(void);
extern FILE *yyin;
%}

%union {
    char *str;
    int num;
}

%token <str> IDENTIFIER
%token <num> NUMBER

%%

program:
    declarations
    {
        printf("Symbol table after parsing:\n");
        print_symbol_table();  // Print the symbol table after parsing
        printf("\n");
    }
    ;

declarations:
    declaration
    | declarations declaration
    ;

declaration:
    IDENTIFIER '=' NUMBER { insert_symbol($1, $3); }
    ;

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
