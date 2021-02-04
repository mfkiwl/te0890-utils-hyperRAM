/*
 * UART device driver.
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

/* Send a character through the UART. */
void rvlib_uart_send_byte(uint32_t base_addr, uint8_t b);

/* Return a received character, or return -1 if no character is available. */
int rvlib_uart_recv_byte(uint32_t base_addr);

/* Write a byte to the default UART. */
int rvlib_putchar(int c);

/* end */
