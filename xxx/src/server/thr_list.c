#include "thr_list.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <proto.h>
#include "server.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <string.h>
static mlib_listentry_st *listent;
static int listsize;

void *thr_list_snd(void *unused)
{
	msg_list_st *sndlistp = NULL;
	msg_listentry_st *everychn = NULL;

	int totalsize;
	int size,i;
	int ret;
	totalsize = sizeof(chnid_t);
	for (i = 0; i < listsize; i++){
		totalsize += sizeof(msg_listentry_st) + strlen(listent[i].desc);
	}
	
	sndlistp = malloc(totalsize);
	if (sndlistp == NULL){
		fprintf(stderr, "malloc() error\n");
		pthread_exit(NULL);
		
	}

	sndlistp->id = CHNLISTID;
	everychn = sndlistp->list;

	for (i = 0;i < listsize; i++){
		size = sizeof(msg_listentry_st) + strlen(listent[i].desc);
		everychn->id = listent[i].id;
		everychn->len = htons(size);
		strcpy(everychn->desc, listent[i].desc);
		
		everychn = (void *)((char *)(everychn) + size);
	}

	while(1){
		ret = sendto(serversd, sndlistp, totalsize, 0, (struct sockaddr *)&sndaddr, sizeof(sndaddr));
		if (ret < 0){
			fprintf(stderr, "list sendto() failure\n");
		}else{
			fprintf(stdout, "list sendto() %d data\n", ret);
		}
		sleep(1);
	}
	free(sndlistp);
	pthread_exit(NULL);
}

int thr_list_create(mlib_listentry_st *listchn, int chnnum)
{
	pthread_t pd;
	int err;
	
	listent = listchn;
	listsize = chnnum;	
	
	err = pthread_create(&pd, NULL, thr_list_snd, NULL);
	if (err){
		fprintf(stderr, "pthread_create():%s\n", strerror(errno));
	}
	return 0;
}


