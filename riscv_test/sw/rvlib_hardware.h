/*
 * Memory mapped peripherals for simple RISC-V platform.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#ifndef RVLIB_HARDWARE_H_
#define RVLIB_HARDWARE_H_

#include <stdint.h>


/* Base addresses of memory-mapped peripherals. */
#define RVSYS_ADDR_FASTRAM  0x80000000
#define RVSYS_ADDR_LEDS     0xf0000000
#define RVSYS_ADDR_GPIO1    0xf0001000
#define RVSYS_ADDR_GPIO2    0xf0002000
#define RVSYS_ADDR_TIMER    0xf0008000
#define RVSYS_ADDR_UART     0xf0010000

/* GPIO channels for LEDs */
#define RVLIB_LED_RED_CHANNEL   0
#define RVLIB_LED_GREEN_CHANNEL 1

/* Select a default UART device */
#define RVLIB_DEFAULT_UART_ADDR RVSYS_ADDR_UART


/* Processor clock frequency. */
#define RVLIB_CPU_FREQ_MHZ  100


/* Read from memory-mapped register. */
static inline uint32_t rvlib_hw_read_reg(uint32_t addr)
{
    return *((volatile const uint32_t *)addr);
}


/* Write to memory-mapped register. */
static inline void rvlib_hw_write_reg(uint32_t addr, uint32_t val)
{
    *((volatile uint32_t *)addr) = val;
}


/* Read the lower 32 bits of the cycle counter. */
static inline uint32_t rvlib_hw_rdcycle(void)
{
    uint32_t ret;
    asm volatile ( "rdcycle %0" : "=r" (ret) );
    return ret;
}


/* Read the upper 32 bits of the cycle counter. */
static inline uint32_t rvlib_hw_rdcycle_high(void)
{
    uint32_t ret;
    asm volatile ( "rdcycleh %0" : "=r" (ret) );
    return ret;
}

#endif  // RVLIB_HARDWARE_H_
