################################################################
# START
################################################################

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part ${device}
   set_property BOARD_PART digilentinc.com:arty-a7-100:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name ${platform}

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES:
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips {xilinx.com:ip:proc_sys_reset:5.0}
   lappend list_check_ips xilinx.com:ip:xlconstant:1.1
   lappend list_check_ips bluespec.com:ip:MCU_RV32IMC_16K_AHBL:1.0
   lappend list_check_ips bluespec.com:ip:xilinx_jtag:1.0
   lappend list_check_ips bluespec.com:ip:GPIO_AHBL:1.0
   lappend list_check_ips bluespec.com:ip:Loader_AXI4:1.0
   lappend list_check_ips bluespec.com:ip:RV_Debug_Module:1.0

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell proc_ip } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create ports
  set CLK100MHZ [ create_bd_port -dir I -type clk CLK100MHZ ]
  set LED [ create_bd_port -dir O -from 15 -to 0 LED ]
  set RESETn [ create_bd_port -dir I -type rst RESETn ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
     CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
     CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
     CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
     CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50}  \
     CONFIG.MMCM_DIVCLK_DIVIDE {1}  \
     CONFIG.MMCM_CLKFBOUT_MULT_F {10.000}  \
     CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000}   \
     CONFIG.MMCM_CLKOUT1_DIVIDE {5}  \
     CONFIG.MMCM_CLKOUT2_DIVIDE {20}         \
     CONFIG.CLKOUT2_USED {true} \
     CONFIG.CLKOUT3_USED {true} \
     CONFIG.NUM_OUT_CLKS {3} \
     CONFIG.CLKOUT1_PHASE_ERROR {98.575}  \
     CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
     CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
     CONFIG.CLKOUT1_JITTER {130.958}         \
     CONFIG.CLKOUT2_JITTER {114.829} \
     CONFIG.CLKOUT3_JITTER {151.636}   \
     CONFIG.RESET_BOARD_INTERFACE {reset} \
     CONFIG.RESET_PORT {resetn} \
     CONFIG.RESET_TYPE {ACTIVE_LOW} \
     CONFIG.USE_BOARD_FLOW {true} \
  ] $clk_wiz_0
  

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.C_AUX_RST_WIDTH {4} \
   CONFIG.C_EXT_RST_WIDTH {4} \
   CONFIG.C_NUM_BUS_RST {1} \
 ] $proc_sys_reset_1

  # Create instance: mcu_0, and set properties
  set bscore  [ create_bd_cell -type ip -vlnv bluespec.com:ip:MCU_RV32IMC_16K_AHBL:1.0 bscore ]
  set bsdebug [ create_bd_cell -type ip -vlnv bluespec.com:ip:RV_Debug_Module:1.0 bsdebug ]
  set gpio    [ create_bd_cell -type ip -vlnv bluespec.com:ip:GPIO_AHBL:1.0 gpio ]
  set loader  [ create_bd_cell -type ip -vlnv bluespec.com:ip:Loader_AXI4:1.0 loader ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xilinx_jtag_0, and set properties
  set xilinx_jtag_0 [ create_bd_cell -type ip -vlnv bluespec.com:ip:xilinx_jtag:1.0 xilinx_jtag_0 ]

  # Connect up the jtag
  connect_bd_intf_net -intf_net jtag_connection      [get_bd_intf_pins xilinx_jtag_0/jtag]         [get_bd_intf_pins bsdebug/jtag]

  # Create port connections
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_ports LED] [get_bd_pins gpio/out]

  # Connect up the clock
  connect_bd_net -net clk_in1_0_1 [get_bd_ports CLK100MHZ] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_network [get_bd_pins clk_wiz_0/clk_out3] \
     [get_bd_pins proc_sys_reset_1/slowest_sync_clk]  \
     [get_bd_pins bscore/CLK]                          \
     [get_bd_pins bsdebug/CLK]                          \
     [get_bd_pins gpio/CLK]                          \
     [get_bd_pins loader/CLK]                           \
     [get_bd_pins xilinx_jtag_0/clk]

  # Connect up the reset
  connect_bd_net -net ext_reset_in [get_bd_ports RESETn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_1/aux_reset_in]
  connect_bd_net -net tiehigh                      \
     [get_bd_pins xlconstant_1/dout]               \
     [get_bd_pins proc_sys_reset_1/ext_reset_in]   \
     [get_bd_pins proc_sys_reset_1/dcm_locked]
  
  connect_bd_net -net reset_network                      \
     [get_bd_pins proc_sys_reset_1/peripheral_aresetn]   \
     [get_bd_pins bscore/RST_N]                           \
     [get_bd_pins bsdebug/RST_N]                           \
     [get_bd_pins gpio/RST_N]                           \
     [get_bd_pins loader/RST_N]                           \
     [get_bd_pins xilinx_jtag_0/rst_n]                    

  connect_bd_net -net dmi_reset_in [get_bd_pins xilinx_jtag_0/reset] [get_bd_pins bsdebug/dmi_reset]

  # Tie off the interrupts
  connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins bscore/ext_interrupt]
  connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins bscore/sw_interrupt]
  connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins bscore/timer_interrupt]

  # Connect RDY-EN for the BSDebug-BSCore Client-Server Interfaces
  set and_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 and_0 ]
  set_property -dict [list CONFIG.C_SIZE {1}] $and_0
  connect_bd_net [get_bd_pins bsdebug/RDY_toCore_request_get] [get_bd_pins and_0/Op2]
  connect_bd_net [get_bd_pins bscore/RDY_debug_request_put] [get_bd_pins and_0/Op1]
  connect_bd_net [get_bd_pins and_0/Res] [get_bd_pins bscore/EN_debug_request_put]
  connect_bd_net [get_bd_pins and_0/Res] [get_bd_pins bsdebug/EN_toCore_request_get]
  connect_bd_net [get_bd_pins bsdebug/toCore_request_get] [get_bd_pins bscore/debug_request_put]
  
  set and_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 and_1 ]
  set_property -dict [list CONFIG.C_SIZE {1}] $and_1
  connect_bd_net [get_bd_pins bscore/RDY_debug_response_get] [get_bd_pins and_1/Op1]
  connect_bd_net [get_bd_pins bsdebug/RDY_toCore_response_put] [get_bd_pins and_1/Op2]
  connect_bd_net [get_bd_pins and_1/Res] [get_bd_pins bsdebug/EN_toCore_response_put]
  connect_bd_net [get_bd_pins and_1/Res] [get_bd_pins bscore/EN_debug_response_get]
  connect_bd_net [get_bd_pins bscore/debug_response_get] [get_bd_pins bsdebug/toCore_response_put]

  # Connect AHB-L master interface from bscore to the gpio AHB-L device
  connect_bd_net [get_bd_pins gpio/target_HADDR] [get_bd_pins bscore/master1_HADDR]
  connect_bd_net [get_bd_pins gpio/target_HBURST] [get_bd_pins bscore/master1_HBURST]
  connect_bd_net [get_bd_pins gpio/target_HPROT] [get_bd_pins bscore/master1_HPROT]
  connect_bd_net [get_bd_pins gpio/target_HSIZE] [get_bd_pins bscore/master1_HSIZE]
  connect_bd_net [get_bd_pins gpio/target_HTRANS] [get_bd_pins bscore/master1_HTRANS]
  connect_bd_net [get_bd_pins gpio/target_HWDATA] [get_bd_pins bscore/master1_HWDATA]
  connect_bd_net [get_bd_pins gpio/target_HWRITE] [get_bd_pins bscore/master1_HWRITE]
  connect_bd_net [get_bd_pins gpio/target_HRESP] [get_bd_pins bscore/master1_HRESP]
  connect_bd_net [get_bd_pins gpio/target_HRDATA] [get_bd_pins bscore/master1_HRDATA]
  connect_bd_net [get_bd_pins bscore/master1_HMASTLOCK] [get_bd_pins gpio/target_HMASTLOCK]
  connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins gpio/target_HSEL]
  connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins gpio/target_HREADY]
  connect_bd_net [get_bd_pins gpio/target_HREADYOUT] [get_bd_pins bscore/master1_HREADY]

  # Loader device connections
  connect_bd_intf_net [get_bd_intf_pins loader/toFabric] [get_bd_intf_pins bscore/dma_server]
  connect_bd_net [get_bd_pins loader/cpu_halt] [get_bd_pins bscore/cpu_halt_x]
  connect_bd_net [get_bd_pins bscore/reset_done] [get_bd_pins loader/reset_done_x]
  

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design "" $proc_ip
