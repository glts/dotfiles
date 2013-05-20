OBJS=example.o main.o

CC=gcc
LFLAGS=-Wall
CFLAGS=-Wall -c

# link object files and create the executable

example: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o example

# compile targets

example.o: example.h example.c
	$(CC) $(CFLAGS) example.c
main.o: main.c
	$(CC) $(CFLAGS) main.c

# clean

clean:
	\rm -f *.o *.h.gch example
