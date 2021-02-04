/*
 * Support code for running PicoLibC code on a bare-metal RISC-V system.
 *
 * Written in 2021 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */


#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include "rvlib_hardware.h"
#include "rvlib_uart.h"


/*
 * Dummy implementation of getpid() system call.
 *
 * This is required to support the PicoLibC abort() function.
 * And the abort() function is required to support C++ code.
 */
pid_t getpid(void)
{
    return 1;
}


/*
 * Dummy implementation of kill() system call.
 *
 * This is required to support the PicoLibC abort() function.
 * The kill() function does not have to do anything; the PicoLibC abort()
 * function will invoke _exit() if the kill() function returns.
 */
int kill(pid_t pid, int sig)
{
    return -1;
}


/*
 * Minimal implementation of write() system call.
 * This implementation writes output to STDOUT and STDERR to the console.
 *
 * This is required to support certain error conditions in libstdc++.
 */
ssize_t write(int fd, const void *buf, size_t count)
{
#ifdef RVLIB_DEFAULT_UART_ADDR
    if (fd == STDOUT_FILENO || fd == STDERR_FILENO) {
        const char *msg = buf;
        for (size_t i = 0; i < count; i++) {
            char c = msg[i];
            if (c == '\n')
                rvlib_putchar('\r');
            rvlib_putchar(c);
        }
        return count;
    }
#endif
    return -1;
}


#ifdef RVLIB_DEFAULT_UART_ADDR

/* Write character to serial port. */
static int my_stdio_putc(char c, FILE *file)
{
    if (c == '\n')
        rvlib_uart_send_byte(RVLIB_DEFAULT_UART_ADDR, '\r');
    rvlib_uart_send_byte(RVLIB_DEFAULT_UART_ADDR, c);
    return c;
}

/* Read character from serial port. */
static int my_stdio_getc(FILE *file)
{
    int c;
    do {
        c = rvlib_uart_recv_byte(RVLIB_DEFAULT_UART_ADDR);
    } while (c < 0);
    return c;
}

/*
 * Create a FILE instance to be used as stdin/stdout/stderr.
 */
static FILE __stdio = FDEV_SETUP_STREAM(my_stdio_putc,
                                        my_stdio_getc,
                                        NULL,
                                        _FDEV_SETUP_RW);

/*
 * Define stdin/stdout/stderr streams.
 *
 * This is necessary to support standard I/O in PicoLibC.
 */
FILE *const __iob[3] = { &__stdio, &__stdio, &__stdio };

#endif

/* end */
