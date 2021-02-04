/*
 * Timing and delay routines.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#include <stdint.h>


/* Delay for "usec" microseconds, then return 0. */
int usleep(unsigned long usec);


/* Return a monotonic CPU cycle counter.
   This counter starts at an arbitrary value at boot. */
uint64_t get_cycle_counter(void);

/* end */
