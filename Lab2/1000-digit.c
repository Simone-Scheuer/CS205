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

    while (fgets(buffer, STRLEN, stdin) != NULL) //continually read in
    {
        printf("Reading line: %s", buffer); //print the line you are reading
        len = strlen(buffer); //set len to the length of the string in buffer
        char temphex[7] = {0}; //create a temphex big enough for 6 chars and a null terminator 
        int num_seq_hex = 0; //initate the index to track how many sequential hexes you have
                             
        for(int i = 0; i < len; i++) //PROCEED THROUGH EVERY CHAR
        { 
            if (isxdigit(buffer[i])) //IF IT IS A HEX, BEGIN THE PROCESS
            {
                printf("%c ", buffer[i]); //Output it for clarity
                if (num_seq_hex == 6) //IF YOU HAVE ACCUMULATED SIX, AND YOU ARE LOOKING AT A HEX, TIME TO SHIFT AND MAKE A NEW SET
                {
                    for (int j = 0; j < 5; j++) //for all but one of the chars in the hex sequence..
                    {
                        temphex[j] = temphex[j + 1]; //cut off the first char in the sequence
                    }
                    temphex[5] = buffer[i]; //assign the sixth position to the new one.
                }
                else //IF YOU ARE NOT AT THE SIXTH POSITION OF A SEQUENCE
                {
                    temphex[num_seq_hex] = buffer[i]; //add the hex to the sequence
                    num_seq_hex++; //increase the sequence by one
                }
                if (num_seq_hex == 6) //IF YOU HAVE SIX
                {
                    temphex[6] = '\0'; //set the SEVENTH POSITION, to the null terminator
                    printf("\nSix concurrent hex found: "); //output the chain you found
                    printf("%s", temphex);
                }
            }
            else //IF IT IS NOT A HEX
            {
                num_seq_hex = 0; //reset the sequence.
            }

        }

    }
    return 0;
}
