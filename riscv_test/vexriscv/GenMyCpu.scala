/*
 * Scala code to generate a Risc-V CPU with VexRiscv.
 *
 * ISA:        RV32I
 * Features:   static branch prediction,
 *             full barrel shifter,
 *             bypassed pipeline,
 *             rdcycle instruction.
 * Timing:     125 MHz on Spartan-7
 * Dhrystone:  1.01 DMIPS/MHz
 *
 * To generate VHDL code:
 *  - put this file in VexRiscv/src/main/scala/vexriscv/demo/GenMyCpu.scala
 *  - run sbt "runMain vexriscv.demo.GenMyCpu"
 *  - result will be written to "VexRiscv.vhd"
 */

package vexriscv.demo

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._

object GenMyCpu extends App {

  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new IBusSimplePlugin(
          resetVector = 0x80000000l,
          cmdForkOnSecondStage = true,
          cmdForkPersistence = false,
          prediction = STATIC,
          catchAccessFault = false,
          compressedGen = false
        ),
        new DBusSimplePlugin(
          catchAddressMisaligned = true,
          catchAccessFault = false
        ),
        new CsrPlugin(
          config = CsrPluginConfig.small(mtvecInit = 0x80000020l).copy(
            ucycleAccess = CsrAccess.READ_ONLY
          )
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = false
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new FullBarrelShifterPlugin(),
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = true,
          catchAddressMisaligned = true
        ),
        new DebugPlugin(
          debugClockDomain = ClockDomain.current.clone(reset = Bool().setName("debugReset")),
          hardwareBreakpointCount = 0
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )

  SpinalVhdl(cpu())
}

