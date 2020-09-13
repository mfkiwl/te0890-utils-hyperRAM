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
--   For each pattern in [0x0000, 0xff00, 0xaa55, 0xcc33, 0xf00f, 0xb5c4]:
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
--   Finally, test each burst_length with a pseudo-random pattern.
--       Only incrementing address order is used in this case.
--       The march elements for pseudo-random data are up(wX) ; up(rX, wY) ; up(rY).
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
    -- Patterns 0 to 4 are fixed 16-bit patterns.
    -- Patterns 5 and 6 use pseudo-random data.
    type test_pattern_type is
        array(natural range <>) of std_logic_vector(15 downto 0);
    constant test_pattern_data: test_pattern_type(0 to 6) := (
        x"0000",
        x"ff00",
        x"aa55",
        x"cc33",
        x"f00f",
        x"0000",
        x"0000" );
    constant test_pattern_random: std_logic_vector(6 downto 0) := "1100000";

    -- RAM for error logging
    constant error_mem_databits: integer := 2 + address_bits + 2 + 16 + 16;
    type error_mem_type is array(0 to 63) of std_logic_vector(error_mem_databits-1 downto 0);
    signal error_mem: error_mem_type;

    -- Main state machine.
    type state_type is (
        State_Init,
        State_Greeting,
        State_NewRound,
        State_NewPattern,
        State_NewBurstLen,
        State_StartMarch,
        State_MarchUpW0,
        State_MarchUpR0,
        State_MarchUpW1,
        State_MarchDownR1,
        State_MarchDownW0,
        State_MarchUpR1,
        State_EndBurstLen,
        State_ReportError,
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
        invert_pattern: std_logic;
        invert_prev:    std_logic;
        random_pattern: std_logic;
        march_active:   std_logic;
        march_write:    std_logic;
        burstlen:       unsigned(9 downto 0);
        burst_addr:     unsigned(address_bits downto 0);
        burst_end:      unsigned(address_bits downto 0);
        byte_addr:      unsigned(address_bits downto 0);
        rdata_fifolen:  unsigned(2 downto 0);
        rdata_fifo:     std_logic_vector(20 downto 0);
        errmem_write:   std_logic;
        errmem_waddr:   unsigned(5 downto 0);
        errmem_raddr:   unsigned(5 downto 0);
        errmem_wdata:   std_logic_vector(error_mem_databits-1 downto 0);
        errmem_rdata:   std_logic_vector(error_mem_databits-1 downto 0);
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
        invert_pattern  => '0',
        invert_prev     => '0',
        random_pattern  => '0',
        march_active    => '0',
        march_write     => '0',
        burstlen        => (others => '0'),
        burst_addr      => (others => '0'),
        burst_end       => (others => '0'),
        byte_addr       => (others => '0'),
        rdata_fifolen   => (others => '0'),
        rdata_fifo      => (others => '0'),
        errmem_write    => '0',
        errmem_waddr    => (others => '0'),
        errmem_raddr    => (others => '0'),
        errmem_wdata    => (others => '0'),
        errmem_rdata    => (others => '0') );

    -- Internal registers.
    signal r:               regs_type := regs_init;

    -- Signals to random generator.
    signal s_rng_wr_ready:  std_logic;
    signal s_rng_rd_ready:  std_logic;
    signal s_rng_wr_data:   std_logic_vector(31 downto 0);
    signal s_rng_rd_data:   std_logic_vector(31 downto 0);

