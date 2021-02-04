/*
 * Receive HEX file from serial port, store it in RAM, then execute it.
 *
 * This code is written in assembler to ensure it is self-contained
 * and position-independent. The routine is temporarily copied to
 * the end of RAM and executed there. That allows the incoming HEX
 * file to overwrite all other parts of memory.
 *
 * The incoming HEX file must not write anything to the last 512 bytes
 * of RAM, to avoid overwriting the temporary copy of the hexboot
 * helper function.
 *
 * Written in 2021 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

/* Disable linker relaxation. */
.option norelax

.text
.section .text, "ax", @progbits

/*
 * void bootmon_hexboot_helper(uint32_t uart_base_addr)
 *
 * x0 = fixed zero value
 * ra = return address
 * t0 - t6 = temporary
 * a0 - a7 = arguments and return values
 * s0 - s11 = preserved registers
 */
.global bootmon_hexboot_helper
bootmon_hexboot_helper:
    /*
     * This function copies itself to the end of RAM,
     * then runs there while loading a HEX file into the rest of the RAM.
     *
     * Register allocations within this function:
     *   s0 = uart_base_addr
     *   s1 = temporary location of hexboot helper code
     *   s2 = start address of HEX program
     *   s3 = current extended linear address
     *   s4 = current address within HEX file
     *   s5 = remaining data length of current HEX record
     *   s6 = partial checksum of current HEX record
     *   s7 = type of current HEX record
     *
     * This function can not use the stack.
     */

    /* Set s0 = uart_base_addr */
    mv      s0, a0

    /* Set default start address = start of RAM. */
    lui     s2, %hi(__ram)
    addi    s2, s2, %lo(__ram)

    /* Initialize extended linear address. */
    mv      s3, zero

    /* Initialize s1 = end of RAM (will be updated later). */
    lui     t0, %hi(__ram_size)
    addi    t0, t0, %lo(__ram_size)
    add     s1, s2, t0

    /* Disable interrupts. */
    li      t0, 0x88
    csrc    mstatus, t0

    /* Re-initialize stack pointer to end of RAM. */
    mv      sp, s1

    /*
     * Copy all code between .Lhexboot_continue and .Lhexboot_end
     * to the end of RAM.
     */
    la      a2, .Lhexboot_continue
    la      a1, .Lhexboot_end
.Lhexboot_copyloop:
    addi    a1, a1, -4
    lw      t0, (a1)
    addi    s1, s1, -4
    sw      t0, (s1)
    sltu    t0, a2, a1
    bnez    t0, .Lhexboot_copyloop

    /* Jump to new location of .Lhexboot_continue */
    fence.i
    jr      s1

    .align 4  /* force 4-byte alignment */
.Lhexboot_continue:

    /*
     * From this point on, the code is executing from its
     * temporary location at the end of RAM.
     */

    /*
     * Start reading a new line from the HEX file.
     * Skip loading white space, then read the ':' character.
     */
.Lhexboot_startline:
    jal     .Lhexboot_recv_char
    addi    t0, a0, -' '
    beqz    t0, .Lhexboot_startline
    addi    t0, a0, -'\n'
    beqz    t0, .Lhexboot_startline
    addi    t0, a0, -'\r'
    beqz    t0, .Lhexboot_startline
    addi    t0, a0, -':'
    bnez    t0, .Lhexboot_badhex

    /* Read the number of data bytes in this record. */
    jal     .Lhexboot_recv_hexbyte
    mv      s5, a0
    mv      s6, a0

    /* Read address of this record; merge with extended linear address. */
    jal     .Lhexboot_recv_hexbyte
    add     s6, s6, a0
    slli    a0, a0, 8
    or      s4, s3, a0
    jal     .Lhexboot_recv_hexbyte
    add     s6, s6, a0
    or      s4, s4, a0

    /* Read record type. */
    jal     .Lhexboot_recv_hexbyte
    add     s6, s6, a0
    mv      s7, a0

    /* Check that record type 0x04 (extended linear address) has length 2. */
    addi    t0, s7, -4
    addi    a0, s5, -2
    beqz    t0, .Lhexboot_checklen

    /* Check that record type 0x05 (start linear address) has length 4. */
    addi    t0, s7, -5
    addi    a0, s5, -4
    bnez    t0, .Lhexboot_nextbyte

.Lhexboot_checklen:
    bnez    a0, .Lhexboot_badhex

.Lhexboot_nextbyte:
    /* Check if we reached the end of the current record. */
    beqz    s5, .Lhexboot_read_checksum
    addi    s5, s5, -1

    /* Read the next data byte of the current record. */
    jal     .Lhexboot_recv_hexbyte
    add     s6, s6, a0

    /* Handle data byte depending on record type. */
    beqz    s7, .Lhexboot_handle_data
    addi    t0, s7, -4
    beqz    t0, .Lhexboot_handle_extaddr
    addi    t0, s4, -5
    beqz    t0, .Lhexboot_handle_startaddr

    /* Ignore unknown record type. */
    j       .Lhexboot_nextbyte

