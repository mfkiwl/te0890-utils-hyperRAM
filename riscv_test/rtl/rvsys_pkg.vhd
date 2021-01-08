--
-- VHDL package for simple processor system.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rvsys is

    subtype rvsys_addr_type is std_logic_vector(31 downto 0);

    -- Memory map.
    constant rvsys_addr_fastram: rvsys_addr_type := x"80000000";
    constant rvsys_addr_leds:    rvsys_addr_type := x"f0000000";
    constant rvsys_addr_gpio1:   rvsys_addr_type := x"f0001000";
    constant rvsys_addr_gpio2:   rvsys_addr_type := x"f0002000";
    constant rvsys_addr_timer:   rvsys_addr_type := x"f0008000";
    constant rvsys_addr_uart:    rvsys_addr_type := x"f0010000";

    -- Compile-time description of a bus peripheral device.
    type bus_slv_info_type is record
        addr_start:     rvsys_addr_type;
        addr_size:      rvsys_addr_type;
    end record;

    -- Input signals for a bus device.
    type bus_slv_input_type is record
        cmd_valid:      std_logic;
        cmd_addr:       rvsys_addr_type;
        cmd_write:      std_logic;
        cmd_wdata:      std_logic_vector(31 downto 0);
        cmd_wmask:      std_logic_vector(3 downto 0);
    end record;

    -- Output signals from a bus device.
    type bus_slv_output_type is record
        cmd_ready:      std_logic;
        rsp_valid:      std_logic;
        rsp_rdata:      std_logic_vector(31 downto 0);
    end record;

    type bus_slv_info_array is array(natural range <>) of bus_slv_info_type;
    type bus_slv_input_array is array(natural range <>) of bus_slv_input_type;
    type bus_slv_output_array is array(natural range <>) of bus_slv_output_type;

    -- Convert transaction size code and address to byte enable mask.
    function bus_transaction_address_to_write_mask(addr: unsigned;
                                                   size: unsigned(1 downto 0))
        return std_logic_vector;

end package;

package body rvsys is

    -- Convert transaction size code and address to byte enable mask.
    function bus_transaction_address_to_write_mask(addr: unsigned;
                                                   size: unsigned(1 downto 0))
        return std_logic_vector
    is
        variable wmask: std_logic_vector(3 downto 0) := "1111";
    begin
        case size is
            when "00" =>  -- byte access
                case addr(1 downto 0) is
                    when "00"   => wmask := "0001";
                    when "01"   => wmask := "0010";
                    when "10"   => wmask := "0100";
                    when others => wmask := "1000";
                end case;
            when "01" =>  -- half-word access
                case addr(1) is
                    when '0' =>    wmask := "0011";
                    when others => wmask := "1100";
                end case;
            when others =>  -- full word access
                wmask := "1111";
        end case;
        return wmask;
    end function;

end;