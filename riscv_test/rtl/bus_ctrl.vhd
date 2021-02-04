--
-- System bus controller for simple processor system
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rvsys.all;


entity bus_ctrl is

    generic (
        -- Number of peripheral devices attached to the controller.
        num_slaves:     integer range 1 to 15;

        -- Information about each peripheral device.
        slv_info:       bus_slv_info_array(0 to num_slaves-1);

        -- True to insert a pipeline stage in the command path.
        pipeline_cmd:   boolean;

        -- True to insert a pipeline stage in the response path.
        pipeline_rsp:   boolean
    );

    port (
        -- System clock.
        clk:            in  std_logic;

        -- Synchronous reset, active high.
        rst:            in  std_logic;

        -- Signals to bus master (RISC-V processor).
        mst_cmd_valid:  in  std_logic;
        mst_cmd_ready:  out std_logic;
        mst_cmd_addr:   in  rvsys_addr_type;
        mst_cmd_write:  in  std_logic;
        mst_cmd_wdata:  in  std_logic_vector(31 downto 0);
        mst_cmd_wmask:  in  std_logic_vector(3 downto 0);
        mst_rsp_valid:  out std_logic;
        mst_rsp_rdata:  out std_logic_vector(31 downto 0);

        -- Sigals to bus slaves.
        slv_input:      out bus_slv_input_array(0 to num_slaves-1);
        slv_output:     in  bus_slv_output_array(0 to num_slaves-1)
    );

end entity;

architecture bus_ctrl_arch of bus_ctrl is

    constant num_slv_idx_bits: integer := 4;

    -- Internal registers.
    type regs_type is record
        pending_read:   std_logic;
        pending_slv_idx: unsigned(num_slv_idx_bits-1 downto 0);
        cmdpipe_valid:  std_logic;
        cmdpipe_addr:   rvsys_addr_type;
        cmdpipe_write:  std_logic;
        cmdpipe_wdata:  std_logic_vector(31 downto 0);
        cmdpipe_wmask:  std_logic_vector(3 downto 0);
        cmdpipe_slv_sel: std_logic_vector(num_slaves-1 downto 0);
        rsppipe_valid:  std_logic;
        rsppipe_rdata:  std_logic_vector(31 downto 0);
    end record;

    constant regs_init: regs_type := (
        pending_read    => '0',
        pending_slv_idx => (others => '0'),
        cmdpipe_valid   => '0',
        cmdpipe_addr    => (others => '0'),
        cmdpipe_write   => '0',
        cmdpipe_wdata   => (others => '0'),
        cmdpipe_wmask   => (others => '0'),
        cmdpipe_slv_sel => (others => '0'),
        rsppipe_valid   => '0',
        rsppipe_rdata   => (others => '0'));

    signal r: regs_type := regs_init;
    signal rnext: regs_type;

