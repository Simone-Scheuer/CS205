#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>


int STRLEN = 3000;

int main(void)
{
    int len;
    char buffer[STRLEN];

    printf("\nTHIS IS FROM INSIDE MAIN\n");

    while (fgets(buffer, STRLEN, stdin) != NULL)
    {
        printf("Reading line: %s", buffer);
        len = strlen(buffer);
        char temphex[7] = {0};
        int num_seq_hex = 0;
        for(int i = 0; i < len; i++)
        { 
            if (isxdigit(buffer[i]))
            {
                printf("%c ", buffer[i]);
                if (num_seq_hex < 6)
                {
                    num_seq_hex += 1;
                    temphex[num_seq_hex-1] = buffer[i];
                }
                if (num_seq_hex == 6)
                {
                     temphex[6] = '\0';
                    printf("\nSix concurrent hex found: ");
                    for(int i = 0; i < 6; i++)
                    {
                        printf("%c", temphex[i]);
                        num_seq_hex = 0;
                    }
                    printf("\n");
                }
            }
            else
            {
                num_seq_hex = 0;
            }

        }

    }
    return 0;
}


