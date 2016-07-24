#include <stdio.h>
#include <unistd.h>
#include "server.h"
#include <stdlib.h>
#include <proto.h>
#include "medialib.h"
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/ip.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <signal.h>
#include <syslog.h>
static mlib_listentry_st *list;
static int listsize;

int serversd;
struct sockaddr_in sndaddr;

static void daemon_exit(int unused)
{
	mlib_freechnlist(list, listsize);
	syslog(LOG_INFO, "server success quit!\n");
	exit(0);
}

static int mydaemon(void)
{
	pid_t pid;
	int fd;
	pid = fork();
	if (pid < 0){
		syslog(LOG_ERR, "fork() error\n");
		return -1;
	}
	else if(pid > 0){
		exit(0);
	}
	fd = open("/dev/null", O_RDWR);
	dup2(fd, 0);
	dup2(fd, 1);
	dup2(fd, 2);
	
	setsid();
	chdir("/");
	umask(0);
	return 0;
}

static void sock_init(void)
{
	struct ip_mreqn reqn;
	serversd = socket(AF_INET, SOCK_DGRAM, 0);
	if (serversd < 0){
		exit(1);
	}
	
	inet_pton(AF_INET, DEFAULT_MGROUP, &reqn.imr_multiaddr);
	inet_pton(AF_INET, "0.0.0.0", &reqn.imr_address);
	reqn.imr_ifindex = if_nametoindex("eth0");

	if (setsockopt(serversd, IPPROTO_IP, IP_MULTICAST_IF, (void *)&reqn, sizeof(reqn)) < 0){
		perror("setsockopt()");
		exit(1);
	}
	
	sndaddr.sin_family = AF_INET;
	sndaddr.sin_port = htons(atoi(DEFAULT_RCPORT));
	inet_pton(AF_INET, DEFAULT_MGROUP, &sndaddr.sin_addr);
	
}

int main(void)
{
//getopt

	int err, i;

	signal(SIGUSR1, daemon_exit);
	
	openlog("server", LOG_PID, LOG_DAEMON);
	
	if (mydaemon()){
		syslog(LOG_ERR, "mydaemon error!\n");
		//fprintf(stderr, "mydaemon error!\n");
	}else{
		syslog(LOG_INFO, "mydaemon success\n");
	}
	
	sock_init();	

	err = mlib_getchnlist(&list, &listsize);
	if (err){
		syslog(LOG_ERR, "mlib_getchnlist() error");
		exit(1);
	}

	thr_list_create(list, listsize);
#if 1
	for ( i = 0; i < listsize; i++){
		thr_channel_create(list + i);
	}
#endif
	while (1) pause();
	closelog();
	exit(0);
}
