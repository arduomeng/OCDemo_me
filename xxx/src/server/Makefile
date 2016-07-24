CFLAGS+=-I../include
LDFLAGS+=-lpthread

#all:test medialib

#test:testserver.c
#	gcc $^ $(CFLAGS) -o $@
#medialib:medialib.h medialib.c
#	gcc $^  -o $@



all:server

server:main.o medialib.o thr_list.o thr_channel.o mytbf.o
	gcc $^ -o $@ $(LDFLAGS)	
clean:
	rm -r *.o
