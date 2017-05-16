%{
	#include<stdio.h>
	#include<string.h>
	void yyerror(const char *message);
	int error = -1;
	extern int col;
%}
%union {
    int matrix[2];
    int ival;
}
%token<ival> INT
%token<ival> PLUS
%token<ival> MINUS
%token<ival> MULT
%type<matrix> matrix
%type<matrix> expr
%left PLUS MINUS
%left MULT

%%
input   : expr 
                { 
					if(error == -1){
							printf("Accepted"); 
					}else {
						// for( int i= 1 ; i < error ; i++)
						// 	printf(" ");	
						printf("Semantic error on col %d\n",error);
					}
                }
        ;
expr    :  expr MULT expr  
                        { 
                                if($1[1] == $3[0]) 
                                { 
                                        $$[0] = $1[0]; $$[1] = $3[1]; 
                                }else {
									if(error == -1)
                                        error = $2;
                                }
                        }
        |  expr PLUS expr  
                        { 
                                if($1[0] == $3[0] && $1[1] == $3[1]) {
                                        $$[0] = $3[0]; $$[1] = $3[1]; 
                                }else {
									if(error == -1)
                                        error = $2;
                                }
                        }
        |  expr MINUS expr  
                        { 
                                if($1[0] == $3[0] && $1[1] == $3[1]) 
                                {
                                        $$[0] = $3[0]; $$[1] = $3[1]; 
                                }else{
									if(error == -1)
                                        error = $2;
                                }
                        }
        |  '(' expr ')' { $$[0] = $2[0]; $$[1] = $2[1]; }
        |  expr '^' 'T' { int tmp = $$[1]; $$[1] = $$[0]; $$[0] = tmp; }
        |  matrix  {$$[0] = $1[0]; $$[1] = $1[1];}
        ;
matrix  :  '[' INT ',' INT ']' { $$[0] = $2; $$[1] = $4; }
        ;
%%
void yyerror(const char *message){
	fprintf(stderr, "%s\n", message);
}
int main(int argc, char *argv[]){
	yyparse();
	return 0;
}