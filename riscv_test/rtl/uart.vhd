--
-- UART controller for simple processor system
--
-- The UART transmits and receives at a fixed baud rate.
-- A single-byte transmit buffer and single-byte receive buffer are used.
-- A receive interrupt can optionally be generated when the receive buffer
-- is not empty.
-- A transmit interrupt can optionally be generated when the transmit buffer
-- is empty.
--
-- Partial-word writes (byte, half-word) are not supported.
--
-- Register map:
--   address 0 (read):
--     bits 7-0 (ro)  = received byte
--     bit 16 (ro)    = '1' if byte received, '0' if no byte ready
--     bit 17 (ro)    = receiver frame error (cleared by reading)
--     bit 18 (ro)    = receive buffer overrun (cleared by reading)
--   address 0 (write):
--     bits 7-0 (wo)  = byte to transmit
--   address 4:
--     bit 0 (rw)     = transmit interrupt enable
--     bit 1 (rw)     = receive interrupt enable
--     bit 8 (ro)     = transmit interrupt pending
--     bit 9 (ro)     = receive interrupt pending
--     bit 15 (ro)    = '1' when transmit buffer not empty
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rvsys.all;


entity uart is

    generic (
        -- Number of clock cycles per bit period.
        -- The effective baud rate is (clk_freq / bit_period).
        bit_period: integer range 8 to 32766
    );

    port (
        -- System clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- UART signals.
        uart_rx:        in  std_logic;
        uart_tx:        out std_logic;

        -- Interrupt signal.
        interrupt:      out std_logic;

        -- Bus interface signals.
        slv_input:      in  bus_slv_input_type;
        slv_output:     out bus_slv_output_type
    );

end entity;

architecture uart_arch of uart is

    -- Internal registers.
    type regs_type is record
        rxtimer:        unsigned(14 downto 0);
        rxstate:        unsigned(3 downto 0);
        rxshift:        std_logic_vector(7 downto 0);
        txtimer:        unsigned(14 downto 0);
        txstate:        unsigned(3 downto 0);
        txshift:        std_logic_vector(7 downto 0);
        txvalid:        std_logic;
        rxvalid:        std_logic;
        errframe:       std_logic;
        erroverrun:     std_logic;
        txbuf:          std_logic_vector(7 downto 0);
        rxbuf:          std_logic_vector(7 downto 0);
        tx_int_en:      std_logic;
        rx_int_en:      std_logic;
        rxdeglitch:     std_logic_vector(3 downto 0);
        uart_rx:        std_logic;
        uart_tx:        std_logic;
        interrupt_out:  std_logic;
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(31 downto 0);
    end record;

    constant regs_init: regs_type := (
        rxtimer         => (others => '0'),
        rxstate         => (others => '0'),
        rxshift         => (others => '0'),
        txtimer         => (others => '0'),
        txstate         => (others => '0'),
        txshift         => (others => '0'),
        txvalid         => '0',
        rxvalid         => '0',
        errframe        => '0',
        erroverrun      => '0',
        txbuf           => (others => '0'),
        rxbuf           => (others => '0'),
        tx_int_en       => '0',
        rx_int_en       => '0',
        rxdeglitch      => (others => '1'),
        uart_rx         => '1',
        uart_tx         => '1',
        interrupt_out   => '0',
        rsp_valid       => '0',
        rsp_rdata       => (others => '0'));

    signal r: regs_type := regs_init;
    signal rnext: regs_type;

