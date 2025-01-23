#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>


int STRLEN = 3000;

int main(void)
{
    int len;
    char buffer[STRLEN];
    int largest = 0;
    char largest_hex[7] = {0};
    int largest_index = 0;


    printf("\nTHIS IS FROM INSIDE MAIN\n");

    while (fgets(buffer, STRLEN, stdin) != NULL) //continually read in
    {
        char temphex[7] = {0}; //create a temphex big enough for 6 chars and a null terminator 
        int num_seq_hex = 0; //initate the index to track how many sequential hexes you have
        printf("Reading line: %s", buffer); //print the line you are reading
        len = strlen(buffer); //set len to the length of the string in buffer
                             
        for(int i = 0; i < len; i++) //PROCEED THROUGH EVERY CHAR
        { 
            if (isxdigit(buffer[i])) //IF IT IS A HEX, BEGIN THE PROCESS
            {
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

                    int value = (int)strtol(temphex, NULL, 16);
                    temphex[6] = '\0'; //set the SEVENTH POSITION, to the null terminator
                    printf("\nSix concurrent hex found: "); //output the chain you found
                    printf("%s", temphex);
                    if (value > largest)
                    {
                        largest = value;
                        strcpy(largest_hex, temphex);
                        largest_index = i - 5;
                    }
                    printf("\nThe value of this hex seq: %d", value);
                }
            }

        }

    }

        printf("\n\nThe Largest value was %d occuring from %s beginning at index %d", largest, largest_hex, largest_index);
    return 0;
}
