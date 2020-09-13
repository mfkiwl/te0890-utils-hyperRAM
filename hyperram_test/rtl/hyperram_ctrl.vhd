--
-- HyperRAM memory controller.
--
-- This entity receives read and write requests via a command stream
-- with valid/ready handshaking. Read data are reported back via a
-- read response flow with data-valid marker. Read transactions have
-- a variable latency, typically between 10 and 20 clock cycles.
-- Write transactions are not reported back.
--
-- All memory transactions are 16 bits wide.
--
-- Each non-sequential transaction has a latency of 10 to 20 clock cycles.
-- Back-to-back sequential transactions with an address increment of 1
-- will be mapped to linear bursts on the HyperRAM. Burst transactions
-- proceed at a typical rate of 1 transaction per clock cycle, but
-- the HyperRAM may insert wait states into a read burst.
--
-- After reset, some delay is required before the memory becomes
-- accessible (t_init_clk). The controller will then perform a
-- single write to configuration register 0. After that, the controller
-- will be ready to accept commands.
--
-- This implementation uses the same clock signal for generating the CK signal
-- for the HyperRAM and for capturing data from the HyperRAM. This works when
-- running at 100 MHz on a TE0890 module. (Since in this case the CK-to-data
-- delay is approximately 10 ns = one clock cycle). This implementation will
-- probably not work on other clock frequencies or other board designs.
--
-- Default values for the generic parameters are suitable for running
-- at 100 MHz on a TE0890 module.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity hyperram_ctrl is

    generic (
        -- Number of address bits.
        -- Each address identifies a 16-bit word.
        -- The total size of the address space is thus 2**(address_bits+1) bytes.
        address_bits:   integer range 12 to 31 := 22;

        -- Maximum burst length as a number of clock cycles.
        -- This must be set such that the burst duration does not exceed the
        -- refresh interval.
        max_burst:      integer range 2 to 1023 := 320;

        -- Initial latency (t_ACC) as a number of clock cycles.
        -- Must match the setting in configuration register 0.
        t_access_clk:   integer range 4 to 6 := 4;

        -- Read-write-recovery time (t_RWR) as a number of clock cycles.
        t_rwr_clk:      integer range 4 to 7 := 4;

        -- Reset pulse duration (t_RP) as a number of clock cycles.
        t_reset_clk:    integer range 2 to 1023 := 64;

        -- Power up delay (t_VCS) as a number of clock cycles.
        t_init_clk:     integer range 2 to 16383 := 15000;

        -- Data to be written to configuration register 0 after reset.
        --   bit 15:    deep power down (1=normal, 0=power down), must be "1".
        --   bit 14-12: drive strength; default "000" = 34 Ohm.
        --   bit 11-8:  reserved, must be "1111".
        --   bit 7-4:   initial latency, must match "t_access_clk",
        --                "0000" = 5 clocks,
        --                "0001" = 6 clocks,
        --                "1110" = 3 clocks,
        --                "1111" = 4 clocks.
        --   bit 3:     fixed latency (1=fixed, 0=variable), both supported.
        --   bit 2:     hybrid burst, default "1", ignored for linear burst.
        --   bit 1-0:   burst length, default "11", ignored for linear burst.
        config0_data:   std_logic_vector(15 downto 0) := "1000111111110111"
    );

    port (
        -- Main clock (100 MHz).
        -- All bus signals are synchronous to the rising edge of this clock.
        -- The HyperRAM clock runs at the same frequency as this clock.
        clk:        in  std_logic;

        -- Main clock delayed by 270 degrees.
        -- Used to generate the HyperRAM data input.
        clk270:     in  std_logic;

        -- Synchronous reset, active high.
        rst:        in  std_logic;

        -- High when command input signals are valid.
        cmd_valid:  in  std_logic;

        -- High to request a write transaction.
        -- Low to request a read transaction.
        cmd_write:  in  std_logic;

        -- Address for the read/write transaction.        
        cmd_addr:   in  std_logic_vector(address_bits-1 downto 0);

        -- Data to write.
        cmd_wdata:  in  std_logic_vector(15 downto 0);

        -- Write enable mask (to support single-byte writes).
        -- High to enable writing to indexed byte.
        cmd_wmask:  in  std_logic_vector(1 downto 0);

        -- High when entity is ready to accept new command signals.
        -- A transaction starts if "cmd_valid" and "cmd_ready" are both
        -- high on a rising "clk".
        cmd_ready:  out std_logic;

        -- High when valid read data is presented on "rsp_rdata".
        rsp_valid:  out std_logic;

        -- Read data from memory.
        rsp_rdata:  out std_logic_vector(15 downto 0);

        -- HyperRAM signals.
        -- In/out signals are split into xx_i, xx_o, xx_t, to be combined
        -- in external tri-state IO buffers.
        ram_csn:    out std_logic;
        ram_ck:     out std_logic;
        ram_rstn:   out std_logic;
        ram_dq_i:   in  std_logic_vector(7 downto 0);
        ram_dq_o:   out std_logic_vector(7 downto 0);
        ram_dq_t:   out std_logic_vector(7 downto 0);
        ram_rwds_i: in  std_logic;
        ram_rwds_o: out std_logic;
        ram_rwds_t: out std_logic
    );

