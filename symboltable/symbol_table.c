// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
// #include "symbol_table.h"

// Symbol *symbol_table = NULL;

// Symbol* insert_symbol(char *name, int value) {
//     Symbol *sym = (Symbol *)malloc(sizeof(Symbol));
//     sym->name = strdup(name);
//     sym->value = value;
//     sym->next = symbol_table;
//     symbol_table = sym;
//     printf("Inserted symbol: %s with value: %d\n", name, value);  // Debugging statement
//     return sym;
// }

// Symbol* lookup_symbol(char *name) {
//     for (Symbol *sym = symbol_table; sym != NULL; sym = sym->next) {
//         if (strcmp(sym->name, name) == 0) {
//             printf("Found symbol: %s with value: %d\n", name, sym->value);  // Debugging statement
//             return sym;
//         }
//     }
//     return NULL;
// }

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

Symbol *symbol_table = NULL;

Symbol* insert_symbol(char *name, int value) {
    Symbol *sym = (Symbol *)malloc(sizeof(Symbol));
    sym->name = strdup(name);
    sym->value = value;
    sym->next = symbol_table;
    symbol_table = sym;
    return sym;
}

Symbol* lookup_symbol(char *name) {
    for (Symbol *sym = symbol_table; sym != NULL; sym = sym->next) {
        if (strcmp(sym->name, name) == 0) {
            return sym;
        }
    }
    return NULL;
}

void print_symbol_table(void) {
    Symbol *sym = symbol_table;
    while (sym != NULL) {
        printf("Symbol: %s, Value: %d\n", sym->name, sym->value);
        sym = sym->next;
    }
}

