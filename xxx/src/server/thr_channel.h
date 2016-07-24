#ifndef THR_CHANNEL_H
#define THR_CHANNEL_H


#include "medialib.h"



typedef struct chn_pthread {
	pthread_t tid;
	chnid_t id;
}chn_pthread_st;


int thr_channel_create(mlib_listentry_st *);

/*
int thr_channel_destroy(mlib_listentry_st *);

int thr_channel_dryall(void);
*/
#endif