end entity;


architecture arch_hyperram_ctrl of hyperram_ctrl is

    -- Address of configuration register 0.
    constant addr_reg_config0: std_logic_vector(address_bits-1 downto 0) :=
        (11 => '1', others => '0');

    -- Main state machine.
    type state_type is (
        State_Init,
        State_Reset,
        State_ResetWait,
        State_Idle,
        State_Cmd1,
        State_Cmd2,
        State_Cmd3,
        State_Config,
        State_WaitRWDS,
        State_PollRWDS,
        State_AccessWait,
        State_Write,
        State_Read,
        State_EndWrite,
        State_EndBurst );

    -- Record definition for internal registers.
    type regs_type is record
        state:          state_type;
        counter:        unsigned(13 downto 0);
        req_config:     std_logic;
        req_write:      std_logic;
        rwaddr:         std_logic_vector(address_bits-1 downto 0);
        wdata:          std_logic_vector(15 downto 0);
        wmask:          std_logic_vector(1 downto 0);
        seq_addr:       std_logic;
        cmd_ready:      std_logic;
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(15 downto 0);
        ram_csn:        std_logic;
        ram_ck_en:      std_logic;
        ram_rstn:       std_logic;
        ram_dq_out:     std_logic_vector(15 downto 0);
        ram_dq_t:       std_logic;
        ram_rwds_out:   std_logic_vector(1 downto 0);
        ram_rwds_t:     std_logic;
    end record;

    -- Power-on initialization of internal registers.
    constant regs_init: regs_type := (
        state           => State_Init,
        counter         => (others => '0'),
        req_config      => '0',
        req_write       => '0',
        rwaddr          => (others => '0'),
        wdata           => (others => '0'),
        wmask           => (others => '0'),
        seq_addr        => '0',
        cmd_ready       => '0',
        rsp_valid       => '0',
        rsp_rdata       => (others => '0'),
        ram_csn         => '0',
        ram_ck_en       => '0',
        ram_rstn        => '0',
        ram_dq_out      => (others => '0'),
        ram_dq_t        => '0',
        ram_rwds_out    => (others => '0'),
        ram_rwds_t      => '0' );

    -- Internal registers.
    signal r:               regs_type := regs_init;

    -- DDR input signals captured from HyperRAM interface.
    signal s_ram_dq_in:     std_logic_vector(15 downto 0);
    signal s_ram_rwds_in:   std_logic_vector(1 downto 0);

