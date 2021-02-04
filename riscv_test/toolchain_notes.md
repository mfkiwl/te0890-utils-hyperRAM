# Notes on building a C compiler toolchain for RISC-V

## Introduction

This document is a step-by-step guide for building a C/C++ cross-compiler
toolchain for the RISC-V processor.

The purpose of this toolchain is to compile small programs that will run
on a *bare metal* embedded RV32I processor without an operating system.
The compiled code should be able to run with very tight memory constraints,
for example 16 kByte total memory for code and data.

The toolchain is based on GCC with GNU binutils.
The obvious alternative would be Clang+LLVM, but it appears that
GCC currently has better suppor for RISC-V.

The toolchain can be used as a "freestanding" C compiler without
any standard C library. In this case, the application must provide
its own linker script and support functions.

Alternatively, the toolchain can be used with PicoLibc, a C library
for small embedded platforms. The obvious alternative would be Newlib.
However, PicoLibc seems better suited for bare metal platforms.

The toolchain has limited support for C++ code. The C++ standard library
is built with support for exception handling.


## References

This guide borrows heavily from other sources.

 - See https://github.com/riscv/riscv-gnu-toolchain
   for another RISC-V toolchain guide, aimed at Linux.

 - See http://www.ifp.illinois.edu/~nakazato/tips/xgcc.html
   for a general procedure for building GCC cross-compilers.

 - See https://www.sifive.com/blog/all-aboard-part-0-introduction
   for a series of posts about RISC-V aspects of toolchains: relocation,
   linker relaxation, memory models.

 - See https://github.com/picolibc/picolibc
   for documentation of the PicoLibc library.

 - See https://gcc.gnu.org/onlinedocs/gcc/Standards.html
   for a description of the "freestanding" mode of GCC.


## Step 1: Install tools

This guide assumes that the toolchain will be installed on a Linux PC.
The exact commands listed here are suitable for Debian GNU/Linux 10.

 - Install tools required to build GCC:
   ```
   $ sudo apt install 
         build-essential autoconf automake autotools-dev libtool \
         gawk flex bison libmpc-dev libmpfr-dev libgmp-dev zlib1g-dev texinfo
   ```

 - Install tools required to build PicoLibc:
   ```
   $ sudo apt install ninja-build python3-pip
   $ sudo pip3 install meson
   ```

 - Install tools required for OpenOCD:
   ```
   $ sudo apt install libusb-1.0.0-dev libusb-dev libyaml-dev pkg-config
   ```


## Step 2: Build binutils

 - Create directory where the toolchain will be installed:
   ```
   $ mkdir /opt/riscv32_toolchain
   ```

 - Download binutils 2.36:
   ```
   $ wget https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.xz
   ```

 - Build binutils:
   ```
   $ tar xf binutils-2.36.tar.xz
   $ mkdir b-binutils
   $ cd b-binutils
   $ ../binutils-2.36/configure \
         --target=riscv32-none-elf \
         --prefix=/opt/riscv32_toolchain
   $ make
   $ make install
   ```

 - Add cross tools to path for next steps:
   ```
   $ PATH=$PATH:/opt/riscv32_toolchain/bin
   ```


## Step 3: Build GCC (C only)

This step builds GCC, but only the C compiler.
We can not yet build the C++ compiler because it depends on libc.

We configure GCC without support for threads or thread-local-storage.

 - Download GCC 10.2:
   ```
   $ wget ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-10.2.0/gcc-10.2.0.tar.xz
   ```

 - Build GCC:
   ```
   $ tar xf gcc-10.2.0.tar.xf
   $ mkdir b-gcc
   $ cd b-gcc
   $ ../gcc-10.2.0/configure \
         --target=riscv32-none-elf \
         --prefix=/opt/riscv32_toolchain \
         --with-arch=rv32i \
         --disable-multilib \
         --enable-languages=c \
         --disable-shared \
         --disable-threads \
         --disable-tls \
         --disable-libssp \
         --disable-libquadmath \
         --disable-tm-clone-registry \
         --enable-target-optspace \
         --with-newlib \
         --without-headers
   $ make
   $ make install
   ```


## Step 4: Build PicoLibc

This step is optional.
If you only want to compile bare metal C code in "freestanding" mode,
this step can be skipped.

