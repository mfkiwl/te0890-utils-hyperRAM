
# Main clock input from 100 MHz on-board oscillator.
create_clock -period 10.000 -name clk_100m -waveform {0.000 5.000} [get_ports clk_100m_pin]
set_input_jitter clk_100m 0.200

# JTAG clock, assume max 50 MHz.
create_clock -period 20.0 -name jtag_clk -waveform {0.0 10.0} [get_pins inst_bscane2/DRCK]
set_max_delay -from [get_clocks -include_generated_clocks clk_100m] -to [get_clocks jtag_clk] -datapath_only 10.0
