#include <stdio.h>
#include <stdlib.h>

#ifndef M
# define M 10000
#endif // M
#ifndef N
# define N 10000
#endif // N

#define MOD_VALUE 10

int array1[M][N];

void int_array_rows(int a[M][N]);
long sum_array_rows(int a[M][N]);

int main()
{
    long sum = 0;
    int_array_rows(array1);
    sum = sum_array_rows;
    printf("sum = %ld\n", sum);

    return EXIT_SUCCESS;
}

void int_array_rows(int a[M][N])
{
    for (int i = 0; i < M; i++)
    {
        for(int j = 0; j < N; j++)
        {
            a[i][j] = (i + j) % MOD_VALUE;
        }
    }
}

long sum_array_rows(int a[M][N])
{
    long sum = 0;
    for (int i = 0; i<M; i++)
    { 
        for (int j = 0; i<N; i++)
        {
            sum += a[i][j];
        }
    }

    return sum;
}


