 #include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // getopt
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
//horse

void sieve(int n, char mode, char binary); //prototype

int main(int argc, char **argv) //argc lists the number of arguments, argvv is an array of them 
{
    char c; //to hold the argv params.
    int n = 100; //to hold the optarg from the -u containing the upper limit
    char mode = 'p'; //to determine wether to print primes or the other guys
    char binary = 'n';

    while ((c = getopt(argc, argv, "pcu:bvh")) != -1) //parse argv for the guys were looking for
    {
        switch(c) //switch on them
        {
            case 'p':
                {
                    mode = 'p';
                    break;
                }
            case 'c':
                {
                    mode = 'c';
                    break;
                }
            case 'u': 
                {
                    n = strtol(optarg, NULL, 10);
                    break;
                }
            case 'b':
                {
                    binary = 'y';
                    break;
                }
            case 'v':
                {
                    printf("\nCase V\n");
                    break;
                }
            case 'h':
                {
                    printf("\nCase H\n");
                    break;
                }
        }
    }

    sieve(n, mode, binary);

    return 0;
}

void sieve(int n, char mode, char binary)
{

    int num_bytes = (n / 8) + 1; //the number of bytes needed to store bits 0-n
    uint8_t *numbers = malloc(sizeof(uint8_t) * num_bytes); //initialize an array of byte num bytes
    uint8_t shift; //stores the bit position within bytes
    uint8_t mask; //used to set and flip bytes
    memset(numbers, 0, num_bytes); //set all the memory of the bytes to zero, assuming primacy by default


    for (int p = 2; p * p <= n; p++) //for all multiples of p greater than or equal to its square
    {
        shift = p % 8; // get the bit position in the byte for p
        mask = 1 << shift; //create a bitmask to check if the bit is set
        if ((numbers[p / 8] & mask) == 0) //check if the numbers at the position are yet unmarked
        {
            for (int i = p * p; i <= n; i+= p) //find all multoples of p
            {
                shift = i % 8; //get bitposition for multiple i
                mask = 1 << shift; //make the mask
                numbers[i / 8] = numbers[i / 8] | mask; //flip the bit with the bitwise and.
            }
        }
    }
    if (mode == 'p')
    {
        for (int p = 2; p <=n; p++)
        {
            mask = 1 << (p % 8);
            if ((numbers[p / 8] & mask) == 0)
            {
                if (binary == 'y')
                {
                    unsigned long prime = (unsigned long)p;
                    write(STDOUT_FILENO, &prime, sizeof(unsigned long));
                }
                else
                {
                    printf("%d\n", p);
                }
            }
        }
    }
    if (mode == 'c')
    {
        for (int p = 2; p <=n; p++)
        {
            mask = 1 << (p % 8);
            if ((numbers[p / 8] & mask) != 0)
            {
                if (binary == 'y')
                {
                    unsigned long composite = (unsigned long)p;
                    write(STDOUT_FILENO, &composite, sizeof(unsigned long));
                }
                else
                {
                    printf("%d\n", p);
                }
            }
        }
    }
    free(numbers);

}


