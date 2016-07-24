#ifndef CLIENT_CONF_H
#define CLIENT_CONF_H


typedef struct client_conf {
	char *rcvport;
	char *mgroup;
	char *player;
}client_conf_st;


extern client_conf_st client_cf;

#define DEFAULT_PLAYER "/usr/local/bin/mplayer -"          //sh -c "ls -l"


#endif
