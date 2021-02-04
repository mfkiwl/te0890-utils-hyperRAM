/*
 * Test program for PicoLibc on RISC-V.
 *
 * This program is designed to be linked with PicoLibC.
 * It runs on a bare-metal RISC-V system, using rvlib to access
 * system peripherals.
 *
 * Written in 2021 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>


int main(void)
{
    printf("RISC-V test with picolibc\n");

    // Test basic printf.
    printf("%s %d 0x%04x\r\n", "printf", 1234, 0x2345);

    // Test floating point.
    for (int i = 0; i < 5; i++) {
        printf("%d/3 = %f, sqrt(%d) = %f, sin(%d) = %f\n",
               i, i / 3.0, i, sqrt(i), i, sin(i));
    }

    // Test heap.
    char *buf = malloc(128);
    snprintf(buf, 128, "got buffer at 0x%p\n", buf);
    fputs(buf, stdout);
    free(buf);

    // Test stdin.
    printf("Type a number: ");
    fflush(stdout);

    int n;
    scanf("%d", &n);
    printf("%d * %d = %d\n", n, n, n * n);

    printf("done\n");

    return 0;
}
