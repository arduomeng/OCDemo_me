CFLAGS+=-I../include
LDFLAGS+=-lpthread

all:client

client:main.c
	gcc $^ $(CFLAGS) -o $@ $(LDFLAGS)
clean:
	rm -rf *.o client
