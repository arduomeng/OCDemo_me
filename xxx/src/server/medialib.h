#ifndef __MEDIALIB_H_
#define __MEDIALIB_H_

#include <common.h>
#include <glob.h>
#include <unistd.h>
#include "mytbf.h"
#define RATE_SEC  65536

typedef struct mlib_listentry {
	chnid_t id;
	char *desc;
}mlib_listentry_st;

typedef struct mlib_info  {
	chnid_t id;
	char *desc;
	//readn
	int pos; 			//which mp3
	int offset;			//offset
	glob_t globchn;
	mytbf_t *tbf;
	int fd;
}mlib_info_st;

int mlib_getchnlist(mlib_listentry_st **, int *);      

int mlib_freechnlist(mlib_listentry_st *, int );

ssize_t mlib_readn(chnid_t , void *, size_t );	
#endif
