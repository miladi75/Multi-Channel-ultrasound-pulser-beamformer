# Copyright (C) 2017  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions
# and other software and tools, and its AMPP partner logic
# functions, and any output files from any of the foregoing
# (including device programming or simulation files), and any
# associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel MegaCore Function License Agreement, or other
# applicable license agreement, including, without limitation,
# that your use is for the sole purpose of programming logic
# devices manufactured by Intel and sold by Intel or its
# authorized distributors.  Please refer to the applicable
# agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: pulser_stx_16ch_fpga.tcl
# Generated on: Fri Jun 23 13:22:48 2017

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "pulser_stx_16ch_fpga"]} {
		puts "Project pulser_stx_16ch_fpga is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists pulser_stx_16ch_fpga]} {
		project_open -revision pulser_stx_16ch_fpga pulser_stx_16ch_fpga
	} else {
		project_new -revision pulser_stx_16ch_fpga pulser_stx_16ch_fpga
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CGXFC5C6F27C7
	set_global_assignment -name TOP_LEVEL_ENTITY pulser_stx_top
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "09:17:31  OCTOBER 03, 2022"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Standard Edition"
	set_global_assignment -name SAFE_STATE_MACHINE ON

	if { $argc > 0 } {
		# in case running on different computers
		set cpu_cores [lindex $argv 0]
		set_global_assignment -name NUM_PARALLEL_PROCESSORS $cpu_cores
	} else {
		set cpu_cores 4
		set_global_assignment -name NUM_PARALLEL_PROCESSORS $cpu_cores
		post_message "less cpu: $cpu_cores cores"
	}
	post_message "Utilizing $cpu_cores parallel processors..."
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 7
	set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON
	set_global_assignment -name HPS_EARLY_IO_RELEASE ON
	# set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 0.9V
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.1V

	# Classic Timing Assignments
	# ==========================
	# set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"
	# set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

	set_global_assignment -name MIN_CORE_JUNCTION_TEMP "0"
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85

	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	# set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
	set_global_assignment -name OPTIMIZE_SSN OFF
	set_global_assignment -name OPTIMIZE_TIMING "NORMAL COMPILATION"
	set_global_assignment -name ECO_OPTIMIZE_TIMING ON
	set_global_assignment -name FINAL_PLACEMENT_OPTIMIZATION ALWAYS
	set_global_assignment -name FITTER_AGGRESSIVE_ROUTABILITY_OPTIMIZATION AUTOMATICALLY
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING ON
	set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
	set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT EXTRA
	set_global_assignment -name PERIPHERY_TO_CORE_PLACEMENT_AND_ROUTING_OPTIMIZATION AUTO
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
	set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
	set_global_assignment -name SYNTHESIS_EFFORT AUTO
	set_global_assignment -name ROUTER_CLOCKING_TOPOLOGY_ANALYSIS ON
	set_global_assignment -name SEED 1
	set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC_FOR_AREA OFF
	set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
	set_global_assignment -name IO_PLACEMENT_OPTIMIZATION ON
	set_global_assignment -name FORCE_FITTER_TO_AVOID_PERIPHERY_PLACEMENT_WARNINGS OFF
	set_global_assignment -name ENABLE_IP_DEBUG OFF
	set_global_assignment -name PARALLEL_SYNTHESIS ON
	set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION AUTO
	set_global_assignment -name AUTO_RESOURCE_SHARING OFF
	set_global_assignment -name OPTIMIZE_POWER_DURING_SYNTHESIS "NORMAL COMPILATION"
	set_global_assignment -name PRE_MAPPING_RESYNTHESIS ON
	set_global_assignment -name SYNTH_MESSAGE_LEVEL MEDIUM
	set_global_assignment -name DISABLE_REGISTER_MERGING_ACROSS_HIERARCHIES AUTO
	set_global_assignment -name MLAB_ADD_TIMING_CONSTRAINTS_FOR_MIXED_PORT_FEED_THROUGH_MODE_SETTING_DONT_CARE OFF
	set_global_assignment -name REMOVE_DUPLICATE_REGISTERS ON
	set_global_assignment -name FORCE_SYNCH_CLEAR OFF
	set_global_assignment -name USE_LOGICLOCK_CONSTRAINTS_IN_BALANCING ON
	set_global_assignment -name HDL_MESSAGE_LEVEL LEVEL2
	set_global_assignment -name ALM_REGISTER_PACKING_EFFORT MEDIUM
	set_global_assignment -name AUTO_DELAY_CHAINS_FOR_HIGH_FANOUT_INPUT_PINS OFF

	# set_global_assignment -name ENABLE_OCT_DONE OFF
	# set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
	# set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	# set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
	# set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	# set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
	# set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	# set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	# set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	# set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	# set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ

	# set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE EPCQ512
	# set_global_assignment -name STRATIXIII_UPDATE_MODE REMOTE

	# source ../board/31691-1/board.tcl
	source ../board/cyc5gx_starter/board.tcl
	source filelist.tcl

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
