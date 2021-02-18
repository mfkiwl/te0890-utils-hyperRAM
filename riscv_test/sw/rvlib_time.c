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


#define RVLIB_TIMER_REG_MTIME_LO    0
#define RVLIB_TIMER_REG_MTIME_HI    4
#define RVLIB_TIMER_REG_MTIMECMP_LO 8
#define RVLIB_TIMER_REG_MTIMECMP_HI 12


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


/* Return the current value of the "rdcycle" monotonic CPU cycle counter. */
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


/*
 * Return the current value of the "mtime" register.
 * This register increments at the rate of the CPU frequency.
 *
 * Note this timer is separate from the "rdcycle" counter.
 */
uint64_t rvlib_timer_get_counter(void)
{
    uint32_t mtime_hi0, mtime_lo, mtime_hi;
    mtime_hi0 = rvlib_hw_read_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIME_HI);
    mtime_lo = rvlib_hw_read_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIME_LO);
    mtime_hi = rvlib_hw_read_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIME_HI);
    if (mtime_hi != mtime_hi0) {
        /* Upper 32 bits changed while reading the lower 32 bits.
           Set lower 32 bits to zero to construct a value that occurred
           some time between the first and last read of the register. */
        mtime_lo = 0;
    }
    return (((uint64_t)mtime_hi) << 32) | mtime_lo;
}


/* Reset the "mtime" register to zero. */
void rvlib_timer_reset_counter(void)
{
    rvlib_hw_write_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIME_LO, 0);
    rvlib_hw_write_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIME_HI, 0);
}


/* Set the value of the "mtimecmp" register. */
void rvlib_timer_set_timecmp(uint64_t timecmp)
{
    /* Temporarily set the low word to the maximum value to avoid spurious
       interrupts while updating the high word. */
    rvlib_hw_write_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIMECMP_LO,
                       UINT32_MAX);
    rvlib_hw_write_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIMECMP_HI,
                       timecmp >> 32);
    rvlib_hw_write_reg(RVSYS_ADDR_TIMER + RVLIB_TIMER_REG_MTIMECMP_LO,
                       (uint32_t)timecmp);
}

/* end */
