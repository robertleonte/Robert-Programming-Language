%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
"_rint"|"_rfloat"|"_rchar"|"_rstring"|"_rbool" {yylval.strval=strdup(yytext); return TIP;}
"Eval" {return EVAL;}
"_rvoid" {return VOID;}
"r_true" {return TRUE;}
"r_false" {return FALSE;}
"public" {return PUBLIC;}
"private" {return PRIVATE;}
"protected" {return PROTECTED;}
"_rmain" {return MAIN;}
"_rif" {return IF;}
"_relse" {return ELSE;}
"_rwhile" {return WHILE;}
"_rfor" {return FOR;}
"_r=" {return ASSIGN;}
"_r=="|"_r<"|"_r>"|"_r<="|"_r>="|"_r!=" {return OP;}
"_r++" {yylval.strval=strdup(yytext); return INC;}
"_r--" {yylval.strval=strdup(yytext); return DEC;}
"_r&&" {return AND;}
"_r||" {return OR;}
"s+" {return PLUSSTR;}
"s-" {return MINUSSTR;}
"s*" {return MULTSTR;}
"class" {return CLASS;}
"Display" {return DISPLAY;}
"lp" {return LP;}
"_r+=" {yylval.strval=strdup(yytext); return PLUS;}
"_r-=" {yylval.strval=strdup(yytext); return MINUS;}
"_r*=" {yylval.strval=strdup(yytext); return PRODUS;}
"_r/=" {yylval.strval=strdup(yytext); return IMPARTIRE;}
"const" {return CONST;}
"return" {return RETURN;}
[a-zA-Z][a-zA-Z0-9]* {yylval.strval=strdup(yytext); return ID;}
\'[a-zA-Z]\' {yylval.strval=strdup(yytext); return LITERA;}
[0-9]|[1-9][0-9]* {yylval.intval=atoi(yytext); return NR;}
[0-9],[0-9][0-9]* {yylval.floatval=strtof(yytext, NULL); return FLOAT;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
