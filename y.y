%{
	#include<stdio.h>
	#include<string.h>
	#include <string>
	#include <map>
	using namespace std;
	void yyerror(const char *message);
	int yylex();
	struct YYT {
		map<string , int > chem;
		string str;
		int ival;
	};
	#define YYSTYPE YYT
%}
%token<str> Chemical
%token<ival> Number
%type<chem> expr
%type<chem> compound
%%
input   : expr '-' '>' expr 
			{
				for(map<string, int>::iterator it = $4.begin(); it != $4.end(); it++)
				{
					$1[it->first] -= it->second;
				}

				for(map<string, int>::iterator it = $1.begin(); it != $1.end(); it++)
				{
					if(it->second == 0) continue;
					printf("%s %d\n",it->first.c_str(),it->second);
				}
			}
        ;
expr    :expr '+' expr 
			{
				for(map<string, int>::iterator it = $3.begin(); it != $3.end(); it++) {
					$1[it->first] += it->second;
				}
				$$ = $1;
			}
		| Number compound  
			{
				for(map<string, int>::iterator it = $2.begin(); it != $2.end(); it++) {
					it->second *= $1;
				}
				$$ = $2;
			}
		| compound
			{
				$$ = $1;
			}
		; 
compound : Chemical { $$[$1] += 1;}
		 | compound Number 
			{
				for(map<string, int>::iterator it = $1.begin(); it != $1.end(); it++) {
					it->second *= $2;
				}
				$$ = $1;
			}
		 | compound compound 
		 	{
				for(map<string, int>::iterator it = $2.begin(); it != $2.end(); it++) {
					$1[it->first] += it->second;
				}
				$$ = $1;
			}
		 | '(' compound ')' {$$ = $2;}
		 ;
%%
void yyerror(const char *message){
	printf("Invalid format\n");
}
int main(int argc, char *argv[]){
	yyparse();
	return 0;
}