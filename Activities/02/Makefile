CC = gcc

CFLAGS = -g3 -O0 -Wall

LDFLAGS =

TARGET = 1-13 1-4 1-8
SRC = 1-13.c 1-4.c 1-8.c
OBJ = 1-13.o 1-4.o 1-8.o

all: 1-13 1-4 1-8

1-4: 1-4.o
	$(CC) $(CFLAGS) -o $@ 1-4.o -lm

1-8: 1-8.o
	$(CC) $(CFLAGS) -o $@ 1-8.o -lm

1-13: 1-13.o
	$(CC) $(CFLAGS) -o $@ 1-13.o -lm


clean : 
	rm -f $(TARGET) $(OBJ) *~ *.swp *.gz *.out

tar : 
	tar -czf simones_Activity02.tar.gz *.c Makefile 
