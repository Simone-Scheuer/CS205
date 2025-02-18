// rchaney@pdx.edu

// compile with:
// gcc -m32 -g3 -O0 -Wall -Werror -std=c11  -c segments.c
// gcc -m32 -no-pie -fno-pie segments.o -o segments

#include <stdio.h>
#include <stdlib.h>

int xx;           // an unitialized variable. it will go into the bss section
int yy = 7;       // an initialized varaible. it will go into the data section
const int zz = 0; // a read-only variable. it will go into the read-only section

int
main(void)
{
    int aa = 0;   // this variable is allocated from the stack
    int *bb = malloc(sizeof(int) * 2); // the address in bb comes from the heap

    printf("identifier\t\tabs address\trelative address\n");
    printf(
        "stack &aa:\t\t%11p\t%#011x\n"
        "heap bb:\t\t%11p\t%#011x\n"
        "uninitialized &xx:\t%11p\t%#011x\n"
        "initialized &yy:\t%11p\t%#011x\n"
        "read-only &zz:\t\t%11p\t%#011x\n"
        "text &main:\t\t%11p\t0x%09u\n"
        , (void *) &aa, ((void *) &aa) - ((void *) main)
        , (void *) bb,  ((void *) bb) - ((void *) main)
        , (void *) &xx, ((void *) &xx) - ((void *) main)
        , (void *) &yy, ((void *) &yy) - ((void *) main)
        , (void *) &zz, ((void *) &zz) - ((void *) main)
        , (void *) main, ((void *) main) - ((void *) main)
    );
    free(bb);

    return EXIT_SUCCESS;
}
