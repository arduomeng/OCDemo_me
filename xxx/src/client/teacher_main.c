#include <stdio.h>
#include <net/if.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <signal.h>
#include <getopt.h>

#include <proto.h>

#include "client_conf.h"
/*
 *-P	制定接受端口
 *-M	指定多播组
 *-p	指定播放器命令行
 *-H	显示帮助
 */
static int pd[2];
struct client_conf_st client_conf= {
	.rcvport = DEFAULT_RCVPORT,
	.mgroup = DEFAULT_MGROUP,
	.player_cmd = DEFAULT_PLAYERCMD
};

static void printfhelp()
{
	
}

static ssize_t writen(int fd, const char *buf, size_t len)
{
	ssize_t pos;
	int ret;

	pos = 0;
	while (len > 0) {
		ret = write(fd, buf + pos, len);
		if (ret < 0) {
			if (errno == EINTR)
				continue;
			break;
		}
		len -= ret;
		pos += ret;
	}
	if (pos == 0)
		return -1;
	return pos;
}

static void user1_handler(int s)
{
}

int main(int argc, char *argv[])
{
	pid_t pid;
	int c;
	int sd;
	int len;
	struct sockaddr_in laddr;
	struct sockaddr_in raddr, serveraddr;
	socklen_t raddr_len, serveraddr_len;
	struct msg_list_st *msg_list;
	struct msg_channel_st *msg_channel;
	int chosenid;
	struct ip_mreqn mreq; 
	int ret, i, child = 0;
	/*初始化*/

	signal(SIGUSR1, user1_handler);

	while (1) {
		c = getopt(argc, argv, "P:M:p:H");//带option加:
		if (c < 0) {
			break;
		}
		/*配置策略：默认值	conf文件	环境变量	命令行参数*/
		switch (c) {
			case 'M':
				client_conf.mgroup = optarg;
				break;
			case 'P':
				client_conf.rcvport = optarg;
				break;
			case 'p':
				client_conf.player_cmd = optarg;
				break;
			case 'H':
				printfhelp();
				exit(0);
				break;
			default:
				abort();
				break;
		}
	}

	sd = socket(AF_INET, SOCK_DGRAM, 0);/*IPPROTO_UDP*/
	if (sd < 0) {
		perror("socket()");
		exit(1);
	}
	
	inet_pton(AF_INET, client_conf.mgroup, &mreq.imr_multiaddr);
	inet_pton(AF_INET, "0.0.0.0", &mreq.imr_address);
	mreq.imr_ifindex = if_nametoindex("eth0");
	if (setsockopt(sd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq)) < 0) {
		perror("setsockopt()");
		exit(1);
	}
	int val = 1;
	if (setsockopt(sd, IPPROTO_IP, IP_MULTICAST_LOOP, &val, sizeof(val)) < 0) {
		perror("setsockopt()");
		exit(1);
	}
	printf("Join mgroup %s\n", client_conf.mgroup);

	val = 1024000;//1M
	if (setsockopt(sd, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)) < 0) {
		perror("setsockopt()");
		exit(1);
	}

	laddr.sin_family = AF_INET;
	laddr.sin_port = htons(atoi(client_conf.rcvport));
	inet_pton(AF_INET, "0.0.0.0", &laddr.sin_addr);//任意地址

	if ( bind(sd, (struct sockaddr *)&laddr, sizeof(laddr)) < 0 ) {
		perror("bind()");
		exit(1);
	}
	printf("bind() ok\n");

	if (pipe(pd) < 0) {
		perror("pipe()");
		exit(1);
	}

	pid = fork();
	if (pid < 0) {
		perror("fork()");
		exit(1);
	}

	if (pid == 0) {
		close(sd);
		close(pd[1]);
		dup2(pd[0], 0);
		if (pd[0] > 0) {
			close(pd[0]);
		}
		pause();
		/*运行解码器*/
		execl("/usr/local/bin/mpg123", "mpg123", "-", NULL);
//		execl("/bin/sh", "sh", "-c", client_conf.player_cmd, NULL);
		exit(0);
	}
	fprintf(stderr, "children forked\n");
	close(pd[0]);

	msg_list = malloc(MSG_LIST_MAX);
	if (msg_list == NULL) {
		perror("malloc()");
		exit(1);
	}
	serveraddr_len = sizeof(serveraddr);
	while (1) {
		/*收包*/
		len =recvfrom(sd, msg_list, MSG_LIST_MAX, 0, (struct sockaddr *)&serveraddr, &serveraddr_len);
		fprintf(stderr, "msg recived\n");
		if (len < sizeof(struct msg_list_st)) {
			fprintf(stderr, "message is too small.\n");
			continue;
		}	
		if (msg_list->id != LISTCHNID) {//单字节不存在字节序问题
			fprintf(stderr, "chnid is no match.\n");
			continue;	
		}
		break;
	}
	/* 选择频道 */
	struct msg_listentry_st *pos;
	for (pos = msg_list->entry; (char *)pos < (((char *)(msg_list)) + len); pos = (void *)((char *)pos + ntohs(pos->len))) {
		printf("Channel %d: %s\n", pos->id, pos->descr);
	}
	do {
		ret = scanf("%d", &chosenid);
	} while(ret < 1);

	free(msg_list);
	msg_channel = malloc(MSG_CHANNEL_MAX);
	if (msg_channel == NULL) {
		perror("malloc()");
		exit(1);
	}
//	i = 0;
	while (1) {
		/* 收包 */
		len = recvfrom(sd, msg_channel, MSG_CHANNEL_MAX, 0, (struct sockaddr *)&raddr, &raddr_len);
		if (raddr.sin_addr.s_addr != serveraddr.sin_addr.s_addr || raddr.sin_port != serveraddr.sin_port) {
			continue;
		}
		if (len < sizeof(struct msg_channel_st)) {
			continue;
		}
		if (msg_channel->id == chosenid) {
			/*PLAY*/
		//	ret = writen(pd[1], msg_channel->data, len - sizeof(chnid_t));
//			i += ret;
			writen(1, msg_channel->data, len - sizeof(chnid_t));
		}
		/*
		if (child == 0 && i > 1000) {
		//linux管道64k
			kill(pid, SIGUSR1);
			child = 1;
		}
		*/
	}
	free(msg_channel);

	close(sd);

	return 0;
}