begin

    --
    -- I/O flipflops.
    --

    inst_oddr_cs: entity work.ff_oddr
        port map (
            clk     => clk,
            d1      => r.ram_csn,
            d2      => r.ram_csn,
            q_out   => ram_csn );

    inst_oddr_ck: entity work.ff_oddr
        port map (
            clk     => clk,
            d1      => r.ram_ck_en,
            d2      => '0',
            q_out   => ram_ck );

    gen_dq: for i in 0 to 7 generate

        inst_iddr_dq: entity work.ff_iddr
            port map (
                clk     => clk,
                d_in    => ram_dq_i(i),
                q1      => s_ram_dq_in(i+8),
                q2      => s_ram_dq_in(i) );

        inst_oddr_dq: entity work.ff_oddr
            port map (
                clk     => clk270,
                d1      => r.ram_dq_out(i+8),
                d2      => r.ram_dq_out(i),
                q_out   => ram_dq_o(i) );

        inst_oddr_dqt: entity work.ff_oddr
            port map (
                clk     => clk270,
                d1      => r.ram_dq_t,
                d2      => r.ram_dq_t,
                q_out   => ram_dq_t(i) );

    end generate;

    inst_iddr_rwds: entity work.ff_iddr
        port map (
            clk     => clk,
            d_in    => ram_rwds_i,
            q1      => s_ram_rwds_in(1),
            q2      => s_ram_rwds_in(0) );

    inst_oddr_rwds: entity work.ff_oddr
        port map (
            clk     => clk270,
            d1      => r.ram_rwds_out(1),
            d2      => r.ram_rwds_out(0),
            q_out   => ram_rwds_o );

    inst_oddr_rwds_t: entity work.ff_oddr
        port map (
            clk     => clk270,
            d1      => r.ram_rwds_t,
            d2      => r.ram_rwds_t,
            q_out   => ram_rwds_t );

    --
    -- Drive outputs.
    --

    cmd_ready   <= r.cmd_ready;
    rsp_valid   <= r.rsp_valid;
    rsp_rdata   <= r.rsp_rdata;
    ram_rstn    <= r.ram_rstn;

    --
    -- Synchronous logic.
    --

    process (clk) is
        variable v: regs_type;
    begin
        -- Initialize next registers from current registers.
        v := r;

        if rising_edge(clk) then

            -- By default clear DQ and RWDS output signals.
            v.ram_dq_out    := x"0000";
            v.ram_rwds_out  := "00";

            -- Capture data from RAM but by default flag it as not-valid.
            v.rsp_valid     := '0';
            v.rsp_rdata     := s_ram_dq_in;

            -- Count down clock cycles (for various purposes).
            v.counter       := r.counter - 1;

            -- Accept bus transactions.
            if (r.cmd_ready = '1') and (cmd_valid = '1') then
                -- Since cmd_ready and cmd_valid are both '1', we accept
                -- a new bus transaction in this cycle. In some cases,
                -- the main state machine (below) can consume this new request
                -- immediately and set cmd_ready back to '1' in this same cycle.
                v.req_write     := cmd_write;
                v.rwaddr        := cmd_addr;
                v.wdata         := cmd_wdata;
                v.wmask         := cmd_wmask;
                v.cmd_ready     := '0';

                -- Detect whether this may be a continuation of an ongoing
                -- linear burst.
                if (unsigned(cmd_addr) = unsigned(r.rwaddr) + 1) then
                    v.seq_addr      := '1';
                else
                    v.seq_addr      := '0';
                end if;
            end if;

            -- Main state machine.
            case r.state is

                when State_Init =>
                    -- Initialize controller.
                    v.state         := State_Reset;

                    -- Prepare to configure HyperRAM after reset.
                    v.req_config    := '1';
                    v.rwaddr        := addr_reg_config0;
                    v.cmd_ready     := '0';

                    -- Start HyperRAM reset.
                    v.ram_csn       := '1';
                    v.ram_ck_en     := '0';
                    v.ram_rstn      := '0';
                    v.ram_dq_t      := '1';
                    v.ram_rwds_t    := '1';

                    -- Setup counter for reset pulse duration.
                    v.counter       := to_unsigned(t_reset_clk - 1,
                                                   r.counter'length);

                when State_Reset =>
                    -- Hold HyperRAM in reset.
                    if r.counter = 0 then
                        -- End reset.
                        v.state         := State_ResetWait;

                        -- Setup counter for power-up delay.
                        v.counter       := to_unsigned(t_init_clk - 1,
                                                       r.counter'length);
                    end if;

                when State_ResetWait =>
                    -- Wait until HyperRAM recovers from power-up or reset.
                    v.ram_rstn      := '1';  -- end HyperRAM reset
                    if r.counter = 0 then
                        -- Prepare to write configuration register 0.
                        v.state         := State_Idle;
                    end if;

                when State_Idle =>
                    -- Keep chip select disabled and wait until we get
                    -- a request from the bus.
                    -- Note: r.ram_csn is '1' in this state.
                    if r.cmd_ready = '0' or cmd_valid = '1' then
                        -- Starting a new burst.
                        -- Enable chip select and start driving DQ.
                        v.state         := State_Cmd1;
                        v.ram_csn       := '0';
                        v.ram_dq_t      := '0';    
                    end if;

                when State_Cmd1 =>
                    -- Prepare to send command word 1.
                    -- Note: r.ram_csn is '0' in this state.
                    -- Note: r.ram_dq_t is '0' in this state.
                    v.state         := State_Cmd2;

                    -- Prepare to start CK pulses.
                    v.ram_ck_en     := '1';

                    -- Prepare to send command bits 47:32.
                    --   bit 47 = RW (0=write, 1=read)
                    --   bit 46 = AS (0=memory, 1=register)
                    --   bit 45 = burst type (0=wrapped, 1=linear)
                    --   bit 44:32 = address bits 31:19
                    v.ram_dq_out(15)    := not (r.req_config or r.req_write);
                    v.ram_dq_out(14)    := r.req_config;
                    v.ram_dq_out(13)    := '1';
                    v.ram_dq_out(12 downto 0) := (others => '0');
                    v.ram_dq_out(address_bits-20 downto 0) :=
                        r.rwaddr(address_bits-1 downto 19);

                when State_Cmd2 =>
                    -- Prepare to send command word 2.
                    -- Note: r.ram_dq_out holds command word 1 in this state.
                    v.state         := State_Cmd3;

                    -- Prepare to send command bits 31:16.
                    --   bit 31:16 = address bits 18:3.
                    v.ram_dq_out    := (others => '0');
                    if address_bits < 19 then
                        v.ram_dq_out(address_bits-4 downto 0) := r.rwaddr(address_bits-1 downto 3);
                    else
                        v.ram_dq_out(15 downto 0) := r.rwaddr(18 downto 3);
                    end if;

                when State_Cmd3 =>
                    -- Prepare to send command word 3.
                    -- Note: r.ram_dq_out holds command word 2 in this state.

                    -- Prepare to send command bits 15:0.
                    --   bit 15:3 = reserved, set to 0
                    --   bit 2:0  = address bits 2:0.
                    v.ram_dq_out(15 downto 3) := (others => '0');
                    v.ram_dq_out(2 downto 0)  := r.rwaddr(2 downto 0);

                    if r.req_config = '1' then
                        -- Jump to a separate state to handle the initial
                        -- configuration transaction. This is part of the
                        -- HyperRAM initialization after reset.
                        v.state         := State_Config;
                    else
                        v.state         := State_WaitRWDS;
                    end if;

                when State_Config =>
                    -- Prepare to send configuration data.
                    -- Note: r.ram_dq_out holds command word 3 in this state.

                    -- Prepare to send data word for configuration register.
                    v.ram_dq_out    := config0_data;

                    -- Prepare to accept bus requests.
                    v.req_config    := '0';
                    v.cmd_ready     := '1';

                    -- End config burst after this word.
                    v.state         := State_EndWrite;

                when State_WaitRWDS =>
                    -- Wait before polling the state of RWDS.
                    -- Note: r.ram_dq_out holds command word 3 in this state.
                    v.state         := State_PollRWDS;

                when State_PollRWDS =>
                    -- Check the state of RWDS during the command word to
                    -- decide whether the HyperRAM needs 1x or 2x latency.
                    v.state         := State_AccessWait;

                    if r.req_write = '0' then
                        -- Stop driving DQ in case of a read transaction.
                        v.ram_dq_t      := '1';
                    end if;

                   -- Setup counter to wait for access latency.
                    if s_ram_rwds_in(0) = '1' then
                        -- High RWDS indicates 2x access latency.
                        v.counter       := to_unsigned(2 * t_access_clk - 4,
                                                       r.counter'length);
                    else
                        -- Low RWDS indicates 1x access latency.
                        v.counter       := to_unsigned(t_access_clk - 4,
                                                       r.counter'length);
                    end if;

                when State_AccessWait =>
                    -- Wait until end of access latency.

                    if r.counter = 0 then
                        if r.req_write = '1' then
                            -- Prepare to write data.
                            -- Start driving the RWDS signal.
                            v.state         := State_Write;
                            v.ram_rwds_t    := '0';
                        else
                            -- Prepare to capture read data.
                            v.state         := State_Read;
                        end if;

                        -- Prepare to accept the next bus request
                        -- (for burst transactions).
                        v.cmd_ready     := '1';

                        -- Prepare to count down maximum burst duration.
                        v.counter       := to_unsigned(max_burst - 1,
                                                       r.counter'length);
                    end if;

                when State_Write =>
                    -- Drive pattern to DQ and RWDS.
                    -- Note: r.ram_dq_t is '0' in this state (driving DQ).
                    -- Note: r.ram_rwds_t is '0' in this state (driving RWDS).

                    -- Prepare to send data word to memory.
                    v.ram_dq_out    := r.wdata;
                    v.ram_rwds_out  := not r.wmask;

                    -- Continue the burst as long as the next bus request
                    -- writes to the next address, but stop when we reach
                    -- the maximum burst length.
                    if (cmd_valid = '1') and
                       (cmd_write = '1') and
                       (unsigned(cmd_addr) = unsigned(r.rwaddr) + 1) and
                       (r.counter /= 0) then
                        -- Continue burst; consume the new request that was
                        -- accepted in this cycle and prepare to accept a
                        -- next bus request.
                        v.cmd_ready     := '1';
                    else
                        -- End burst.
                        v.state         := State_EndWrite;
                    end if;

                when State_Read =>
                    -- Capture data from DQ and RWDS.

                    if s_ram_rwds_in = "10" then
                        -- Push valid data from HyperRAM to the bus.
                        v.rsp_valid     := '1';

                        -- Continue the burst as long as the bus requests to read
                        -- the next address, until we hit the max burst length.
                        -- Note: This is based on the updated values of
                        -- cmd_ready and seq_addr because the new request may
                        -- have been captured during a previous clock cycle
                        -- where the HyperRAM did not provide valid output.
                        -- Note: We need to check that the counter did not
                        -- wrap through zero, since we don't check the counter
                        -- on every clock cycle.
                        if (v.cmd_ready = '0') and
                           (v.req_write = '0') and
                           (v.seq_addr = '1') and
                           (r.counter /= 0) and
                           (r.counter(r.counter'high) = '0') then
                            -- Continue burst; prepare to accept next bus request.
                            v.cmd_ready     := '1';
                        else
                            -- End burst.
                            v.state         := State_EndBurst;
                            v.ram_ck_en     := '0';
                            v.ram_csn       := '1';
                            v.counter       := to_unsigned(t_rwr_clk - 4,
                                                           r.counter'length);
                        end if;
                    end if;

                when State_EndWrite =>
                    -- End write burst.
                    -- Note: r.ram_dq_out holds the last word to be written.

                    -- Prepare to stop clock and release chip select
                    -- after this word.
                    v.ram_ck_en     := '0';
                    v.ram_csn       := '1';

                    -- Prepare to wait for read-write recovery time.
                    v.state         := State_EndBurst;
                    v.counter       := to_unsigned(t_rwr_clk - 4,
                                                   r.counter'length);

                when State_EndBurst =>
                    -- Wait until end of read-write recovery time.
                    -- Note: r.ram_ck_en is '0' in this state.
                    -- Note: r.ram_csn is '1' in this state.

                    -- Stop driving DQ and RWDS.
                    v.ram_dq_t      := '1';
                    v.ram_rwds_t    := '1';

                    -- Wait to ensure read-write recovery time, then go back
                    -- to idle.
                    if r.counter = 0 then
                        v.state         := State_Idle;
                    end if;

            end case;

            -- Synchronous reset.
            if rst = '1' then
                v.state         := State_Init;
                v.cmd_ready     := '0';
                v.rsp_valid     := '0';
                v.ram_rstn      := '0';
            end if;

            -- Update registers.
            r <= v;

        end if;
    end process;

end architecture;
