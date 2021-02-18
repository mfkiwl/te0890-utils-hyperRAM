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

#ifndef RVLIB_TIME_H_
#define RVLIB_TIME_H_

#include <stdint.h>

/* Delay for "usec" microseconds, then return 0. */
int usleep(unsigned long usec);

/*
 * Return the current value of the "rdcycle" monotonic CPU cycle counter.
 * This counter starts at an arbitrary value at boot.
 */
uint64_t get_cycle_counter(void);

/*
 * Return the current value of the "mtime" register.
 * This register increments at the rate of the CPU frequency.
 *
 * Note this timer is separate from the "rdcycle" counter.
 */
uint64_t rvlib_timer_get_counter(void);

/* Reset the "mtime" register to zero. */
void rvlib_timer_reset_counter(void);

/*
 * Set the value of the "mtimecmp" register.
 *
 * This schedules an interrupt to occur as soon as "mtime" reaches
 * the value of "mtimecmp".
 *
 * Note that the interrupt signal remains  active as long as "mtime" is
 * greater-or-equal than "mtimecmp". The timer interrupt handler must
 * update "mtimecmp" to clear the interrupt.
 */
void rvlib_timer_set_timecmp(uint64_t timecmp);

#endif  // RVLIB_TIME_H_
