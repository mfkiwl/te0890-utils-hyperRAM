--
--  RS232 serial I/O controller (8 databits, no parity, 2 stopbits)
--
--  Parameters:
--    BITPERIOD   Period for one bit expressed in system clock cycles
--
--  Ports:
--    In:  CLK    System clock
--    Out: RXR    Set high after receiving a byte, low at start of next byte
--    Out: RXN    Flashes high for one cycle after receiving a byte
--    Out: RXE    Set high on a frame error, low on reception of a good byte
--    Out: RXB    Last received data byte
--    Out: TXR    High when ready to send a new byte
--    In:  TXS    High signal starts transmission of next byte
--    In:  TXB    Data byte to send (sampled once at start of transmission)
--    In:  RS232_RX  Connect to RS232 RX line
--    Out: RS232_TX  Connect to RS232 TX line
--

library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity rs232 is

    generic (
	BITPERIOD : integer := 1302   -- Bit period, default 50MHz / 38400bps
    );

    port (
	CLK : in  std_logic;
	RXR : out std_logic;
	RXN : out std_logic;
	RXE : out std_logic;
	RXB : out std_logic_vector(7 downto 0);
	TXR : out std_logic;
	TXS : in  std_logic;
	TXB : in  std_logic_vector(7 downto 0);
	RS232_RX : in std_logic;
	RS232_TX : out std_logic
    );

end entity rs232;

architecture rs232_arch of rs232 is

    -- Receiver stabilization
    signal rx_hist : std_logic_vector(1 downto 0);
    signal rx_level : std_logic := '0';

    -- Receiver control
    signal rx_timer : unsigned(15 downto 0);
    signal rx_state : unsigned(3 downto 0) := "0000";
    signal rx_shift : std_logic_vector(7 downto 0);
    signal rx_ready : std_logic := '0';
    signal rx_prevready : std_logic := '0';
    signal rx_err :   std_logic := '0';

    -- Transmission control
    signal tx_timer : unsigned(15 downto 0) := (others => '0');
    signal tx_nbits : unsigned(3 downto 0) := "0000";
    signal tx_shift : std_logic_vector(7 downto 0);

begin

    -- Publish receiver state
    RXR <= rx_ready;
    RXN <= rx_ready and (not rx_prevready);
    RXE <= rx_err;
    RXB <= rx_shift;

    -- On every rising clock edge
    process is
    begin
	wait until rising_edge(CLK);

	-- Latch ready signal
	rx_prevready <= rx_ready;

	-- Stabilize incoming signal
	if (rx_hist(0) = rx_hist(1)) and (rx_hist(0) = RS232_RX) then
	    rx_level <= rx_hist(0);
	end if;
	rx_hist <= ( rx_hist(0), RS232_RX );

	-- Operate receiving channel
	if rx_timer = 0 then

	    if rx_state = "1011" then

		-- Waiting for start of next byte
		if rx_level = '0' then
		    -- Found start of next byte
		    rx_ready <= '0';
		    rx_state <= "1010";
		    rx_timer <= to_unsigned(BITPERIOD / 2, rx_timer'length);
		end if;

	    elsif rx_state = "1010" then

		-- Expecting start bit
		if rx_level = '0' then
		    -- Got start bit
		    rx_state <= "1001";
		    rx_timer <= to_unsigned(BITPERIOD, rx_timer'length);
		else
		    -- Something wrong
		    rx_err <= '1';
		    rx_state <= "1011";
		end if;

	    elsif rx_state = "0001" then

		-- Expecting stop bit
		if rx_level = '1' then
		    -- Got stop bit
		    rx_ready <= '1';
		    rx_err <= '0';
		    rx_state <= "1011";
		else
		    -- Something wrong
		    rx_err <= '1';
		    rx_state <= "0000";
		end if;

	    elsif rx_state = "0000" then

		-- Waiting for line idle
		if rx_level = '1' then
		    rx_state <= "1011";
		end if;

	    else

		-- Expecting next data bit
		rx_shift <= rx_level & rx_shift(7 downto 1);
		rx_state <= rx_state - 1;
		rx_timer <= to_unsigned(BITPERIOD, rx_timer'length);

	    end if;

	else

	    -- Count down the current bit period
	    rx_timer <= rx_timer - 1;

	end if;

	-- Operate transmission channel
	if tx_timer = 0 then

	    if tx_nbits > 0 then

		-- still more bits to send, start working on the next bit
		RS232_TX <= tx_shift(0);
		tx_shift <= '1' & tx_shift(7 downto 1);
		tx_nbits <= tx_nbits - 1;
		tx_timer <= to_unsigned(BITPERIOD, tx_timer'length);

	    elsif TXS = '1' then

		-- start transmission of the next byte
		TXR <= '0';
		tx_shift <= TXB;
		-- start by sending the start bit
		RS232_TX <= '0';
		tx_nbits <= "1010";
		tx_timer <= to_unsigned(BITPERIOD, tx_timer'length);

	    else

		-- transmission channel is idle
		TXR <= '1';
		RS232_TX <= '1';

	    end if;

	else

	    -- Count down the current bit period
	    tx_timer <= tx_timer - 1;

	end if;

    end process;

end architecture rs232_arch;