.Lhexboot_handle_data:
    /* Record type 0x00 (data). */
    sb      a0, (s4)
    addi    s4, s4, 1
    j       .Lhexboot_nextbyte

.Lhexboot_handle_extaddr:
    /* Record type 0x04 (extended linear address). */
    slli    a0, a0, 8
    or      s3, s3, a0
    slli    s3, s3, 8
    j       .Lhexboot_nextbyte

.Lhexboot_handle_startaddr:
    /* Record type 0x05 (start linear address). */
    slli    s2, s2, 8
    or      s2, s2, a0
    j       .Lhexboot_nextbyte

.Lhexboot_read_checksum:
    /* Read checksum byte. */
    jal     .Lhexboot_recv_hexbyte
    add     s6, s6, a0

    /* Verify checksum. */
    andi    s6, s6, 0xff
    bnez    s6, .Lhexboot_badhex

    /* Read end-of-line character. */
    jal     .Lhexboot_recv_char
    addi    t0, a0, -'\n'
    beqz    t0, .Lhexboot_endline
    addi    t0, a0, -'\r'
    bnez    t0, .Lhexboot_badhex

.Lhexboot_endline:
    /* Finished handling a line of the HEX file. */

    /* Write a '.' character to the serial port. */
    li      t0, '.'
    sw      t0, (s0)

    /* Go to the next line, unless this was record type 0x01 (end of file). */
    addi    t0, s7, -1
    bnez    t0, .Lhexboot_startline

    /* We just handled the last line of the HEX file. */

    /* Write "OK" message to serial port. */
    la      a0, .Lhexboot_msg_ok
    jal     .Lhexboot_print_str

    /* Jump to start address of HEX program. */
    fence.i
    jr      s2

.Lhexboot_badhex:
    /* There is something wrong with the HEX file. */
    /* Write "FAIL" message to serial port. */
    la     a0, .Lhexboot_msg_fail
    jal    .Lhexboot_print_str

    /* Halt execution. */
.Lhexboot_fail_loop:
    j      .Lhexboot_fail_loop

.Lhexboot_recv_hexbyte:
    /*
     * Subroutine: Receive two hex digits from the serial port.
     *
     * Returns:
     *   a0 = byte value
     *
     * Destroys: t0, t1, t2
     *
     * Jumps to .Lhexboot_badhex if the character is not a valid hex digit.
     */
    mv      t1, ra
    jal     .Lhexboot_recv_char
    jal     .Lhexboot_fromhex
    slli    t2, a0, 4
    jal     .Lhexboot_recv_char
    jal     .Lhexboot_fromhex
    or      a0, a0, t2
    jr      t1

.Lhexboot_recv_char:
    /*
     * Subroutine: Receive one character from the serial port.
     *
     * Returns:
     *   a0 = received character
     *
     * Destroys: t0
     */
    lw      a0, (s0)
    srli    t0, a0, 16
    andi    t0, t0, 1
    andi    a0, a0, 0xff
    beqz    t0, .Lhexboot_recv_char
    ret

.Lhexboot_fromhex:
    /*
     * Subroutine: Convert ASCII character to hexadecimal digit value.
     *
     * Parameters:
     *   a0 = ASCII character
     *
     * Returns:
     *   a0 = hex value of character
     *
     * Destroys: t0
     *
     * Jumps to .Lhexboot_badhex if the character is not a valid hex digit.
     */
    addi    a0, a0, -0x30
    bltz    a0, .Lhexboot_badhex
    addi    t0, a0, -10
    bltz    t0, .Lhexboot_fromhex_done
    addi    a0, a0, -0x11
    bltz    a0, .Lhexboot_badhex
    andi    a0, a0, ~0x20
    addi    t0, a0, -8
    bgez    t0, .Lhexboot_badhex
    addi    a0, a0, 10
.Lhexboot_fromhex_done:
    ret

.Lhexboot_print_str:
    /*
     * Subroutine: Send string to serial port.
     *
     * Parameters:
     *   a0 = address of string
     *
     * Destroys: a0, t0
     */
    lw      t0, 4(s0)
    srli    t0, t0, 15
    andi    t0, t0, 1
    bnez    t0, .Lhexboot_print_str
    lbu     t0, (a0)
    beqz    t0, .Lhexboot_print_str_done
    sw      t0, (s0)
    addi    a0, a0, 1
    j       .Lhexboot_print_str
.Lhexboot_print_str_done:
    ret

.Lhexboot_msg_ok:
    .asciz "OK\r\n"

.Lhexboot_msg_fail:
    .asciz "FAIL\r\n"

    .align 4  /* force 4-byte alignment */
.Lhexboot_end:

/* end */
