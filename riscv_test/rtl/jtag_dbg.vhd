--
-- JTAG debug bridge
--
-- This is a bridge between the JTAG port and the debug bus of the VexRiscv.
-- The JTAG protocol is compatible with the VexRiscv port of OpenOCD.
--
-- Two types of operations are supported:
--  - Initiate a read or write transaction on the debug bus;
--  - Poll the result of the immediately preceding read transaction.
--
-- Both operations are performed through the same JTAG instruction code.
-- The instruction value is determined by the parameters of the BSCANE2
-- instance.
--
-- To initiate a transaction, the debugger shifts 77 bits into the
-- data register via TDI, then goes through the Update-DR state.
-- Bits are shifted LSB first. The meaning of the bits is as follows:
--   bits 1:0   = "00" (initiate transaction)
--   bits 9:2   = "00000000" (header)
--   bits 41:10 = 32-bit address on debug bus
--   bits 73:42 = 32-bit data value (in case of write transaction)
--   bit  74    = '1' to write, '0' to read
--   bits 76:75 = transaction size (ignored, all transactions are 32-bit)
--
-- To poll the read result, the debugger goes through the Capture-DR state,
-- then shifts 36 bits through the data register. The first 2 bits are inputs
-- via TDI, the following 34 bits are outputs via TDO.
-- The meaning of the bits is as follows:
--   bits 1:0   = (tdi) "01" (poll result)
--   bit  2     = (tdo) '1' if read result is valid
--   bit  3     = (tdo) error flag (always '0')
--   bits 35:4  = (tdo) 32-bit read result
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rvsys.all;

entity jtag_dbg is

    port (
        -- System clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- JTAG interface
        jtag_drck:      in  std_logic;
        jtag_capture:   in  std_logic;
        jtag_shift:     in  std_logic;
        jtag_tdi:       in  std_logic;
        jtag_tdo:       out std_logic;

        -- Debug bus.
        dbg_cmd_valid:  out std_logic;
        dbg_cmd_ready:  in  std_logic;
        dbg_cmd_write:  out std_logic;
        dbg_cmd_addr:   out std_logic_vector(31 downto 0);
        dbg_cmd_wdata:  out std_logic_vector(31 downto 0);
        dbg_rsp_rdata:  in  std_logic_vector(31 downto 0)
    );

end entity;

architecture jtag_dbg_arch of jtag_dbg is

    type state_type is (
        State_Idle,
        State_Header1,
        State_Header2,
        State_Command,
        State_Read );

    -- Internal registers, clocked on system clock.
    type regs_type is record
        jt_toggle_prev: std_logic;
        jt_toggle:      std_logic;
        shift_cmd:      std_logic_vector(74 downto 0);
        shift_cnt:      unsigned(6 downto 0);
        shift_last:     std_logic;
        cmd_valid:      std_logic;
        cmd_write:      std_logic;
        cmd_addr:       std_logic_vector(31 downto 0);
        cmd_wdata:      std_logic_vector(31 downto 0);
        cmd_fire:       std_logic;
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(31 downto 0);
    end record;

    constant regs_init: regs_type := (
        jt_toggle_prev  => '0',
        jt_toggle       => '0',
        shift_cmd       => (others => '0'),
        shift_cnt       => (others => '0'),
        shift_last      => '0',
        cmd_valid       => '0',
        cmd_write       => '0',
        cmd_addr        => (others => '0'),
        cmd_wdata       => (others => '0'),
        cmd_fire        => '0',
        rsp_valid       => '0',
        rsp_rdata       => (others => '0'));

    -- Internal registers, clocked on JTAG clock.
    type regs_jtag_type is record
        state:          state_type;
        header:         std_logic_vector(1 downto 0);
        cmd_init:       std_logic;
        cmd_toggle:     std_logic;
        cmd_databit:    std_logic;
        rsp_valid:      std_logic;
        shift_read:     std_logic_vector(32 downto 0);
        tdo:            std_logic;
    end record;

    constant regs_jtag_init: regs_jtag_type := (
        state           => State_Idle,
        header          => "00",
        cmd_init        => '0',
        cmd_toggle      => '0',
        cmd_databit     => '0',
        rsp_valid       => '0',
        shift_read      => (others => '0'),
        tdo             => '0' );

    signal r: regs_type := regs_init;
    signal rjt: regs_jtag_type := regs_jtag_init;

    signal s_sync_cmd_init: std_logic;
    signal s_sync_cmd_toggle: std_logic;
    signal s_sync_cmd_databit: std_logic;

