#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include "mytbf.h"

#define CPS             1
#define Buffer_SIze     200
#define BURST           20             


static int my_copy(char *src)
{
	mytbf_t *me = NULL;

	int pos = 0;
	char buffer[Buffer_SIze];
	int r_number = 0;
	int w_number = 0;

	int size = 0;

	memset(buffer, '\0', sizeof(buffer));
	FILE *sf = NULL;
	
	sf = fopen( src, "r" );
	
	me = mytbf_init(CPS, BURST);

	
	while(1)
	{
		size = mytbf_fetchtoken(me, Buffer_SIze);
	
		r_number = fread(buffer, sizeof(char), size, sf);

		if (r_number < size){
			
			mytbf_returntoken(me, size - r_number);
		}		

		pos = 0;
		while(r_number > 0)
		{
			w_number = fwrite(buffer + pos, sizeof(char), r_number, stdout);
			if (w_number < 0){
				perror("write()");
				exit(1);
			}
			pos += w_number;
			r_number -= w_number;
			fflush(stdout);
		}
		memset(buffer, '\0', sizeof(buffer));

	}

	fclose(sf);
	
	mytbf_destroy(me);
	return 0;
}

int main(int argc, char *argv[])
{
	my_copy(*(argv+1));
		
	
	return 0;
}
