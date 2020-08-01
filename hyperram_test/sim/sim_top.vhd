--
-- Simulation of RAM test with HyperRAM model.
--
-- This simulation requires a specific VHDL model for the HyperRAM device:
-- the S27KL0641 model, available from Cypress.
--
-- To run this simulation in a practical way:
--  * Temporarily modify the test driver to test only a small subset
--    of the memory space;
--  * Temporarily modify the top level to avoid waiting until
--    the RS232 driver is ready for the next character.
--

library ieee;
use ieee.std_logic_1164.all;

entity sim is
end entity;

architecture sim_arch of sim is

    signal clk100: std_logic := '0';
    signal s_led1: std_logic;
    signal s_led2: std_logic;
    signal s_ftdi: std_logic_vector(3 downto 0) := "ZZZZ";
    signal s_cs:   std_logic;
    signal s_rst:  std_logic;
    signal s_ck:   std_logic := 'Z';
    signal s_rwds: std_logic;
    signal s_dq:   std_logic_vector(7 downto 0);

begin

    clk100 <= (not clk100) after 5 ns;

    inst_top: entity work.memtest_top
        port map (
            clk_100m_pin    => clk100,
            led1            => s_led1,
            led2            => s_led2,
            ftdi            => s_ftdi,
            hr_cs_l         => s_cs,
            hr_rst_l        => s_rst,
            hr_ck           => s_ck,
            hr_rwds         => s_rwds,
            hr_dq           => s_dq );

    inst_hyperram: entity work.s27kl0641
        generic map (
            tpd_ck_rwds     => (others => 7 ns),
            tpd_ck_dq0      => (others => 7 ns),
            timingmodel     => "s27kl0641dabhi000"
        )
        port map (
            csneg           => s_cs,
            ck              => s_ck,
            resetneg        => s_rst,
            rwds            => s_rwds,
            dq0             => s_dq(0),
            dq1             => s_dq(1),
            dq2             => s_dq(2),
            dq3             => s_dq(3),
            dq4             => s_dq(4),
            dq5             => s_dq(5),
            dq6             => s_dq(6),
            dq7             => s_dq(7) );

end architecture;
