--
--  Pseudo Random Number Generator "xoshiro128+".
--
--  This is a 32-bit random number generator in synthesizable VHDL.
--  The generator can produce 64 new random bits on every clock cycle.
--
--  The algorithm "xoshiro128+" is by David Blackman and Sebastiano Vigna.
--  See also http://prng.di.unimi.it/
--
--  The generator requires a 128-bit seed value, not equal to zero.
--  A default seed must be supplied at compile time and will be used
--  to initialize the generator at reset. The generator also supports
--  re-seeding at run time.
--
--  After reset at least one clock cycle is needed before valid random
--  data appears on the output.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity random_gen is

    generic (
        -- Seed value.
        init_seed:  std_logic_vector(127 downto 0) );

    port (

        -- Clock, rising edge active.
        clk:        in  std_logic;

        -- Synchronous reset, active high.
        rst:        in  std_logic;

        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
        out_ready:  in  std_logic;

        -- High when valid random data is available on the output.
        -- This signal is low during the first clock cycle after reset and
        -- after re-seeding, and high in all other cases.
        out_valid:  out std_logic;

        -- Random output data (valid when out_valid = '1').
        -- A new random word appears after every rising clock edge
        -- where out_ready = '1'.
        out_data:   out std_logic_vector(31 downto 0) );

end entity;


architecture random_gen_arch of random_gen is

    -- Internal state of RNG.
    signal reg_state_s0:    unsigned(31 downto 0) := unsigned(init_seed(31 downto 0));
    signal reg_state_s1:    unsigned(31 downto 0) := unsigned(init_seed(63 downto 32));
    signal reg_state_s2:    unsigned(31 downto 0) := unsigned(init_seed(95 downto 64));
    signal reg_state_s3:    unsigned(31 downto 0) := unsigned(init_seed(127 downto 96));

    -- Output register.
    signal reg_valid:       std_logic := '0';
    signal reg_output:      std_logic_vector(31 downto 0) := (others => '0');

begin

    -- Drive output signal.
    out_valid   <= reg_valid;
    out_data    <= reg_output;

    -- Synchronous process.
    process (clk) is
    begin
        if rising_edge(clk) then

            if out_ready = '1' or reg_valid = '0' then

                -- Prepare output word.
                reg_valid       <= '1';
                reg_output      <= std_logic_vector(reg_state_s0 + reg_state_s3);

                -- Update internal state.
                reg_state_s0    <= reg_state_s0 xor reg_state_s1 xor reg_state_s3; 
                reg_state_s1    <= reg_state_s1 xor reg_state_s0 xor reg_state_s2;
                reg_state_s2    <= reg_state_s2 xor reg_state_s0 xor shift_left(reg_state_s1, 9);
                reg_state_s3    <= rotate_left(reg_state_s3 xor reg_state_s1, 11);
            end if;

            -- Synchronous reset.
            if rst = '1' then
                reg_state_s0    <= unsigned(init_seed(31 downto 0));
                reg_state_s1    <= unsigned(init_seed(63 downto 32));
                reg_state_s2    <= unsigned(init_seed(95 downto 64));
                reg_state_s3    <= unsigned(init_seed(127 downto 96));
                reg_valid       <= '0';
                reg_output      <= (others => '0');
            end if;

        end if;
    end process;

end architecture;