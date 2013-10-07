
%{
#include <string>

#include <stdlib.h>
#include "parser.hpp"
#include "syntax.hpp"

using namespace std;

%}

%option noyywrap

number [0-9]+
var [a-zA-Z][a-zA-Z0-9]*
newline \n
space [ \t]+

if "if"
else "else"
then "then"
while "while"
do "do"
print "print"

lop_equal "=="
lop_nequal "!="

aop_add "+"
aop_sub "-"

assign "="

%%

{if} {
	return token_if;
}

{else} {
	return token_else;
}

{then} {
	return token_then;
}

"endif" {
	return token_endif;
}

"endwhile" {
	return token_endwhile;
}

{while} {
	return token_while;
}

{do} {
	return token_do;
}

{print} {
	return token_print;
}

{number} {
	yylval.tree = new imm_node(atoi(yytext));
	return token_num;
}

{var} {
	yylval.tree = new var_node(string(yytext));

	return token_var;
}

{space} {
	//ignore
}

{lop_equal} {
	return token_lop_equal;
}

{lop_nequal} {
	return token_lop_nequal;
}

{aop_add} {
	return token_aop_add;
}

{aop_sub} {
	return token_aop_sub;
}

{assign} {
	return token_assign;
}

{newline} {
	return token_newline;
}

"." {
	printf("lex: invalid: %s\n", yytext);
}

%%

