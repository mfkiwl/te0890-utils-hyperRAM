--
-- Test design for RISC-V processor on Trenz TE0890 Spartan-7 Mini.
--
-- This design implements a VexRiscv processor with a few simple peripherals.
-- The design runs at 100 MHz from the on-board oscillator.
--
-- Input/output ports:
--   FTDI(2) = TX = pin 5 on the FTDI header: RS232 output, 115200 bps.
--   FTDI(1) = RX = pin 4 on the FTDI header: RS232 input.
--   LED1, LED2:    Controlled by software via GPIO.
--   PORT_A..D:     Controlled by software via GPIO1.
--   PORT_E..H:     Controlled by software via GPIO2.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.rvsys.all;


entity riscv_test_top is
    port (
        clk_100m_pin:   in    std_logic;
        led1:           out   std_logic;
        led2:           out   std_logic;
        ftdi:           inout std_logic_vector(3 downto 0);
        port_a:         inout std_logic_vector(7 downto 0);
        port_b:         inout std_logic_vector(7 downto 0);
        port_c:         inout std_logic_vector(7 downto 0);
        port_d:         inout std_logic_vector(7 downto 0);
        port_e:         inout std_logic_vector(7 downto 0);
        port_f:         inout std_logic_vector(7 downto 0);
        port_g:         inout std_logic_vector(7 downto 0);
        port_h:         inout std_logic_vector(7 downto 0);
        hr_cs_l:        out   std_logic;
        hr_rst_l:       out   std_logic );
end entity;


architecture arch_top of riscv_test_top is

    signal clk_main:                std_logic;
    signal s_mmcm_fb:               std_logic;
    signal s_mmcm_clkout0:          std_logic;
    signal s_mmcm_locked:           std_logic;

    signal r_rstn_shift:            std_logic_vector(7 downto 0);
    signal r_reset:                 std_logic;
    signal r_sys_rstn_shift:        std_logic_vector(7 downto 0);
    signal r_sys_reset:             std_logic;

    signal s_cpu_ibus_cmd_valid:    std_logic;
    signal s_cpu_ibus_cmd_ready:    std_logic;
    signal s_cpu_ibus_cmd_addr:     unsigned(31 downto 0);
    signal r_cpu_ibus_rsp_valid:    std_logic;
    signal s_cpu_ibus_rsp_error:    std_logic;
    signal s_cpu_ibus_rsp_rdata:    std_logic_vector(31 downto 0);
    signal s_cpu_int_external:      std_logic;
    signal s_cpu_int_soft:          std_logic;
    signal s_cpu_dbus_cmd_valid:    std_logic;
    signal s_cpu_dbus_cmd_ready:    std_logic;
    signal s_cpu_dbus_cmd_write:    std_logic;
    signal s_cpu_dbus_cmd_addr:     unsigned(31 downto 0);
    signal s_cpu_dbus_cmd_wdata:    std_logic_vector(31 downto 0);
    signal s_cpu_dbus_cmd_size:     unsigned(1 downto 0);
    signal s_cpu_dbus_rsp_valid:    std_logic;
    signal s_cpu_dbus_rsp_error:    std_logic;
    signal s_cpu_dbus_rsp_rdata:    std_logic_vector(31 downto 0);
    signal s_cpu_dbg_cmd_valid:     std_logic;
    signal s_cpu_dbg_cmd_ready:     std_logic;
    signal s_cpu_dbg_cmd_write:     std_logic;
    signal s_cpu_dbg_cmd_addr:      std_logic_vector(31 downto 0);
    signal s_cpu_dbg_cmd_wdata:     std_logic_vector(31 downto 0);
    signal s_cpu_dbg_rsp_rdata:     std_logic_vector(31 downto 0);
    signal s_cpu_dbg_reset_out:     std_logic;
    signal s_sysbus_wmask:          std_logic_vector(3 downto 0);
    signal r_sysbus_bram_rsp_valid: std_logic;
    signal s_sysbus_slv_input:      bus_slv_input_array(0 to 1);
    signal s_sysbus_slv_output:     bus_slv_output_array(0 to 1);
    signal s_devbus_slv_input:      bus_slv_input_array(0 to 4);
    signal s_devbus_slv_output:     bus_slv_output_array(0 to 4);

    signal s_gpio_led_o:            std_logic_vector(31 downto 0);
    signal s_gpio1_i:               std_logic_vector(31 downto 0);
    signal s_gpio1_o:               std_logic_vector(31 downto 0);
    signal s_gpio1_t:               std_logic_vector(31 downto 0);
    signal s_gpio2_i:               std_logic_vector(31 downto 0);
    signal s_gpio2_o:               std_logic_vector(31 downto 0);
    signal s_gpio2_t:               std_logic_vector(31 downto 0);

    signal s_uart_tx:               std_logic;
    signal s_uart_rx:               std_logic;
    signal s_uart_interrupt:        std_logic;
    signal s_timer_interrupt:       std_logic;

    signal s_jtag_drck:             std_logic;
    signal s_jtag_capture:          std_logic;
    signal s_jtag_shift:            std_logic;
    signal s_jtag_tdi:              std_logic;
    signal s_jtag_tdo:              std_logic;

