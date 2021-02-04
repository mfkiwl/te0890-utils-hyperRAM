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

    /* TODO : support trap handling */
    /* For now, we just loop here if a trap occurs. */
    j       __trap_vector


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
    j       _Exit

/* end */
