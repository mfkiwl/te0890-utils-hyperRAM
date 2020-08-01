--
-- Test design for HyperRAM on Trenz TE0890 Spartan-7 Mini.
--
-- This design runs a simple, continuous memory test on the
-- on-board HyperRAM memory. It can be used to check that the
-- HyperRAM interface is correctly implemented.
--
-- The design runs at 100 MHz from the on-board oscillator.
-- Note that the HyperRAM interface core is designed to run only at 100 MHz,
-- so changing the clock frequency will probably cause this test to fail.
--
-- Outputs:
--
--   LED1 (red):    On when the test detected at least one error.
--
--   LED2 (green):  On when no errors have been detected and the
--                  test has completed at least one full round.
--
--   FTDI(2) = TX = pin 5 on the FTDI header:
--                  Serial output messages at 115200 bps.
--
-- If everything works correctly, the red LED should never turn on,
-- and the green LED should turn on about 90 seconds after startup.
--
-- To monitor the test process, connect an FTDI-USB cable to
-- the FTDI header and monitor the serial port at 115200 bps.
--
-- Each round of the test prints a line:
--   R=(round_nr_hex) F=(total_failures_hex)
--
-- Each round consists of 8 test patterns, tested at several burst lengths.
-- Each test pattern prints a line:
--   P=(test_pattern) B=(burstlen) B=(burstlen) ... F=(total_failures_hex)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity hyperram_test_top is
    port (
        clk_100m_pin:   in    std_logic;
        led1:           out   std_logic;
        led2:           out   std_logic;
        ftdi:           inout std_logic_vector(3 downto 0);
        hr_cs_l:        out   std_logic;
        hr_rst_l:       out   std_logic;
        hr_ck:          out   std_logic;
        hr_rwds:        inout std_logic;
        hr_dq:          inout std_logic_vector(7 downto 0) );
end entity;


architecture arch_top of hyperram_test_top is

    signal clk_main:        std_logic;
    signal clk_270:         std_logic;
    signal s_mmcm_fb:       std_logic;
    signal s_mmcm_clkout0:  std_logic;
    signal s_mmcm_clkout1:  std_logic;
    signal s_mmcm_locked:   std_logic;

    signal ram_csn:         std_logic;
    signal ram_rstn:        std_logic;
    signal ram_ck:          std_logic;
    signal ram_rwds_o:      std_logic;
    signal ram_rwds_i:      std_logic;
    signal ram_rwds_t:      std_logic;
    signal ram_dq_o:        std_logic_vector(7 downto 0);
    signal ram_dq_i:        std_logic_vector(7 downto 0);
    signal ram_dq_t:        std_logic_vector(7 downto 0);

    signal s_rs232_tx:      std_logic;
    signal s_rs232_txr:     std_logic;
    signal s_rs232_txs:     std_logic;
    signal s_rs232_txb:     std_logic_vector(7 downto 0);

    signal ram_cmd_valid:   std_logic;
    signal ram_cmd_write:   std_logic;
    signal ram_cmd_addr:    std_logic_vector(21 downto 0);
    signal ram_cmd_wdata:   std_logic_vector(15 downto 0);
    signal ram_cmd_wmask:   std_logic_vector(1 downto 0);
    signal ram_cmd_ready:   std_logic;
    signal ram_rsp_valid:   std_logic;
    signal ram_rsp_rdata:   std_logic_vector(15 downto 0);
    signal msg_valid:       std_logic;

    signal r_reset:         std_logic;
    signal r_rstn_shift:    std_logic_vector(7 downto 0);
    signal r_blink_1hz:     std_logic;
    signal r_count_1hz:     unsigned(27 downto 0);

    signal s_test_fail:     std_logic;
    signal s_test_pass:     std_logic;

