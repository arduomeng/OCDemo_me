
#include <stdint.h>
#include <common.h>
#ifndef _PROTO_H
#define _PROTO_H


#define DEFAULT_RCPORT "1994"      //default 
#define DEFAULT_MGROUP "224.2.2.2" //default



#define CHANNR	        200

#define MINCHNID        1
#define MAXCHNID        (CHANNR + MINCHNID - 1)

#define MSG_CHANNEL_MAX (65536 - 20 - 8)
#define MSG_LIST_MAX    (65536 - 20 -8)

#define CHNLISTID       0

typedef struct msg_channel {
	chnid_t id;   /* must between MINCHNID and MAXCHNID  */
	uint8_t data[1];
}__attribute__((packed)) msg_chn_st;

typedef struct msg_listentry {
	chnid_t id;
	uint16_t len;
	uint8_t  desc[1];	
}__attribute__((packed)) msg_listentry_st;



typedef struct msg_list {
	chnid_t id;   /* must be CHNLISTID */
	msg_listentry_st list[1];
}__attribute__((packed)) msg_list_st;

#endif
