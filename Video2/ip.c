#include <stdio.h>

// gcc -Wall -g -o ip ip.c
// ./ip
//
#define STRLEN 100

int main(void)
{
    {
        char str1[STRLEN] = {'\0'};
        char str2[STRLEN] = {'\0'};
        char str3[STRLEN] = {'\0'};
        int matched = 0;

        printf("--strings\n");
        fgets(str1, STRLEN, stdin);
        printf(">>%s<<\n",str1);

        scanf("%s", str2);
        printf(">>%s<<\n",str2);

        scanf("%s %s", str2, str3);
        printf(">>%s %s<<\n", str2, str3);

        printf("-- 3 strings\n");
        matched = scanf("%s %s %s", str1, str2, str3);
        printf(">>%s %s %s<< %d\n", str1, str2, str3, matched);   
    }
    {
        int matched = 0;
        int i = 0;
        unsigned u = 0;

        printf("--integers\n");
        scanf("%i", &i);
        printf("%i\n", i);

        printf("--nex\n");
        scanf("%x", &u);
        printf("%u\n",u);

        scanf("%x",&u);
        printf("%x\n", u);

        printf("--bogus hex\n");
        matched = scanf("%x", &u);
        printf("%x %d\n", u, matched); 
    }

    {
        char cleanup[STRLEN] = {'\0'};
        fgets(cleanup, STRLEN, stdin);
    }

    {
        float f = 0.0;
        printf("--float\n");
        scanf("%f", &f);
        printf("%.2f\n", f);
    }
    return 0;
}
