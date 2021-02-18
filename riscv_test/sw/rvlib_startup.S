/*
 * Start-up code for RISC-V embedded software.
 *
 * Written in 2020 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

.text
.section .text.init.enter, "ax", @progbits
/*
 * This section should be mapped into memory such that the symbol "_start"
 * corresponds to the reset vector of the RISC-V processor.
 *
 * This section must be at most 32 bytes to keep room for the trap vector.
 */

.global _start
_start:
    /* The processor will start executing here after reset. */

.option push
.option norelax  /* temporarily disable linker relaxation */

    /* Initialize global pointer register. */
    la      gp, __global_pointer$

    /* Initialize stack pointer. */
    la      sp, __stack

.option pop  /* restore original options */

    /* Jump to rest of startup code. */
    j       __start_continue


.section .text.trap_vector, "ax", @progbits
/*
 * This section should be mapped into memory such that
 * the symbol "_trap_vector" corresponds to the trap vector
 * of the RISC-V processor.
 */

.global __trap_vector
__trap_vector:
    /* The processor starts executing here after a trap or interrupt. */

    /* Push the caller-save registers on the stack. */
    addi   sp, sp, -64
    sw     ra, (sp)
    sw     t0, 4(sp)
    sw     t1, 8(sp)
    sw     t2, 12(sp)
    sw     a0, 16(sp)
    sw     a1, 20(sp)
    sw     a2, 24(sp)
    sw     a3, 28(sp)
    sw     a4, 32(sp)
    sw     a5, 36(sp)
    sw     a6, 40(sp)
    sw     a7, 44(sp)
    sw     t3, 48(sp)
    sw     t4, 52(sp)
    sw     t5, 56(sp)
    sw     t6, 60(sp)

    /* Call the trap handler. */
    csrr   a0, mcause
    csrr   a1, mbadaddr
    lui    t0, 0x80000
    addi   t0, t0, 3
    beq    a0, t0, .Ltrap_sw_int
    addi   t0, t0, 4
    beq    a0, t0, .Ltrap_timer_int
    addi   t0, t0, 4
    beq    a0, t0, .Ltrap_ext_int
    call   handle_unexpected_trap
    j      .Ltrap_done

.Ltrap_sw_int:
    call   handle_software_interrupt
    j      .Ltrap_done

.Ltrap_timer_int:
    call   handle_timer_interrupt
    j      .Ltrap_done

.Ltrap_ext_int:
    call   handle_external_interrupt

.Ltrap_done:
    /* Restore the saved registers. */
    lw     ra, (sp)
    lw     t0, 4(sp)
    lw     t1, 8(sp)
    lw     t2, 12(sp)
    lw     a0, 16(sp)
    lw     a1, 20(sp)
    lw     a2, 24(sp)
    lw     a3, 28(sp)
    lw     a4, 32(sp)
    lw     a5, 36(sp)
    lw     a6, 40(sp)
    lw     a7, 44(sp)
    lw     t3, 48(sp)
    lw     t4, 52(sp)
    lw     t5, 56(sp)
    lw     t6, 60(sp)
    addi   sp, sp, 64

    /* Return from interrupt. */
    mret

/*
 * Weak default definitions of the trap handlers.
 * These simply loop forever, thus halting the program.
 */
.weak handle_software_interrupt
.weak handle_timer_interrupt
.weak handle_external_interrupt
handle_software_interrupt:
handle_timer_interrupt:
handle_external_interrupt:
    tail    handle_unexpected_trap

.weak handle_unexpected_trap
handle_unexpected_trap:
.Ltrap_loop:
    j       .Ltrap_loop


.section .text.trap_dummy, "ax", @progbits
/*
 * This section provides a dummy trap handler which simply loops forever.
 * In a program that does not support trap handling, the full trap handler
 * from the previous section will not be emitted by the linker.
 * In that case, this dummy handler will make sure that the program halts
 * cleanly if an unexpected trap occurs.
 */

.Ltrap_dummy:
    j       .Ltrap_dummy


.section .text.startup, "ax", @progbits
/*
 * This section contains the rest of the startup code.
 * It can be mapped anywhere in memory.
 */

__start_continue:

    /* Clear the BSS data segment. */
    la      a0, __bss_start
    la      a1, __bss_end
    beq     a0, a1, .Lclear_bss_done
.Lclear_bss_loop:
    sw      zero, 0(a0)
    addi    a0, a0, 4
    bne     a0, a1, .Lclear_bss_loop
.Lclear_bss_done:

    /* Call GCC static initialization/constructors. */
    la      s1, __preinit_array_start
.Linit_array_loop:
    la      a1, __init_array_end
    beq     s1, a1, .Linit_array_done
    lw      a2, 0(s1)
    addi    s1, s1, 4
    jalr    a2
    j       .Linit_array_loop
.Linit_array_done:

    /* Call main(0, NULL) */
    mv      a0, zero
    mv      a1, zero
    call    main

    /* When main() returns, execution will fall through into _Exit(). */

/*
 * void _Exit(int exitcode)
 *
 * Halt the program by looping forever.
 * We also come here when the application returns from the main() function.
 */
.global _Exit
.global _exit
_Exit:
_exit:

    /* Disable interrupts. */
    csrci   mstatus, 8

    /* Loop forever. */
.Lexit_loop:
    j       .Lexit_loop

/* end */
