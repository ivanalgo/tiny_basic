
%{
#include <string>
#include <vector>

#include <stdlib.h>
#include "parser.hpp"
#include "syntax.hpp"

using namespace std;

%}

%option noyywrap
%option yylineno

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

"function" {
	return FUNC;
}

"endfunc" {
	return ENDFUNC;
}

{number} {
	yylval.tree = new imm_node(atoi(yytext));
	return NUM;
}

{var} {
	yylval.var = new string(yytext);

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

{newline} {
	return NEWLINE;
}

[(),=+-] {
	return *yytext;
}

"." {
	printf("lex: invalid: %s\n", yytext);
}

%%

