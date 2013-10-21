
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

"if" {
	return IF;
}

"else" {
	return ELSE;
}

"THEN" {
	return THEN;
}

"endif" {
	return ENDIF;
}

"endwhile" {
	return ENDWHILE;
}

"while" {
	return WHILE;
}

"do" {
	return DO;
}

"print" {
	return PRINT;
}

{number} {
	yylval.tree = new imm_node(atoi(yytext));
	return NUM;
}

{var} {
	yylval.tree = new var_node(string(yytext));

	return VAR;
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
	return NEWLINE;
}

"." {
	printf("lex: invalid: %s\n", yytext);
}

%%

