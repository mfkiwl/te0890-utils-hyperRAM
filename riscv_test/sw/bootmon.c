/*
 * Boot monitor program for RISC-V system.
 *
 * This program accepts text commands via the serial port.
 * It can be used to test a few simple things in the RISC-V system.
 * It also supports a command that can be used to upload
 * a program file into the RISC-V memory and start executing it.
 *
 * This program can be useful as a default program image
 * to execute when the RISC-V system starts up.
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


/* Hexboot helper function (written in assembler). */
extern void bootmon_hexboot_helper(uint32_t uart_base_addr);


static char scratchbuf[40];


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
/*static*/ void print_uint(unsigned int val)
{
    char *p = scratchbuf + sizeof(scratchbuf) - 1;
    *p = '\0';
    do {
        p--;
        *p = '0' + val % 10;
        val /= 10;
    } while (val != 0);
    print_str(p);
}


/*
 * Print a 64-bit unsigned integer to the console as a decimal number.
 */
static void print_uint64(uint64_t val)
{
    char *p = scratchbuf + sizeof(scratchbuf) - 1;
    *p = '\0';
    do {
        p--;
        *p = '0' + val % 10;
        val /= 10;
    } while (val != 0);
    print_str(p);
}


/* Print end-of-line characters to the console. */
static void print_endln(void)
{
    rvlib_putchar('\r');
    rvlib_putchar('\n');
}


/* Read one line of text from the serial port. */
static void read_command(char *cmdbuf, size_t maxlen, int cmd_echo)
{
    size_t pos = 0;

    while (1) {

        // Read next character.
        int c;
        do {
            c = rvlib_uart_recv_byte(RVLIB_DEFAULT_UART_ADDR);
        } while (c == -1);

        // Check for CR or LF to end the command.
        if (c == '\r' || c == '\n') {
            break;
        }

        // Replace TAB by space.
        if (c == '\t') {
            c = ' ';
        }

        if (c == '\b') {
            // Handle backspace.
            if (pos > 0) {
                pos--;
            }
        } else if (pos + 1 < maxlen) {
            // Add character to command buffer.
            cmdbuf[pos] = c;
            pos++;
        } else {
            // Ignore characters while command buffer is full.
            continue;
        }

        // Echo the command character.
        if (cmd_echo) {
            rvlib_putchar(c);
        }
    }

    // Mark end of command string.
    cmdbuf[pos] = '\0';
}


/* Simplify a received command:
   convert to lower case and strip redundant white space. */
void simplify_command(char *cmdbuf)
{
    char *pdst = cmdbuf;
    char *psrc = cmdbuf;
    int got_ws = 0;

    while (*psrc == ' ') {
        psrc++;
    }

    while (*psrc != '\0') {
        char c = *psrc;
        psrc++;
        if (c == ' ') {
            got_ws = 1;
        } else {
            if (got_ws) {
                *pdst = ' ';
                pdst++;
                got_ws = 0;
            }
            if (c >= 'A' && c <= 'Z') {
                c |= 0x20;
            }
            *pdst = c;
            pdst++;
        }
    }

    *pdst = '\0';
}


/* Show instruction cycle counter. */
void show_rdcycle(void)
{
    uint64_t cycles = get_cycle_counter();
    print_str("RDCYCLE = ");
    print_uint64(cycles);
    print_endln();
}


/* Show GPIO input state. */
void show_gpio_input(void)
{
    for (int gpio_index = 0; gpio_index < 2; gpio_index++) {
        print_str("GPIO");
        print_uint(gpio_index + 1);
        rvlib_putchar('=');

        uint32_t base_addr =
            (gpio_index == 0) ? RVSYS_ADDR_GPIO1 : RVSYS_ADDR_GPIO2;
        rvlib_gpio_set_drive(base_addr, 0);
        usleep(1000);
        
        for (int i = 0; i < 32; i++) {
            int v = rvlib_gpio_get_channel_input(base_addr, i);
            rvlib_putchar('0' + v);
        }
        rvlib_putchar(' ');
    }
    print_endln();
}


/* Repeatedly show GPIO input state until Enter received from console. */
void watch_gpio_input(void)
{
    print_str("Watching GPIO, press Enter to stop ...\r\n");
    while (1) {
        show_gpio_input();
        usleep(100000);
        int c = rvlib_uart_recv_byte(RVLIB_DEFAULT_UART_ADDR);
        if (c == '\r' || c == '\n') {
            break;
        }
    }
}


/*
 * Test GPIO input/output.
 * This test assumes that the actual FPGA I/O pins are floating.
 */
