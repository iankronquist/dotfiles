#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("perror ERRNO\r\n");
        return -1;
    }
    int err = atoi(argv[1]);
    printf("%d: %s\r\n", err, strerror(err));

    return 0;
}
