## Generated SDC file "DE2_115_WEB_SERVER.sdc"

## Copyright (C) 1991-2011 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 10.1 Build 197 01/19/2011 Service Pack 1 SJ Full Version"

## DATE    "Sat Jun 09 13:41:44 2012"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {camera_clk} -period 10.417 -waveform { 0.000 5.208 } [get_ports { GPIO[0] }]
create_clock -name {virtual_camera_clk} -period 10.417 -waveform { 0.000 5.208 } 
create_clock -name {ENET0_RX_CLK} -period 8.000 -waveform { 0.000 4.000 } [get_ports {ENET0_RX_CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]} -source [get_pins {DE2_115_SOPC_inst|the_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {CLOCK_50} [get_pins {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] 
create_generated_clock -name {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]} -source [get_pins {DE2_115_SOPC_inst|the_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 5 -master_clock {CLOCK_50} [get_pins {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] 
derive_pll_clocks


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.070 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.100 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.070 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.100 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.070 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.100 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.070 
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.100 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.070 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.100 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.070 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.100 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.070 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.100 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.070 
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.100 
set_clock_uncertainty -rise_from [get_clocks {virtual_camera_clk}] -rise_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {virtual_camera_clk}] -fall_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {virtual_camera_clk}] -rise_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {virtual_camera_clk}] -fall_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {CLOCK_50}]  0.040 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {CLOCK_50}]  0.040 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.080 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.110 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.080 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.110 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.080 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.110 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.080 
set_clock_uncertainty -rise_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.110 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {CLOCK_50}]  0.040 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {CLOCK_50}]  0.040 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {camera_clk}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.080 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.110 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -setup 0.080 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -hold 0.110 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.080 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.110 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -setup 0.080 
set_clock_uncertainty -fall_from [get_clocks {camera_clk}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -hold 0.110 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -rise_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {camera_clk}] -setup 0.110 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {camera_clk}] -hold 0.080 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[0]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -rise_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
set_clock_uncertainty -fall_from [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}] -fall_to [get_clocks {DE2_115_SOPC_inst|the_pll|sd1|pll7|clk[2]}]  0.020 
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -min -clock [get_clocks {ENET0_RX_CLK}]  2.000 [get_ports {ENET0_RX_CLK}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[0]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[0]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[0]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[0]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[1]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[1]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[1]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[1]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[3]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[3]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[3]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[3]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[4]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[4]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[4]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[4]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[5]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[5]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[5]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[5]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[6]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[6]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[6]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[6]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[7]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[7]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[7]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[7]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[8]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[8]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[8]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[8]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[9]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[9]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[9]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[9]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[10]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[10]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[10]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[10]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[11]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[11]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[11]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[11]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[12]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[12]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[12]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[12]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[13]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[13]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[13]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[13]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[21]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[21]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[21]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[21]}]
set_input_delay -add_delay -max -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[22]}]
set_input_delay -add_delay -min -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[22]}]
set_input_delay -add_delay -max -clock_fall -clock [get_clocks {virtual_camera_clk}]  0.100 [get_ports {GPIO[22]}]
set_input_delay -add_delay -min -clock_fall -clock [get_clocks {virtual_camera_clk}]  -0.100 [get_ports {GPIO[22]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_se9:dffpipe19|dffe20a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_re9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_id9:dffpipe19|dffe20a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_ld9:dffpipe19|dffe20a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_kd9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_ue9:dffpipe20|dffe21a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_te9:dffpipe17|dffe18a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_0f9:dffpipe19|dffe20a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_ve9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_fd9:dffpipe18|dffe19a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_ed9:dffpipe15|dffe16a*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_write}] -to [get_registers {*|alt_jtag_atlantic:*|read_write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|td_shift[0]*}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|write_stalled*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_break:the_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[33]}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[0]}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr[34]}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_ocimem:the_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}]
set_false_path -from [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_tck:the_cpu_jtag_debug_module_tck|*sr*}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_sysclk:the_cpu_jtag_debug_module_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_jtag_debug_module_wrapper:the_cpu_jtag_debug_module_wrapper|cpu_jtag_debug_module_sysclk:the_cpu_jtag_debug_module_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*cpu:*|cpu_nios2_oci:the_cpu_nios2_oci|cpu_nios2_oci_debug:the_cpu_nios2_oci_debug|monitor_go}]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_writedata_d1*|*}] -to [get_registers *]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_address*|*}] -to [get_registers *]
set_false_path -from [get_pins -nocase -compatibility_mode {*the*clock*|slave_readdata_p1*}] -to [get_registers *]
set_false_path -from [get_keepers -nocase {*the*clock*|slave_readdata_p1*}] -to [get_registers *]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

