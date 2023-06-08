set mulExit [lsearch -exact [get_ips DataGen_Bram] DataGen_Bram]
if { $mulExit <0} {
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name DataGen_Bram
}
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {64} CONFIG.Write_Depth_A {16384} CONFIG.Read_Width_A {64} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {64} CONFIG.Read_Width_B {64} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips DataGen_Bram]