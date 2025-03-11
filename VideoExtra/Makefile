CC = gcc

DEBUG = -g3 -O0
ARCH = -m32 
PIE = -no-pie -fno-pie
STACK = -z noexecstack

CFLAGS = $(ARCH) $(PIE) $(DEBUG) -Wall
LDFLAGS = $(ARCH) $(PIE) $(STACK)

PROG0 = sum-array-rows
PROG1 = sum-array-cols
PROGS = $(PROG0) $(PROG1)

all: $(PROGS)

$(PROG0): $(PROG0).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG0).o: $(PROG0).c
	$(CC) $(CFLAGS) -c -o $@ $<

$(PROG1): $(PROG1).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG1).o: $(PROG1).c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean ci git get tar

clean: 
	rm -f $(PROGS) *.s *.o *.lst *~ \#*

TAR_FILE = ${LOGNAME}_Lab5.tar.gz
tar:
	rm -f $(TAR_FILE)
	tar cvaf $(TAR_FILE) *.c [Mm]akefile
	tar tvaf $(TAR_FILE)
