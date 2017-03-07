# Legal Notice: (C)2012 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	cpuori 	cpuori:*
set 	cpuori_oci 	cpuori_nios2_oci:the_cpuori_nios2_oci
set 	cpuori_oci_break 	cpuori_nios2_oci_break:the_cpuori_nios2_oci_break
set 	cpuori_ocimem 	cpuori_nios2_ocimem:the_cpuori_nios2_ocimem
set 	cpuori_oci_debug 	cpuori_nios2_oci_debug:the_cpuori_nios2_oci_debug
set 	cpuori_wrapper 	cpuori_jtag_debug_module_wrapper:the_cpuori_jtag_debug_module_wrapper
set 	cpuori_jtag_tck 	cpuori_jtag_debug_module_tck:the_cpuori_jtag_debug_module_tck
set 	cpuori_jtag_sysclk 	cpuori_jtag_debug_module_sysclk:the_cpuori_jtag_debug_module_sysclk
set 	cpuori_oci_path 	 [format "%s|%s" $cpuori $cpuori_oci]
set 	cpuori_oci_break_path 	 [format "%s|%s" $cpuori_oci_path $cpuori_oci_break]
set 	cpuori_ocimem_path 	 [format "%s|%s" $cpuori_oci_path $cpuori_ocimem]
set 	cpuori_oci_debug_path 	 [format "%s|%s" $cpuori_oci_path $cpuori_oci_debug]
set 	cpuori_jtag_tck_path 	 [format "%s|%s|%s" $cpuori_oci_path $cpuori_wrapper $cpuori_jtag_tck]
set 	cpuori_jtag_sysclk_path 	 [format "%s|%s|%s" $cpuori_oci_path $cpuori_wrapper $cpuori_jtag_sysclk]
set 	cpuori_jtag_sr 	 [format "%s|*sr" $cpuori_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$cpuori_oci_break_path|break_readreg*] -to [get_keepers *$cpuori_jtag_sr*]
set_false_path -from [get_keepers *$cpuori_oci_debug_path|*resetlatch]     -to [get_keepers *$cpuori_jtag_sr[33]]
set_false_path -from [get_keepers *$cpuori_oci_debug_path|monitor_ready]  -to [get_keepers *$cpuori_jtag_sr[0]]
set_false_path -from [get_keepers *$cpuori_oci_debug_path|monitor_error]  -to [get_keepers *$cpuori_jtag_sr[34]]
set_false_path -from [get_keepers *$cpuori_ocimem_path|*MonDReg*] -to [get_keepers *$cpuori_jtag_sr*]
set_false_path -from *$cpuori_jtag_sr*    -to *$cpuori_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$cpuori_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$cpuori_oci_debug_path|monitor_go
