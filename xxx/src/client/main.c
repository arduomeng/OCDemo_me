#include <stdio.h>
#include <pthread.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/ip.h>
#include <net/if.h>
#include <stdlib.h>
#include <unistd.h>
//#include "../include/proto.h"
#include <proto.h>
#include "client_conf.h"

/*getopt();
 *-M  set play group
 *-P  set port
 *-p  set player
 *-H  display help
 */


client_conf_st client_cf = {
	.rcvport = DEFAULT_RCPORT,
	.mgroup = DEFAULT_MGROUP,
	.player = DEFAULT_PLAYER,	
};


static chnid_t select_id = 222;

static void print_help(void)
{
	
}


static int writen(int fd, const char *buf, int len)
{
	int ret, pos;
		
	pos = 0;
	while (len > 0){
		ret = write(fd, buf + pos, len);
		if (ret < 0){
			return -1;
		}
		len -= ret;
		pos += ret;
	}
	if (pos == 0){
		return -1;
	}	
	return pos;
}

static void usr1_handler(int unused)
{
	
}

static void *choose_chn(void *unused)
{
	int ret;	
	while(1){
		printf("please input you select:");
		ret = scanf("%d", &select_id);
		if (ret != 1){	
			pthread_exit(NULL);
		}
		
		if (ret < 1 && ret > 200)
			printf("input error!\n");
		
	}
		
	
}

static chnid_t select_id;
int main(int argc, char *argv[])
{
	/* initialize: join multycast: socket(), bind(), setsockopt()[man 7 ip] recvfrom(), , pipe(), fork() mplayer */
	/* configuration:  priority high to low:   1.default 2.configuration file 3.environment variable 4.command line */	
	pid_t pid;
	int fd[2];
	int fdt;
	int count = 0;
	int flag = 1;
	int socket_fd;
	int sock_err ;
	struct sockaddr_in addr;
	struct sockaddr_in list_addr, chn_addr;
	socklen_t sock_len;
	struct ip_mreqn mreqn;
	pthread_t tid;
	//char msg_buffer[MSG_CHANNEL_MAX];
	//char list_buffer[MSG_LIST_MAX];

	//signal(SIGUSR1, usr1_handler);

	msg_list_st *list_st = NULL;
	msg_chn_st  *chn_st = NULL;
	//malloc
	list_st = malloc(MSG_LIST_MAX);
	chn_st  = malloc(MSG_CHANNEL_MAX);	
	if ((list_st == NULL)||(chn_st == NULL)){
		fprintf(stderr, "malloc!\n");
		exit(1);
	}
	char ch;

	int len, r_number, w_number;

	int pos;
	int ret;
	while(1){
		if ((ch = getopt(argc, argv, "M:P:p:H")) < 0 )
			break;

		switch(ch){
			case 'M':
				client_cf.mgroup = optarg;
				break;
			case 'P':
				client_cf.rcvport = optarg;
				break;
			case 'p':
				client_cf.player = optarg;
				break;
			case 'H':
				print_help();
				break;
			default:
				break;
		}
	}

	socket_fd = socket(AF_INET, SOCK_DGRAM, 0);
	if (socket_fd < 0){
		perror("socket()");
		exit(1);
	}

	//inet_pton(AF_INET, client_cf.mgroup, &mreqn.imr_multiaddr);
	inet_pton(AF_INET, DEFAULT_MGROUP, &mreqn.imr_multiaddr);
	inet_pton(AF_INET, "0.0.0.0", &mreqn.imr_address);
	mreqn.imr_ifindex = if_nametoindex("eth0");

	sock_err = setsockopt(socket_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreqn, sizeof(mreqn));
	if (sock_err < 0){
		perror("setsockopt()");
		exit(1);
	}

	addr.sin_family = AF_INET;
	//addr.sin_port = htons(atoi(client_cf.rcvport));
	
	addr.sin_port = htons(atoi(DEFAULT_RCPORT));
	inet_pton(AF_INET, "0.0.0.0", &addr.sin_addr);

	if (bind(socket_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("bind()");
		exit(1);
	}

	printf("bind success!\n");

	
	if (sock_err < 0){
		perror("setsockopt()");
		exit(1);
	}

	if (pipe(fd) < 0){
		perror("pipe()");
		exit(1);
	}
	
	
	pid = fork();
	
	if (pid < 0){
		perror("fork()");
		exit(1);
	}
	else if (pid > 0){
		close(fd[0]);
		sock_len = sizeof(list_addr);		
		while (1){
			/* recv  package */
	//		memset((void *)list_st, '\0', MSG_LIST_MAX);
			len = recvfrom(socket_fd, list_st, MSG_LIST_MAX, 0, (void *)&list_addr, &sock_len);
			if (len < sizeof(msg_list_st)){
				fprintf(stderr, "recv to small!\n");
				continue;
			}
			if ( list_st->id != CHNLISTID){	
				fprintf(stderr, "id is not match!\n");
				continue;
			}
			break;
		}
		/* list */
		msg_listentry_st *listentry;	
	
	        for (listentry = list_st->list; (char *)listentry < (((char *)(list_st)) + len); listentry =(void *)((char *)listentry + ntohs(listentry->len)) ){
			printf("channel : %d  desc: %s\n", listentry->id, listentry->desc);
		}

		free(list_st);
		//
		//
		/* select  channel */
		
		pthread_create(&tid, NULL, choose_chn, NULL);	
		
		memset((void *)chn_st, '\0', MSG_CHANNEL_MAX);	

		sock_len = sizeof(chn_addr);

		//fdt = open("test", O_RDWR | O_CREAT | O_TRUNC, 0666);
		while (1){
			/* recv  package*/
			r_number = recvfrom(socket_fd, (void *)chn_st, MSG_CHANNEL_MAX, 0, (struct sockaddr *)&chn_addr, &sock_len);
			if (r_number < sizeof(msg_chn_st)){
				fprintf(stderr, "recvfrom to small!\n");
				continue;
			}
			if (chn_addr.sin_addr.s_addr != list_addr.sin_addr.s_addr || chn_addr.sin_port != list_addr.sin_port){
				printf("port = %d, %d\n", ntohs(chn_addr.sin_port),ntohs(chn_addr.sin_port));
				printf("chnaddr not same to listaddr\n");
				continue;
			}
			if (chn_st->id == select_id){
				/* write pipe */
				ret = writen(fd[1], chn_st->data, r_number - sizeof(chnid_t));
				if (ret < 0){
					fprintf(stderr, "write pipe error\n");
					exit(1);
				}
				printf("writen success channel %d : %d data\n", chn_st->id, ret);
	/*
				count += ret;
				if (count > 10000 && flag){
					kill(pid, SIGUSR1);
					flag = 0;
				}
	*/
			}
		}	
	}
	else{
		close(fd[1]);
		dup2(fd[0], 0);
	/*	if (fd[0] > 0){
			close(fd[0]);
		}*/
		/* close stdin stdout stderr */
	//	pause();
	//	execl("bin/sh", "sh", "-c", client_cf.player, NULL);  //??
	//	printf("child fork()!\n");		
		system("mplayer -");
	}

		

	while (1);
}
