	/*deklaracje */
%{
#include <stdio.h>
#include <string.h>

char *date;
char *month;
int i=0;
int day,year,mnth;
int zla_wpisana=1;

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
	char *array[3];
	char *separator="-./";
    char *p = strtok (date, separator);
    while (p != NULL){
        array[i++] = p;
        p = strtok (NULL, separator);
    }

    day=atoi(array[0]);
    year=atoi(array[2]);
    year=year%100;
	
	if(strlen(array[1]) <= 2){
		mnth=atoi(array[1]);
		printf("Poprawny format: %.2d-%s-%.2d\n",day,months[mnth-1],year);
        }	
	else{
		printf("Poprawny format: %.2d-%s-%.2d\n",day,array[1],year);
	} 
	
	i=0;
		
}

{zla_data} {	
	if(zla_wpisana)
	{
		zla_wpisana=0;
		printf("Podaj prawidlowa date\n");
	}
	zla_wpisana=1;
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
