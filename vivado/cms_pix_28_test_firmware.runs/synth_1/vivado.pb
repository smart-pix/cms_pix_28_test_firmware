
�
fTcl app '%s' is out of date for this release. Please run tclapp::reset_tclstore and reinstall the app.517*common2
designutils2default:defaultZ17-1221h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2$
create_project: 2default:default2
00:00:052default:default2
00:00:082default:default2
2998.1682default:default2
2.0232default:default2
431682default:default2
4022022default:defaultZ17-722h px� 
>
Refreshing IP repositories
234*coregenZ19-234h px� 
G
"No user IP repositories specified
1154*coregenZ19-1704h px� 
�
"Loaded Vivado IP repository '%s'.
1332*coregen2:
&/asic/cad/Xilinx/Vivado/2022.1/data/ip2default:defaultZ19-2313h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
add_files: 2default:default2
00:00:082default:default2
00:00:092default:default2
3110.2152default:default2
112.0472default:default2
431142default:default2
4021372default:defaultZ17-722h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental /asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.srcs/utils_1/imports/synth_1/cms_pix_28_fw_top_bd_wrapper.dcp2default:defaultZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.srcs/utils_1/imports/synth_1/cms_pix_28_fw_top_bd_wrapper.dcp2default:defaultZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
�
Command: %s
53*	vivadotcl2]
Isynth_design -top cms_pix_28_fw_top_bd_wrapper -part xczu9eg-ffvb1156-2-e2default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xczu9eg2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xczu9eg2default:defaultZ17-349h px� 
[
Loading part %s157*device2(
xczu9eg-ffvb1156-2-e2default:defaultZ21-403h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
42default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
`
#Helper process launched with PID %s4824*oasys2
321312default:defaultZ8-7075h px� 
�
%s*synth2�
�Starting RTL Elaboration : Time (s): cpu = 00:00:04 ; elapsed = 00:00:05 . Memory (MB): peak = 3289.207 ; gain = 178.992 ; free physical = 40871 ; free virtual = 399906
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys20
cms_pix_28_fw_top_bd_wrapper2default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/hdl/cms_pix_28_fw_top_bd_wrapper.v2default:default2
122default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2(
cms_pix_28_fw_top_bd2default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
122default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2922default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2,
s00_couplers_imp_1IHNVIV2default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
6022default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys22
cms_pix_28_fw_top_bd_auto_ds_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_auto_ds_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys22
cms_pix_28_fw_top_bd_auto_ds_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_auto_ds_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys22
cms_pix_28_fw_top_bd_auto_pc_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_auto_pc_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys22
cms_pix_28_fw_top_bd_auto_pc_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_auto_pc_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2,
s00_couplers_imp_1IHNVIV2default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
6022default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2922default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys24
 cms_pix_28_fw_top_bd_clk_wiz_0_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_clk_wiz_0_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys24
 cms_pix_28_fw_top_bd_clk_wiz_0_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_clk_wiz_0_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys25
!cms_pix_28_fw_top_bd_fw_top_v_0_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_fw_top_v_0_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys25
!cms_pix_28_fw_top_bd_fw_top_v_0_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_fw_top_v_0_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_proc_sys_reset_0_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_proc_sys_reset_0_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2
mb_reset2default:default2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2$
proc_sys_reset_02default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2412default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2$
bus_struct_reset2default:default2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2$
proc_sys_reset_02default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2412default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2$
peripheral_reset2default:default2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2$
proc_sys_reset_02default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2412default:default8@Z8-7071h px� 
�
Kinstance '%s' of module '%s' has %s connections declared, but only %s given4757*oasys2$
proc_sys_reset_02default:default2;
'cms_pix_28_fw_top_bd_proc_sys_reset_0_02default:default2
102default:default2
72default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2412default:default8@Z8-7023h px� 
�
synthesizing module '%s'%s4497*oasys2<
(cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_02default:default2
 2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0_stub.v2default:default2
52default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2<
(cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_02default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/.Xil/Vivado-31828-fasic-beast2.fnal.gov/realtime/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0_stub.v2default:default2
52default:default8@Z8-6155h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2"
maxigp0_awuser2default:default2<
(cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_02default:default2%
zynq_ultra_ps_e_02default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2492default:default8@Z8-7071h px� 
�
9port '%s' of module '%s' is unconnected for instance '%s'4818*oasys2"
maxigp0_aruser2default:default2<
(cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_02default:default2%
zynq_ultra_ps_e_02default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2492default:default8@Z8-7071h px� 
�
Kinstance '%s' of module '%s' has %s connections declared, but only %s given4757*oasys2%
zynq_ultra_ps_e_02default:default2<
(cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_02default:default2
422default:default2
402default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
2492default:default8@Z8-7023h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2(
cms_pix_28_fw_top_bd2default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/synth/cms_pix_28_fw_top_bd.v2default:default2
122default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys20
cms_pix_28_fw_top_bd_wrapper2default:default2
 2default:default2
02default:default2
12default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/hdl/cms_pix_28_fw_top_bd_wrapper.v2default:default2
122default:default8@Z8-6155h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
M_ACLK2default:default2,
s00_couplers_imp_1IHNVIV2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	M_ARESETN2default:default2,
s00_couplers_imp_1IHNVIV2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ACLK2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ARESETN2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
�
%s*synth2�
�Finished RTL Elaboration : Time (s): cpu = 00:00:06 ; elapsed = 00:00:07 . Memory (MB): peak = 3353.160 ; gain = 242.945 ; free physical = 41970 ; free virtual = 401006
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:06 ; elapsed = 00:00:08 . Memory (MB): peak = 3370.961 ; gain = 260.746 ; free physical = 41970 ; free virtual = 401006
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:06 ; elapsed = 00:00:08 . Memory (MB): peak = 3370.961 ; gain = 260.746 ; free physical = 41970 ; free virtual = 401006
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.012default:default2
00:00:00.012default:default2
3370.9652default:default2
0.0002default:default2
419662default:default2
4010022default:defaultZ17-722h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0_in_context.xdc2default:default2>
(cms_pix_28_fw_top_bd_i/zynq_ultra_ps_e_0	2default:default8Z20-848h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
create_clock: 2default:default2
00:00:052default:default2
00:00:052default:default2
3437.7382default:default2
11.9102default:default2
418792default:default2
4009152default:defaultZ17-722h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0/cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0_in_context.xdc2default:default2>
(cms_pix_28_fw_top_bd_i/zynq_ultra_ps_e_0	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_proc_sys_reset_0_0/cms_pix_28_fw_top_bd_proc_sys_reset_0_0/cms_pix_28_fw_top_bd_proc_sys_reset_0_0_in_context.xdc2default:default2=
'cms_pix_28_fw_top_bd_i/proc_sys_reset_0	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_proc_sys_reset_0_0/cms_pix_28_fw_top_bd_proc_sys_reset_0_0/cms_pix_28_fw_top_bd_proc_sys_reset_0_0_in_context.xdc2default:default2=
'cms_pix_28_fw_top_bd_i/proc_sys_reset_0	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_auto_ds_0/cms_pix_28_fw_top_bd_auto_ds_0/cms_pix_28_fw_top_bd_auto_ds_0_in_context.xdc2default:default2T
>cms_pix_28_fw_top_bd_i/axi_interconnect_0/s00_couplers/auto_ds	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_auto_ds_0/cms_pix_28_fw_top_bd_auto_ds_0/cms_pix_28_fw_top_bd_auto_ds_0_in_context.xdc2default:default2T
>cms_pix_28_fw_top_bd_i/axi_interconnect_0/s00_couplers/auto_ds	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_auto_pc_0/cms_pix_28_fw_top_bd_auto_pc_0/cms_pix_28_fw_top_bd_auto_pc_0_in_context.xdc2default:default2T
>cms_pix_28_fw_top_bd_i/axi_interconnect_0/s00_couplers/auto_pc	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_auto_pc_0/cms_pix_28_fw_top_bd_auto_pc_0/cms_pix_28_fw_top_bd_auto_pc_0_in_context.xdc2default:default2T
>cms_pix_28_fw_top_bd_i/axi_interconnect_0/s00_couplers/auto_pc	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_clk_wiz_0_0/cms_pix_28_fw_top_bd_clk_wiz_0_0/cms_pix_28_fw_top_bd_clk_wiz_0_0_in_context.xdc2default:default26
 cms_pix_28_fw_top_bd_i/clk_wiz_0	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_clk_wiz_0_0/cms_pix_28_fw_top_bd_clk_wiz_0_0/cms_pix_28_fw_top_bd_clk_wiz_0_0_in_context.xdc2default:default26
 cms_pix_28_fw_top_bd_i/clk_wiz_0	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_fw_top_v_0_0/cms_pix_28_fw_top_bd_fw_top_v_0_0/cms_pix_28_fw_top_bd_fw_top_v_0_0_in_context.xdc2default:default27
!cms_pix_28_fw_top_bd_i/fw_top_v_0	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.gen/sources_1/bd/cms_pix_28_fw_top_bd/ip/cms_pix_28_fw_top_bd_fw_top_v_0_0/cms_pix_28_fw_top_bd_fw_top_v_0_0/cms_pix_28_fw_top_bd_fw_top_v_0_0_in_context.xdc2default:default27
!cms_pix_28_fw_top_bd_i/fw_top_v_0	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.srcs/constrs_1/new/cms_pix_28_test_firmware.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.srcs/constrs_1/new/cms_pix_28_test_firmware.xdc2default:default8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.srcs/constrs_1/new/cms_pix_28_test_firmware.xdc2default:default2B
..Xil/cms_pix_28_fw_top_bd_wrapper_propImpl.xdc2default:defaultZ1-236h px� 
�
Parsing XDC File [%s]
179*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/dont_touch.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/dont_touch.xdc2default:default8Z20-178h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
3437.7382default:default2
0.0002default:default2
418792default:default2
4009152default:defaultZ17-722h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common24
 Constraint Validation Runtime : 2default:default2
00:00:00.012default:default2
00:00:00.022default:default2
3437.7382default:default2
0.0002default:default2
418792default:default2
4009152default:defaultZ17-722h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:17 ; elapsed = 00:00:20 . Memory (MB): peak = 3437.738 ; gain = 327.523 ; free physical = 41950 ; free virtual = 400986
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Loading part: xczu9eg-ffvb1156-2-e
2default:defaulth p
x
� 
B
 Reading net delay rules and data4578*oasysZ8-6742h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:17 ; elapsed = 00:00:20 . Memory (MB): peak = 3437.738 ; gain = 327.523 ; free physical = 41950 ; free virtual = 400986
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:17 ; elapsed = 00:00:20 . Memory (MB): peak = 3437.738 ; gain = 327.523 ; free physical = 41950 ; free virtual = 400986
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:17 ; elapsed = 00:00:21 . Memory (MB): peak = 3437.738 ; gain = 327.523 ; free physical = 41953 ; free virtual = 400990
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2o
[Part Resources:
DSPs: 2520 (col length:168)
BRAMs: 1824 (col length: RAMB18 168 RAMB36 84)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ACLK2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
ARESETN2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
M00_ACLK2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
M00_ARESETN2default:default2=
)cms_pix_28_fw_top_bd_axi_interconnect_0_02default:defaultZ8-7129h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:18 ; elapsed = 00:00:22 . Memory (MB): peak = 3437.738 ; gain = 327.523 ; free physical = 42038 ; free virtual = 401079
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:30 ; elapsed = 00:00:39 . Memory (MB): peak = 3825.352 ; gain = 715.137 ; free physical = 41376 ; free virtual = 400416
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:30 ; elapsed = 00:00:39 . Memory (MB): peak = 3825.352 ; gain = 715.137 ; free physical = 41375 ; free virtual = 400416
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:30 ; elapsed = 00:00:39 . Memory (MB): peak = 3844.375 ; gain = 734.160 ; free physical = 41366 ; free virtual = 400407
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
j
%s
*synth2R
>+------+-----------------------------------------+----------+
2default:defaulth p
x
� 
j
%s
*synth2R
>|      |BlackBox name                            |Instances |
2default:defaulth p
x
� 
j
%s
*synth2R
>+------+-----------------------------------------+----------+
2default:defaulth p
x
� 
j
%s
*synth2R
>|1     |cms_pix_28_fw_top_bd_auto_ds_0           |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>|2     |cms_pix_28_fw_top_bd_auto_pc_0           |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>|3     |cms_pix_28_fw_top_bd_clk_wiz_0_0         |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>|4     |cms_pix_28_fw_top_bd_fw_top_v_0_0        |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>|5     |cms_pix_28_fw_top_bd_proc_sys_reset_0_0  |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>|6     |cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0_0 |         1|
2default:defaulth p
x
� 
j
%s
*synth2R
>+------+-----------------------------------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
d
%s*synth2L
8+------+---------------------------------------+------+
2default:defaulth px� 
d
%s*synth2L
8|      |Cell                                   |Count |
2default:defaulth px� 
d
%s*synth2L
8+------+---------------------------------------+------+
2default:defaulth px� 
d
%s*synth2L
8|1     |cms_pix_28_fw_top_bd_auto_ds           |     1|
2default:defaulth px� 
d
%s*synth2L
8|2     |cms_pix_28_fw_top_bd_auto_pc           |     1|
2default:defaulth px� 
d
%s*synth2L
8|3     |cms_pix_28_fw_top_bd_clk_wiz_0         |     1|
2default:defaulth px� 
d
%s*synth2L
8|4     |cms_pix_28_fw_top_bd_fw_top_v_0        |     1|
2default:defaulth px� 
d
%s*synth2L
8|5     |cms_pix_28_fw_top_bd_proc_sys_reset_0  |     1|
2default:defaulth px� 
d
%s*synth2L
8|6     |cms_pix_28_fw_top_bd_zynq_ultra_ps_e_0 |     1|
2default:defaulth px� 
d
%s*synth2L
8|7     |IBUF                                   |     5|
2default:defaulth px� 
d
%s*synth2L
8|8     |OBUF                                   |    10|
2default:defaulth px� 
d
%s*synth2L
8+------+---------------------------------------+------+
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.316 ; gain = 740.102 ; free physical = 41354 ; free virtual = 400395
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
r
%s
*synth2Z
FSynthesis finished with 0 errors, 0 critical warnings and 5 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:27 ; elapsed = 00:00:36 . Memory (MB): peak = 3850.316 ; gain = 673.324 ; free physical = 41395 ; free virtual = 400436
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:33 ; elapsed = 00:00:43 . Memory (MB): peak = 3850.320 ; gain = 740.102 ; free physical = 41396 ; free virtual = 400436
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.012default:default2
00:00:00.012default:default2
3862.2852default:default2
0.0002default:default2
414892default:default2
4005302default:defaultZ17-722h px� 
e
-Analyzing %s Unisim elements for replacement
17*netlist2
52default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
3888.0702default:default2
0.0002default:default2
414152default:default2
4004562default:defaultZ17-722h px� 
�
!Unisim Transformation Summary:
%s111*project2m
Y  A total of 5 instances were transformed.
  IBUF => IBUF (IBUFCTRL, INBUF): 5 instances
2default:defaultZ1-111h px� 
g
$Synth Design complete, checksum: %s
562*	vivadotcl2
d893698b2default:defaultZ4-1430h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
452default:default2
162default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:00:462default:default2
00:00:552default:default2
3888.0702default:default2
777.8552default:default2
416192default:default2
4006592default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/synth_1/cms_pix_28_fw_top_bd_wrapper.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
�Executing : report_utilization -file cms_pix_28_fw_top_bd_wrapper_utilization_synth.rpt -pb cms_pix_28_fw_top_bd_wrapper_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Mon Jun 24 08:55:16 20242default:defaultZ17-206h px� 


End Record