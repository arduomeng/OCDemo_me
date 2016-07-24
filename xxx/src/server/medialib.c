#include "medialib.h"
#include <proto.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <glob.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <unistd.h>
#define MEDIA_DIR "/var/media"
#define PATHSIZE 1024
#define BUFSIZE 1024
//
//

mlib_info_st channel[MAXCHNID + 1];

glob_t globdir;


static int open_nextfile(chnid_t id)
{
	int i;
	for (i = 0; i < channel[id].globchn.gl_pathc; i++){
		

	
		channel[id].pos++;
		
		if (channel[id].pos == channel[id].globchn.gl_pathc){
			channel[id].pos = 0;
		}
	
		close(channel[id].fd);

		channel[id].fd = open(channel[id].globchn.gl_pathv[channel[id].pos], O_RDONLY);
		if (channel[id].fd < 0){
			fprintf(stderr, "open %d : %s file error\n", id, channel[id].globchn.gl_pathv[channel[id].pos]);
		}else{
			fprintf(stdout, "open() %d : %s successful \n", id, channel[id].globchn.gl_pathv[channel[id].pos]);
			channel[id].offset = 0;
			return 0;
		}
	}
	return -1;

}


ssize_t c(chnid_t id, void *buf, size_t size)
{
	int tbfsize;
	int len;
	
	tbfsize = mytbf_fetchtoken(channel[id].tbf, size);
	
	while (1){

		len = pread(channel[id].fd, buf, tbfsize, channel[id].offset);
		if (len < 0){
			fprintf(stderr, "pread %d : %s error\n", id, channel[id].globchn.gl_pathv[channel[id].pos]);

			if (open_nextfile(id) < 0 ){
				fprintf(stderr, "channel %d have on right file\n", id);
				return -1;
			}
		}else if(len == 0){
			fprintf(stdout, "%d : %s is already done\n", id, channel[id].globchn.gl_pathv[channel[id].pos]);

			if (open_nextfile(id) < 0 ){
				fprintf(stderr, "channel %d have on right file\n", id);
				return -1;
				
			}
		}else{
			printf("pread %d : %s : %d data\n", id, channel[id].globchn.gl_pathv[channel[id].pos], len);
			channel[id].offset += len;
			break;
		}
	}
		
	if (tbfsize > len){
		mytbf_returntoken(channel[id].tbf, tbfsize-len);
	}
	
	
}


static mlib_info_st *path2entry(const char *pathdir)
{
	// /var/media/*
	static chnid_t chnid = MINCHNID;
	char path[PATHSIZE];
	char buf_desc[BUFSIZE];
	FILE *fp;
	
	mlib_info_st *cur_chn = NULL;
	
	snprintf(path, PATHSIZE, "%s/desc.txt", pathdir);
	//  path = /var/media/chxxx/desc.txt
	/*
	strncpy(path, pathdir, PATHSIZE);
	strncat(path, "/desc.txt", PATHSIZE);
	*/                                             //the same to snprintf
	
	fp = fopen(path, "r");
	if (fp == NULL){
		fprintf(stderr, "fopen %s error\n", path);
		return NULL;
	}
	
	if (fgets(buf_desc, BUFSIZE, fp) == NULL){
		fprintf(stderr, "fgets() %s error\n", path);
		return NULL;
	}

	cur_chn = malloc(sizeof(mlib_info_st));
	if (cur_chn == NULL){
		fprintf(stderr, "cur_chn malloc () error\n");
		return NULL;
	}
	
	snprintf(path, PATHSIZE, "%s/*.mp3", pathdir);
	if (glob(path, 0, NULL, &cur_chn->globchn)){          
		fprintf(stderr, "there is not have mp3\n");
		return NULL;
	}                      
	
	cur_chn->desc = strdup(buf_desc);
	cur_chn->pos = 0;
	cur_chn->offset = 0;
	cur_chn->fd = open(cur_chn->globchn.gl_pathv[cur_chn->pos], O_RDONLY);
	if (cur_chn->fd < 0){
		fprintf(stderr, "open():%s error\n", cur_chn->globchn.gl_pathv[cur_chn->pos]);
		return NULL;
	}
	
	fprintf(stdout, "open():%s successful \n", cur_chn->globchn.gl_pathv[cur_chn->pos]);

	cur_chn->tbf = mytbf_init(RATE_SEC/2, RATE_SEC * 10 / 8);         //adjust 10      64K  burst=64K * 10

	cur_chn->id = chnid++;

	return cur_chn;

	
}

int mlib_getchnlist(mlib_listentry_st **reslist, int *resnum)
{
	
	mlib_listentry_st *ptr = NULL;
	mlib_info_st *retchn = NULL;
	int num;
	int i;
	char path[PATHSIZE];

	for (i = 0; i < MAXCHNID + 1; i++){
		channel[i].id = -1;
	}

	snprintf(path, PATHSIZE, "%s/*", MEDIA_DIR);           //	
	//  path = /var/media/*
	
	if (glob(path, 0, NULL, &globdir) ){                 // /var/media/*  --->>  globdir
		perror("glob()");
		return -1;
	}
	 
	ptr = malloc(sizeof(mlib_listentry_st) * globdir.gl_pathc);
	if (ptr == NULL){
		perror("malloc()");
		return -1;
	}     
	num = 0;
	
	for (i = 0; i < globdir.gl_pathc; i++){
		retchn = path2entry(globdir.gl_pathv[i]);
		if (retchn != NULL){
			memcpy(channel+(retchn->id), retchn, sizeof(mlib_info_st));

			ptr[num].id = retchn->id;
			ptr[num].desc = strdup(retchn->desc);                //   ---> malloc(ptr[num].desc) , strcpy(ptr[num].desc, retchn->desc)
			num ++;
		}
	}                    //
	
	*reslist = realloc(ptr, num * sizeof(mlib_listentry_st));
	*resnum = num;
	return 0;
} 

int mlib_freechnlist(mlib_listentry_st *list,int size)
{
	int i;
	for (i = 0; i < size; i++){
		free(list[i].desc);
	}
	free(list);
}



























