--
-- DDR input flipflop for Xilinx 7 Series FPGA.
--
-- This is just a simple wrapper for IDDR in same-edge-pipelined mode.
--


library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;


entity ff_iddr is

    port (
        -- Clock signal.
        clk:    in   std_logic;

        -- Input signal from IO buffer.
        d_in:   in   std_logic;

        -- Input bit captured on rising edge of "clk".
        -- This output updates at the rising edge of "clk".
        -- It reflects the input state captured during the rising "clk" edge
        -- before the most recent rising "clk" edge.
        q1:     out  std_logic;

        -- Input bit captured on the falling edge of "clk".
        -- This output updates at the rising edge of "clk".
        -- It reflects the input state captured during the falling "clk" edge
        -- before the most recent rising "clk" edge.
        -- This implies that "q1" was captured before "q2".
        q2:     out  std_logic
    );

end entity;


architecture arch_ff_iddr of ff_iddr is

begin

    inst_iddr: IDDR
        generic map (
            DDR_CLK_EDGE => "SAME_EDGE_PIPELINED" )
        port map (
            C  => clk,
            CE => '1',
            D  => d_in,
            Q1 => q1,
            Q2 => q2 );

end architecture;
