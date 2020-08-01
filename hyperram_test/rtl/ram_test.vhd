--
-- Test driver for RAM controller.
--
-- This entity performs a continuous memory test.
-- It is designed to test HyperRAM, but it can in principle be used
-- for any RAM controller with a compatible 16-bit bus interface.
--
-- The test driver reports a pass/fail output via logic output.
-- The test driver also produces debug output (for a serial port).
--
-- The test is based on moving-inversions, where the memory is filled
-- with a pattern, which is then read back while writing the bit-inverted
-- pattern. One round of the test sequence consists of the following steps:
--
--   For each pattern in [0x0000, 0xff00, 0xaa55, 0xcc33, 0xf00f,
--                        0xb5c4, 0xa372, 0x1d95]:
--       For each burst_length in [ 1, 2, 3, 4, 5, 16, 512]:
--           View the memory as k groups of burst_length 8-bit bytes.
--           Walk through the memory in incrementing address order:
--               Write the test pattern in bursts of burst_length bytes.
--           Walk through the memory in incrementing address order:
--               Read burst_length bytes and verify against the test pattern.
--               Overwrite the same bytes with the bit-inverted pattern.
--           Walk through the memory in decrementing address order:
--               Read burst_length bytes and verify the bit-inverted pattern.
--               Overwrite the same bytes with the non-inverted pattern.
--               (Use incrementing addresses within each burst.)
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ram_test is

    generic (
        -- Number of address bits.
        -- Each address identifies a 16-bit word.
        address_bits:   integer range 8 to 31
    );

    port (
        -- Main clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- Command stream to the RAM controller.
        ram_cmd_valid:  out std_logic;
        ram_cmd_write:  out std_logic;
        ram_cmd_addr:   out std_logic_vector(address_bits-1 downto 0);
        ram_cmd_wdata:  out std_logic_vector(15 downto 0);
        ram_cmd_wmask:  out std_logic_vector(1 downto 0);
        ram_cmd_ready:  in  std_logic;

        -- Response flow from the RAM controller.
        ram_rsp_valid:  in  std_logic;
        ram_rsp_rdata:  in  std_logic_vector(15 downto 0);

        -- Count number of test failures.
        fail_count:     out std_logic_vector(31 downto 0);

        -- Count number of test rounds completed.
        round_count:    out std_logic_vector(15 downto 0);

        -- High when at least one failure has occurred.
        fail_flag:      out std_logic;

        -- High when there are zero failures and at least one round completed.
        pass_flag:      out std_logic;

        -- Report message stream.
        msg_valid:      out std_logic;
        msg_data:       out std_logic_vector(7 downto 0);
        msg_ready:      in  std_logic
    );

end entity;


