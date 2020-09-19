
  VexRiscv configuration for TE0890
  =================================

The RISC-V test design for the TE0889 is based on VexRiscv.

VexRiscv is a configurable RISC-V processor designed in SpinalHDL.
It is available on GitHub:
  https://github.com/SpinalHDL/VexRiscv

Systems based on VexRiscv are designed in SpinalHDL (a hardware-specification
language based on Scala). To implement a SpinalHDL design, the code is
first compiled into a Scala program. Executing that program generates
a synthesizable VHDL file.

SpinalHDL can be used to design a complete SoC system including a processor
and all peripherals. However for this RISC-V test design, I want to design
the bus system and peripherals directly in VHDL. The processor will be
just one entity within the overall VHDL system. Therefore, my SpinalHDL
design contains only the configuration of the VexRiscv processor.

The file "GenMyCpu.scala" describes the VexRiscv configuration.
The file "VexRiscv.vhd" contains the corresponding VHDL code.


  Generating VexRiscv
  -------------------

The steps below explain what must be done to regenerate the VHDL code
for the VexRiscv processor. This explanation is aimed at people like
myself who have never used SpinalHDL before.

Note that the VHDL code is included in this repository, so these steps
are only needed when you want to change the processor configuration.

These steps are for Debian Linux 10 on x86_64:

 1. Install OpenJDK 11:

    # apt install openjdk-11-jdk

 2. Install sbt (Scala build tool):

    Go to https://www.scala-sbt.org/ and download sbt-1.3.13.zip.
    Unzip the file in some suitable location:

    $ unzip sbt-1.3.13.zip

 3. Download VexRiscv:

    $ git clone https://github.com/SpinalHDL/VexRiscv.git

 4. Copy the file GenMyCpu.scala to the VexRiscv tree:

    $ cd VexRiscv
    $ cp {some-path}/riscv_test/vexriscv/GenMyCpu.scala src/main/scala/vexriscv/demo

 5. Compile the SpinalHDL code:

    $ {some-path}/sbt/bin/sbt "runMain vexriscv.demo.GenMyCpu"

    When running for the first time, sbt will automatically download
    a large number of packages including a Scala compiler and SpinalHDL.

    Eventually, sbt should report running "vexriscv.demo.GenMyCpu"
    and completing successfully.

    The result should be a file "VexRiscv.vhd" in the current directory.
    This is the VHDL code for the processor.


  License
  -------

VexRiscv is licensed under the MIT License.
See the file "LICENSE" for the complete copyright statement.

--