begin

    -- Synchronize signals from JTAG clock to system clock domain.
    sync_init: entity work.syncdff
        port map (
            clk => clk,
            di  => rjt.cmd_init,
            do  => s_sync_cmd_init );

    sync_toggle: entity work.syncdff
        port map (
            clk => clk,
            di  => rjt.cmd_toggle,
            do  => s_sync_cmd_toggle );

    sync_databit: entity work.syncdff
        port map (
            clk => clk,
            di  => rjt.cmd_databit,
            do  => s_sync_cmd_databit );

    -- Drive outputs.
    jtag_tdo <= rjt.tdo;
    dbg_cmd_valid <= r.cmd_valid;
    dbg_cmd_write <= r.cmd_write;
    dbg_cmd_addr <= r.cmd_addr;
    dbg_cmd_wdata <= r.cmd_wdata;

    --
    -- Synchronous process in JTAG clock domain.
    -- This clock is slow and often paused.
    --
    process (jtag_drck) is
        variable vjt: regs_jtag_type;
    begin
        -- By default, set next registers equal to current registers.
        vjt := rjt;

        if rising_edge(jtag_drck) then

            -- By default, drive '0' state to TDO.
            vjt.tdo := '0';

            -- By default, clear the start-of-command flag.
            vjt.cmd_init := '0';

            -- Capture read result valid flag from fast clock domain.
            vjt.rsp_valid := r.rsp_valid;

            if jtag_capture = '1' then

                -- The JTAG capture state resets the debug bridge flow.
                vjt.state := State_Header1;

                -- Indicate start of new command to the fast clock domain.
                vjt.cmd_init := '1';
                vjt.cmd_toggle := '0';

            elsif jtag_shift = '1' then

                case rjt.state is

                    when State_Header1 =>
                        vjt.header(0) := jtag_tdi;
                        vjt.state := State_Header2;

                    when State_Header2 =>
                        vjt.header(1) := jtag_tdi;
                        if vjt.header = "00" then
                            -- Prepare to push a bus transaction command to the fast clock domain.
                            vjt.state := State_Command;
                        elsif vjt.header = "01" then
                            -- Capture read result from fast clock domain.
                            -- Output "valid" bit via TDO.
                            -- Prepare to shift "error" flag and 32 data bits to TDO.
                            vjt.state := State_Read;
                            vjt.tdo := rjt.rsp_valid;
                            vjt.shift_read := r.rsp_rdata & "0";
                        else
                            -- Undefined header.
                            vjt.state := State_Idle;
                        end if;

                    when State_Command =>
                        -- Push the next command bit from TDI to the fast clock domain.
                        vjt.cmd_toggle := not rjt.cmd_toggle;
                        vjt.cmd_databit := jtag_tdi;

                    when State_Read =>
                        -- Shift the next read data bit to TDO.
                        vjt.tdo := rjt.shift_read(0);
                        vjt.shift_read := "0" & rjt.shift_read(rjt.shift_read'high downto 1);

                    when others =>
                        -- Got undefined command. Wait for next capture state.
                        vjt.state := State_Idle;

                end case;

            end if;

            -- Update registers.
            rjt <= vjt;

        end if;
    end process;

    --
    -- Synchronous process in system clock domain.
    -- This clock is fast and regular.
    --
    process (clk) is
        variable v: regs_type;
    begin
        -- By default, set next registers equal to current registers.
        v := r;

        if rising_edge(clk) then

            v.jt_toggle_prev := r.jt_toggle;
            v.jt_toggle := s_sync_cmd_toggle;
            v.shift_last := '0';

            if s_sync_cmd_init = '1' then

                -- Reset bit stream from JTAG clock domain.
                v.shift_cnt := (others => '0');

            elsif r.jt_toggle /= r.jt_toggle_prev then

                -- Clear read data valid flag.
                v.rsp_valid := '0';

                -- Capture command bit stream from JTAG clock domain.
                if r.shift_cnt < 75 then
                    v.shift_cmd := s_sync_cmd_databit & r.shift_cmd(r.shift_cmd'high downto 1);
                    v.shift_cnt := r.shift_cnt + 1;
                    if r.shift_cnt = 74 then
                        v.shift_last := '1';
                    end if;
                end if;

            end if;

            -- Push new command to debug bus.
            if dbg_cmd_ready = '1' then
                v.cmd_valid := '0';
            end if;
            if r.shift_last = '1' then
                v.cmd_valid := '1';
                v.cmd_addr  := r.shift_cmd(39 downto 8);
                v.cmd_wdata := r.shift_cmd(71 downto 40);
                v.cmd_write := r.shift_cmd(72);
            end if;

            -- Handle debug command completion.
            v.cmd_fire := r.cmd_valid and dbg_cmd_ready;
            if r.cmd_fire = '1' then
                v.rsp_valid := '1';
                v.rsp_rdata := dbg_rsp_rdata;
            end if;

            -- Synchronous reset of debug bus interface.
            if rst = '1' then
                v := regs_init;
            end if;

            -- Update registers.
            r <= v;

        end if;
    end process;

end architecture;