static void test_gpio_inout(void)
{
    for (int gpio_index = 0; gpio_index < 2; gpio_index++) {

        print_str("Testing GPIO");
        print_uint(gpio_index + 1);
        rvlib_putchar(' ');

        uint32_t base_addr =
            (gpio_index == 0) ? RVSYS_ADDR_GPIO1 : RVSYS_ADDR_GPIO2;
        rvlib_gpio_set_drive(base_addr, 0xffffffff);

        int ok = 1;

        for (int invert = 0; invert <= 1; invert++) {

            rvlib_putchar('.');

            uint32_t bgpattern = (invert) ? 0xffffffff : 0;
            rvlib_gpio_set_output(base_addr, bgpattern);

            for (int i = 0; i < 32; i++) {

                rvlib_gpio_set_channel_output(base_addr, i, !invert);
                usleep(100);

                uint32_t v = rvlib_gpio_get_input(base_addr);
                if (v != (bgpattern ^ (1 << i))) {
                    ok = 0;
                }

                rvlib_gpio_set_channel_output(base_addr, i, invert);
                usleep(100);

                v = rvlib_gpio_get_input(base_addr);
                if (v != bgpattern) {
                    ok = 0;
                }
            }
        }

        rvlib_putchar('.');

        rvlib_gpio_set_drive(base_addr, 0);

        if (ok) {
            print_str(" OK\r\n");
        } else {
            print_str(" FAIL\r\n");
        }
    }
}


/*
 * Very simple memory access test.
 *
 * This could potentially catch issues where write transactions
 * are incorrectly mapped to byte-enable signals.
 */
void test_mem_access(void)
{
    static volatile uint32_t testbuf[2];
    int ok = 1;

    print_str("Testing memory access ... ");

    // Init test buffer.
    memcpy((uint32_t*)testbuf, "abcd0123", 8);

    // Check word size read access.
    int w0 = 0x64636261;
    int w1 = 0x33323130;
    if (testbuf[0] != w0 || testbuf[1] != w1) {
        ok = 0;
    }

    for (int i = 0; i < 8; i++) {

        // Check byte size read access.
        unsigned char c = ((volatile unsigned char *)testbuf)[i];
        unsigned char x = (i < 4) ? (0x61 + i) : (0x30 + i - 4);
        if (c != x) {
            ok = 0;
        }

        // Byte size write access.
        ((volatile unsigned char *)testbuf)[i] = ~c;

        // Check effect of byte write on word read.
        if (i < 4) {
            w0 ^= (0xff << (8 * i));
        } else {
            w1 ^= (0xff << (8 * i - 32));
        }
        if (testbuf[0] != w0 || testbuf[1] != w1) {
            ok = 0;
        }
        
    }

    for (int i = 0; i < 4; i++) {

        // Check uint16 read access.
        uint16_t v = ((volatile uint16_t *)testbuf)[i];
        uint16_t x = (i == 0) ? 0x6261 :
                     (i == 1) ? 0x6463 :
                     (i == 2) ? 0x3130 : 0x3332;
        if (v != (x ^ 0xffff)) {
            ok = 0;
        }

        // uint16 write access.
        ((volatile uint16_t *)testbuf)[i] = ~v;

        // Check effect of uint16 write on word read.
        if (i < 2) {
            w0 ^= (0xffff << (16 * i));
        } else {
            w1 ^= (0xffff << (16 * i - 32));
        }
        if (testbuf[0] != w0 || testbuf[1] != w1) {
            ok = 0;
        }
        
    }

    if (ok) {
        print_str("OK\r\n");
    } else {
        print_str("FAIL\r\n");
    }
}


/* Load and execute HEX file. */
void do_hexboot(void)
{
    print_str("Reading HEX data ... ");
    bootmon_hexboot_helper(RVSYS_ADDR_UART);
}


/* Handle "led ..." subcommand. */
static int set_led_subcommand(const char *cmdbuf)
{
    const char *pcmd = cmdbuf;
    int led_channel;
    int led_state;

    if (strncmp(pcmd, "red ", 4) == 0) {
        led_channel = RVLIB_LED_RED_CHANNEL;
        pcmd += 4;
    } else if (strncmp(pcmd, "green ", 6) == 0) {
        led_channel = RVLIB_LED_GREEN_CHANNEL;
        pcmd += 6;
    } else {
        return -1;
    }

    if (strncmp(pcmd, "on", 3) == 0) {
        led_state = 1;
    } else if (strncmp(pcmd, "off", 4) == 0) {
        led_state = 0;
    } else {
        return -1;
    }

    rvlib_set_led(led_channel, led_state);
    return 1;
}


