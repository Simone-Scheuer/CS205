// R Jesse Chaney
// rchaney@pdex.edu

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#ifndef MAX_BUFFER_LEN
# define MAX_BUFFER_LEN 1024
#endif // MAX_BUFFER_LEN

int main(int argc, char *argv[])
{
    long buffer = 0;
    ssize_t bytes_read;

    if (argc <= 1) {
        // If no files are listed on the command buffer.
        while ((bytes_read = read(STDIN_FILENO, &buffer, sizeof(buffer))) > 0) {
            printf("%ld\n", buffer);

        }
    }
    else {
        int i;
        int fd;

        // Loop through the  files listed on the command line.
        for (i = 1; i < argc; i++) {
            fd = open(argv[i], O_RDONLY);
            if (fd > 0) {
                while ((bytes_read = read(fd, &buffer, sizeof(buffer))) > 0) {
                    printf("%ld\n", buffer);
                }
                close(fd);
            }
            else {
                fprintf(stderr, "Could not open file for input %s\n", argv[i]);
            }
        }
    }

    return 0;
}
