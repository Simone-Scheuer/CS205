#include <string.h>
#include <stdio.h>

const int STRLEN = 1024;

int main(void)
{
    char str[STRLEN] = {};
    printf("\nEnter a string: ");
    fgets(str, STRLEN, stdin);
    int len = strlen(str) - 1;

    printf("\n\nCharacter Output: \n");
    for (int i = 0; i < len; i++)
    {
        printf("%c ",str[i]);
    }


    printf("\n\nOctal Output: \n");
    for (int i = 0; i < len; i++)
    {
        printf("0%o ",str[i]);
    }


    printf("\n\nDecimal Output: \n");
    for (int i = 0; i < len; i++)

    {
        printf("%d ",str[i]);
    }


    printf("\n\nHex Output: \n");
    for (int i = 0; i < len; i++)
    {
        printf("0x%x ",str[i]);
    }
    printf("\n\n");

return 0;
}




