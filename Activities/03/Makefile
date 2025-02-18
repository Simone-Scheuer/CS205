#
# R Jesse Chaney
# 

CC = gcc
AS = nasm

DEFINES =
DEBUG = -g3 -O0
ARCH = -m32
PIE = -no-pie -fno-pie
STACK = -z noexecstack
CFLAGS = $(ARCH) $(PIE) $(DEBUG) -Wall -Werror $(DEFINES)
LDFLAGS = $(ARCH) $(PIE) $(STACK)
ASFLAGS = -g -f elf32 -F dwarf

PROG1  = c_segments
PROG2  = nasm_segments
PROGS  = $(PROG1) $(PROG2) $(PROG3) $(PROG4) $(PROG5)

# there are some special make automatic variables
#  $@ is the target filename
#  $* is the basename of the target filename
#  $^ is the names of all the prerequisites 
#  $< is the name of the first dependency
#  $? is the names of all prerequisites that are newer than the target
#  there are others, but these are the ones we will be using

all: $(PROGS)

$(PROG1): $(PROG1).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG1).o: $(PROG1).c
	$(CC) -c $(CFLAGS) $<

$(PROG2): $(PROG2).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG2).o: $(PROG2).asm
	$(AS) $(ASFLAGS) -l $(PROG2).lst $<

.PHONY: clean cls ci git get zip tar

# clean up the compiled files and editor chaff
clean cls:
	rm -f $(PROGS) *.s *.o *.lst *~ \#*

# check into revision control
ci:
	if [ ! -d RCS ] ; then mkdir RCS; fi
	ci -t-none -m"lazy-checkin" -l *.asm *.[ch] ?akefile

# https://www.youtube.com/watch?v=4m48GqaOz90
git gotta get gat:
	if [ ! -d .git ] ; then git init; fi
	git add *.[ch] *.asm ?akefile
	git commit -m "my lazy git commit comment"

TAR_FILE = ${LOGNAME}_$(PROG1)_$(ASSIGNMENT).tar.gz
tar:
	rm -f $(TAR_FILE)
	tar cvzf $(TAR_FILE) *.[ch] *.asm [Mm]akefile
	tar tvfz $(TAR_FILE)
