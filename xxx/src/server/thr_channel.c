#include <stdio.h>
#include <stdlib.h>
#include <proto.h>
#include "server.h"
#include "thr_channel.h"
#include <pthread.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
chn_pthread_st thr_channel[CHANNR];

static int thr_pos = 0;



static void *thr_channel_job(void *ptr)
{
	int ret;
	int len;
	int datasize;
	mlib_listentry_st *ent_chn = NULL;
	msg_chn_st *chn_buf = NULL;
	
	chn_buf = malloc(MSG_CHANNEL_MAX);
	if (chn_buf == NULL){
		fprintf(stderr, "thr_job malloc error\n");
		pthread_exit(NULL);
	}

	datasize = MSG_CHANNEL_MAX - sizeof(chnid_t);

	ent_chn = ptr;

		
	chn_buf->id = ent_chn->id;

	while(1){
		
		len = mlib_readn(ent_chn->id, chn_buf->data, datasize);	
	
		ret = sendto(serversd, chn_buf, len + sizeof(chnid_t), 0, (void *)&sndaddr, sizeof(sndaddr));
		if (ret < 0){
			fprintf(stderr, "channel %d sendto error", ent_chn->id);
			pthread_exit(NULL);
		}else{
			fprintf(stdout, "channel %d successed %d data\n", ent_chn->id, ret);
		}
		sched_yield();
	}
}

int thr_channel_create(mlib_listentry_st *ptr)
{
	int err;
	err = pthread_create(&thr_channel[thr_pos].tid, NULL, thr_channel_job, ptr);
	if (err){
		fprintf(stderr, "channel pthread_create() error %s\n", strerror(errno));
		return -1;
	}
	thr_channel[thr_pos].id = ptr->id;
	thr_pos++;
}

/*
int thr_channel_destroy(mlib_listentry_st *);

int thr_channel_dryall(void);
*/
