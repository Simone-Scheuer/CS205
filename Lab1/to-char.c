#include <stdio.h>
#include <string.h>

const int STRLEN = 1024;

int main(void)
{
    char buffer[STRLEN] = {};
    int base = 0;
    char * toke = NULL;
    int value = 0;

    fgets(buffer, STRLEN, stdin);

    int res = sscanf(buffer, "%d", &base);

    if (res == 0)
    {
        printf("\nERROR. INVALID BASE.\n");
        return 0;
    }  

    if (base == 8) {printf("octal input\n"); }   
    if (base == 10) {printf("decimal input\n"); }
    if (base == 16) {printf("hex input\n"); }

    while (fgets(buffer, STRLEN, stdin) != NULL)
    {
        toke = strtok(buffer, "\n\t ");
        while (toke)
        {
            switch(base)
            {
                case 8:
                    sscanf(toke, "%o", &value);
                    break;

                case 10:
                    sscanf(toke, "%d", &value);
                    break;

                case 16:
                    sscanf(toke, "%x", &value);
                    break;

                default:
                    break;
            }
            if (value != 0)
            {
                printf("%c", value);
            }
            toke = strtok(NULL,"\n\t ");
        }
        printf("\n");
    }

    return 1;
}
