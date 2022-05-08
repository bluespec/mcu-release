# Set default number of Vivado jobs
set num_jobs 2

variable script_file
set script_file "build.tcl"

# Script command line options
#
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Build a bitstream given a Vivado project"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--jobs <jobs>\]"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--project_name <name>\] The Vivado project to be built. Project directory must exist in CWD.\n"
  puts "\[--jobs\]               Number of vivado jobs"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}
if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argv]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--jobs" { incr i; set num_jobs [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

open_project ${project_name}/${project_name}.xpr

launch_runs impl_1 -to_step write_bitstream -jobs ${num_jobs}
wait_on_run impl_1
