#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct Symbol {
    char *name;
    int value;
    struct Symbol *next;
} Symbol;

Symbol* insert_symbol(char *name, int value);
Symbol* lookup_symbol(char *name);

#endif
