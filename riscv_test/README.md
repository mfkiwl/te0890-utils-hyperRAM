# RISC-V soft-core processor

This design implements a RISC-V soft-core processor on the TE0890 board.

To control my TE0890 module, I want to run small C programs inside
the FPGA. Many types of functionality are much easier to program in C
than in VHDL, for example flash programming, Ethernet protocols, etc.

The RISC-V looks like an ideal candidate for this purpose. The instruction
set is simple but powerful, C compilers and tools are readily available,
and soft-core FPGA implementations of RISC-V are available as open-source.

For more information about RISC-V: \
  https://riscv.org/

For more information about VexRiscv: \
  https://github.com/SpinalHDL/VexRiscv


## Design

The heart of the design is the VexRiscv, a highly configurable RISC-V
soft-core designed by the SpinalHDL team. I configured the processor
to support only the basic RV32I instruction set (no multiply instruction,
no compressed instructions, no floating point).

The system bus of the RISC-V processor is attached to 64 kByte RAM
and to several I/O peripherals. The RAM is used both for instructions
and for data. The peripherals provide access to an UART (the FTDI pins
of the TE0890 module), to the on-board LEDs and to GPIO pins.

The design, including the RISC-V and peripherals, runs at 100 MHz.


## Features

The following seems to be working nicely:
 - RISC-V RV32I processor
 - 64 kByte RAM
 - UART (serial port)
 - GPIO and LEDs
 - timer
 - running small C programs
 - interrupt handling
 - remote debugging with GDB

The following is on my TODO list (and may or may not get done at some point):
 - access to TE0890 flash chip
 - access to HyperRAM


## Usage

Running this design on a TE0890 board is easy.
Use Vivado to open the project file `riscv_test/vivado/riscv_test.xpr`. \
Click *Generate Bitstream* to build the design.

Attach an USB-serial-port cable to the "FTDI" pins of the TE0890 board.
Open the serial port and configure for 115200 bps, 8N1, no flow control.

Then program the bitfile to the TE0890 board via JTAG.
This should start the built-in *boot monitor* program on the RISC-V,
which should immediately print output via the serial port.

The boot monitor has an interactive command prompt which can
be controlled via the serial port.

For example, this command should turn on the green LED on the TE0870 board:
```
>> led green on
OK
```

When you get bored from playing with the boot monitor, you can use
the `hexboot` command to load another program:
```
>> hexboot
Reading HEX data ...
```

Immediately following the `hexboot` command, the boot monitor expects
to read an IHEX file through the serial port.
It loads the file into the RISC-V RAM, overwriting the boot monitor code,
then starts running the loaded program.
The last 512 bytes of RAM are reserved for the HEX loading code and
must not be overwritten by the HEX file.

An easier way to load and run programs is remote debugging with GDB
via the JTAG port.
This requires setting up GDB and OpenOCD;
see [toolchain_notes.md](toolchain_notes.md) for how to do that.

Once OpenOCD is running, start GDB and run a program like this:
```
$ riscv-none-elf-gdb
(gdb) target extended-remote localhost:3333
(gdb) monitor reset halt
(gdb) load hello.elf
(gdb) cont
```


## Software

To run C code on the RISC-V, we need a compiler.
Fortunately, GCC can be built as a cross compiler for RISC-V.
See the file [toolchain_notes.md](toolchain_notes.md) for a guide
on how to set up a suitable RISC-V toolchain.

The directory [sw/](sw/) contains source code for a bunch of small
programs that can run on our RISC-V test system:
 - [bootmon.c](sw/bootmon.c) is the boot monitor program.
 - [hello.c](sw/hello.c) is a simple bare metal test program.
 - [hello_picolibc.c](sw/hello_picolibc.c) is a simple test program which uses printf and libm.
 - [hello_cpp.cpp](sw/hello_cpp.cpp) is a simple C++ test program. 

To compile these programs, first set up the toolchain, then just run `make`
in the software directory.

The software directory contains a custom linker script which places
the compiled code in the right address range to run from the RISC-V
block RAM.
By default, this linker script assumes tat the RAM size is 64 kByte.
It is not necessary to have so much RAM; a lot of useful things could be
done with a program that fits in 16 kByte.
However, if you change the RAM size in the top-level VHDL design,
you must also change it in the linker file.

The RISC-V is hardcoded to start executing instructions at address `0x80000000`
when it starts up.
The top-level VHDL code configures the initial contents of the RAM such
that it contains the boot monitor program.
As a result, the RISC-V starts running the boot monitor as soon as
the FPGA is programmed.


## Repository structure

| Path                    | Description |
|-------------------------|-------------|
| [vexriscv/](vexriscv/)  | VexRiscv model and resulting VHDL code |
| [rtl/](rtl/)            | VHDL code for top-level and system peripherals |
| [vivado/](vivado/)      | Vivado project files and constraints |
| [sw/](sw/)              | Software to run on the RISC-V processor |


## License

This RISC-V test system consists of several components, some of which
were designed by other people:

 - The RISC-V processor is an implementation of VexRiscv.
   The VexRiscv copyright belongs to the Spinal HDL contributors.
   VexRiscv is licensed under the MIT License.
   See the file [vexriscv/LICENSE](vexriscv/LICENSE) for
   the complete copyright statement.

   See <https://github.com/SpinalHDL/VexRiscv/> for the original VexRiscv code.

 - Some of the software examples use PicoLibc.
   PicoLibc is licensed under several variants of the BSD license.a

   See <https://github.com/picolibc/picolibc> for the PicoLibc source code.

 - Everything else, including the VHDL code in the "rtl" directory
   and the software in the "sw" directory is written by Joris van Rantwijk.
   These parts are released under the CC0 1.0 license.

   To the extent possible under law, the author has dedicated all copyright
   and related and neighboring rights to this software to the public domain
   worldwide. This software is distributed without any warranty.

   See <http://creativecommons.org/publicdomain/zero/1.0/>

