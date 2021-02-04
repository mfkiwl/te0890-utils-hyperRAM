/*
 * Test program for RISC-V system.
 *
 * This program is designed to be compiled in freestanding mode
 * (without libc). It runs on a bare-metal RISC-V system,
 * using rvlib to access system peripherals.
 *
 * Written in 2021 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#include <stddef.h>
#include <stdint.h>
#include "rvlib_std.h"
#include "rvlib_hardware.h"
#include "rvlib_time.h"
#include "rvlib_gpio.h"
#include "rvlib_uart.h"


/*
 * Print a string to the console.
 */
static void print_str(const char *msg)
{
    while (*msg != '\0') {
        rvlib_putchar(*msg);
        msg++;
    }
}


/*
 * Print an unsigned integer to the console as a decimal number.
 */
static void print_uint(unsigned int val)
{
    char msg[12];
    char *p = msg + sizeof(msg) - 1;
    *p = '\0';
    do {
        p--;
        *p = '0' + val % 10;
        val /= 10;
    } while (val != 0);
    print_str(p);
}


/*
 * Flash the on-board LEDs.
 */
static void flash_leds(unsigned long delay)
{
    for (int i = 0; i < 10; i++) {
        rvlib_set_red_led(1);
        usleep(delay);
        rvlib_set_red_led(0);
        rvlib_set_green_led(1);
        usleep(delay);
        rvlib_set_green_led(0);
    }
}


/*
 * Main program.
 */
int main(void)
{
    unsigned int loop_cnt = 0;

    while (1) {

        // Turn red LED on.
        rvlib_set_red_led(1);

        // Print message.
        print_str("TE0890 RISC-V test\r\n");

        // Turn red LED off after 100 ms.
        usleep(100000);
        rvlib_set_red_led(0);

        // Print some more messages.
        loop_cnt += 1;
        print_str("testing ");
        print_uint(loop_cnt);
        print_str("\r\n");
        if (loop_cnt < (1<<16)) {
            print_str("  ");
            print_uint(loop_cnt);
            print_str(" * ");
            print_uint(loop_cnt);
            print_str(" = ");
            print_uint(loop_cnt * loop_cnt);
            print_str("\r\n");
        }

        // Flash LEDs.
        print_str("Flashing LEDs at 5 Hz\r\n");
        flash_leds(100000);
        print_str("Flashing LEDs at 1 Hz\r\n");
        flash_leds(500000);

        // Sleep for different durations.
        print_str("Sleeping for 1 second ... ");
        usleep(1000000);
        print_str("done\r\n");
        print_str("Sleeping for 2 seconds ... ");
        usleep(2000000);
        print_str("done\r\n");
        // Note: sleeps longer than 11 seconds have a special implementation.
        print_str("Sleeping for 12 seconds ... ");
        usleep(12000000);
        print_str("done\r\n");

        print_str("\r\n");
    }
 
    return 0;
}

