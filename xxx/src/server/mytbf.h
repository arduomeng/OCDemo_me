#ifndef MYTBF_H
#define MYTBF_H

typedef void mytbf_t;

mytbf_t *mytbf_init(int cps, int burst);//cps 每秒钟字符数， 突发量

int mytbf_destroy(mytbf_t *);

int mytbf_fetchtoken(mytbf_t *, int n);

int mytbf_returntoken(mytbf_t *, int n);

#endif
