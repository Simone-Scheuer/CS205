#include <stdio.h>

// gcc -Wall -g -o op op.c
// ./op

int main(void) 
{
    {
        //strings
        char *str1 = "hello1";
        char str2[] = "hello2";
        char str3[20] = "hello3";

        puts(str1);
        printf(">>%s<< %%s\n", str1);
        printf(">>%15s<< %%15s\n", str2);
        printf(">>%-15s<< %%-15s\n", str3);
        printf(">>%3s<< small fields %%3s\n", str1);

    }

    {
        char ssi = 65;  //1 byte;
        int i = 10; //4 bytes;
        short si = 7; //2 bytes;
        long li = 117; //8 bytes;
        long long lli = 1117; // 8 bytes;
        unsigned ui = 5; //4 bytes;

        printf("%d int %%d\n", i);
        printf("%hd short %%hd\n", si);
        printf("%hhd char as an int %%hhd\n", ssi);
        printf("%ld long %%ld\n", li);
        printf("%lld long long %%lld\n", lli);

        printf("%c char as a char %%c\n", ssi);

        printf("%u unsigned %%u\n", ui);

        printf(">>%10d<< %%10d\n", i);
        printf(">>%-10d<< %%-10d\n", i);
        printf(">>%010d<< %%10d\n", i);

        printf(">>%#o<< octal %%#o\n", i);
        printf(">>%#x<< hex %%#x\n", i);
        printf(">>%#X<< hex %%#X\n", i);
        printf(">>%p<< pointer %%p\n", (void *) &i);

    }

    {
        float f = 3.14;
        double d = 6.28;
        long double ld = 12.56; //16 bytes

        printf("%f float %%f\n",f);
        printf("%lf double %%lf\n",d);
        printf("%Lf long double %%Lf\n", ld);

        printf(">>%8.3f<< float %%8.3f\n",f);
        printf(">>%08.3f<< float %%08.3f\n",f);
        printf(">>%-8.3f<< float %%-8.3f\n",f);
        printf(">>%+-8.3f<< float %%+-8.3f\n",f);
        
        printf(">>%14.5e<< float %%14.5e\n", f * 100);

    }
    return 0;
}
