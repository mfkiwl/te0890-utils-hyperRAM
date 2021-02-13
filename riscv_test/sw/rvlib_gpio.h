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

#ifndef RVLIB_GPIO_H_
#define RVLIB_GPIO_H_

#include <stdint.h>


/* Set the output driver enable flags of all channels. */
void rvlib_gpio_set_drive(uint32_t base_addr, uint32_t drive_mask);

/* Enable or disable output driver of one channel. */
void rvlib_gpio_set_channel_drive(uint32_t base_addr, int channel, int drive);

/* Read input state of all channels. */
uint32_t rvlib_gpio_get_input(uint32_t base_addr);

/* Read input state of one channel. */
int rvlib_gpio_get_channel_input(uint32_t base_addr, int channel);

/* Get output state of all channels. */
uint32_t rvlib_gpio_get_output(uint32_t base_addr);

/* Set output state of all channels. */
void rvlib_gpio_set_output(uint32_t base_addr, uint32_t mask);

/* Set output state of one channel. */
void rvlib_gpio_set_channel_output(uint32_t base_addr, int channel, int state);

#ifdef RVSYS_ADDR_LEDS

/* Turn the specified LED on or off. */
static inline void rvlib_set_led(int led, int state)
{
    rvlib_gpio_set_channel_output(RVSYS_ADDR_LEDS, led, state);
}

/* Turn the red LED on or off. */
static inline void rvlib_set_red_led(int state)
{
    rvlib_gpio_set_channel_output(RVSYS_ADDR_LEDS,
                                  RVLIB_LED_RED_CHANNEL,
                                  state);
}

/* Turn the green LED on or off. */
static inline void rvlib_set_green_led(int state)
{
    rvlib_gpio_set_channel_output(RVSYS_ADDR_LEDS,
                                  RVLIB_LED_GREEN_CHANNEL,
                                  state);
}

#endif  // RVSYS_ADDR_LEDS
#endif  // RVLIB_GPIO_H_