begin

    --
    -- Clocking.
    --

    -- Use MMCM to create 100 MHz clock:
    inst_mmcm: MMCME2_BASE
        generic map (
            BANDWIDTH           => "LOW",
            CLKFBOUT_MULT_F     => 10.0,
            CLKOUT0_DIVIDE_F    => 10.0,
            CLKOUT0_PHASE       => 0.0,
            CLKIN1_PERIOD       => 10.0 )
        port map (
            CLKFBIN             => s_mmcm_fb,
            CLKFBOUT            => s_mmcm_fb,
            CLKOUT0             => s_mmcm_clkout0,
            CLKIN1              => clk_100m_pin,
            PWRDWN              => '0',
            RST                 => '0',
            LOCKED              => s_mmcm_locked );

    inst_bufg_clk_main: BUFG
        port map ( I => s_mmcm_clkout0, O => clk_main );

    --
    -- I/O buffers.
    --

    inst_obuf_led1: OBUF
        port map ( I => s_gpio_led_o(0), O => led1 );  -- red LED

    inst_obuf_led2: OBUF
        port map ( I => s_gpio_led_o(1), O => led2 );  -- green LED

    inst_obuf_uarttx: OBUF
        port map ( I => s_uart_tx, O => ftdi(2) );

    inst_obuf_uartrx: IBUF
        port map ( I => ftdi(1), O => s_uart_rx );

    ftdi(0) <= 'Z';
    ftdi(1) <= 'Z';
    ftdi(3) <= 'Z';

    inst_iobuf_gpio: for i in 0 to 7 generate
        inst_iobuf_gpio_a: IOBUF
            port map ( I => s_gpio1_o(i), T => s_gpio1_t(i), O => s_gpio1_i(i), IO => port_a(i) );
        inst_iobuf_gpio_b: IOBUF
            port map ( I => s_gpio1_o(i+8), T => s_gpio1_t(i+8), O => s_gpio1_i(i+8), IO => port_b(i) );
        inst_iobuf_gpio_c: IOBUF
            port map ( I => s_gpio1_o(i+16), T => s_gpio1_t(i+16), O => s_gpio1_i(i+16), IO => port_c(i) );
        inst_iobuf_gpio_d: IOBUF
            port map ( I => s_gpio1_o(i+24), T => s_gpio1_t(i+24), O => s_gpio1_i(i+24), IO => port_d(i) );
        inst_iobuf_gpio_e: IOBUF
            port map ( I => s_gpio2_o(i), T => s_gpio2_t(i), O => s_gpio2_i(i), IO => port_e(i) );
        inst_iobuf_gpio_f: IOBUF
            port map ( I => s_gpio2_o(i+8), T => s_gpio2_t(i+8), O => s_gpio2_i(i+8), IO => port_f(i) );
        inst_iobuf_gpio_g: IOBUF
            port map ( I => s_gpio2_o(i+16), T => s_gpio2_t(i+16), O => s_gpio2_i(i+16), IO => port_g(i) );
        inst_iobuf_gpio_h: IOBUF
            port map ( I => s_gpio2_o(i+24), T => s_gpio2_t(i+24), O => s_gpio2_i(i+24), IO => port_h(i) );
    end generate;

    inst_obuf_csn: OBUF
        port map ( I => '1', O => hr_cs_l );

    inst_obuf_rstn: OBUF
        port map ( I => '0', O => hr_rst_l );

    --
    -- JTAG port.
    --

    -- Whenever the JTAG instruction register contains USER1,
    -- the data register will shift through this component.
    -- On Spartan7, USER1 is the 6-bit value "000010".
    inst_bscane2: BSCANE2
        generic map (
            JTAG_CHAIN => 1 )  -- Value for USER command.
        port map (
            CAPTURE     => s_jtag_capture,
            DRCK        => s_jtag_drck,
            SHIFT       => s_jtag_shift,
            TDI         => s_jtag_tdi,
            TDO         => s_jtag_tdo );

    --
    -- VexRiscv
    --

    inst_cpu: entity work.VexRiscv
        port map (
            iBus_cmd_valid          => s_cpu_ibus_cmd_valid,
            iBus_cmd_ready          => s_cpu_ibus_cmd_ready,
            iBus_cmd_payload_pc     => s_cpu_ibus_cmd_addr,
            iBus_rsp_valid          => r_cpu_ibus_rsp_valid,
            iBus_rsp_payload_error  => s_cpu_ibus_rsp_error,
            iBus_rsp_payload_inst   => s_cpu_ibus_rsp_rdata,
            timerInterrupt          => s_timer_interrupt,
            externalInterrupt       => s_cpu_int_external,
            softwareInterrupt       => s_cpu_int_soft,
            debug_bus_cmd_valid           => s_cpu_dbg_cmd_valid,
            debug_bus_cmd_ready           => s_cpu_dbg_cmd_ready,
            debug_bus_cmd_payload_wr      => s_cpu_dbg_cmd_write,
            debug_bus_cmd_payload_address => unsigned(s_cpu_dbg_cmd_addr(7 downto 0)),
            debug_bus_cmd_payload_data    => s_cpu_dbg_cmd_wdata,
            debug_bus_rsp_data            => s_cpu_dbg_rsp_rdata,
            debug_resetOut          => s_cpu_dbg_reset_out,
            dBus_cmd_valid          => s_cpu_dbus_cmd_valid,
            dBus_cmd_ready          => s_cpu_dbus_cmd_ready,
            dBus_cmd_payload_wr     => s_cpu_dbus_cmd_write,
            dBus_cmd_payload_address => s_cpu_dbus_cmd_addr,
            dBus_cmd_payload_data   => s_cpu_dbus_cmd_wdata,
            dBus_cmd_payload_size   => s_cpu_dbus_cmd_size,
            dBus_rsp_ready          => s_cpu_dbus_rsp_valid,
            dBus_rsp_error          => s_cpu_dbus_rsp_error,
            dBus_rsp_data           => s_cpu_dbus_rsp_rdata,
            clk                     => clk_main,
            reset                   => r_sys_reset,
            debugReset              => r_reset );

    -- Instruction bus and data bus never raise error flag.
    s_cpu_ibus_rsp_error <= '0';
    s_cpu_dbus_rsp_error <= '0';

    --
    -- On-chip RAM
    --

    -- 64 kByte dual-port block RAM.
    -- This will be used for instructions and data.
    -- The initial contents of the block RAM is loaded from "bootmon.hex".
    inst_ram: entity work.bram32_dualport
        generic map (
            address_bits => 14,
            init_file   => "../sw/bootmon.hex" )
        port map (
            clk         => clk_main,
            en_a        => s_sysbus_slv_input(0).cmd_valid,
            en_b        => s_cpu_ibus_cmd_valid,
            wr_a        => s_sysbus_slv_input(0).cmd_write,
            addr_a      => s_sysbus_slv_input(0).cmd_addr(15 downto 2),
            addr_b      => std_logic_vector(s_cpu_ibus_cmd_addr(15 downto 2)),
            wdata_a     => s_sysbus_slv_input(0).cmd_wdata,
            wmask_a     => s_sysbus_slv_input(0).cmd_wmask,
            rdata_a     => s_sysbus_slv_output(0).rsp_rdata,
            rdata_b     => s_cpu_ibus_rsp_rdata );

    -- On-chip memory is always ready.
    s_cpu_ibus_cmd_ready <= '1';
    s_sysbus_slv_output(0).cmd_ready <= '1';
    s_sysbus_slv_output(0).rsp_valid <= r_sysbus_bram_rsp_valid;

    -- On-chip memory has 1 cycle read response latency.
    process (clk_main) is
    begin
        if rising_edge(clk_main) then
            r_cpu_ibus_rsp_valid <= s_cpu_ibus_cmd_valid;
            r_sysbus_bram_rsp_valid <= s_sysbus_slv_input(0).cmd_valid and
                                       (not s_sysbus_slv_input(0).cmd_write);
        end if;
    end process;

    --
    -- Main data bus controller.
    --
    -- Memory map:
    --   0x80000000 ... 0x8fffffff = On-chip RAM (actually only 64 kByte)
    --   0xf0000000 ... 0xffffffff = Peripheral bus
    --

    inst_sysbus_ctrl: entity work.bus_ctrl
        generic map (
            num_slaves    => 2,
            slv_info      => ( 0 => ( addr_start => x"80000000",
                                      addr_size  => x"10000000" ),
                               1 => ( addr_start => x"f0000000",
                                      addr_size  => x"10000000" )),
            pipeline_cmd  => false,
            pipeline_rsp  => false )
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            mst_cmd_valid => s_cpu_dbus_cmd_valid,
            mst_cmd_ready => s_cpu_dbus_cmd_ready,
            mst_cmd_addr  => std_logic_vector(s_cpu_dbus_cmd_addr),
            mst_cmd_write => s_cpu_dbus_cmd_write,
            mst_cmd_wdata => s_cpu_dbus_cmd_wdata,
            mst_cmd_wmask => s_sysbus_wmask,
            mst_rsp_valid => s_cpu_dbus_rsp_valid,
            mst_rsp_rdata => s_cpu_dbus_rsp_rdata,
            slv_input     => s_sysbus_slv_input,
            slv_output    => s_sysbus_slv_output );

    s_sysbus_wmask <= bus_transaction_address_to_write_mask(s_cpu_dbus_cmd_addr,
                                                            s_cpu_dbus_cmd_size);

    --
    -- Peripheral data bus controller.
    --
    -- Memory map:
    --   0xf0000000 = GPIO controller for on-board LEDs
    --   0xf0001000 = GPIO controller for pins A..D
    --   0xf0002000 = GPIO controller for pins E..F
    --   0xf0008000 = Timer controller
    --   0xf0010000 = UART controller
    --

    inst_devbus_ctrl: entity work.bus_ctrl
        generic map (
            num_slaves    => 5,
            slv_info      => ( 0 => ( addr_start => rvsys_addr_leds,
                                      addr_size  => x"00001000" ),
                               1 => ( addr_start => rvsys_addr_gpio1,
                                      addr_size  => x"00001000" ),
                               2 => ( addr_start => rvsys_addr_gpio2,
                                      addr_size  => x"00001000" ),
                               3 => ( addr_start => rvsys_addr_uart,
                                      addr_size  => x"00001000" ),
                               4 => ( addr_start => rvsys_addr_timer,
                                      addr_size  => x"00001000" )),
            pipeline_cmd  => true,
            pipeline_rsp  => true )
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            mst_cmd_valid => s_sysbus_slv_input(1).cmd_valid,
            mst_cmd_ready => s_sysbus_slv_output(1).cmd_ready,
            mst_cmd_addr  => s_sysbus_slv_input(1).cmd_addr,
            mst_cmd_write => s_sysbus_slv_input(1).cmd_write,
            mst_cmd_wdata => s_sysbus_slv_input(1).cmd_wdata,
            mst_cmd_wmask => s_sysbus_slv_input(1).cmd_wmask,
            mst_rsp_valid => s_sysbus_slv_output(1).rsp_valid,
            mst_rsp_rdata => s_sysbus_slv_output(1).rsp_rdata,
            slv_input     => s_devbus_slv_input,
            slv_output    => s_devbus_slv_output );

    --
    -- GPIO.
    --

    inst_gpio_led: entity work.gpio
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            gpio_i        => (others => '0'),
            gpio_o        => s_gpio_led_o,
            gpio_t        => open,
            slv_input     => s_devbus_slv_input(0),
            slv_output    => s_devbus_slv_output(0) );

    inst_gpio1: entity work.gpio
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            gpio_i        => s_gpio1_i,
            gpio_o        => s_gpio1_o,
            gpio_t        => s_gpio1_t,
            slv_input     => s_devbus_slv_input(1),
            slv_output    => s_devbus_slv_output(1) );

    inst_gpio2: entity work.gpio
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            gpio_i        => s_gpio2_i,
            gpio_o        => s_gpio2_o,
            gpio_t        => s_gpio2_t,
            slv_input     => s_devbus_slv_input(2),
            slv_output    => s_devbus_slv_output(2) );

    --
    -- UART.
    --

    inst_uart: entity work.uart
        generic map (
            bit_period    => 868 )  -- 115200 bps at 100 MHz
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            uart_rx       => s_uart_rx,
            uart_tx       => s_uart_tx,
            interrupt     => s_uart_interrupt,
            slv_input     => s_devbus_slv_input(3),
            slv_output    => s_devbus_slv_output(3));

    --
    -- Timer.
    --

    inst_timer: entity work.timer
        port map (
            clk           => clk_main,
            rst           => r_sys_reset,
            interrupt     => s_timer_interrupt,
            slv_input     => s_devbus_slv_input(4),
            slv_output    => s_devbus_slv_output(4));

    --
    -- JTAG debug bridge.
    --

    inst_jtag_dbg: entity work.jtag_dbg
        port map (
            clk           => clk_main,
            rst           => r_reset,
            jtag_drck     => s_jtag_drck,
            jtag_capture  => s_jtag_capture,
            jtag_shift    => s_jtag_shift,
            jtag_tdi      => s_jtag_tdi,
            jtag_tdo      => s_jtag_tdo,
            dbg_cmd_valid => s_cpu_dbg_cmd_valid,
            dbg_cmd_ready => s_cpu_dbg_cmd_ready,
            dbg_cmd_write => s_cpu_dbg_cmd_write,
            dbg_cmd_addr  => s_cpu_dbg_cmd_addr,
            dbg_cmd_wdata => s_cpu_dbg_cmd_wdata,
            dbg_rsp_rdata => s_cpu_dbg_rsp_rdata );

    --
    -- Reset generator.
    --

    -- Main reset.
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

    -- Separate reset for CPU and system bus.
    process (clk_main, r_reset) is
    begin
        if r_reset = '1' then
            -- Reset system bus on the main reset.
            r_sys_reset <= '1';
            r_sys_rstn_shift <= (others => '0');
        elsif rising_edge(clk_main) then
            if s_cpu_dbg_reset_out = '1' then
                -- Reset system bus on request from debugger.
                r_sys_reset <= '1';
                r_sys_rstn_shift <= (others => '0');
            else
                -- Release system bus reset.
                r_sys_rstn_shift <= "1" & r_sys_rstn_shift(r_sys_rstn_shift'high downto 1);
                r_sys_reset <= not r_sys_rstn_shift(0);
            end if;
        end if;
    end process;

end architecture;
