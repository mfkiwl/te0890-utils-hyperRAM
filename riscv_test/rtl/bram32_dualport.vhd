--
-- Synchronous dual port block RAM.
--
-- Port A: 32 bits wide, read/write access, separate write-enable for each byte
-- Port B: 32 bits wide, read-only access
-- A common clock is used for both ports.
--
-- Vivado will infer block RAM for this entity.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram32_dualport is
    generic (
        address_bits:   integer range 3 to 16;
        init_file:      string := "" );
    port (
        clk:            in  std_logic;
        en_a:           in  std_logic;
        en_b:           in  std_logic;
        wr_a:           in  std_logic;
        addr_a:         in  std_logic_vector(address_bits-1 downto 0);
        addr_b:         in  std_logic_vector(address_bits-1 downto 0);
        wdata_a:        in  std_logic_vector(31 downto 0);
        wmask_a:        in  std_logic_vector(3 downto 0);
        rdata_a:        out std_logic_vector(31 downto 0);
        rdata_b:        out std_logic_vector(31 downto 0) );
end entity;

architecture arch_bram32_dualport of bram32_dualport is

    constant mem_size: integer := 2**address_bits;
    type mem_type is array(0 to mem_size-1) of std_logic_vector(31 downto 0);

    -- Optionally initialize the memory contents from an Intel HEX file.
    --
    -- If file_name = "", memory is initialized to zeros.
    -- Otherwise, memory is initialized from the specified HEX file.
    --
    -- Note: The HEX file can only initialize the first 64 kByte of the RAM.
    --
    impure function init_mem(file_name: in string) return mem_type is
        file f: text;
        variable linenr: integer;
        variable input_line: line;
        variable c: character;
        variable record_len: std_logic_vector(7 downto 0);
        variable record_addr: std_logic_vector(15 downto 0);
        variable record_type: std_logic_vector(7 downto 0);
        variable record_csum: std_logic_vector(7 downto 0);
        variable data_addr: integer;
        variable word_addr: integer;
        variable byte_index: integer;
        variable data_byte: std_logic_vector(7 downto 0);
        variable checksum: unsigned(7 downto 0);
        variable result: mem_type := (others => (others => '0'));
    begin
        if file_name /= "" then
            file_open(f, file_name, read_mode);
            linenr := 0;
            loop
                -- Read next record.
                linenr := linenr + 1;
                readline(f, input_line);
                -- Decode record header.
                read(input_line, c);
                if c /= ':' then
                    report "syntax error in HEX file line " & integer'image(linenr)
                        severity failure;
                end if;
                hread(input_line, record_len);
                hread(input_line, record_addr);
                hread(input_line, record_type);
                checksum := unsigned(record_len) +
                            unsigned(record_addr(15 downto 8)) +
                            unsigned(record_addr(7 downto 0)) +
                            unsigned(record_type);
                -- Decode payload.
                data_addr := to_integer(unsigned(record_addr));
                for i in 1 to to_integer(unsigned(record_len)) loop
                    hread(input_line, data_byte);
                    checksum := checksum + unsigned(data_byte);
                    if record_type = x"00" then
                        -- Store data in memory.
                        word_addr := (data_addr / 4) mod mem_size;
                        byte_index := data_addr mod 4;
                        result(word_addr)(byte_index*8+7 downto byte_index*8) := data_byte;
                    end if;
                    data_addr := data_addr + 1;
                end loop;
                -- Verify checksum.
                hread(input_line, record_csum);
                checksum := checksum + unsigned(record_csum);
                if checksum /= 0 then
                    report "checksum mismatch in HEX file line " & integer'image(linenr)
                        severity failure;
                end if;
                if (record_len = x"00") and (record_type = x"01") then
                    -- End of file.
                    exit;
                end if;
            end loop;
            file_close(f);
        end if;
        return result;
    end function;

    shared variable mem: mem_type := init_mem(init_file);

begin

    process (clk) is
    begin
        if rising_edge(clk) then
            if en_a = '1' then
                rdata_a <= mem(to_integer(unsigned(addr_a)));
                if wr_a = '1' then
                    for i in 0 to 3 loop
                        if wmask_a(i) = '1' then
                            mem(to_integer(unsigned(addr_a)))(8*i+7 downto 8*i) :=
                                wdata_a(8*i+7 downto 8*i);
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    process (clk) is
    begin
        if rising_edge(clk) then
            if en_b = '1' then
                rdata_b <= mem(to_integer(unsigned(addr_b)));
            end if;
        end if;
    end process;

end architecture;
