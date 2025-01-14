#include <stdio.h>

//gcc -Wall strings1 strings1.c
// ./strings1

int main(void)
{
    char str1[10] = "Hello";
    for(int i = 0; i<5; i++)
    {
        printf("%d: %c\n", __LINE__, str1[i]);
    }

    printf("\n");

    for(int i = 0; i<5; i++)
    {
        if (str1[i] == 'l') 
        {
            break;
        }
        printf("%d: %c\n", __LINE__, str1[i]);
    }

    printf("\n");

    for(int i = 0; i<5; i++)
    {
        if (str1[i] == 'l') 
        {
            continue;
        }
        printf("%d: %c\n", __LINE__, str1[i]);
    }
    return 0;
}
