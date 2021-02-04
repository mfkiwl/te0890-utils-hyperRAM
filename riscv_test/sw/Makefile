#
# Makefile for compiling software to run on the RISC-V system.
#

# Select cross compiler.
CROSS = riscv32-none-elf-
CC      = $(CROSS)gcc
CXX     = $(CROSS)g++
OBJCOPY = $(CROSS)objcopy

# Target instruction set: RV32I (no atomics, no floating point).
TARGET_FLAGS = -march=rv32i

# General C compiler flags:
#   -Wall                (enable warnings)
#   -O2                  (optimize, appears to produce smaller code than -Os)
#   -ffunction-sections  (allows discarding unused functions)
CFLAGS_GENERAL = -Wall -O2 -ffunction-sections

# Flags specific for compiling in freestanding mode (without libc).
CFLAGS_freestanding  = -ffreestanding
ASFLAGS_freestanding =
LDFLAGS_freestanding = -nostdlib -Wl,--gc-sections
LDLIBS_freestanding  = -lgcc

# Flags specific for compiling with PicoLibc.
CFLAGS_picolibc  = -specs=picolibc.specs
ASFLAGS_picolibc = -specs=picolibc.specs
LDFLAGS_picolibc = -specs=picolibc.specs -nostartfiles
LDLIBS_picolibc  =

# Final flags for compiler, assembler, linker.
CFLAGS   = $(TARGET_FLAGS) $(CFLAGS_GENERAL) $(CFLAGS_$(ccmode))
CXXFLAGS = $(TARGET_FLAGS) $(CFLAGS_GENERAL) -fno-exceptions $(CFLAGS_$(ccmode))
ASFLAGS  = $(TARGET_FLAGS) $(ASFLAGS_$(ccmode))
LDFLAGS  = $(TARGET_FLAGS) $(LDFLAGS_$(ccmode))
LDLIBS   = $(LDLIBS_$(ccmode))


# Default target.
.PHONY: all
all: bootmon.hex hello.hex hello_picolibc.hex hello_cpp.hex


#
# ---- Rules to build the support library ----
#

RVLIB_HDRS = rvlib_std.h \
             rvlib_hardware.h \
             rvlib_time.h \
             rvlib_gpio.h \
             rvlib_uart.h

RVLIB_OBJS = rvlib_startup.o \
             rvlib_std.o \
             rvlib_time.o \
             rvlib_gpio.o \
             rvlib_uart.o

# Build the library in freestanding mode.
$(RVLIB_OBJS): ccmode = freestanding

rvlib_startup.o: rvlib_startup.S
rvlib_std.o: rvlib_std.c rvlib_std.h
rvlib_time.o: rvlib_time.c rvlib_time.h rvlib_hardware.h
rvlib_uart.o: rvlib_uart.c rvlib_uart.h rvlib_hardware.h
rvlib_gpio.o: rvlib_gpio.c rvlib_gpio.h rvlib_hardware.h


#
# ---- Rules to build the boot monitor program ----
#

BOOTMON_OBJS = bootmon.o bootmon_hexboot.o $(RVLIB_OBJS)

# Build the program in freestanding mode.
bootmon.elf bootmon.o bootmon_hexboot.o: ccmode = freestanding

# Compile main program.
bootmon.o: bootmon.c $(RVLIB_HDRS)
bootmon_hexboot.o: bootmon_hexboot.S

# Link final program image.
bootmon.elf: $(BOOTMON_OBJS) linker.ld
	$(CC) $(LDFLAGS) -T linker.ld -o $@ $(BOOTMON_OBJS) $(LDLIBS)

# Convert program image to HEX file.
bootmon.hex: bootmon.elf
	$(OBJCOPY) -O ihex $< $@


#
# ---- Rules to build the hello test program ----
#

HELLO_OBJS = hello.o $(RVLIB_OBJS)

# Build the program in freestanding mode.
hello.elf hello.o: ccmode = freestanding

# Compile main program.
hello.o: hello.c $(RVLIB_HDRS)

# Link final program image.
hello.elf: $(HELLO_OBJS) linker.ld
	$(CC) $(LDFLAGS) -T linker.ld -o $@ $(HELLO_OBJS) $(LDLIBS)

# Convert program image to HEX file.
hello.hex: hello.elf
	$(OBJCOPY) -O ihex $< $@


#
# ---- Rules to build the PicoLibC support code ----
#

RVLIB_PICOLIBC_OBJS = rvlib_startup.o \
                      rvlib_time.o \
                      rvlib_gpio.o \
                      rvlib_uart.o \
                      picolibc_support.o

# Compile the PicoLibC support functions.
picolibc_support.o: ccmode = picolibc
picolibc_support.o: picolibc_support.c $(RVLIB_HDRS)


#
# ---- Rules to build the PicoLibc test program ----
#

HELLO_PICOLIBC_OBJS = hello_picolibc.o $(RVLIB_PICOLIBC_OBJS)

# Compile main program.
hello_picolibc.o: ccmode = picolibc
hello_picolibc.o: hello_picolibc.c

# Link final program image.
hello_picolibc.elf: ccmode = picolibc
#hello_picolibc.elf: LDFLAGS += -DPICOLIBC_INTEGER_PRINTF_SCANF
hello_picolibc.elf: LDLIBS = -lm
hello_picolibc.elf: $(HELLO_PICOLIBC_OBJS) linker.ld
	$(CC) $(LDFLAGS) -T linker.ld -o $@ $(HELLO_PICOLIBC_OBJS) $(LDLIBS)

# Convert program image to HEX file.
hello_picolibc.hex: hello_picolibc.elf
	$(OBJCOPY) -O ihex $< $@


#
# ---- Rules to build the C++ test program ----
#

HELLO_CPP_OBJS = hello_cpp.o $(RVLIB_PICOLIBC_OBJS)

# Compile main program.
hello_cpp.o: ccmode = picolibc
hello_cpp.o: hello_cpp.cpp

# Link final program image.
hello_cpp.elf: ccmode = picolibc
hello_cpp.elf: $(HELLO_CPP_OBJS) linker.ld
	$(CXX) $(LDFLAGS) -T linker.ld -o $@ $(HELLO_CPP_OBJS) $(LDLIBS)

# Convert program image to HEX file.
hello_cpp.hex: hello_cpp.elf
	$(OBJCOPY) -O ihex $< $@


#
# ---- Pattern rules ----
#

# Rule for compiling C code.
%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

# Rule for compiling C++ code.
%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

# Rule for compiling assembler code.
%.o: %.S
	$(CC) $(CPPFLAGS) $(ASFLAGS) -c $<


#
# ---- Utility rules ----
#

# Cleanup.
.PHONY: clean
clean:
	$(RM) -- bootmon.elf bootmon.hex 
	$(RM) -- hello.elf hello.hex
	$(RM) -- hello_picolibc.elf hello_picolibc.hex
	$(RM) -- hello_cpp.elf hello_cpp.hex
	$(RM) -- *.o

