set proj "pulser_stx_16ch_fpga"
set revision_id ""
set dirty "*"
set effort "1"
set seed 1
set test "false"
set wsb_test "false"
set imtype "app"
set sfi_regbuf "false"

if { $argc > 0 } {
	set revision_id [lindex $argv 0]
}

if { $argc > 1 } {
	set seed [lindex $argv 1]
}

if { $argc > 2 } {
	set effort [lindex $argv 2]
}

if { $argc > 3 } {
	set test [lindex $argv 3]
}

if { $argc > 4 } {
	set wsb_test [lindex $argv 4]
}

if { $argc > 5 } {
	set imtype [lindex $argv 5]
}

if { $argc > 6 } {
	set sfi_regbuf [lindex $argv 6]
}

#set dirty "*"





if { $test eq "true" } {
	set generic_test "true"
} else {
	set generic_test "false"
}

if { $wsb_test eq "true" } {
	set generic_wsb_test "true"
} else {
	set generic_wsb_test "false"
}

set revision "$revision_id$dirty"

project_open -revision $proj $proj

set_global_assignment -name SEED $seed

if { $imtype eq "app" } {
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY "build_app"
	set_global_assignment -name TIMEQUEST_REPORT_SCRIPT timequest_report_app.tcl
} else {
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY "build_fac"
	set_global_assignment -name TIMEQUEST_REPORT_SCRIPT timequest_report_fac.tcl
	set sfi_regbuf "true"
}

# post_message " "
# post_message " FPGA revision: $revision"
# post_message " "
# post_message " Effort is set to $effort"
# post_message " "
# post_message " SEED: $seed"
# post_message " "
# post_message " TESTIMG: $generic_test"
# post_message " "
# post_message " WSB_TEST: $generic_wsb_test"
# post_message " "
# post_message " SFI_REGBUF: $sfi_regbuf"
# post_message " "

set_parameter -name G_REVISION $revision
set_parameter -name G_TEST $generic_test
set_parameter -name G_WSB_TEST $generic_wsb_test
set_parameter -name G_SFI_REGBUF $sfi_regbuf

# Default value is 1 to set into balanced mode
if { $effort eq "2"} {
	set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
} elseif { $effort eq "3"} {
	set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
}
export_assignments
