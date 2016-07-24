#include <stdio.h>
#include <pthread.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <proto.h>
#include "medialib.h"

static mlib_listentry_st *list;
static int listsize;

static void daemon_exit(int unused)
{
	mlib_freechnlist(list);
	exit(0);
}
void *send_list(void *unused)
{
	int send_fd;
	sockaddr_in addr;
	send_fd = socket(AF_INET, SOCK_DGRAM, 0);
	addr.sin_family = AF_INET;
        addr.sin_port = htons(atoi(client_cf.rcvport));
        inet_pton(AF_INET, client_cf.group, &addr.sin_addr.s_addr);

	sendto(send_fd, );
}



int thr_list_create(mlib_listentry_st *list, int listsize)
{
	pthread_t send_pd;
	
	pthread_create(&send_pd, NULL, send_list, NULL);
}

int main(void)
{

	int err;
	err = mlib_getchnlist(&list, &listsize);
	if (err){
		fprintf(stderr, "mlib_getchnlist() error");
		exit(1);
	}

	thr_list_create(list, listsize);

	for ( i = 0; i < listsize; i++){
		thr_channel_create(list + i);
	}

	while (1) pause();
	exit(0);
}
