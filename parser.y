%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "sym.hpp"
#include "syntax.hpp"
#include "pointer.hpp"

using namespace std;

extern int yylex();

void yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	exit(1);
}

%}

%union {
	class syntax_node *tree;	
	class block_stat_node *stats;
}

%token <tree> token_num
%token <tree> token_var
%token token_if
%token token_else
%token token_then
%token token_endif
%token token_while
%token token_do
%token token_endwhile
%token token_print
%token token_assign
%token token_space
%token token_ospace
%token token_newline
%token token_lop_equal
%token token_lop_nequal
%token token_aop_add
%token token_aop_sub

%type <tree> statement assign_stat if_stat while_stat print_stat 
%type <tree>  expr a_expr l_expr
%type <stats> block_stat

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
	;

expr: 
	  token_var { $$ = $1; }
	| token_num { $$ = $1; }
	;

a_expr: 
	  expr { $$ =  $1; }
	| expr token_aop_add expr 
		{ 
			$$ = new arith_expr_node($1, arith_expr_node::arith_add, $3);
		}
	| expr token_aop_sub expr 
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

assign_stat: token_var token_assign a_expr token_newline
		{ 
			$$ = new assign_node($1, $3);
		}
	;

if_stat:
	  token_if l_expr token_then token_newline block_stat token_endif token_newline
		{
			$$ = new if_else_node($2, $5);
		}

	| token_if l_expr token_then token_newline block_stat token_else token_newline block_stat token_endif token_newline
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
	  token_while l_expr token_do token_newline block_stat token_endwhile token_newline
		{
			$$ = new while_node($2, $5);
		}
	;

print_stat:
	  token_print token_var token_newline
		{
			$$ = new print_node($2);
		}
	;

%%


int main(void)
{
	yyparse();

	return 0;
}
