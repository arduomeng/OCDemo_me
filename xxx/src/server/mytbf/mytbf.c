#include "mytbf.h"
#include <signal.h>
#include <stdlib.h>
struct mytbf_st {
	int cps;
	int burst;
	int token;
	int pos;
};

typedef void (*alrm_t)(int);

static struct mytbf_st *job[MYTBF_MAX];
static alrm_t alrm_handler_save; 
static int inited = 1;

static void alrm_handler(int unused)
{
	int i;

	alarm(1);
	for (i = 0; i < MYTBF_MAX; i++) {
		if (job[i] != NULL) {
			job[i]->token += job[i]->cps;
			if (job[i]->token >= job[i]->burst) {
				job[i]->token = job[i]->burst;	
			}
		}
	}
}

static void module_unload(void)
{
	alarm(0);	
	signal(SIGALRM, alrm_handler_save);
}

static void module_load(void)
{
	alrm_handler_save = signal(SIGALRM, alrm_handler);
	alarm(1);

	atexit(module_unload);
}

static int get_free_pos(void)
{
	int i;

	for (i = 0; i < MYTBF_MAX; i++) {
		if (job[i] == NULL)
			return i;
	}
	return -1;
}

mytbf_t *mytbf_init(int cps, int burst)
{
	struct mytbf_st *me;

	if (inited) {
		module_load();
		inited = 0;
	}
	
	me = malloc(sizeof(*me));
	if (me == NULL) {
		return NULL;
	}
	me->cps = cps;
	me->burst = burst;
	me->token = 0;

	me->pos = get_free_pos();	
	if (me->pos < 0) {
		free(me);
		return NULL;
	}
	job[me->pos] = me;
	
	return me;
}

static int min(int a, int b)
{
	return a > b ? b : a;
}

int mytbf_fetchtoken(mytbf_t *tbf, int size)
{
	struct mytbf_st *me = tbf;
	int n;

	if (size < 0) {
		return -1;
	}
	while (me->token <= 0)
		pause();

	n = min(me->token, size);
	me->token -= n;

	return n;
}

int mytbf_returntoken(mytbf_t *tbf, int size)
{
	struct mytbf_st *me = tbf;
	if (size < 0) {
		return -1;
	}
	me->token += size;
	if (me->token >= me->burst) {
		me->token = me->burst;
	}

	return 0;
}

void mytbf_destroy(mytbf_t *tbf)
{
	struct mytbf_st *me = tbf;

	job[me->pos] = NULL;
	free(me);
}

