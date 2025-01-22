CC = gcc

CFLAGS = -g3 -O0 -Wall -Werror

LDFLAGS =

TARGET = 1-3
SRC = 1-3.c
OBJ = 1-3.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)


clean : 
	rm -f $(TARGET) $(OBJ) *~ *.swp *.gz *.out

tar : 
	tar -czf simones_Activity01.tar.gz *.c Makefile *.o

