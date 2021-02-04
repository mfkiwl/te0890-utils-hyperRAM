/*
 * Support library for RISC-V embedded software.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */


#include "rvlib_std.h"


void * memcpy(void *dest, const void *src, size_t n)
{
    char *pdest = (char *)dest;
    const char *psrc = (const char *)src;
    while (n > 0) {
        *(pdest++) = *(psrc++);
        n--;
    }
    return dest;
}


void memcpy_aligned(uint32_t *dest, const uint32_t *src, size_t n)
{
    n &= ~(3UL);
    while (n > 0) {
        *(dest++) = *(src++);
        n -= 4;
    }
}


void * memmove(void *dest, const void *src, size_t n)
{
    char *pdest = (char *)dest;
    const char *psrc = (const char *)src;
    int step = 1;
    if (dest > src) {
        step = -1;
        pdest += n - 1;
        psrc += n - 1;
    }
    while (n > 0) {
        *pdest = *psrc;
        pdest += step;
        psrc += step;
        n--;
    }
    return dest;
}


void * memset(void *dest, int c, size_t n)
{
    unsigned char *pdest = (unsigned char *)dest;
    while (n > 0) {
        *(pdest++) = c;
        n--;
    }
    return dest;
}


void memzero_aligned(uint32_t *dest, size_t n)
{
    n &= ~(3UL);
    while (n > 0) {
        *(dest++) = 0;
        n -= 4;
    }
}


int memcmp(const void *s1, const void *s2, size_t n)
{
    const unsigned char *p1 = (const unsigned char *)s1;
    const unsigned char *p2 = (const unsigned char *)s2;
    while (n > 0) {
        unsigned char c1 = *(p1++);
        unsigned char c2 = *(p2++);
        if (c1 != c2) {
            return (c1 < c2) ? (-1) : 1;
        }
        n--;
    }
    return 0;
}


void
__attribute__ ((weak))
abort(void)
{
    while (1) ;
}


size_t strnlen_s(const char *str, size_t strsz)
{
    size_t p = 0;
    if (str != NULL) {
        while ((p < strsz) && (str[p] != '\0')) {
            p++;
        }
    }
    return p;
}


int strncmp(const char *lhs, const char *rhs, size_t count)
{
    while (count > 0) {
        unsigned char c1 = *(lhs++);
        unsigned char c2 = *(rhs++);
        if (c1 != c2) {
            return (c1 < c2) ? (-1) : 1;
        }
        if (c1 == '\0') {
            break;
        }
        count--;
    }
    return 0;
}

/* end */