begin

    -- Asynchronous process.
    process (all) is
        variable v: regs_type;
        variable v_cmd_slv_sel: std_logic_vector(num_slaves-1 downto 0);
        variable v_cmd_slv_idx: unsigned(num_slv_idx_bits-1 downto 0);
        variable v_cmd_slv_ready: std_logic;
        variable v_cmd_ready: std_logic;
        variable v_rsp_valid: std_logic;
        variable v_rsp_rdata: std_logic_vector(31 downto 0);
    begin
        -- By default, set next registers equal to current registers.
        v := r;

        -- By default, assume that the next access is to a non-mapped address.
        -- In that case, map to a dummy slave to generate a read response.
        -- This dummy slave is always ready.
        v_cmd_slv_sel   := (others => '0');
        v_cmd_slv_idx   := (others => '1');
        v_cmd_slv_ready := '1';

        -- Match address against peripheral memory maps.
        for i in 0 to num_slaves - 1 loop
            if (unsigned(mst_cmd_addr) >= unsigned(slv_info(i).addr_start)) and
               (unsigned(mst_cmd_addr) <= unsigned(slv_info(i).addr_start) +
                                          unsigned(slv_info(i).addr_size) - 1) then

                -- Found slave with matching address.
                v_cmd_slv_sel(i) := mst_cmd_valid and (not r.pending_read);
                v_cmd_slv_idx := to_unsigned(i, num_slv_idx_bits);
                v_cmd_slv_ready := slv_output(i).cmd_ready;

                -- Exit the loop. At most one slave can be selected.
                exit;
            end if;
        end loop;

        -- Handle command stream.
        if pipeline_cmd then

            -- Ready for a new command if the command pipeline is empty
            -- and there is no pending read transaction.
            v_cmd_ready := (not r.cmdpipe_valid) and (not r.pending_read);

            -- Accept new commands into the command pipeline.
            if r.cmdpipe_valid = '0' then
                v.cmdpipe_valid := mst_cmd_valid and (not r.pending_read);
                v.cmdpipe_slv_sel := v_cmd_slv_sel;
                v.cmdpipe_addr  := mst_cmd_addr;
                v.cmdpipe_write := mst_cmd_write;
                v.cmdpipe_wdata := mst_cmd_wdata;
                v.cmdpipe_wmask := mst_cmd_wmask;
            end if;

            -- Clear pipelined command when accepted by slave.
            if r.cmdpipe_valid = '1' then
                if r.pending_slv_idx >= num_slaves then
                    -- The pipelined command hits a non-mapped address.
                    -- Clear the command immediately.
                    v.cmdpipe_valid := '0';
                else
                    for i in 0 to num_slaves - 1 loop
                        if slv_output(i).cmd_ready = '1' then
                            -- Slave ready; clear pipelined command flag.
                            v.cmdpipe_slv_sel(i) := '0';

                            -- If the selected slave is ready, clear
                            -- the pipelined command stage.
                            if r.pending_slv_idx = i then
                                v.cmdpipe_valid := '0';
                            end if;
                        end if;
                    end loop;
                end if;
            end if;

        else

            -- Ready for a new command if the selected slave is ready
            -- and there is no pending read transaction.
            v_cmd_ready := v_cmd_slv_ready and (not r.pending_read);

        end if;

        -- Keep track of pending read transactions.
        -- Note: pending_slv_idx is used to select which slave rsp_valid
        -- signal to monitor. A pipelined controller additionally uses
        -- pending_slv_idx to select which slave cmd_ready signal to monitor.
        if v_cmd_ready = '1' then
            v.pending_read  := mst_cmd_valid and (not mst_cmd_write);
            v.pending_slv_idx := v_cmd_slv_idx;
        end if;

        -- Prepare a dummy read response for the case where the pending
        -- read transaction hits a non-mapped slave.
        v_rsp_valid     := r.pending_read;
        v_rsp_rdata     := (others => '0');

        -- Handle actual read response from the slave selected by
        -- the pending read transaction.
        for i in 0 to num_slaves - 1 loop
            if r.pending_slv_idx = i then
                v_rsp_valid     := r.pending_read and slv_output(i).rsp_valid;
                v_rsp_rdata     := slv_output(i).rsp_rdata;
            end if;
        end loop;

        -- Clear pending read transaction when the response comes.
        if (r.pending_read = '1') and (v_rsp_valid = '1') then
            v.pending_read  := '0';
        end if;

        if pipeline_rsp then

            -- Drive the pipelined read response to the master.
            mst_rsp_valid   <= r.rsppipe_valid;
            mst_rsp_rdata   <= r.rsppipe_rdata;

            -- Clock the new read response into the response pipeline.
            v.rsppipe_valid := v_rsp_valid;
            v.rsppipe_rdata := v_rsp_rdata;

        else

            -- Drive the new read response directly to the master.
            mst_rsp_valid   <= v_rsp_valid;
            mst_rsp_rdata   <= v_rsp_rdata;

        end if;

        -- Synchronous reset.
        if rst = '1' then
            v.pending_read  := '0';
            v.cmdpipe_valid := '0';
            v.cmdpipe_slv_sel := (others => '0');
            v.rsppipe_valid := '0';
        end if;

        -- Drive ready signal to bus master.
        mst_cmd_ready   <= v_cmd_ready;

        -- Drive outputs to bus slaves.
        for i in 0 to num_slaves - 1 loop
            if pipeline_cmd then
                slv_input(i).cmd_valid  <= r.cmdpipe_slv_sel(i);
                slv_input(i).cmd_addr   <= r.cmdpipe_addr;
                slv_input(i).cmd_write  <= r.cmdpipe_write;
                slv_input(i).cmd_wdata  <= r.cmdpipe_wdata;
                slv_input(i).cmd_wmask  <= r.cmdpipe_wmask;
            else
                slv_input(i).cmd_valid  <= v_cmd_slv_sel(i);
                slv_input(i).cmd_addr   <= mst_cmd_addr;
                slv_input(i).cmd_write  <= mst_cmd_write;
                slv_input(i).cmd_wdata  <= mst_cmd_wdata;
                slv_input(i).cmd_wmask  <= mst_cmd_wmask;
            end if;
        end loop;

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
