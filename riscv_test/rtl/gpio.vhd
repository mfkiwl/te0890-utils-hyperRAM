--
-- GPIO controller for simple processor system
--
-- Partial-word writes (byte, half-word) are not supported.
--
-- Register map:
--   address 0: (read-only)  captured input signals
--   address 4: (read-write) active output signals
--   address 8: (read-write) input/output direction flags (0=input, 1=output)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rvsys.all;


entity gpio is

    port (
        -- System clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- GPIO input/output/tri-state signals.
        gpio_i:         in  std_logic_vector(31 downto 0);
        gpio_o:         out std_logic_vector(31 downto 0);
        gpio_t:         out std_logic_vector(31 downto 0);

        -- Bus interface signals.
        slv_input:      in  bus_slv_input_type;
        slv_output:     out bus_slv_output_type
    );

end entity;

architecture gpio_arch of gpio is

    -- Internal registers.
    type regs_type is record
        reg_input:      std_logic_vector(31 downto 0);
        reg_output:     std_logic_vector(31 downto 0);
        reg_direction:  std_logic_vector(31 downto 0);
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(31 downto 0);
    end record;

    constant regs_init: regs_type := (
        reg_input       => (others => '0'),
        reg_output      => (others => '0'),
        reg_direction   => (others => '0'),
        rsp_valid       => '0',
        rsp_rdata       => (others => '0'));

    signal r: regs_type := regs_init;
    signal rnext: regs_type;

begin

    -- Drive outputs.
    gpio_o      <= r.reg_output;
    gpio_t      <= not r.reg_direction;
    slv_output  <= ( cmd_ready => '1',
                     rsp_valid => r.rsp_valid,
                     rsp_rdata => r.rsp_rdata );

    -- Asynchronous process.
    process (all) is
        variable v: regs_type;
    begin
        -- By default, set next registers equal to current registers.
        v := r;

        -- Capture input signals.
        v.reg_input     := gpio_i;

        -- Handle write transactions.
        if (slv_input.cmd_valid = '1') and (slv_input.cmd_write = '1') then
            if slv_input.cmd_addr(3 downto 2) = "01" then
                -- addr 4 = output register
                v.reg_output    := slv_input.cmd_wdata;
            end if;
            if slv_input.cmd_addr(3 downto 2) = "10" then
                -- addr 8 = direction register
                v.reg_direction := slv_input.cmd_wdata;
            end if;
        end if;

        -- Handle read transactions.
        v.rsp_valid     := slv_input.cmd_valid and (not slv_input.cmd_write);
        case slv_input.cmd_addr(3 downto 2) is
            when "01" =>
                -- addr 4 = output register
                v.rsp_rdata     := r.reg_output;
            when "10" =>
                -- addr 8 = direction register
                v.rsp_rdata     := r.reg_direction;
            when others =>
                -- input register
                v.rsp_rdata     := r.reg_input;
        end case;

        -- Synchronous reset.
        if rst = '1' then
            v.reg_output    := (others => '0');
            v.reg_direction := (others => '0');
            v.rsp_valid     := '0';
        end if;

        -- Drive new register values to synchronous process.
        rnext	<= v;

    end process;

    -- Synchronous process.
    process (clk) is
    begin
        if rising_edge(clk) then
            r <= rnext;
        end if;
    end process;

end architecture;
