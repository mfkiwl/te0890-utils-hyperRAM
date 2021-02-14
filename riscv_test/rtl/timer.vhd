--
-- Timer peripheral for simple processor system
--
-- The 64-bit register MTIME counts up by one count per system clock cycle.
-- The 64-bit register MTIMECMP marks the time of the next interrupt.
-- The interrupt signal is high whenever MTIME >= MTIMECMP.
--
-- The 64-bit registers are accessed as two 32-bit words.
-- Partial-word writes (byte, half-word) are not supported.
--
-- Reads and writes of the 64-bit register are not atomic
-- because they are broken down into 32-bit word accesses.
-- Software must be prepared to deal with this.
--
-- Register map:
--   address  0 (read-write): Bits 31-0 of the MTIME register.
--   address  4 (read-write): Bits 63-32 of the MTIME register.
--   address  8 (read-write): Bits 31-0 of the MTIMECMP register.
--   address 12 (read-write): Bits 63-32 of the MTIMECMP register.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rvsys.all;


entity timer is

    port (
        -- System clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- Interrupt signal.
        interrupt:      out std_logic;

        -- Bus interface signals.
        slv_input:      in  bus_slv_input_type;
        slv_output:     out bus_slv_output_type
    );

end entity;

architecture timer_arch of timer is

    -- Internal registers.
    type regs_type is record
        reg_mtime:      std_logic_vector(63 downto 0);
        reg_mtimecmp:   std_logic_vector(63 downto 0);
        interrupt_out:  std_logic;
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(31 downto 0);
    end record;

    constant regs_init: regs_type := (
        reg_mtime       => (others => '0'),
        reg_mtimecmp    => (others => '1'),
        interrupt_out   => '0',
        rsp_valid       => '0',
        rsp_rdata       => (others => '0'));

    signal r: regs_type := regs_init;
    signal rnext: regs_type;

begin

    -- Drive outputs.
    interrupt   <= r.interrupt_out;
    slv_output  <= ( cmd_ready => '1',
                     rsp_valid => r.rsp_valid,
                     rsp_rdata => r.rsp_rdata );

    -- Asynchronous process.
    process (all) is
        variable v: regs_type;
    begin
        -- By default, set next registers equal to current registers.
        v := r;

        -- Increment counter.
        v.reg_mtime := std_logic_vector(unsigned(r.reg_mtime) + 1);

        -- Handle write transactions.
        if (slv_input.cmd_valid = '1') and (slv_input.cmd_write = '1') then
            case slv_input.cmd_addr(3 downto 2) is
                when "00" =>
                    -- addr 0 = low 32 bits of MTIME
                    v.reg_mtime(31 downto 0) := slv_input.cmd_wdata;
                when "01" =>
                    -- addr 4 = high 32 bits of MTIME
                    v.reg_mtime(63 downto 32) := slv_input.cmd_wdata;
                when "10" =>
                    -- addr 8 = low 32 bits of MTIMECMP
                    v.reg_mtimecmp(31 downto 0) := slv_input.cmd_wdata;
                when others =>
                    -- addr 12 = high 32 bits of MTIMECMP
                    v.reg_mtimecmp(63 downto 32) := slv_input.cmd_wdata;
            end case;
        end if;

        -- Handle read transactions.
        v.rsp_valid := slv_input.cmd_valid and (not slv_input.cmd_write);
        case slv_input.cmd_addr(3 downto 2) is
            when "00" =>
                -- addr 0 = low 32 bits of MTIME
                v.rsp_rdata := r.reg_mtime(31 downto 0);
            when "01" =>
                -- addr 4 = high 32 bits of MTIME
                v.rsp_rdata := r.reg_mtime(63 downto 32);
            when "10" =>
                -- addr 8 = low 32 bits of MTIMECMP
                v.rsp_rdata := r.reg_mtimecmp(31 downto 0);
            when others =>
                -- addr 12 = high 32 bits of MTIMECMP
                v.rsp_rdata := r.reg_mtimecmp(63 downto 32);
        end case;

        -- Time comparison and interrupt output signal.
        if unsigned(r.reg_mtime) >= unsigned(r.reg_mtimecmp) then
            v.interrupt_out := '1';
        else
            v.interrupt_out := '0';
        end if;

        -- Synchronous reset.
        if rst = '1' then
            v := regs_init;
        end if;

        -- Drive new register values to synchronous process.
        rnext <= v;

    end process;

    -- Synchronous process.
    process (clk) is
    begin
        if rising_edge(clk) then
            r <= rnext;
        end if;
    end process;

end architecture;
