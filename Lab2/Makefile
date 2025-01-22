CC = gcc

DEFINES = 
DEBUG = -g3 -O0
CFLAGS = -Wall -Wshadow -Wunreachable-code -Wredundant-decls \
         -Wmissing-declarations -Wold-style-definition -Wmissing-prototypes \
         -Wdeclaration-after-statement -Wextra -Werror -Wpedantic \
         $(DEBUG) $(DEFINES)

TARGET = 1000-digit

SRC = 1000-digit.c
OBJ = 1000-digit.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)

clean:
	rm -f $(TARGET) $(OBJ) *~ *.swp


