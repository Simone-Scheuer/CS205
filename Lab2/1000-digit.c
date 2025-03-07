#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>


int STRLEN = 3000;

int main(void)
{
    int len;
    char buffer[STRLEN];
    long int largest = 0;
    long int product = 0;
    char largest_hex[7] = {0};
    int largest_index = 0;
    int num_digits = 0;
    char temphex[7] = {0}; //create a temphex big enough for 6 chars and a null terminator 
    int num_seq_hex = 0; //initate the index to track how many sequential hexes you have
    char hex_char = ' ';
    int hex_value = 0;

    while (fgets(buffer, STRLEN, stdin) != NULL) //continually read in
    {
        len = strlen(buffer); //set len to the length of the string in buffer

        for(int i = 0; i < len; i++) //PROCEED THROUGH EVERY CHAR
        {
            if (isxdigit(buffer[i])) //IF IT IS A HEX, BEGIN THE PROCESS
            {
                num_digits++;
                if (num_seq_hex == 6) //IF YOU HAVE ACCUMULATED SIX, AND YOU ARE LOOKING AT A HEX, TIME TO SHIFT AND MAKE A NEW SET
                {
                    for (int j = 0; j < 5; j++) //for all but one of the chars in the hex sequence..
                    {
                        temphex[j] = temphex[j + 1]; //cut off the first char in the sequence
                    }
                    temphex[5] = toupper(buffer[i]); //assign the sixth position to the new one.
                }
                else //IF YOU ARE NOT AT THE SIXTH POSITION OF A SEQUENCE
                {
                    temphex[num_seq_hex] = toupper(buffer[i]);//add the hex to the sequence
                    num_seq_hex++; //increase the sequence by one
                }
                if (num_seq_hex == 6) //IF YOU HAVE SIX
                {
                    temphex[6] = '\0'; //set the SEVENTH POSITION, to the null terminator
                    product = 1; //initialize the product calculator
                    for (int z = 0; z < 6; z++) //MANUALLY CALCULATE THE PRODUCT BY TRAVERSING EACH CHAR
                    {
                        hex_value = 0; //set the char inital value to zero
                        hex_char = temphex[z]; //set the temphex to the hex char to examine
                        if (hex_char >= '0' && hex_char <= '9') //map it to the number if its a number
                        {
                            hex_value = hex_char - '0'; 
                        }
                        else if (hex_char >= 'A' && hex_char <= 'F') //otherwise map it to its respective letter
                        {
                            hex_value = hex_char - 'A' + 10;
                        }
                        product *= hex_value; //and multiply cummulitivelty
                    }
                    if (product > largest)
                    {
                        largest = product;
                        strcpy(largest_hex, temphex);
                        largest_index = num_digits - 6;
                    }
                }
            }

        }

    }
    printf("Greatest product of 6 consecutive digits: %ld", largest);
    printf("\n  Found at index: %d", largest_index);
    printf("\n  Consisting of the string: %s", largest_hex);
    printf("\n  Digit count: %d", num_digits);
    printf("\n");
    return 0;
}
