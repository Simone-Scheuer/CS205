#include <stdio.h>
#include <string.h>

const int STRLEN = 1024;

int main(void)
{
    int base = 0;
    char coded_message[STRLEN] = {};
    char translated_message[STRLEN] = {};

    printf("\nEnter a base to translate (8, 10, 16): ");
    scanf("%d", &base);
    while (getchar() != '\n');

    if (base != 8 && base != 10 && base !=16)
    {
        printf("\nINVALID BASE, TERMINATING PROGRAM.\n");
        return 0;
    }

    if (base == 8)
    {
        printf("\nOctal Input: ");
        fgets(coded_message, STRLEN, stdin);
        int index = 0;
        int translated_index = 0;
        int octal = 0;
        char temp[5] = {};
        while(coded_message[index] != '\0')
        {
            if (coded_message[index] == '0' && coded_message[index + 1] == '0' && coded_message[index + 2] == '\0')
            {
                temp[0] = 0;
                temp[1] = 0;                                                                                                                                                      
                temp[4] = '\0';
            }
            else
            {
                for (int i = 0; i < 4; i++)
                {
                    temp[i] = coded_message[index + i];
                }
            }
            int octal = strtol(temp, NULL, 8);
            translated_message[translated_index] = (char)octal;
            ++translated_index;
            index += 5;
        }

    }
    if (base == 10)
    {
        return 1;
    }
    if (base == 16)
    {
        return 1;
    }

    printf("\ntranslated message: %s", translated_message);
    return 0;
}
