#include <stdio.h>

int main(void)
{
    char *str1 = "Hello";

    for (int i = 0; str1[i] !='\0'; ++i)
    {
        printf("%d:%c\n", __LINE__, str1[i]);
    }

    printf("\n");

    for (char *pch = str1; *pch !='\0'; ++pch)
    {
        if (*pch == 'l') { break;}
        printf("%d:%c\n", __LINE__, *pch);
    }

    printf("\n");

    for (char *pch = str1; *pch !='\0'; ++pch)
    {
        if (*pch == 'l') { continue;}
        printf("%d:%c\n", __LINE__, *pch);
    }
    return 0;
}