architecture arch_ram_test of ram_test is

    -- Convert 4-bit value to hex character.
    function hexdigit(val: in std_logic_vector) return std_logic_vector is
        type tbl_type is array(0 to 15) of std_logic_vector(7 downto 0);
        constant tbl: tbl_type := (
            x"30", x"31", x"32", x"33", x"34", x"35", x"36", x"37",
            x"38", x"39", x"61", x"62", x"63", x"64", x"65", x"66" );
    begin
        return tbl(to_integer(unsigned(val)));
    end function;

    -- Burst length table.
    type burst_length_table_type is array(natural range <>) of natural;
    constant burst_length_table: burst_length_table_type(0 to 7) := (
        1, 2, 3, 4, 5, 16, 63, 512 );

    -- Test data pattern.
    type test_data_type is
        array(natural range <>) of std_logic_vector(15 downto 0);
    constant test_data: test_data_type(0 to 7) := (
        x"0000",
        x"ff00",
        x"aa55",
        x"cc33",
        x"f00f",
        x"b5c4",
        x"a372",
        x"1d95" );

    -- Main state machine.
    type state_type is (
        State_Init,
        State_Greeting,
        State_NewRound,
        State_NewPattern,
        State_NewBurstLen,
        State_Elem1Write,
        State_Elem2Read,
        State_Elem2Write,
        State_Elem3Read,
        State_Elem3Write,
        State_EndBurstLen,
        State_EndPattern,
        State_EndRound );

    -- Record definition for internal registers.
    type regs_type is record
        state:          state_type;
        index:          unsigned(4 downto 0);
        cmd_valid:      std_logic;
        cmd_write:      std_logic;
        cmd_addr:       std_logic_vector(address_bits-1 downto 0);
        cmd_wdata:      std_logic_vector(15 downto 0);
        cmd_wmask:      std_logic_vector(1 downto 0);
        fail_count:     unsigned(31 downto 0);
        fail_count_inc: std_logic;
        round_count:    unsigned(15 downto 0);
        fail_flag:      std_logic;
        pass_flag:      std_logic;
        msg_valid:      std_logic;
        msg_data:       std_logic_vector(7 downto 0);
        hexshift:       std_logic_vector(31 downto 0);
        pattern_index:  unsigned(2 downto 0);
        burstlen_index: unsigned(2 downto 0);
        pattern:        std_logic_vector(15 downto 0);
        burstlen:       unsigned(9 downto 0);
        burst_addr:     unsigned(address_bits downto 0);
        burst_end:      unsigned(address_bits downto 0);
        byte_addr:      unsigned(address_bits downto 0);
        rdata_fifolen:  unsigned(2 downto 0);
        rdata_fifo:     std_logic_vector(23 downto 0);
    end record;

    -- Power-on initialization of internal registers.
    constant regs_init: regs_type := (
        state           => State_Init,
        index           => (others => '0'),
        cmd_valid       => '0',
        cmd_write       => '0',
        cmd_addr        => (others => '0'),
        cmd_wdata       => (others => '0'),
        cmd_wmask       => (others => '0'),
        fail_count      => (others => '0'),
        fail_count_inc  => '0',
        round_count     => (others => '0'),
        fail_flag       => '0',
        pass_flag       => '0',
        msg_valid       => '0',
        msg_data        => (others => '0'),
        hexshift        => (others => '0'),
        pattern_index   => (others => '0'),
        burstlen_index  => (others => '0'),
        pattern         => (others => '0'),
        burstlen        => (others => '0'),
        burst_addr      => (others => '0'),
        burst_end       => (others => '0'),
        byte_addr       => (others => '0'),
        rdata_fifolen   => (others => '0'),
        rdata_fifo      => (others => '0') );

    -- Internal registers.
    signal r:               regs_type := regs_init;

