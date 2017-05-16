%{
	#include "y.tab.h"
	#include <string.h>
	int col = 0;
%}
%%
\n						{return(0); /*EOF*/}
[ \t]+					{col++;}
[0-9]+					{ col+=strlen(yytext);yylval.ival = atoi(yytext); return(INT); }
","|"("|")"|"["|"]"		{col++;return(yytext[0]); }
[T\^]					{col++;return(yytext[0]); }
"+"						{col++;yylval.ival = col;return(PLUS); }
"-"						{col++;yylval.ival = col;return(MINUS); }
"*"						{col++;yylval.ival = col;return(MULT); }
.						{col++;return(yytext[0]); }
%%
