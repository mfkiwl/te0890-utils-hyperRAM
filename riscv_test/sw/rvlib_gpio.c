/*
 * GPIO device driver.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#include "rvlib_hardware.h"
#include "rvlib_gpio.h"


#define RVLIB_GPIO_REG_INPUT      0
#define RVLIB_GPIO_REG_OUTPUT     4
#define RVLIB_GPIO_REG_DIRECTION  8


static inline uint32_t set_bit(uint32_t val, int bit, int state)
{
     if (state) {
         return val | (1UL << bit);
     } else {
         return val & ~(1UL << bit);
     }
}


/* Set the output driver enable flags of all channels. */
void rvlib_gpio_set_drive(uint32_t base_addr, uint32_t drive_mask)
{
    rvlib_hw_write_reg(base_addr + RVLIB_GPIO_REG_DIRECTION, drive_mask);
}


/* Enable or disable output driver of one channel. */
void rvlib_gpio_set_channel_drive(uint32_t base_addr, int channel, int drive)
{
    uint32_t mask = rvlib_hw_read_reg(base_addr + RVLIB_GPIO_REG_DIRECTION);
    mask = set_bit(mask, channel, drive);
    rvlib_hw_write_reg(base_addr + RVLIB_GPIO_REG_DIRECTION, mask);
}


/* Read input state of all channels. */
uint32_t rvlib_gpio_get_input(uint32_t base_addr)
{
    return rvlib_hw_read_reg(base_addr + RVLIB_GPIO_REG_INPUT);
}


/* Read input state of one channel. */
int rvlib_gpio_get_channel_input(uint32_t base_addr, int channel)
{
    uint32_t state = rvlib_hw_read_reg(base_addr + RVLIB_GPIO_REG_INPUT);
    return (state >> channel) & 1;
}


/* Get output state of all channels. */
uint32_t rvlib_gpio_get_output(uint32_t base_addr)
{
    return rvlib_hw_read_reg(base_addr + RVLIB_GPIO_REG_OUTPUT);
}


/* Set output state of all channels. */
void rvlib_gpio_set_output(uint32_t base_addr, uint32_t mask)
{
    rvlib_hw_write_reg(base_addr + RVLIB_GPIO_REG_OUTPUT, mask);
}


/* Set output state of one channel. */
void rvlib_gpio_set_channel_output(uint32_t base_addr, int channel, int state)
{
    uint32_t mask = rvlib_hw_read_reg(base_addr + RVLIB_GPIO_REG_OUTPUT);
    mask = set_bit(mask, channel, state);
    rvlib_hw_write_reg(base_addr + RVLIB_GPIO_REG_OUTPUT, mask);
}

/* end */
