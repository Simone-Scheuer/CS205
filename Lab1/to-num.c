#include <string.h>
#include <stdio.h>

const int STRLEN = 1024;

int main(void)
{
    char str[STRLEN] = {};

    while (fgets(str,STRLEN,stdin) != NULL)
    {

    int len = strlen(str) - 1;

    printf("character output\n");
    for (int i = 0; i < len; i++)
    {
        printf("%c ",str[i]);
    }
    printf("\noctal output\n");
    for (int i = 0; i < len; i++)
    {
        printf("%#04o ",str[i]);
    }
    printf("\ndecimal output\n");
    for (int i = 0; i < len; i++)
    {
        printf("%3d ",str[i]);
    }
    printf("\nhex output\n");
    for (int i = 0; i < len; i++)
    {
        printf("%#04x ",str[i]);
    }
    printf("\n");
    }

return 0;
}
