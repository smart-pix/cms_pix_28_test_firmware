set_property PACKAGE_PIN T8  [get_ports vin_test_trig_out]
set_property PACKAGE_PIN Y3  [get_ports bxclk]
set_property PACKAGE_PIN AB4 [get_ports bxclk_ana]
set_property PACKAGE_PIN AC4 [get_ports config_clk]
set_property PACKAGE_PIN V2  [get_ports scan_load]
set_property PACKAGE_PIN V1  [get_ports config_load]
set_property PACKAGE_PIN Y2  [get_ports config_in]
set_property PACKAGE_PIN Y1  [get_ports scan_in]
set_property PACKAGE_PIN AA2 [get_ports reset_not]
set_property PACKAGE_PIN AA1 [get_ports super_pixel_sel]
set_property PACKAGE_PIN AB3 [get_ports scan_out_test]
set_property PACKAGE_PIN AC3 [get_ports scan_out]
set_property PACKAGE_PIN AC2 [get_ports config_out]
# J1-pin-27 == FMC_LA_06_N == FPGA-pin-AC1 is nou used
# J1-pin-29 == FMC_LA_07_P == FPGA-pin-U5  is nou used
# J1-pin-31 == FMC_LA_07_N == FPGA-pin-U4  is nou used
set_property PACKAGE_PIN V4  [get_ports dnn_output_0]
set_property PACKAGE_PIN V3  [get_ports dnn_output_1]
# J1-pin-37 == FMC_LA_09_P == FPGA-pin-W2  is nou used
# J1-pin-39 == FMC_LA_09_N == FPGA-pin-W1  is nou used
# WARNING: input port dn_event_toggle is NOT connected to wirebonded DUT PCB J-26
# set_property PACKAGE_PIN T8  [get_ports dn_event_toggle] T8 pin now used by vin_test_trig_out
# set_property PACKAGE_PIN R8  [get_ports up_event_toggle]

set_property IOSTANDARD LVCMOS18 [get_ports vin_test_trig_out]
set_property IOSTANDARD LVCMOS18 [get_ports bxclk]
set_property IOSTANDARD LVCMOS18 [get_ports bxclk_ana]
set_property IOSTANDARD LVCMOS18 [get_ports config_clk]
set_property IOSTANDARD LVCMOS18 [get_ports scan_load]
set_property IOSTANDARD LVCMOS18 [get_ports config_load]
set_property IOSTANDARD LVCMOS18 [get_ports config_in]
set_property IOSTANDARD LVCMOS18 [get_ports scan_in]
set_property IOSTANDARD LVCMOS18 [get_ports reset_not]
set_property IOSTANDARD LVCMOS18 [get_ports super_pixel_sel]
set_property IOSTANDARD LVCMOS18 [get_ports scan_out_test]
set_property IOSTANDARD LVCMOS18 [get_ports scan_out]
set_property IOSTANDARD LVCMOS18 [get_ports config_out]
set_property IOSTANDARD LVCMOS18 [get_ports dnn_output_0]
set_property IOSTANDARD LVCMOS18 [get_ports dnn_output_1]
# set_property IOSTANDARD LVCMOS18 [get_ports dn_event_toggle]
# set_property IOSTANDARD LVCMOS18 [get_ports up_event_toggle]

# Differential signals
set_property PACKAGE_PIN AC12 [get_ports vin_test_trig_out_OBUF_DS_P[0]]
set_property PACKAGE_PIN AC11 [get_ports vin_test_trig_out_OBUF_DS_N[0]]
set_property IOSTANDARD LVDS [get_ports vin_test_trig_out_OBUF_DS_*]