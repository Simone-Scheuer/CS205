#include <stdio.h>

// gcc -Wall -g -o f2c f2c.c
// ./f2c

int main(void)
{
#ifdef WRONG
    int far = 0;
    int cel = 0;
    printf("Enter the temp in fahrenheit: ");
    scanf("%d", &far);
    cel = (far - 32) * 5 / 9;
    printf("Celsius = %d\n", cel);

#else //WRONG
    float far = 0.0;
    float cel = 0.0;
    printf("Enter the temp in fahrenheit: ");
    scanf("%f", &far);
    cel = (far - 32.0) * 5.0 / 9.0;
    printf("Celsius = %f\n", cel);

#endif //WRONG

    return 0;
}
