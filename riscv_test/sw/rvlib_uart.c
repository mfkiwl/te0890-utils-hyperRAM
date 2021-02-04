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

#include "rvlib_hardware.h"
#include "rvlib_uart.h"


#define RVLIB_UART_REG_DATA         0
#define RVLIB_UART_REG_CTRL         4
#define RVLIB_UART_BIT_DATA_RXVALID 16
#define RVLIB_UART_BIT_CTRL_TXBUSY  15


/* Send character through UART. */
void rvlib_uart_send_byte(uint32_t base_addr, uint8_t b)
{
    uint32_t ctrl;

    /* Wait until TX buffer empty. */
    do {
        ctrl = rvlib_hw_read_reg(base_addr + RVLIB_UART_REG_CTRL);
    } while (ctrl & (1 << RVLIB_UART_BIT_CTRL_TXBUSY));

    rvlib_hw_write_reg(base_addr + RVLIB_UART_REG_DATA, b);
}


/* Return received character, or return -1 if no character available. */
int rvlib_uart_recv_byte(uint32_t base_addr)
{
    uint32_t b = rvlib_hw_read_reg(base_addr + RVLIB_UART_REG_DATA);
    if (b & (1 << RVLIB_UART_BIT_DATA_RXVALID)) {
        return (b & 0xff);
    } else {
        return -1;
    }
}


#ifdef RVLIB_DEFAULT_UART_ADDR
/* Write a byte to the default UART. */
int rvlib_putchar(int c)
{
    c &= 0xff;
    rvlib_uart_send_byte(RVLIB_DEFAULT_UART_ADDR, c);
    return c;
}
#endif

/* end */