begin

    -- Drive outputs.
    uart_tx     <= r.uart_tx;
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

        -- Handle read transactions.
        -- Read transactions can cause the RX buffer to become empty
        -- or error flags to become cleared. Therefore this needs to
        -- be handled before we push new data into these flags below.
        v.rsp_valid     := slv_input.cmd_valid and (not slv_input.cmd_write);
        v.rsp_rdata     := (others => '0');
        if (slv_input.cmd_valid = '1') and (slv_input.cmd_write = '0') then
            if slv_input.cmd_addr(2) = '0' then
                -- addr 0 = received data
                v.rsp_rdata(7 downto 0) := r.rxbuf;
                v.rsp_rdata(16) := r.rxvalid;
                v.rsp_rdata(17) := r.errframe;
                v.rsp_rdata(18) := r.erroverrun;
                v.rxvalid   := '0';
                v.errframe  := '0';
                v.erroverrun := '0';
            else
                -- addr 4 = status register
                v.rsp_rdata(0) := r.tx_int_en;
                v.rsp_rdata(1) := r.rx_int_en;
                v.rsp_rdata(8) := (not r.txvalid) and r.tx_int_en;
                v.rsp_rdata(9) := r.rxvalid and r.rx_int_en;
                v.rsp_rdata(15) := r.txvalid;
            end if;
        end if;

        -- Capture and deglitch input signal.
        v.rxdeglitch    := uart_rx & r.rxdeglitch(3 downto 1);
        if r.rxdeglitch = "0000" then
            v.uart_rx       := '0';
        elsif r.rxdeglitch = "1111" then
            v.uart_rx       := '1';
        end if;

        -- UART receive channel.
        v.rxtimer       := r.rxtimer - 1;
        if r.rxstate = 0 then
            -- Idle. Wait for next start bit.
            if r.uart_rx = '0' then
                v.rxstate       := "1011";
            end if;
            -- Start capturing data 0.5 bit period after edge of start bit.
            v.rxtimer       := to_unsigned(bit_period / 2 - 1,
                                           v.rxtimer'length);
        elsif r.rxstate = 1 then
            -- Got frame error; now wait until line idle.
            if r.uart_rx = '1' then
                v.rxstate       := "0000";
            end if;
        elsif r.rxtimer = 0 then
            -- Capture next bit.
            v.rxshift       := r.uart_rx & r.rxshift(7 downto 1);
            v.rxstate       := r.rxstate - 1;
            v.rxtimer       := to_unsigned(bit_period - 1, v.rxtimer'length);
            if r.rxstate = 11 then
                -- Check start bit.
                if r.uart_rx = '1' then
                    -- Bad start bit.
                    -- Flag frame error and wait for next start bit.
                    v.rxstate       := "0000";
                    v.errframe      := '1';
                end if;
            end if;
            if r.rxstate = 2 then
                -- Check stop bit.
                if r.uart_rx = '1' then
                    -- Got valid stop bit.
                    -- Push the received byte to the RX buffer.
                    v.erroverrun    := v.rxvalid;
                    v.rxvalid       := '1';
                    v.rxbuf         := r.rxshift;
                    v.rxstate       := "0000";
                else
                    -- Got bad stop bit.
                    -- Discard byte, flag frame error and wait for line idle.
                    v.errframe      := '1';
                end if;
            end if;
        end if;

        -- UART transmit channel.
        v.txtimer       := r.txtimer - 1;
        if r.txstate = 0 then
            -- Idle. Ready to start next byte.
            v.txtimer       := to_unsigned(bit_period - 1, v.txtimer'length);
            if r.txvalid = '1' then
                v.txshift       := r.txbuf;
                v.txvalid       := '0';
                v.uart_tx       := '0';  -- start bit
                v.txstate       := "1011";
            end if;
        elsif r.txtimer = 0 then
            -- Shift out next bit.
            v.uart_tx       := r.txshift(0);
            v.txshift       := "1" & r.txshift(7 downto 1);
            v.txstate       := r.txstate - 1;
            v.txtimer       := to_unsigned(bit_period - 1, v.txtimer'length);
            if r.txstate = 2 then
                -- Finished stop bit.
                -- Add another 0.5 stop bit period for reliability.
                v.txtimer       := to_unsigned(bit_period / 2 - 1,
                                               v.txtimer'length);
            end if;
        end if;

        -- Handle write transactions.
        -- Write transactions can push new data into the TX buffer,
        -- therefore this needs to be handled after the UART which
        -- may have emptied the TX buffer in the same cycle.
        if (slv_input.cmd_valid = '1') and (slv_input.cmd_write = '1') then
            if slv_input.cmd_addr(2) = '0' then
                -- addr 0 = transmit byte
                v.txbuf         := slv_input.cmd_wdata(7 downto 0);
                v.txvalid       := '1';
            end if;
            if slv_input.cmd_addr(2) = '1' then
                -- addr 4 = interrupt control
                v.tx_int_en     := slv_input.cmd_wdata(0);
                v.rx_int_en     := slv_input.cmd_wdata(1);
            end if;
        end if;

        -- Update interrupt output signal.
        v.interrupt_out := ((not v.txvalid) and v.tx_int_en) or
                           (v.rxvalid and v.rx_int_en);

        -- Synchronous reset.
        if rst = '1' then
            v.rxstate       := (others => '0');
            v.txstate       := (others => '0');
            v.txvalid       := '0';
            v.rxvalid       := '0';
            v.errframe      := '0';
            v.erroverrun    := '0';
            v.tx_int_en     := '0';
            v.rx_int_en     := '0';
            v.uart_tx       := '1';
            v.interrupt_out := '0';
            v.rsp_valid     := '0';
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
