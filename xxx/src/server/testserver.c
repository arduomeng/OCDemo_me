#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/socket.h>
#include <netinet/in.h>

#include <proto.h>

int main(void)
{
	int sd;
	 msg_list_st *listbuf;
	 msg_listentry_st *tmp;
	int id[3] = {12, 34, 56};
	char * descr[3] = {"Music", "Opera", "Talks"};
	struct ip_mreqn mreq;
	struct sockaddr_in raddr;
	int i;
	int size;
	sd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sd < 0) {
		perror("socket()");
		exit(1);
	}
	inet_pton(AF_INET, "224.2.2.2", &mreq.imr_multiaddr);
	inet_pton(AF_INET, "0.0.0.0", &mreq.imr_address);
	mreq.imr_ifindex = if_nametoindex("eth0");
	if (setsockopt(sd, IPPROTO_IP, IP_MULTICAST_IF, &mreq, sizeof(mreq)) < 0) {
		perror("setsockopt()");
		exit(1);
	}

	listbuf = malloc(28);
	if (listbuf == NULL) {
		perror("malloc()");
		exit(1);
	}
	listbuf->id = CHNLISTID;
	tmp = listbuf->list;
	for (i = 0 ; i < 3; ++i) {
		tmp->id = id[i];
		tmp->len = htons(9);
		strcpy((char *)tmp->desc, descr[i]);
		tmp = (void *)(((char *)tmp) + 9);
	}

	raddr.sin_family = AF_INET;
	raddr.sin_port = htons(1994);
	inet_pton(AF_INET, "224.2.2.2", &raddr.sin_addr);


	while (1) {
	/*
		tmp = listbuf->list;
		for (i = 0; i < 3; i++){
			size = 9;
			printf("%d, %s\n", tmp->id, (tmp->desc));
			fflush(stdout);
			tmp = (void *)(((char *)tmp) + 9);
		}
	*/
		sendto(sd, listbuf, 28, 0, (const struct sockaddr*)&raddr, sizeof(raddr));
		sleep(1);
	}

	exit(0);
}