PicoLibc is based on Newlib, but modified and partly rewritten
to target small embedded systems with limited RAM.

 - Download PicoLibc 1.5.1:
   ```
   $ wget https://github.com/picolibc/picolibc/releases/download/1.5.1/picolibc-1.5.1.tar.xz
   ```

 - Unpack PicoLibc:
   ```
   $ tar xf picolibc-1.5.1.tar.xz
   ```

 - Prepare a cross compilation configuration file.
   The file can be named for example `picolibc-1.5.1/cross-riscv32.txt`.
   This file should contain the following lines:
   ```
   [binaries]
   c = 'riscv32-none-elf-gcc'
   ar = 'riscv32-none-elf-ar'
   as = 'riscv32-none-elf-as'
   ld = 'riscv32-none-elf-ld'
   strip = 'riscv32-none-elf-strip'

   [host_machine]
   system = 'none'
   cpu_family = 'riscv'
   cpu = 'riscv32'
   endian = 'little'

   [properties]
   c_args = [ '-nostdlib', '-march=rv32i' ]
   needs_exe_wrapper = true
   skip_sanity_check = true
   ```

 - Build PicoLibc:
   ```
   $ mkdir b-picolibc
   $ cd b-picolibc
   $ meson \
         --prefix=/opt/riscv32_toolchain \
         --cross-file "../picolibc-1.5.1/cross-riscv32.txt" \
         -Dfast-strcmp=false \
         -Dmultilib=false \
         -Datomic-ungetc=false \
         -Dposix-io=false \
         -Dthread-local-storage=false \
         ../picolibc-1.5.1
   $ ninja
   $ ninja install
   ```


## Step 5: Build GCC with C++ support

This step rebuilds GCC with support for C and C++.

The C++ standard library is built without support for exceptions.
This means that any situation that would normally cause the standard library
to throw an exception, will instead abort the program (by calling `abort()`).

 - Rebuild GCC:
   ```
   $ rm -r b-gcc
   $ mkdir b-gcc
   $ cd b-gcc
   $ ../gcc-10.2.0/configure \
         --target=riscv32-none-elf \
         --prefix=/opt/riscv32_toolchain \
         --with-arch=rv32i \
         --disable-multilib \
         --enable-languages=c,c++ \
         --enable-cxx-flags="-fno-exceptions" \
         --disable-shared \
         --disable-threads \
         --disable-tls \
         --disable-libssp \
         --disable-libquadmath \
         --disable-tm-clone-registry \
         --enable-target-optspace \
         --with-newlib \
         --with-headers=/opt/riscv32_toolchain/include
   $ make
   $ make install
   ```


## Usage

The toolchain can be used as a freestanding C compiler to build applications
that do not use the standard C library. To do this, add the compiler flag
`-ffreestanding` and the linker flag `-nostdlib`.
In this case the application must provide its own linker script,
its own startup code (`crt0.S`)
and its own support functions such as `memcpy()`.

For example:
```
$ riscv32-none-elf-gcc -Wall -Os -ffreestanding -c hello.c
$ riscv32-none-elf-gcc -Wall -Os -ffreestanding -c crt0.S
$ riscv32-none-elf-gcc -nostdlib -T linker.ld -o hello.elf \
      hello.o crt0.o -lgcc
```

Alternatively, the toolchain can be used with PicoLibc. To do this, add
the flag `-specs=picolibc.specs` when invoking the compiler and linker.

Since the programs runs without an operating system, and PicoLibc knows
nothing about the hardware platform, the application must provide custom
functions for low-level I/O handling. For example, when the application
uses `printf()`, it must provide a low-level function to write a character.

It will also be necessary to define the proper memory map for the
target hardware platform, either by providing a custom linker script
or by configuring the PicoLibc linker script.

For example:
```
$ riscv32-none-elf-gcc -specs=picolibc.specs -Wall -Os -o hello.elf hello.c
```

See https://github.com/picolibc/picolibc/blob/1.5.1/doc/os.md
for an explanation of the required low-level functions.

See https://github.com/picolibc/picolibc/blob/1.5.1/doc/printf.md
for a way to configure the features of the printf function.

See https://github.com/picolibc/picolibc/blob/1.5.1/doc/linking.md
for a description of linker scripts.

The toolchain can be used to compile C++ applications, using PicoLibc
as the underlying C library. The previous remarks about PicoLibc apply
also in this case.

The C++ standard library tends to pull in references to low-level functions 
such as `_exit`, `getpid` and `kill`. These must be implemented by the
application. Simple dummy implementations can be used.

For example:
```
$ riscv32-none-elf-g++ -specs=picolibc.specs -Wall -Os -o hello.elf hello.cpp
```


## Indication of code size

Approximate code size of very short C/C++ programs built with PicoLibc.

| program contents     | code size |
|----------------------|-----------|
| return 0             |    504 bytes |
| printf, integer only |   3376 bytes |
| printf, full         |  12872 bytes |
| C++, return 0        |    504 bytes |
| C++, iostream        | 134732 bytes |
| C++, class, new, delete | 1472 bytes |

