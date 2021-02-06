--
--  Double flip-flop synchronizer.
--

library ieee;
use ieee.std_logic_1164.all;
library xpm;
use xpm.vcomponents.all;

entity syncdff is

    port (
        -- Clock (destination domain).
        clk:        in  std_logic;

        -- Input data (asynchronous).
        di:         in  std_logic;

        -- Output data, synchronous to "clk".
        do:         out std_logic
    );

end entity;

architecture rtl of syncdff is

begin

    inst: xpm_cdc_single
        generic map (
            DEST_SYNC_FF  => 2,
            SRC_INPUT_REG => 0 )
        port map (
            dest_clk  => clk,
            dest_out  => do,
            src_clk   => '0',
            src_in    => di );

end architecture;
