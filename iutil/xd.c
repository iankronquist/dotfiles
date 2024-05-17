
static void xd_byte(unsigned char b) {
    static char hexes[] = "0123456789abcedf";
    printf("%c%c", hexes[b >> 4], hexes[b & 0xf]);
}

void XD(void *memory, unsigned long long bytes) {
    unsigned long long i;
    unsigned long long j;
    unsigned char *m = memory;
    unsigned long long last_ascii = 0;
    unsigned char ascii;
    for (i = 0; i < bytes; ++i) {
        if ((i % 16) == 0) {
            printf("%08llx: ", i);
        }
        printf("%02hhx", m[i]);
        if ((i % 2) == 1) {
            printf(" ");
        }
        if ((i % 16) == 15) {
            printf(" ");
            for (j = last_ascii; j <= i; ++j) {
                if (' ' < m[j] && m[j] <= '~') {
                    ascii = m[j];
                } else {
                    ascii = '.';
                }
                printf("%c", (char)ascii);
            }
            last_ascii = i;
            printf("\n");
        }
    }
    if ((i % 16) != 15) {
        printf("\n");
    }
}