begin

    --
    -- Random generators.
    --
    inst_random_wr: entity work.random_gen
        generic map (
            init_seed   => x"c90fdaa22168c234c4c6628b80dc1cd1" )
        port map (
            clk         => clk,
            rst         => rst,
            out_ready   => s_rng_wr_ready,
            out_valid   => open,
            out_data    => s_rng_wr_data );

    inst_random_rd: entity work.random_gen
        generic map (
            init_seed   => x"c90fdaa22168c234c4c6628b80dc1cd1" )
        port map (
            clk         => clk,
            rst         => rst,
            out_ready   => s_rng_rd_ready,
            out_valid   => open,
            out_data    => s_rng_rd_data );

    -- Fetch a new random word whenever we start a random write transaction.
    s_rng_wr_ready  <= r.march_active and
                       r.march_write and
                       r.random_pattern and
                       ((not r.cmd_valid) or ram_cmd_ready);

    -- Fetch a new random word whenever we verify a random read data word.
    s_rng_rd_ready  <= r.random_pattern and ram_rsp_valid;

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
        variable v: regs_type;

        -- Check read response against expected pattern.
        procedure CheckReadResponse is
            variable v_march_phase:  std_logic := '0';
            variable v_rdata_valid:  std_logic := '0';
            variable v_rdata_invert: std_logic := '0';
            variable v_rdata_mask:   std_logic_vector(1 downto 0) := "00";
            variable v_expect_rdata: std_logic_vector(15 downto 0) := (others => '0');
        begin
            -- Assume no failure.
            v.fail_count_inc := '0';
            v.errmem_write   := '0';

            -- Figure out which of the two march elements this read belongs to.
            -- Note the last few reads from MarchUpR0 can be mis-attributed to MarchDownR1.
            if (r.state = State_MarchUpR0) or (r.state = State_MarchUpW1) then
                v_march_phase  := '0';
            else
                v_march_phase  := '1';
            end if;

            -- Get next expected pattern from the FIFO (if non-empty).
            if r.rdata_fifolen > 0 then
                v_rdata_valid   := '1';
                v_rdata_invert  := r.rdata_fifo(3 * to_integer(r.rdata_fifolen) - 1);
                v_rdata_mask    := r.rdata_fifo(3 * to_integer(r.rdata_fifolen) - 2 downto 3 * to_integer(r.rdata_fifolen) - 3);
            end if;

            -- Determine expected read data word (if read FIFO non-empty).
            if r.random_pattern = '1' then
                v_expect_rdata  := s_rng_rd_data(31 downto 16);
            elsif v_rdata_invert = '1' then
                v_expect_rdata  := not r.pattern;
            else
                v_expect_rdata  := r.pattern;
            end if;

            -- Check read response data.
            if ram_rsp_valid = '1' then
                if r.rdata_fifolen = 0 then
                    -- Got unexpected read response.
                    v.fail_count_inc := '1';
                    v.errmem_write   := '1';
                else
                    v.rdata_fifolen := v.rdata_fifolen - 1;
                    if ((v_rdata_mask(0) = '1') and (ram_rsp_rdata(7 downto 0) /= v_expect_rdata(7 downto 0))) or
                       ((v_rdata_mask(1) = '1') and (ram_rsp_rdata(15 downto 8) /= v_expect_rdata(15 downto 8))) then
                        v.fail_count_inc := '1';
                        v.errmem_write   := '1';
                    end if;
                end if;
            end if;

            -- Push new read transactions into the verify FIFO.
            if r.cmd_valid = '1' and ram_cmd_ready = '1' and r.cmd_write = '0' then
                v.rdata_fifolen := v.rdata_fifolen + 1;
                v.rdata_fifo    := r.rdata_fifo(r.rdata_fifo'high-3 downto 0) & r.invert_prev & r.cmd_wmask;
            end if;

            -- Update fail counter.
            if r.fail_count_inc = '1' then
                v.fail_count := r.fail_count + 1;
            end if;

            -- Prepare data to push into the error log.
            v.errmem_wdata(1+address_bits+2+16+16)  := not v_rdata_valid;
            v.errmem_wdata(address_bits+2+16+16)    := v_march_phase;
            v.errmem_wdata(address_bits-1+2+16+16 downto 2+16+16) := std_logic_vector(r.byte_addr(address_bits downto 1));
            v.errmem_wdata(1+16+16 downto 16+16)    := v_rdata_mask;
            v.errmem_wdata(15+16 downto 16)         := v_expect_rdata;
            v.errmem_wdata(15 downto 0)             := ram_rsp_rdata;

            -- Update error log pointer.
            if (r.errmem_write = '1') and (r.errmem_waddr < error_mem'high) then
                v.errmem_waddr := r.errmem_waddr + 1;
            end if;
        end procedure;

        -- Push transactions to the HyperRAM controller.
        procedure DriveMemTransaction is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                v.cmd_valid     := r.march_active;
            end if;
            if (r.march_active = '1') and ((r.cmd_valid = '0') or (ram_cmd_ready = '1')) then

                -- Start a new transaction.
                v.cmd_write     := r.march_write;
                v.cmd_addr      := std_logic_vector(r.byte_addr(r.byte_addr'high downto 1));
                if r.random_pattern = '1' then
                    v.cmd_wdata     := s_rng_wr_data(31 downto 16);
                elsif r.invert_pattern = '1' then
                    v.cmd_wdata     := not r.pattern;
                else
                    v.cmd_wdata     := r.pattern;
                end if;
                if r.byte_addr(0) = '1' then
                    v.cmd_wmask     := "01";  -- burst starts on odd byte address
                elsif r.byte_addr = r.burst_end then
                    v.cmd_wmask     := "10";  -- burst ends on odd byte address
                else
                    v.cmd_wmask     := "11";
                end if;

                -- Keep track of whether the new transaction uses an inverted pattern.
                -- This is important for verifying read data.
                v.invert_prev   := r.invert_pattern;
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
            v.march_active  := '0';
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
                    when 2 | 3 | 4 | 5 =>
                        if r.random_pattern = '1' then
                            v.msg_data := x"72";  -- 'r'
                        end if;
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
                        v.state         := State_StartMarch;
                    when others =>
                        null;
                end case;
            end if;
        end procedure;

        -- Start the march sequence.
        procedure Handle_StartMarch is
        begin
            -- Clear error log.
            v.errmem_waddr  := (others => '0');
            v.errmem_raddr  := (others => '0');

            -- Prepare to start element up(w0).
            v.burst_addr    := (others => '0');
            v.burst_end     := resize(r.burstlen - 1, v.burst_end'length);
            v.byte_addr     := (others => '0');
            v.march_active  := '1';
            v.march_write   := '1';
            v.invert_pattern := '0';
            v.state         := State_MarchUpW0;
        end procedure;

        -- Execute march element up(w0).
        procedure Handle_MarchUpW0 is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- Handle end of burst.
                    if r.burst_end + r.burstlen >= r.burstlen then
                        -- Continue with next burst.
                        v.burst_addr    := r.burst_end + 1;
                        v.burst_end     := r.burst_end + r.burstlen;
                        v.byte_addr     := r.burst_end + 1;
                    else
                        -- Go to march element up(r0, w1).
                        v.burst_addr    := (others => '0');
                        v.burst_end     := resize(r.burstlen - 1, v.burst_end'length);
                        v.byte_addr     := (others => '0');
                        v.march_write   := '0';
                        v.invert_pattern := '0';
                        v.state         := State_MarchUpR0;
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the read phase of march element up(r0, w1).
        procedure Handle_MarchUpR0 is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst; go to the write phase of this march element.
                    v.byte_addr     := r.burst_addr;
                    v.march_write   := '1';
                    v.invert_pattern := '1';
                    v.state         := State_MarchUpW1;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the write phase of march element up(r0, w1).
        procedure Handle_MarchUpW1 is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst.
                    if r.burst_end + r.burstlen >= r.burstlen then
                        -- Continue with read phase of the next burst.
                        v.burst_addr    := r.burst_end + 1;
                        v.burst_end     := r.burst_end + r.burstlen;
                        v.byte_addr     := r.burst_end + 1;
                        v.march_write   := '0';
                        v.invert_pattern := '0';
                        v.state         := State_MarchUpR0;
                    else
                        -- Go to the next march element.
                        if r.random_pattern = '1' then
                            -- Go to march element up(r1).
                            v.burst_addr    := (others => '0');
                            v.burst_end     := resize(r.burstlen - 1, v.burst_end'length);
                            v.byte_addr     := (others => '0');
                            v.march_write   := '0';
                            v.invert_pattern := '1';
                            v.state         := State_MarchUpR1;
                        else
                            -- Go to march element down(r1, w0).
                            -- Start at the end of RAM (the burst address we just reached).
                            v.byte_addr     := r.burst_addr;
                            v.march_write   := '0';
                            v.invert_pattern := '1';
                            v.state         := State_MarchDownR1;
                        end if;
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the read phase of march element down(r1, w0).
        procedure Handle_MarchDownR1 is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst; go to the write phase of this march element.
                    v.byte_addr     := r.burst_addr;
                    v.march_write   := '1';
                    v.invert_pattern := '0';
                    v.state         := State_MarchDownW0;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute the write phase of march element down(r1, w0).
        procedure Handle_MarchDownW0 is
        begin
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- End burst.
                    if r.burst_addr > 0 then
                        -- Continue with read phase of the next burst.
                        v.burst_addr    := r.burst_addr - r.burstlen;
                        v.burst_end     := r.burst_addr - 1;
                        v.byte_addr     := r.burst_addr - r.burstlen;
                        v.state         := State_MarchDownR1;
                    else
                        -- End march.
                        v.state         := State_EndBurstLen;
                        v.march_active  := '0';
                    end if;
                else
                    -- Continue burst.
                    v.byte_addr     := shift_left(shift_right(r.byte_addr, 1) + 1, 1);
                end if;
            end if;
        end procedure;

        -- Execute march element up(r1).
        procedure Handle_MarchUpR1 is
        begin
            -- This march element is instead of down(r1, w0) when using a random data pattern,
            -- because we can generate the random data pattern in reverse order.
            if (r.cmd_valid = '0') or (ram_cmd_ready = '1') then
                -- Update address.
                if shift_right(r.byte_addr, 1) = shift_right(r.burst_end, 1) then
                    -- Handle end of burst.
                    if r.burst_end + r.burstlen >= r.burstlen then
                        -- Continue with next burst.
                        v.burst_addr    := r.burst_end + 1;
                        v.burst_end     := r.burst_end + r.burstlen;
                        v.byte_addr     := r.burst_end + 1;
                    else
                        -- End march.
                        v.state         := State_EndBurstLen;
                        v.march_active  := '0';
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
                if r.errmem_raddr = r.errmem_waddr then
                    -- Reached end of error log.
                    -- Go to the next burst length or end the current pattern.
                    v.burstlen_index := r.burstlen_index + 1;
                    if r.burstlen_index < burst_length_table'high then
                        v.state     := State_NewBurstLen;
                    else
                        v.state     := State_EndPattern;
                    end if;
                else
                    -- Dump error log.
                    v.state     := State_ReportError;
                end if;
            end if;
        end procedure;

        procedure Handle_ReportError is
            variable v_err_phase:    std_logic_vector(1 downto 0) := "00";
            variable v_err_addr:     std_logic_vector(address_bits-1 downto 0) := (others => '0');
            variable v_err_mask:     std_logic_vector(1 downto 0) := "00";
            variable v_err_expect:   std_logic_vector(15 downto 0) := (others => '0');
            variable v_err_rdata:    std_logic_vector(15 downto 0) := (others => '0');
        begin
            -- Write "E=n-nnnnnn-n-nnnn-nnnn " to debug output.

            v_err_phase  := r.errmem_rdata(1+address_bits+2+16+16 downto address_bits+2+16+16);
            v_err_addr   := r.errmem_rdata(address_bits-1+2+16+16 downto 2+16+16);
            v_err_mask   := r.errmem_rdata(1+16+16 downto 16+16);
            v_err_expect := r.errmem_rdata(15+16 downto 16);
            v_err_rdata  := r.errmem_rdata(15 downto 0);

            v.msg_valid     := '1';
            if (r.msg_valid = '0') or (msg_ready = '1') then
                v.index         := r.index + 1;
                v.msg_data      := hexdigit(r.hexshift(r.hexshift'high downto r.hexshift'high-3));
                v.hexshift      := r.hexshift(r.hexshift'high-4 downto 0) & "0000";
                case to_integer(r.index) is
                    when 0 =>
                        v.msg_data      := x"45";  -- 'E'
                    when 1 =>
                        v.msg_data      := x"3D";  -- '='
                        v.hexshift(31 downto 28) := "00" & v_err_phase;
                    when 3 =>
                        v.msg_data      := x"2D";  -- '-'
                        v.hexshift(31 downto 8) := (others => '0');
                        v.hexshift(address_bits+7 downto 8) := v_err_addr;
                    when 10 =>
                        v.msg_data      := x"2D";  -- '-'
                        v.hexshift(31 downto 28) := "00" & v_err_mask;
                    when 12 =>
                        v.msg_data      := x"2D";  -- '-'
                        v.hexshift(31 downto 16) := v_err_expect;
                    when 17 =>
                        v.msg_data      := x"2D";  -- '-'
                        v.hexshift(31 downto 16) := v_err_rdata;
                    when 22 =>
                        v.msg_data      := x"20";  -- ' '
                    when 23 =>
                        -- Go to next error log entry.
                        v.msg_valid     := '0';
                        v.errmem_raddr  := r.errmem_raddr + 1;
                        v.state         := State_EndBurstLen;
                    when others =>
                        null;
                end case;
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
                        if r.pattern_index < test_pattern_data'high then
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
        -- Initialize next registers from current registers.
        v := r;

        if rising_edge(clk) then

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
            v.pattern       := test_pattern_data(to_integer(r.pattern_index));
            v.random_pattern := test_pattern_random(to_integer(r.pattern_index));

            -- Select burst length.
            v.burstlen      := to_unsigned(burst_length_table(to_integer(r.burstlen_index)), 10);

            -- Verify read data.
            CheckReadResponse;

            -- Push new transactions to the HyperRAM controller.
            DriveMemTransaction;

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
                when State_StartMarch =>
                    Handle_StartMarch;
                when State_MarchUpW0 =>
                    Handle_MarchUpW0;
                when State_MarchUpR0 =>
                    Handle_MarchUpR0;
                when State_MarchUpW1 =>
                    Handle_MarchUpW1;
                when State_MarchDownR1 =>
                    Handle_MarchDownR1;
                when State_MarchDownW0 =>
                    Handle_MarchDownW0;
                when State_MarchUpR1 =>
                    Handle_MarchUpR1;
                when State_EndBurstLen =>
                    Handle_EndBurstLen;
                when State_ReportError =>
                    Handle_ReportError;
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
                v.march_active  := '0';
            end if;

            -- Error memory implementation.
            v.errmem_rdata := error_mem(to_integer(r.errmem_raddr));
            if r.errmem_write = '1' then
                error_mem(to_integer(r.errmem_waddr)) <= r.errmem_wdata;
            end if;

            -- Update registers.
            r <= v;

        end if;
    end process;

end architecture;


