#include <stdio.h>

    float
f2c(int fahr)
{
    return (5.0 / 9.0) * (fahr - 32.0);
}
    float
c2f(float celsius)
{
    return (9.0 / 5.0) * celsius + 32;
}
// print Fahrenheit-Celsius table
// for fahr = 0, 20, ..., 300; floating-point version
    int
main(int argc, char *argv[])
{
    float fahr, celsius;
    float lower, upper, step;
    lower = -60; // lower limit of temperature scale
    upper = 300; // upper limit
    step = 20; // step size
    printf("%3s %6s\n", "ºC", "ºF");
    celsius = lower;
    while (celsius <= upper)
    {
        fahr = c2f(celsius);
        printf("%3.0f %6.1f\n", celsius, fahr);
        celsius += step;
    }
    return 0;
}

