--
-- DDR output flipflop for Xilinx 7 Series FPGA.
--
-- This is just a simple wrapper for ODDR in same-edge mode.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;


entity ff_oddr is

    port (
        -- Clock signal.
        clk:    in  std_logic;

        -- Output bit to present at the rising edge of "clk".
        -- This input is sampled at the rising edge of "clk" and immediately
        -- presented on the output.
        d1:     in  std_logic;

        -- Output bit to present at the falling edge of "clk".
        -- This input is sampled at the rising edge of "clk" and presented
        -- on the output at the subsequent falling edge of "clk".
        -- This implies that "d1" appears on the output before "d2".
        d2:     in  std_logic;

        -- Output signal to IO buffer.
        q_out:  out std_logic
    );

end entity;


architecture arch_ff_oddr of ff_oddr is

begin

    inst_oddr: ODDR
        generic map (
            DDR_CLK_EDGE => "SAME_EDGE" )
        port map (
            C  => clk,
            CE => '1',
            D1 => d1,
            D2 => d2,
            Q  => q_out );

end architecture;
