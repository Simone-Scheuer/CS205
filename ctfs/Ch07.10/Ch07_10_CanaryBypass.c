/* Derived from CTF level by Fan Zhang New Beginnings Fall 2015 */
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#define USERDEF 63

char msg[] =
 "Stack canaries and non-executable stacks make stack exploitation difficult. Such\n"
 "techniques, however, do not protect against return-oriented programming where\n"
 "only the return addresses on the stack are targeted.  In this level, you control\n"
 "a single write into a vulnerable buffer in the function prompt_user.  Overflow\n"
 "the buffer to modify the return address beyond the stack canary so that it\n"
 "points to a function of your choice.  The level will prompt you with an offset\n"
 "(in decimal) from the beginning of the buffer that will be written into followed\n"
 "by a hexadecimal value that will be written there (e.g. scanf(\"%d %x\");).\n"
 "The program will then write the hexadecimal value to a location computed\n"
 "using the offset.  To determine how close you are, examine the pointer\n"
 "being used to write into the stack and how far away it is from the value\n"
 "of $rsp when the retq instruction at the end of prompt_user is reached.\n\n";

void print_good() {
    printf("Good Job.\n");
    exit(0);
}

void segv_handler(int sig) {
    printf("Segmentation fault.  Try again.\n");
    exit(0);
}

void print_msg() {
    printf("%s",msg);
}

void prompt_user() {
    char buffer[63];
    int offset;
    char *user_addr;
    char **over_addr;
    printf("Enter the password: ");
    scanf("%d %lx", &offset, (unsigned long *) &user_addr);
    over_addr = (char **) (buffer + offset);
    *over_addr = user_addr;
}

int main(int argc, char *argv[]) {
    signal(SIGSEGV, segv_handler);
    print_msg();
    prompt_user();
    printf("Try again.\n");
    return 0;
}
