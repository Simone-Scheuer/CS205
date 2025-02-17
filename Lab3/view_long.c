#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // getopt
#include <stdbool.h>
#include <string.h>
#include <stdint.h>

int main(int argc, char **argv)
{
    for (int i = 1; i < argc; i++)
    {
        FILE *file;
        size_t items_read;
        unsigned long buffer[100000];
        char * filename = argv[i];
        printf("\n%s\n", filename);
        file = fopen(filename, "rb");
        if (!file)
        {
            continue;
        }
        items_read = fread(buffer, sizeof(unsigned long), 10000, file);
        for(size_t p = 0; p < items_read; p++)
        {
            printf("%lu\n", buffer[p]);
        }
        fclose(file);
    }
    return 0;
}
