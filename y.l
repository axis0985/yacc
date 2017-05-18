%{
	#include <string>
	#include <map>
	struct YYT {
		std::map<std::string , int > m;
		std::string str;
		int ival;
	};
	#define YYSTYPE YYT
	#include "y.tab.h"
%}
%%
\n						{return(0); /*EOF*/}
[ \t]+					{;}
[A-Z][a-z]*				{yylval.str = yytext; return(Chemical);}
[0-9]+					{yylval.ival = atoi(yytext); return(Number); }
"+"|"("|")"				{return(yytext[0]); }
"-"|">"					{return(yytext[0]);}
.						{return(yytext[0]); }
%%
