#*********************************************************************************
# Uses Vivado v2019.1 (64-bit) or later
#
# This script creates a SoC project based on the block diagram defined in
# soc-bd.tcl and runs synthesis and implementation to create a bitstream for the 
# xc7a100tcsg324-1 device on the Arty-A7 100 board.
#*********************************************************************************

# --------
# Script Defaults
#
# Set the reference directory for source file relative paths (by default the value
# is script directory path)
set origin_dir "./tcl"

#
# Set a default project name
set project_name "project_1"

#
# Set default clock frequency (MHz) for the SoC subsystem and processor
set clock_freq_mhz 100

# 
# Set default processor IP
set proc_ip RV32IM_MCU

# 
# Set default processor IP
set platform soctop

# 
# Set default device
set device xc7a100tcsg324-1

# Set install directory
set install_dir .

# 
# Set default number of Vivado jobs
set num_jobs 2

variable script_file
set script_file "soc.tcl"

# --------
#
# Script command line options
#
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Create a Vivado project which includes an instance of the RV32IM_MCUx "
  puts "and SoC components defined in the block diagram."
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--procip <processor-ip>\]"
  puts "$script_file -tclargs \[--install_dir <install location>\]"
  puts "$script_file -tclargs \[--platform <SoC platform>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--project_name <name>\] Create project with the specified name."
  puts "\[--procip <name>\]       Processor IP being used for this project"
  puts "\[--install_dir <dir>\]   Directory where the eval package is installed"
  puts "\[--platform <name>\]     SoC platform being built"                     
  puts "\[--help\]                Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argv]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--project_name"  { incr i; set project_name [lindex $::argv $i] }
      "--install_dir"   { incr i; set install_dir [lindex $::argv $i] }
      "--platform"      { incr i; set platform [lindex $::argv $i] }
      "--procip"        { incr i; set proc_ip [lindex $::argv $i] }
      "--help"          { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

#
# --------
# Diagnostics

puts "soc.tcl -----------------------------------"
puts "soc.tcl arguments received/variable values:"
puts "project_name: $project_name"
puts "install_dir : $install_dir"
puts "origin_dir  : $origin_dir"
puts "platform    : $platform"
puts "proc_ip     : $proc_ip"
puts "device      : $device"
puts "soc.tcl -----------------------------------"

# --------
# Create project and set properties
# --------
create_project ${project_name} ./${project_name} -part ${device}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
set_msg_config  -ruleid {7}  -id {[BD 41-1306]}  -suppress  -source 2
set_msg_config  -ruleid {8}  -id {[BD 41-1271]}  -suppress  -source 2

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "digilentinc.com:arty-a7-100:part0:1.0" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "dsa.num_compute_units" -value "60" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${project_name}.cache/ip" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "source_mgmt_mode" -value "DisplayOnly" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_MEMORY" -objects $obj


# --------
# Sources, constraints, BD, IP paths
# --------
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" [list \
 "[file normalize "$install_dir/packaged_ip/MCU_RV32IMC_16K_AHBL"]" \
 "[file normalize "$install_dir/packaged_ip/jtag"]" \
 "[file normalize "$install_dir/packaged_ip/GPIO_AHBL"]" \
 "[file normalize "$install_dir/packaged_ip/Loader"]" \
 "[file normalize "$install_dir/packaged_ip/Debug_Module"]" \
 ] $obj

# Generate block diagram
source $install_dir/tcl/bd.tcl

save_bd_design

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset properties and the top level module
make_wrapper -import -top -files [get_files */sources_1/bd/${platform}/${platform}.bd]
set obj [get_filesets sources_1]
set_property -name "top" -value "${platform}_wrapper" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
# Add shared constraint files
add_files -fileset constrs_1 [ glob $install_dir/arty.xdc ]

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]


# --------
# Synthesis and Implementation runs
# --------
# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part ${device} -flow {Vivado Synthesis 2019} -strategy {Vivado Synthesis Defaults} -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy {Vivado Synthesis Defaults} [get_runs synth_1]
  set_property flow "Vivado Synthesis 2019" [get_runs synth_1]
}

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part ${device} -flow {Vivado Implementation 2019} -strategy {Vivado Implementation Defaults} -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy {Vivado Implementation Defaults} [get_runs impl_1]
  set_property flow "Vivado Implementation 2019" [get_runs impl_1]
}

set obj [get_runs impl_1]
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:$project_name"
