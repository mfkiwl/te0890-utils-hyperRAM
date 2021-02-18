/*
 * Linker script for RISC-V embedded software image.
 *
 * The image expects to be loaded in RAM at address 0x80000000.
 * By default, the RAM size is assumed to be 64 kByte.
 * Note that __ram_size must match the actual amount of RAM available
 * in the target system.
 *
 * Thread-local storage is not supported.
 * C++ exception handling is not supported.
 *
 * Memory map:
 *
 *   0x80000000 = _start
 *       .text.init.enter: start of initialization code
 *
 *   0x80000020 = _trap_vector
 *       .text.init.trap_vector: trap/interrupt handling (TBD)
 *
 *   0x8000xxxx
 *       .text:       initialization / application code
 *       .init_array: table of initialization functions
 *       .fini_array: table of cleanup functions
 *       .data:       initialized global data
 *       .bss:        uninitialized global data
 *       ._user_heap: heap space
 *       .stack:      stack space
 */

OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)

ENTRY(_start)

/*
 * __ram must match the absolute address of on-chip RAM.
 * __ram_size must match the actual on-chip RAM size of the platform.
 * __stack_size must be set to the required stack size for the application.
 *
 * These are defaults; modify as needed.
 */
__ram = DEFINED(__ram) ? __ram : 0x80000000;
__ram_size = DEFINED(__ram_size) ? __ram_size : 64k;
__stack_size = DEFINED(__stack_size) ? __stack_size : 512;


MEMORY {
    /*
     * Description of the RAM area for program image and data.
     * Adjust the LENGTH attribute to match the size of
     * the on-chip RAM area in the SoC design.
     */
    ram (rwx) : ORIGIN = __ram, LENGTH = __ram_size
}

SECTIONS {

    .text ORIGIN(ram) : {

        /*
         * First part of startup code must be at 0x80000000.
         */
        KEEP( *(.text.init.enter) )

        /*
         * Trap vector must be at 0x80000020.
         * The trap handling code is only emitted if the application
         * implements interrupt handling.
         * Otherwise the dummy handler will take its place.
         */
        . = _start + 0x20;
        *(.text.trap_vector)
        KEEP( *(.text.trap_dummy) )

        /* Rest of the startup code. */
        *(.text.startup)

        /* All other application code. */
        KEEP( *(.init .init.*) )
        *(.text .text.*)
        *(.gnu.linkonce.t.*)
        KEEP( *(.fini) )

    } >ram

    PROVIDE( __etext = . );
    PROVIDE( _etext = . );
    PROVIDE( etext = . );

    /* Table of initialization function pointers. */
    .init_array : ALIGN(4) {
        PROVIDE( __preinit_array_start = . );
        KEEP( *(.preinit_array) )
        PROVIDE( __preinit_array_end = . );
        PROVIDE( __init_array_start = . );
        KEEP( *(SORT_BY_INIT_PRIORITY(.init_array.*)) )
        KEEP( *(SORT_BY_INIT_PRIORITY(.ctors.*)) )
        KEEP( *(.init_array EXCLUDE_FILE(*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o) .ctors) )
        PROVIDE( __init_array_end = . );
    } >ram

    /* Table of cleanup function pointers. */
    .fini_array : ALIGN(4) {
        __fini_array_start = .;
        KEEP( *(SORT_BY_INIT_PRIORITY(.fini_array.*)) )
        KEEP( *(SORT_BY_INIT_PRIORITY(.dtors.*)) )
        KEEP( *(.fini_array EXCLUDE_FILE(*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o) .dtors) )
        __fini_array_end = .;
    } >ram

    /* Initialized data. */
    .data : ALIGN(4) {

        /* The PicoLibc startup code needs __data_start */
        PROVIDE( __data_start = . );

        *(.rodata .rodata.* .gnu.linkonce.r.*)
        *(.data .data.* .gnu.linkonce.d.*)
        *(.got .got.*)

        /* Group small data object together. */
        *(.srodata.cst16)
        *(.srodata.cst8)
        *(.srodata.cst4)
        *(.srodata.cst2)
        *(.srodata .srodata.*)
        *(.sdata .sdata.* .gnu.linkonce.s.*)

    } >ram

    _edata = .;
    PROVIDE( edata = . );

    /*
     * Assign the global pointer for efficient access to at least
     * the last 4 kByte of .data, but preferably to all of .data
     * and the beginning of .bss.
     */
    PROVIDE( __global_pointer$ = MAX(__data_start + 0x800, _edata - 0x800) );

    /* Uninitialized data. */
    .bss (NOLOAD) : ALIGN(4) {

        /* The startup code uses __bss_start to clear .bss. */
        PROVIDE( __bss_start = . );

        *(.sbss .sbss.* .gnu.linkonce.sb.*)
        *(.scommon)
        *(.bss .bss.* .gnu.linkonce.b.*)
        *(COMMON)

        . = ALIGN(4);
        PROVIDE( __bss_end = . );

    } >ram

    PROVIDE( __bss_size = __bss_end - __bss_start );

    _end = .;
    PROVIDE( end = . );

    /* Heap area. */
    ._user_heap (NOLOAD) : ALIGN(16) {
        PROVIDE( __heap_start = . );
        . = (ORIGIN(ram) + LENGTH(ram) - __stack_size) & (~15);
        PROVIDE( __heap_end = . );
    } >ram

    PROVIDE (__heap_size = __heap_end - __heap_start);

    /* Stack area. */
    .stack (NOLOAD) : ALIGN(16) {

        . += __stack_size;
        . = ALIGN(16);

        /* The startup code uses __stack to initialize the stack pointer. */
        PROVIDE( __stack = . );
    } >ram

    /* Discard C++ exception handling information. */
    /DISCARD/ : {
        *(.eh_frame .eh_frame.*)
        *(.note .note.*)
    }

    /*
     * The PicoLibc startup code needs these symbols to copy initialized
     * data from flash to RAM. Since we are running from RAM only,
     * we set __data_size = 0 to skip the copy process.
     */
    PROVIDE( __data_source = __data_start );
    PROVIDE( __data_size = 0 );

}
