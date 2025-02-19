CC = gcc

DEFINES = 
DEBUG = -g3 -O0
CFLAGS = -Wall -Wshadow -Wunreachable-code -Wredundant-decls \
		 -Wmissing-declarations -Wold-style-definition -Wmissing-prototypes \
		 -Wdeclaration-after-statement -Wextra -Werror -Wpedantic \
		 $(DEBUG) $(DEFINES)

EXECUS = sieve-8 view_long

all: $(EXECUS)

sieve_8: sieve-8.o
	gcc $(CFLAGS) -o sieve-8 sieve-8.o

view_long: view_long.o
	gcc $(CFLAGS) -o view_long view_long.o

sieve_8.o: sieve-8.c
	gcc $(CFLAGS) -c sieve-8.c

view_long.o: view_long.c
	gcc $(CFLAGS) -c view_long.c


tar: 
	tar -czf simones_Lab03.tar.gz *.[ch] [mM]akefile

clean:
	rm -f $(EXECUS) *~ *.o \
