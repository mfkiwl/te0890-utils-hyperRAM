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

#include "rvlib_time.h"
#include "rvlib_hardware.h"


/* Delay for "usec" microseconds, then return 0. */
int usleep(unsigned long usec)
{
    uint32_t tref = rvlib_hw_rdcycle();

    /* Special handling when waiting longer than 2**30 cycles. */
    while (usec > (1UL << 30) / RVLIB_CPU_FREQ_MHZ) {
        uint32_t step_usec = (1UL << 29) / RVLIB_CPU_FREQ_MHZ;
        usec -= step_usec;
        tref += step_usec * RVLIB_CPU_FREQ_MHZ;
        while (1) {
            uint32_t tnow = rvlib_hw_rdcycle();
            uint32_t tremain = tref - tnow;
            if ((tremain == 0) || (tremain >= (1UL << 31))) {
                break;
            }
        }
    }

    /* Calculate target value of CYCLE counter.
       Subtract 5 cycles to compensate for overhead. */
    uint32_t tend = tref + RVLIB_CPU_FREQ_MHZ * usec - 5;

    /* Loop until CYCLE counter reaches the target value. */
    while (1) {
        uint32_t tnow = rvlib_hw_rdcycle();
        uint32_t tremain = tend - tnow;
        if ((tremain == 0) || (tremain >= (1UL << 31))) {
            break;
        }
    }

    return 0;
}


/* Return a monotonic CPU cycle counter.
   This counter starts at an arbitrary value at boot. */
uint64_t get_cycle_counter(void)
{
    uint32_t cyc_hi0 = rvlib_hw_rdcycle_high();
    uint32_t cyc_lo = rvlib_hw_rdcycle();
    uint32_t cyc_hi = rvlib_hw_rdcycle_high();
    if (cyc_hi != cyc_hi0) {
        /* Upper 32 bits changed while reading the lower 32 bits.
           Set lower 32 bits to zero to construct a value that occurred
           some time between the first and last read of the register. */
        cyc_lo = 0;
    }
    return (((uint64_t)cyc_hi) << 32) | cyc_lo;
}

/* end */