begin

    --
    -- Clocking.
    --

    -- Use MMCM to create two 100 MHz clocks:
    -- a main clock, and a second clock which is delayed by 270 degrees.
    inst_mmcm:
        MMCME2_BASE
            generic map (
                BANDWIDTH           => "LOW",
                CLKFBOUT_MULT_F     => 8.0,
                CLKOUT0_DIVIDE_F    => 8.0,
                CLKOUT0_PHASE       => 0.0, 
                CLKOUT1_DIVIDE      => 8,
                CLKOUT1_PHASE       => 270.0,
                CLKIN1_PERIOD       => 10.0 )
            port map (
                CLKFBIN             => s_mmcm_fb,
                CLKFBOUT            => s_mmcm_fb,
                CLKOUT0             => s_mmcm_clkout0,
                CLKOUT1             => s_mmcm_clkout1,
                CLKIN1              => clk_100m_pin,
                PWRDWN              => '0',
                RST                 => '0',
                LOCKED              => s_mmcm_locked );

    inst_bufg_clk_main: BUFG
        port map ( I => s_mmcm_clkout0, O => clk_main );

    inst_bufg_clk_270: BUFG
        port map ( I => s_mmcm_clkout1, O => clk_270 );

    --
    -- I/O buffers.
    --

    inst_obuf_csn: OBUF
        port map ( I => ram_csn, O => hr_cs_l );

    inst_obuf_rstn: OBUF
        port map ( I => ram_rstn, O => hr_rst_l );

    inst_obuf_ck: OBUF
        port map ( I => ram_ck, O => hr_ck );

    inst_iobuf_rwds: IOBUF
        port map (
            I  => ram_rwds_o,
            T  => ram_rwds_t,
            O  => ram_rwds_i,
            IO => hr_rwds );

    inst_iobuf_dq: for i in 0 to 7 generate
        inst_iobuf_dq_i: IOBUF
            port map (
                I  => ram_dq_o(i),
                T  => ram_dq_t(i),
                O  => ram_dq_i(i),
                IO => hr_dq(i) );
    end generate;

    --
    -- HyperRAM controller.
    --

    inst_hyperram: entity work.hyperram_ctrl
        port map (
            clk             => clk_main,
            clk270          => clk_270,
            rst             => r_reset,
            cmd_valid       => ram_cmd_valid,
            cmd_write       => ram_cmd_write,
            cmd_addr        => ram_cmd_addr,
            cmd_wdata       => ram_cmd_wdata,
            cmd_wmask       => ram_cmd_wmask,
            cmd_ready       => ram_cmd_ready,
            rsp_valid       => ram_rsp_valid,
            rsp_rdata       => ram_rsp_rdata,
            ram_csn         => ram_csn,
            ram_ck          => ram_ck,
            ram_rstn        => ram_rstn,
            ram_dq_i        => ram_dq_i,
            ram_dq_o        => ram_dq_o,
            ram_dq_t        => ram_dq_t,
            ram_rwds_i      => ram_rwds_i,
            ram_rwds_o      => ram_rwds_o,
            ram_rwds_t      => ram_rwds_t );

    --
    -- RS-232 driver.
    --

    inst_rs232: entity work.rs232
        generic map (
            BITPERIOD       => 868 )  -- 115200 bps
        port map (
            CLK             => clk_main,
            RXR             => open,
            RXN             => open,
            RXE             => open,
            RXB             => open,
            TXR             => s_rs232_txr,
            TXS             => s_rs232_txs,
            TXB             => s_rs232_txb,
            RS232_RX        => '1',
            RS232_TX        => s_rs232_tx );

    ftdi(0) <= 'Z';
    ftdi(1) <= 'Z';
    ftdi(2) <= s_rs232_tx;
    ftdi(3) <= 'Z';

    --
    -- RAM test driver.
    --

    inst_ramtest: entity work.ram_test
        generic map (
            address_bits    => 22 )
        port map (
            clk             => clk_main,
            rst             => r_reset,
            ram_cmd_valid   => ram_cmd_valid,
            ram_cmd_write   => ram_cmd_write,
            ram_cmd_addr    => ram_cmd_addr,
            ram_cmd_wdata   => ram_cmd_wdata,
            ram_cmd_wmask   => ram_cmd_wmask,
            ram_cmd_ready   => ram_cmd_ready,
            ram_rsp_valid   => ram_rsp_valid,
            ram_rsp_rdata   => ram_rsp_rdata,
            fail_count      => open,
            round_count     => open,
            fail_flag       => s_test_fail,
            pass_flag       => s_test_pass,
            msg_valid       => msg_valid,
            msg_data        => s_rs232_txb,
            msg_ready       => s_rs232_txr );

    s_rs232_txs <= s_rs232_txr and msg_valid;

    led1 <= s_test_fail;  -- red LED
    led2 <= s_test_pass;  -- green LED

    --
    -- Reset generator.
    --

    process (clk_main, s_mmcm_locked) is
    begin
        if s_mmcm_locked = '0' then
            r_reset         <= '1';
            r_rstn_shift    <= (others => '0');
        elsif rising_edge(clk_main) then
            r_rstn_shift    <= "1" & r_rstn_shift(r_rstn_shift'high downto 1);
            r_reset         <= not r_rstn_shift(0);
        end if;
    end process;

    --
    -- Blinking light.
    -- (currently not used)
    --

    process (clk_main) is
    begin
        if rising_edge(clk_main) then
            if r_reset = '1' then
                r_blink_1hz     <= '0';
                r_count_1hz     <= (others => '0');
            else
                if r_count_1hz = 49999999 then
                    r_count_1hz     <= (others => '0');
                    r_blink_1hz     <= not r_blink_1hz;
                else
                    r_count_1hz     <= r_count_1hz + 1;
                end if;
            end if;
        end if;
    end process;

end architecture;
