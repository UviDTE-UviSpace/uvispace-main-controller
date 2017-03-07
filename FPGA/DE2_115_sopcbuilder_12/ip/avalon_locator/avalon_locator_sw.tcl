#
# avalon_locator_sw.tcl
#

# Create a new driver - this name must be different than the 
# hardware component name
create_driver avalon_locator_driver

# Associate it with some hardware known as "altera_avalon_uart"
set_sw_property hw_class_name avalon_locator

# The version of this driver 
# Making it newer than the version 9.1 Altera production driver.  This will 
# associate "my_uart" software driver with the altera_avalon_uart hardware, 
# instead of the production version 9.1 altera_avalon_uart software driver.
set_sw_property version 7.2

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 7.1

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize false

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

#
# Source file listings...
#

# Include files - (hw_class_name is used in the auto-generated inclusion in alt_sys_init of
# the altera_avalon_uart.h header file listed below. alt_sys_init.c auto intialization macro
# invocations are also based on hw_class_name, so the altera_avalon_uart.h defines
# ALTERA_AVALON_UART_INIT and ALTERA_AVALON_UART_INSTANCE macros.)
add_sw_property include_source HAL/inc/avalon_locator.h
add_sw_property include_source inc/avalon_locator_regs.h

# C/C++ source files
add_sw_property c_source HAL/src/avalon_locator.c

# End of file
