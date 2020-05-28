	/*deklaracje */
%{
#include <stdio.h>
#include <string.h>

char *date;
int slowo=0;
int zla_wpisana=0;
char *uciety_wzorzec[3];
char *separator="-./";

char *months[12] = {
	"styczen",
	"luty",
	"marzec",
	"kwiecien",
	"maj",
	"czerwiec",
	"lipiec",
	"sierpien",
	"wrzesien",
	"pazdziernik",
	"listopad",
	"grudzien" 
	};

%}
	/*definicje wyrazen regularnych*/
dzien ([0-2][0-9])|([3][0-1])|([1-9])
miesiac ([1-9])|([0][1-9])|([1][0-2])|([3][0-1])|"styczen"|"luty"|"marzec"|"kwiecien"|"maj"|"czerwiec"|"lipiec"|"sierpien"|"wrzesien"|"pazdziernik"|"listopad"|"grudzien"
separator [./-]
rok([1][0-9][0-9][0-9]|[2][0][0-1][0-9]|[2][0][2][0]|[0-9][0-9]|[0-9][0-9][0-9]|[0-9])
data ^{dzien}{separator}{miesiac}{separator}{rok}$
zla_data ^(.)

%%
	/*reguly rozpoznawania*/
{data} {
	
	date = yytext;  
    char *p = strtok (date, separator);
    while (p != NULL){
        uciety_wzorzec[slowo++] = p;
        p = strtok (NULL, separator);
    }
	
	if(strlen(uciety_wzorzec[1]) < 3)
		printf("Poprawny format: %.2d-%s-%.2d\n",atoi(uciety_wzorzec[0]),months[atoi(uciety_wzorzec[1])-1],atoi(uciety_wzorzec[2])%100);
	else
		printf("Poprawny format: %.2d-%s-%.2d\n",atoi(uciety_wzorzec[0]),uciety_wzorzec[1],atoi(uciety_wzorzec[2])%100);
	
	slowo=0;
		
}

{zla_data} {	
	if(!zla_wpisana)
	{
		zla_wpisana=1;
		printf("Podaj prawidlowa date\n");
	}
	zla_wpisana=0;
}
			
.|\n  /*niewypisywanie nieprawidlowych znakow*/
%%

	/* procedury*/

int yywrap(){
	
	return 1;
}

int main()
{
	printf("Wpisz daty, a podam prawidlowe formatowanie \n");
	yylex();
		
}