begin

    --
    -- Drive outputs.
    --
    ram_cmd_valid   <= r.cmd_valid;
    ram_cmd_write   <= r.cmd_write;
    ram_cmd_addr    <= r.cmd_addr;
    ram_cmd_wdata   <= r.cmd_wdata;
    ram_cmd_wmask   <= r.cmd_wmask;
    fail_count      <= std_logic_vector(r.fail_count);
    round_count     <= std_logic_vector(r.round_count);
    fail_flag       <= r.fail_flag;
    pass_flag       <= r.pass_flag;
    msg_valid       <= r.msg_valid;
    msg_data        <= r.msg_data;

    --
    -- Synchronous process.
    --
    process (clk) is
        -- New register values.
        variable v: regs_type := r;

        -- Check read response against expected pattern.
        procedure Check_ReadResponse is
            variable v_rdata_invert: std_logic := '0';
            variable v_rdata_mask:   std_logic_vector(1 downto 0) := "00";
            variable v_expect_rdata: std_logic_vector(15 downto 0) := (others => '0');
        begin
            -- Assume no failure.
            v.fail_count_inc := '0';

            if ram_rsp_valid = '1' then
                if r.rdata_fifolen = 0 then
                    -- Got unexpected read response.
                    v.fail_count_inc := '1';
                else
                    -- Get one expected pattern from the FIFO.
                    v_rdata_invert  := r.rdata_fifo(3 * to_integer(r.rdata_fifolen) - 1);
                    v_rdata_mask    := r.rdata_fifo(3 * to_integer(r.rdata_fifolen) - 2 downto 3 * to_integer(r.rdata_fifolen) - 3);
                    v.rdata_fifolen := r.rdata_fifolen - 1;
                    -- Check read response against expected pattern.
                    if v_rdata_invert = '1' then
                        v_expect_rdata  := not r.pattern;
                    else
                        v_expect_rdata  := r.pattern;
                    end if;
                    if ((v_rdata_mask(0) = '1') and (ram_rsp_rdata(7 downto 0) /= v_expect_rdata(7 downto 0))) or
                       ((v_rdata_mask(1) = '1') and (ram_rsp_rdata(15 downto 8) /= v_expect_rdata(15 downto 8))) then
                       v.fail_count_inc := '1';
                    end if;
                end if;
            end if;

            -- Update fail counter.
            if r.fail_count_inc = '1' then
                v.fail_count := r.fail_count + 1;
            end if;
        end procedure;

        -- Full reset of test driver.
        procedure Handle_Init is
        begin
            v.state         := State_Greeting;
            v.index         := (others => '0');
            v.fail_count    := (others => '0');
            v.fail_count_inc := '0';
            v.round_count   := (others => '0');
            v.rdata_fifolen := (others => '0');
        end procedure;

        -- Write greeting message to debug output.
        procedure Handle_Greeting is
            constant msg_greeting: string(1 to 15) := NUL & "  " & CR & LF & "RAM Test" & CR & LF;
        begin
            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.index         := r.index + 1;
                if r.index < msg_greeting'high then
                    v.msg_data      := std_logic_vector(to_unsigned(character'pos(msg_greeting(to_integer(r.index) + 1)), 8));
                else
                    v.msg_valid     := '0';
                    v.state         := State_NewRound;
                    v.index         := (others => '0');
                end if;
            end if;
        end procedure;

        -- Prepare to start a new round.
        procedure Handle_NewRound is
        begin
            v.pattern_index := (others => '0');

            -- Write "R=nnnn F=nnnnnnnn" to debug output.
            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.index         := r.index + 1;
                v.msg_data      := hexdigit(r.hexshift(r.hexshift'high downto r.hexshift'high-3));
                v.hexshift      := r.hexshift(r.hexshift'high-4 downto 0) & "0000";
                case to_integer(r.index) is
                    when 0 =>
                        v.msg_data      := x"52";  -- 'R'
                    when 1 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift(31 downto 16) := std_logic_vector(r.round_count);
                    when 6 =>
                        v.msg_data      := x"20";  -- ' '
                    when 7 =>
                        v.msg_data      := x"46";  -- 'F'
                    when 8 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift      := std_logic_vector(r.fail_count);
                    when 17 =>
                        v.msg_data      := x"0D";
                    when 18 =>
                        v.msg_data      := x"0A";
                    when 19 =>
                        v.msg_valid     := '0';
                        v.state         := State_NewPattern;
                        v.index         := (others => '0');
                    when others =>
                        null;
                end case;
            end if;
        end procedure;

        -- Prepare to start a new data pattern.
        procedure Handle_NewPattern is
        begin
            v.burstlen_index := (others => '0');

            -- Write "P=nnnn " to debug output.
            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.index         := r.index + 1;
                v.msg_data      := hexdigit(r.hexshift(r.hexshift'high downto r.hexshift'high-3));
                v.hexshift      := r.hexshift(r.hexshift'high-4 downto 0) & "0000";
                case to_integer(r.index) is
                    when 0 =>
                        v.msg_data      := x"50";  -- 'P'
                    when 1 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift(31 downto 16) := r.pattern;
                    when 6 =>
                        v.msg_data      := x"20";  -- ' '
                    when 7 =>
                        v.msg_valid     := '0';
                        v.state         := State_NewBurstLen;
                        v.index         := (others => '0');
                    when others =>
                        null;
                end case;
            end if;
        end procedure;

        -- Prepare to test a new burst length.
        procedure Handle_NewBurstLen is
        begin
            v.burst_addr    := (others => '0');
            v.burst_end     := resize(r.burstlen - 1, v.burst_end'length);
            v.byte_addr     := (others => '0');

            -- Write "B=nnn " to debug output.
            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.msg_data      := hexdigit(r.hexshift(r.hexshift'high downto r.hexshift'high-3));
                v.index         := r.index + 1;
                v.hexshift      := r.hexshift(r.hexshift'high-4 downto 0) & "0000";
                case to_integer(r.index) is
                    when 0 =>
                        v.msg_data      := x"42";  -- 'B'
                    when 1 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift(31 downto 20) := "00" & std_logic_vector(r.burstlen);
                    when 5 =>
                        v.msg_data      := x"20";  -- ' '
                    when 6 =>
                        v.msg_valid     := '0';
                        v.state         := State_Elem1Write;
                    when others =>
                        null;
                end case;
            end if;
        end procedure;

        -- Execute march element 1: up(w0).
        procedure Handle_Elem1Write is
        begin
            v.cmd_valid     := '1';
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Start a new write transaction.
                v.cmd_write     := '1';
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                v.cmd_wdata     := r.pattern;
                if r.byte_addr(0) = '1' then
                    v.cmd_wmask     := "01";  -- burst starts on odd byte address
                elsif r.byte_addr = r.burst_end then
                    v.cmd_wmask     := "10";  -- burst ends on odd byte address
                else
                    v.cmd_wmask     := "11";
                end if;
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst.
                    if r.burst_end + r.burstlen >= r.burstlen then
                        -- Continue with next burst.
                        v.burst_addr    := r.burst_end + 1;
                        v.burst_end     := r.burst_end + r.burstlen;
                        v.byte_addr     := r.burst_end + 1;
                    else
                        -- Go to the next march element.
                        v.burst_addr    := (others => '0');
                        v.burst_end     := resize(r.burstlen - 1, v.burst_end'length);
                        v.byte_addr     := (others => '0');
                        v.state         := State_Elem2Read;
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the read phase of march element 2: up(r0, w1).
        procedure Handle_Elem2Read is
            variable v_rdata_invert: std_logic := '0';
            variable v_rdata_mask:   std_logic_vector(1 downto 0) := "11";
        begin
            v.cmd_valid     := '1';
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Start a new read transaction.
                v.cmd_write     := '0';
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                -- Add exected result to read FIFO.
                v_rdata_invert  := '0';  -- expect non-inverted pattern
                if r.byte_addr(0) = '1' then
                    v_rdata_mask    := "01";  -- ignore first byte
                elsif r.byte_addr = r.burst_end then
                    v_rdata_mask    := "10";  -- ignore second byte
                else
                    v_rdata_mask    := "11";
                end if;
                v.rdata_fifolen := v.rdata_fifolen + 1;
                v.rdata_fifo    := r.rdata_fifo(r.rdata_fifo'high-3 downto 0) & v_rdata_invert & v_rdata_mask;
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst; go to the write phase.
                    v.byte_addr     := r.burst_addr;
                    v.state         := State_Elem2Write;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the write phase of march element 2: up(r0, w1).
        procedure Handle_Elem2Write is
        begin
            v.cmd_valid     := '1';
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Start a new write transaction.
                v.cmd_write     := '1';
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                v.cmd_wdata     := not r.pattern;
                if r.byte_addr(0) = '1' then
                    v.cmd_wmask     := "01";  -- burst starts on odd byte address
                elsif r.byte_addr = r.burst_end then
                    v.cmd_wmask     := "10";  -- burst ends on odd byte address
                else
                    v.cmd_wmask     := "11";
                end if;
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst.
                    if r.burst_end + r.burstlen >= r.burstlen then
                        -- Continue with next burst.
                        v.burst_addr    := r.burst_end + 1;
                        v.burst_end     := r.burst_end + r.burstlen;
                        v.byte_addr     := r.burst_end + 1;
                        v.state         := State_Elem2Read;
                    else
                        -- Go to the next march element.
                        v.byte_addr     := r.burst_addr;
                        v.state         := State_Elem3Read;
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the read phase of march element 3: down(r1, w0).
        procedure Handle_Elem3Read is
            variable v_rdata_invert: std_logic := '0';
            variable v_rdata_mask:   std_logic_vector(1 downto 0) := "11";
        begin
            v.cmd_valid     := '1';
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Start a new read transaction.
                v.cmd_write     := '0';
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                -- Add exected result to read FIFO.
                v_rdata_invert  := '1';  -- expect inverted pattern
                if r.byte_addr(0) = '1' then
                    v_rdata_mask    := "01";  -- ignore first byte
                elsif r.byte_addr = r.burst_end then
                    v_rdata_mask    := "10";  -- ignore second byte
                else
                    v_rdata_mask    := "11";
                end if;
                v.rdata_fifolen := v.rdata_fifolen + 1;
                v.rdata_fifo    := r.rdata_fifo(r.rdata_fifo'high-3 downto 0) & v_rdata_invert & v_rdata_mask;
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst; go to the write phase.
                    v.byte_addr     := r.burst_addr;
                    v.state         := State_Elem3Write;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the write phase of march element 3: down(r1, w0).
        procedure Handle_Elem3Write is
        begin
            v.cmd_valid     := '1';
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Start a new write transaction.
                v.cmd_write     := '1';
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                v.cmd_wdata     := r.pattern;
                if r.byte_addr(0) = '1' then
                    v.cmd_wmask     := "01";  -- burst starts on odd byte address
                elsif r.byte_addr = r.burst_end then
                    v.cmd_wmask     := "10";  -- burst ends on odd byte address
                else
                    v.cmd_wmask     := "11";
                end if;
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst.
                    if r.burst_addr > 0 then
                        -- Continue with next burst.
                        v.burst_addr    := r.burst_addr - r.burstlen;
                        v.burst_end     := r.burst_addr - 1;
                        v.byte_addr     := r.burst_addr - r.burstlen;
                        v.state         := State_Elem3Read;
                    else
                        -- End march.
                        v.state         := State_EndBurstLen;
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Wait until final write transaction accepted and final read result processed.
        procedure Handle_EndBurstLen is
        begin
            v.index         := (others => '0');
            v.cmd_valid     := r.cmd_valid and (not ram_cmd_ready);
            if (r.cmd_valid = '0') and (r.rdata_fifolen = 0) then
                -- Go to the next burst length or end the current pattern.
                v.burstlen_index := r.burstlen_index + 1;
                if r.burstlen_index < burst_length_table'high then
                    v.state     := State_NewBurstLen;
                else
                    v.state     := State_EndPattern;
                end if;
            end if;
        end procedure;

        -- Finish testing with the current data pattern.
        procedure Handle_EndPattern is
        begin
            -- Write "F=nnnnnnnn " to debug output.
            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.index         := r.index + 1;
                v.msg_data      := hexdigit(r.hexshift(r.hexshift'high downto r.hexshift'high-3));
                v.hexshift      := r.hexshift(r.hexshift'high-4 downto 0) & "0000";
                case to_integer(r.index) is
                    when 0 =>
                        v.msg_data      := x"46";  -- 'F'
                    when 1 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift      := std_logic_vector(r.fail_count);
                    when 10 =>
                        v.msg_data      := x"0D";
                    when 11 =>
                        v.msg_data      := x"0A";
                    when 12 =>
                        v.msg_valid     := '0';
                        -- Go to the next pattern or end the current round.
                        v.pattern_index := r.pattern_index + 1;
                        if r.pattern_index < test_data'high then
                            v.state         := State_NewPattern;
                        else
                            v.state         := State_EndRound;
                        end if;
                        v.index         := (others => '0');
                    when others =>
                        null;
                end case;
            end if;
        end procedure;

        -- Prepare to start the next round.
        procedure Handle_EndRound is
        begin
            v.round_count   := r.round_count + 1;
            v.state         := State_NewRound;
            v.index         := (others => '0');
        end procedure;

    begin
        if rising_edge(clk) then

            -- By default do not intiate a memory transaction.
            v.cmd_valid     := '0';

            -- By default do not output a debug character.
            v.msg_valid     := '0';

            -- Update pass/fail flags.
            v.fail_flag     := '0';
            v.pass_flag     := '0';
            if r.fail_count /= 0 then
                v.fail_flag     := '1';
            end if;
            if (r.fail_count = 0) and (r.round_count /= 0) then
                v.pass_flag     := '1';
            end if;

            -- Select data pattern.
            v.pattern       := test_data(to_integer(r.pattern_index));

            -- Select burst length.
            v.burstlen      := to_unsigned(burst_length_table(to_integer(r.burstlen_index)), 10);

            -- Verify read data.
            Check_ReadResponse;

            -- Main state machine.
            case r.state is
                when State_Init =>
                    Handle_Init;
                when State_Greeting =>
                    Handle_Greeting;
                when State_NewRound =>
                    Handle_NewRound;
                when State_NewPattern =>
                    Handle_NewPattern;
                when State_NewBurstLen =>
                    Handle_NewBurstLen;
                when State_Elem1Write =>
                    Handle_Elem1Write;
                when State_Elem2Read =>
                    Handle_Elem2Read;
                when State_Elem2Write =>
                    Handle_Elem2Write;
                when State_Elem3Read =>
                    Handle_Elem3Read;
                when State_Elem3Write =>
                    Handle_Elem3Write;
                when State_EndBurstLen =>
                    Handle_EndBurstLen;
                when State_EndPattern =>
                    Handle_EndPattern;
                when State_EndRound =>
                    Handle_EndRound;
            end case;

            -- Synchronous reset.
            if rst = '1' then
                v.state         := State_Init;
                v.cmd_valid     := '0';
                v.msg_valid     := '0';
            end if;

            -- Update registers.
            r <= v;

        end if;
    end process;

end architecture;