/* Handle "setgpioN ..." subcommand. */
static int set_gpio_subcommand(const char *cmdbuf)
{
    const char *pcmd = cmdbuf;
    uint32_t base_addr;
    int gpio_channel = 0;
    int gpio_state;

    while (*pcmd == ' ') {
        pcmd++;
    }

    if (*pcmd == '1') {
        base_addr = RVSYS_ADDR_GPIO1;
    } else if (*pcmd == '2') {
        base_addr = RVSYS_ADDR_GPIO2;
    } else {
        return -1;
    }
    pcmd++;

    if (*pcmd != ' ') {
        return -1;
    }
    pcmd++;

    do {
        char c = *pcmd;
        if (c < '0' || c > '9') {
            return -1;
        }
        gpio_channel = 10 * gpio_channel + c - '0';
        pcmd++;
    } while (*pcmd != ' ');
    pcmd++;

    if (*pcmd == '0') {
        gpio_state = 0;
    } else if (*pcmd == '1') {
        gpio_state = 1;
    } else if (*pcmd == 'z') {
        gpio_state = -1;
    } else {
        return -1;
    }
    pcmd++;

    if (*pcmd != '\0') {
        return -1;
    }

    if (gpio_channel > 31) {
        return -1;
    }

    int drive = (gpio_state >= 0);
    if (drive) {
        rvlib_gpio_set_channel_output(base_addr, gpio_channel, gpio_state);
    }
    rvlib_gpio_set_channel_drive(base_addr, gpio_channel, drive);

    return 1;
}

void show_help(void)
{
    print_str(
        "Commands:\r\n"
        "  help                     - Show this text\r\n"
        "  echo {on|off}            - Enable or disable command echo\r\n"
        "  led {red|green} {on|off} - Turn LED on or off\r\n"
        "  rdcycle                  - Show instruction cycle counter\r\n"
        "  getgpio                  - Show GPIO input state\r\n"
        "  watchgpio                - Watch GPIO input state\r\n"
        "  setgpio{1|2} {0..31} {0|1|Z} - Set GPIO output pin state\r\n"
        "  testgpio                 - Test GPIO input/output\r\n"
        "  testmem                  - Test simple memory access\r\n"
        "  hexboot                  - Load and execute HEX file\r\n"
        "\r\n");
}


void command_loop(void)
{
    static char cmdbuf[80];
    int cmd_echo = 1;

    while (1) {

        // Show prompt.
        print_str(">> ");

        // Read command.
        read_command(cmdbuf, sizeof(cmdbuf), cmd_echo);
        if (cmd_echo) {
            print_endln();
        }

        // Process command.
        simplify_command(cmdbuf);

        int ret = 0;

        if (strncmp(cmdbuf, "help", sizeof(cmdbuf)) == 0) {
            show_help();
        } else if (strncmp(cmdbuf, "echo on", sizeof(cmdbuf)) == 0) {
            cmd_echo = 1;
            ret = 1;
        } else if (strncmp(cmdbuf, "echo off", sizeof(cmdbuf)) == 0) {
            cmd_echo = 0;
            ret = 1;
        } else if (strncmp(cmdbuf, "led ", 4) == 0) {
            ret = set_led_subcommand(cmdbuf + 4);
        } else if (strncmp(cmdbuf, "rdcycle", sizeof(cmdbuf)) == 0) {
            show_rdcycle();
        } else if (strncmp(cmdbuf, "getgpio", sizeof(cmdbuf)) == 0) {
            show_gpio_input();
        } else if (strncmp(cmdbuf, "watchgpio", sizeof(cmdbuf)) == 0) {
            watch_gpio_input();
        } else if (strncmp(cmdbuf, "setgpio", 7) == 0) {
            ret = set_gpio_subcommand(cmdbuf + 7);
        } else if (strncmp(cmdbuf, "testgpio", sizeof(cmdbuf)) == 0) {
            test_gpio_inout();
        } else if (strncmp(cmdbuf, "testmem", sizeof(cmdbuf)) == 0) {
            test_mem_access();
        } else if (strncmp(cmdbuf, "hexboot", sizeof(cmdbuf)) == 0) {
            do_hexboot();
        } else if (cmdbuf[0] != '\0') {
            ret = -1;
        }

        if (ret < 0) {
            print_str("ERROR: unknown command\r\n");
        } else if (ret > 0) {
            print_str("OK\r\n");
        }
    }
}


int main(void)
{
    rvlib_set_red_led(1);
    print_str("TE0890 RISC-V boot monitor\r\n\r\n");
    usleep(10000);
    rvlib_set_red_led(0);

    show_help();
    command_loop();

    return 0;
}
