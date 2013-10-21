%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <string>
#include <vector>

#include "sym.hpp"
#include "syntax.hpp"
#include "pointer.hpp"

using namespace std;

extern int yylex();
extern int yylineno;

void yyerror(const char *msg)
{
	printf("Error: %s(%d)\n", msg, yylineno);
	exit(1);
}

%}

%union {
	std::string *var;
	class syntax_node *tree;	
	class block_stat_node *stats;
	std::vector<std::string> *args;
}

%token <tree> NUM
%token <var> VAR
%token IF
%token ELSE
%token THEN
%token ENDIF
%token WHILE
%token DO
%token ENDWHILE
%token PRINT
%token token_space
%token token_ospace
%token NEWLINE
%token token_lop_equal
%token token_lop_nequal
%token FUNC
%token ENDFUNC

%type <tree> statement assign_stat if_stat while_stat print_stat
%type <tree> function_define
%type <tree>  expr a_expr l_expr
%type <stats> block_stat
%type <args>  arg_list arg_tail

%%

program: 
	  program statement 
		{
			$2->exec();
			delete $2;
		}
	|
	;

statement: 
	  assign_stat { $$ = $1; }
	| if_stat { $$ = $1; }
	| while_stat {$$ = $1; }
	| print_stat { $$ = $1; }
	| function_define { $$ = $1; }
	;

expr: 
	  VAR { $$ = new var_node(*$1); }
	| NUM { $$ = $1; }
	;

a_expr: 
	  expr { $$ =  $1; }
	| expr '+' expr 
		{ 
			$$ = new arith_expr_node($1, arith_expr_node::arith_add, $3);
		}
	| expr '-' expr 
		{ 
			$$ = new arith_expr_node($1, arith_expr_node::arith_sub, $3);
		}
	;

l_expr:
	  expr token_lop_equal expr 
		{ 
			$$ = new logic_expr_node($1, 
				logic_expr_node::logic_equal, $3);
		}

	| expr token_lop_nequal expr 
		{ 
			$$ = new logic_expr_node($1,
				logic_expr_node::logic_nequal, $3);
		}
	;

assign_stat: VAR '=' a_expr NEWLINE
		{ 
			$$ = new assign_node(new var_node(*$1), $3);
		}
	;

if_stat:
	  IF l_expr THEN NEWLINE block_stat ENDIF NEWLINE
		{
			$$ = new if_else_node($2, $5);
		}

	| IF l_expr THEN NEWLINE block_stat ELSE NEWLINE block_stat ENDIF NEWLINE
		{
			$$ = new if_else_node($2, $5, $8);
		}
	;

block_stat:
	  block_stat statement
		{
			$1->add_stat($2);
			$$ = $1;	
		}
	| 
		{
			$$ = new block_stat_node();
		}
	;
	  

while_stat:
	  WHILE l_expr DO NEWLINE block_stat ENDWHILE NEWLINE
		{
			$$ = new while_node($2, $5);
		}
	;

print_stat:
	  PRINT VAR NEWLINE
		{
			$$ = new print_node(new var_node(*$2));
		}
	;

function_define:
	  FUNC VAR '(' arg_list ')' NEWLINE block_stat ENDFUNC NEWLINE
		{
			$$ = new function_node(*$4, $7);
		}
	;

arg_list:
	  VAR arg_tail
		{
			$2->push_back(*$1);
			$$ = $2;
		}
	|
		{
			$$ = new vector<string>();
		}
	;

arg_tail:
	  ',' VAR arg_tail
		{
			$3->push_back(*$2);
			$$ = $3;
		}
	| ',' VAR
		{
			$$ = new vector<string>();
			$$->push_back(*$2);
		}
	|
		{
			$$ = new vector<string>();
		}
	;

%%


int main(void)
{
	yyparse();

	return 0;
}
