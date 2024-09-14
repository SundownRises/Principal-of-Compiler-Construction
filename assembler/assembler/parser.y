%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern char* yytext;
int yyerror(char *s);

#define MAX_SYMBOLS 1000

typedef struct {
    char *label;
    int address;
} Symbol;

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;
int location_counter = 0;
int pass = 1;

void add_symbol(char *label, int address);
int find_symbol(char *label);
int get_opcode(char *instruction);
int get_register_code(char *reg);
void print_symbol_table();
%}

%union {
    char* str;
    int num;
}

%token <str> IDENTIFIER REGISTER
%token <num> NUMBER
%token NEWLINE COLON COMMA

%type <num> instruction operand

%start program

%%

program: line_list;

line_list: line | line_list line;

line:
    NEWLINE
    | label instruction NEWLINE
    | instruction NEWLINE
    ;

label:
    IDENTIFIER COLON    {
        if (pass == 1) {
            add_symbol($1, location_counter);
        }
        free($1);
    }
    ;

instruction:
    IDENTIFIER          {
        if (pass == 1) {
            add_symbol($1, location_counter);
        }
        int opcode = get_opcode($1);
        if (pass == 2) {
            printf("%02X ", opcode);
        }
        location_counter += 1;
        free($1);
        $$ = opcode;
    }
    | IDENTIFIER operand_list {
        int opcode = get_opcode($1);
        if (pass == 2) {
            printf("%02X ", opcode);
        }
        location_counter += 1;
        free($1);
        $$ = opcode;
    }
    ;

operand_list: operand | operand_list COMMA operand;

operand:
    IDENTIFIER          {
        if (pass == 2) {
            int address = find_symbol($1);
            if (address == -1) {
                fprintf(stderr, "Error: Undefined symbol %s\n", $1);
                exit(1);
            }
            printf("%02X ", address);
        }
        location_counter += 1;
        free($1);
        $$ = 0; // Placeholder value
    }
    | REGISTER          {
        if (pass == 2) {
            int reg_code = get_register_code($1);
            printf("%02X ", reg_code);
        }
        location_counter += 1;
        free($1);
        $$ = 0; // Placeholder value
    }
    | NUMBER            {
        if (pass == 2) {
            printf("%02X ", $1);
        }
        location_counter += 1;
        $$ = $1;
    }
    ;

%%

void add_symbol(char *label, int address) {
    symbol_table[symbol_count].label = strdup(label);
    symbol_table[symbol_count].address = address;
    symbol_count++;
}

int find_symbol(char *label) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].label, label) == 0) {
            return symbol_table[i].address;
        }
    }
    return -1;
}

int get_opcode(char *instruction) {
    if (strcmp(instruction, "MOV") == 0) return 0x3E;
    if (strcmp(instruction, "ADD") == 0) return 0x80;
    if (strcmp(instruction, "SUB") == 0) return 0x90;
    if (strcmp(instruction, "JMP") == 0) return 0xC3;
    if (strcmp(instruction, "CMP") == 0) return 0x3D;
    if (strcmp(instruction, "MUL") == 0) return 0xF6;
    if (strcmp(instruction, "JNE") == 0) return 0x75;
    if (strcmp(instruction, "HALT") == 0) return 0xF4;
    // Add more instructions as needed
    fprintf(stderr, "Error: Unknown instruction %s\n", instruction);
    exit(1);
}

int get_register_code(char *reg) {
    if (strcmp(reg, "A") == 0) return 0x00;
    if (strcmp(reg, "B") == 0) return 0x01;
    if (strcmp(reg, "C") == 0) return 0x02;
    if (strcmp(reg, "D") == 0) return 0x03;
    if (strcmp(reg, "E") == 0) return 0x04;
    if (strcmp(reg, "H") == 0) return 0x05;
    if (strcmp(reg, "L") == 0) return 0x06;
    fprintf(stderr, "Error: Unknown register %s\n", reg);
    exit(1);
}

void print_symbol_table() {
    printf("\nSymbol Table:\n");
    printf("-------------\n");
    printf("Label\t\tAddress\n");
    printf("-----\t\t-------\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%-16s0x%04X\n", symbol_table[i].label, symbol_table[i].address);
    }
    printf("\n");
}

int main(int argc, char **argv) {
    pass = 1; // First pass
    yyparse();
    print_symbol_table();
    // Reset state for second pass
    location_counter = 0;
    pass = 2; // Second pass
    rewind(stdin);  // Reset input to the beginning of the file
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error %s", s);
    return 0;
}