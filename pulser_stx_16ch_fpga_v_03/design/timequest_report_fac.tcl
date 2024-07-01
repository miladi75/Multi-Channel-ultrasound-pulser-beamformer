report_timing -setup -npaths 200 -detail path_only -file "build_fac/TQ_paths_setup.txt"
report_timing -hold -npaths 200 -detail path_only -file "build_fac/TQ_paths_hold.txt"
report_timing -recovery -npaths 200 -detail path_only -file "build_fac/TQ_paths_recovery.txt"
report_timing -removal -npaths 200 -detail path_only -file "build_fac/TQ_paths_removal.txt"