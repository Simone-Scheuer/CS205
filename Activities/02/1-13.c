#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#define LONGEST_WORD 45

    int
main(int argc, char *argv[])
{
    char input[LONGEST_WORD + 1];
    int *lengths = (int*)malloc((LONGEST_WORD + 1) * sizeof(int));
    memset(lengths, 0, (LONGEST_WORD + 1) * sizeof(int));
    long total_words = 0;
    while((scanf("%45s", input) != EOF)){
        lengths[strlen(input)]++;
        total_words++;
    }
    printf("%ld total words\n", total_words);
    for (int i = 0; i <= LONGEST_WORD; ++i){
        printf("%2d: ", i);
        fprintf(stderr,"%d %d:%f\n",i,lengths[i], ceil(lengths[i] / (double)total_words * 100));
        for (int j = 0; j < floor(lengths[i] / (double)total_words * 100); ++j){
            printf("*");
        }
        printf("\n");
    }
    return 0;
}

