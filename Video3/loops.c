#include <stdio.h>




int 
main(void)
{
    for (int i = 0; i <= 10; i+= 2) {
        for (int j = 10; j < 100; j+= 10) {
            if (j == 50) {
                continue;
            }
            if (j == 80) {
                break;
            }
            printf("%d: i = %2d j = %3d\n", __LINE__, i, j);
        }
        printf("\n");
    }

    return 0;
}
