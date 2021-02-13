/*
 * Support library for RISC-V embedded software.
 *
 * This library is intended to be used instead of the standard C library
 * when building tiny embedded programs. The application code as well as
 * this library should be compiled with the "-ffreestanding" flag.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#ifndef RVLIB_STD_H_
#define RVLIB_STD_H_

#include <stddef.h>
#include <stdint.h>


/*
 * Basic array copy/compare functions.
 *
 * These functions are equivalent to the functions with the same name
 * from <string.h>.
 *
 * GCC may emit calls to these functions.
 */

void * memcpy(void * restrict dest, const void * restrict src, size_t n);
void * memmove(void *dest, const void *src, size_t n);
void * memset(void *dest, int c, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);


/*
 * Abort the program.
 * GCC may emit calls to this function.
 *
 * The default implementation simply loops forever.
 * This function is implemented as a weak symbol, therefore
 * it may be overridden by an application-specific implementation.
 */
_Noreturn void abort(void);


/*
 * Basic string functions.
 *
 * These functions are equivalent to the functions with the same name
 * from <string.h>.
 */
size_t strnlen_s(const char *str, size_t strsz);
int strncmp(const char *lhs, const char *rhs, size_t count);


/*
 * Fast memcpy for 4-byte aligned blocks.
 *
 * Parameters:
 *   dest:   Pointer to destination area. Must be a 4-byte aligned address.
 *   src:    Pointer to source area. Must be a 4-byte aligned address.
 *   n:      Number of bytes to copy. Must be a multiple of 4.
 *
 * The source and destination areas must not overlap.
 */
void memcpy_aligned(uint32_t * restrict dest,
                    const uint32_t * restrict src,
                    size_t n);

/*
 * Fast zeroing of 4-byte aligned blocks.
 *
 * Parameters:
 *   dest:   Pointer to destination area. Must be a 4-byte aligned address.
 *   n:      Number of bytes to zero. Must be a multiple of 4.
 */
void memzero_aligned(uint32_t *dest, size_t n);


/*
 * Halt the program by looping forever.
 * The exit code is ignored.
 *
 * This is equivalent to returning 'exit_code' from the main() function.
 */
_Noreturn void _Exit(int exit_code);

#endif  // RVLIB_STD_H_
