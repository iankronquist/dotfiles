// bf16tof
#include<stdio.h>
#include<stdint.h>
#include <stdlib.h>

static  uint16_t f32_to_bf16(float f) {

    union {
        float f;
        uint32_t u32;
    } converter;
    converter.f = f;
    uint16_t u16 = (uint16_t)(converter.u32 >> 16);
    return u16;
}

static  float bf16long_to_float(long bf16) {

    union {
        float f;
        uint32_t u32;
    } converter;
    uint32_t u32 = (uint32_t)bf16;
    u32 <<= 16;
    converter.u32 = u32;
    return converter.f;
}
int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; ++i) {
        long l = strtol(argv[i], NULL, 16);
        float f = bf16long_to_float(l);

        printf("%lx -> %f %x\n", l, f, f);
    }
}
