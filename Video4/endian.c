#include <stdio.h>
#include <stdlib.h>

// gcc -Wall -g -o endian endian.c

int main(void)
{
    unsigned short endian = 1;
    char *ecp = (char *) &endian;

    if (ecp[0] == '\0')
    {
        printf("This is a big endian architecture\n"); 
    }
    else
    {
        printf("This is a little endian architecture\n"); 
    }
    return EXIT_SUCCESS;
}
