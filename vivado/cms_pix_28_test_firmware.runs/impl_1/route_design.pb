
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xczu9eg2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xczu9eg2default:defaultZ17-349h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
82default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common22
Nodegraph reading from file.  2default:default2
00:00:00.872default:default2
00:00:00.952default:default2
5237.7582default:default2
0.0002default:default2
407542default:default2
3998092default:defaultZ17-722h px� 
C
.Phase 1 Build RT Design | Checksum: 1872ecd05
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:17 ; elapsed = 00:00:09 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40643 ; free virtual = 3996982default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
{

Phase %s%s
101*constraints2
2.1 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
N
9Phase 2.1 Fix Topology Constraints | Checksum: 1872ecd05
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:18 ; elapsed = 00:00:09 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40582 ; free virtual = 3996372default:defaulth px� 
t

Phase %s%s
101*constraints2
2.2 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
G
2Phase 2.2 Pre Route Cleanup | Checksum: 1872ecd05
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:18 ; elapsed = 00:00:09 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40582 ; free virtual = 3996372default:defaulth px� 
{

Phase %s%s
101*constraints2
2.3 2default:default2,
Global Clock Net Routing2default:defaultZ18-101h px� 
N
9Phase 2.3 Global Clock Net Routing | Checksum: 17267a13c
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:11 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40568 ; free virtual = 3996232default:defaulth px� 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 2.4 Update Timing | Checksum: 1d69e6cab
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:30 ; elapsed = 00:00:15 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40558 ; free virtual = 3996132default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=0.514  | TNS=0.000  | WHS=-0.146 | THS=-73.340|
2default:defaultZ35-416h px� 
I
4Phase 2 Router Initialization | Checksum: 17b9f9240
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:42 ; elapsed = 00:00:19 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40661 ; free virtual = 3997162default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
3.1 2default:default2"
Global Routing2default:defaultZ18-101h px� 
D
/Phase 3.1 Global Routing | Checksum: 17b9f9240
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:42 ; elapsed = 00:00:20 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40661 ; free virtual = 3997162default:defaulth px� 
C
.Phase 3 Initial Routing | Checksum: 191579c26
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:59 ; elapsed = 00:00:26 . Memory (MB): peak = 5237.758 ; gain = 0.000 ; free physical = 40514 ; free virtual = 3995692default:defaulth px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=0.315  | TNS=0.000  | WHS=0.007  | THS=0.000  |
2default:defaultZ35-416h px� 
H
3Phase 4.1 Global Iteration 0 | Checksum: 253b7fa67
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:27 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40593 ; free virtual = 3996482default:defaulth px� 
�

Phase %s%s
101*constraints2
4.2 2default:default21
Additional Iteration for Hold2default:defaultZ18-101h px� 
S
>Phase 4.2 Additional Iteration for Hold | Checksum: 1dd33ccce
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:27 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40595 ; free virtual = 3996502default:defaulth px� 
F
1Phase 4 Rip-up And Reroute | Checksum: 1dd33ccce
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:27 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40595 ; free virtual = 3996502default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
C
.Phase 5.1 Delay CleanUp | Checksum: 229922e43
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:28 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40600 ; free virtual = 3996552default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
M
8Phase 5.2 Clock Skew Optimization | Checksum: 229922e43
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:28 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40600 ; free virtual = 3996552default:defaulth px� 
O
:Phase 5 Delay and Skew Optimization | Checksum: 229922e43
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:28 ; elapsed = 00:01:04 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40600 ; free virtual = 3996552default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 6.1.1 Update Timing | Checksum: 1e35ae335
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:35 ; elapsed = 00:01:07 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40594 ; free virtual = 3996502default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=0.315  | TNS=0.000  | WHS=0.007  | THS=0.000  |
2default:defaultZ35-416h px� 
C
.Phase 6.1 Hold Fix Iter | Checksum: 2549aab09
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:35 ; elapsed = 00:01:07 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40592 ; free virtual = 3996482default:defaulth px� 
A
,Phase 6 Post Hold Fix | Checksum: 2549aab09
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:35 ; elapsed = 00:01:07 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40586 ; free virtual = 3996422default:defaulth px� 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px� 
B
-Phase 7 Route finalize | Checksum: 21f955da8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:37 ; elapsed = 00:01:08 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40554 ; free virtual = 3996102default:defaulth px� 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
I
4Phase 8 Verifying routed nets | Checksum: 21f955da8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:37 ; elapsed = 00:01:08 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40552 ; free virtual = 3996072default:defaulth px� 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
E
0Phase 9 Depositing Routes | Checksum: 21f955da8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:39 ; elapsed = 00:01:09 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40479 ; free virtual = 3995352default:defaulth px� 
o

Phase %s%s
101*constraints2
10 2default:default2!
Resolve XTalk2default:defaultZ18-101h px� 
B
-Phase 10 Resolve XTalk | Checksum: 21f955da8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:39 ; elapsed = 00:01:10 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40484 ; free virtual = 3995402default:defaulth px� 
t

Phase %s%s
101*constraints2
11 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
�
Estimated Timing Summary %s
57*route2J
6| WNS=0.315  | TNS=0.000  | WHS=0.007  | THS=0.000  |
2default:defaultZ35-57h px� 
�
�The final timing numbers are based on the router estimated timing analysis. For a complete and accurate timing signoff, please run report_timing_summary.
127*routeZ35-327h px� 
G
2Phase 11 Post Router Timing | Checksum: 21f955da8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:41 ; elapsed = 00:01:10 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40485 ; free virtual = 3995402default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:41 ; elapsed = 00:01:10 . Memory (MB): peak = 5250.777 ; gain = 13.020 ; free physical = 40579 ; free virtual = 3996342default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1092default:default2
02default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
route_design: 2default:default2
00:02:492default:default2
00:01:122default:default2
5250.7772default:default2
13.0272default:default2
405792default:default2
3996342default:defaultZ17-722h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:032default:default2
00:00:012default:default2
5250.7812default:default2
0.0042default:default2
405382default:default2
3996252default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/impl_1/cms_pix_28_fw_top_bd_wrapper_routed.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
�Executing : report_drc -file cms_pix_28_fw_top_bd_wrapper_drc_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_drc_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_drc -file cms_pix_28_fw_top_bd_wrapper_drc_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_drc_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_drc_routed.rpx2default:defaultZ4-113h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
586*	vivadotcl2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/impl_1/cms_pix_28_fw_top_bd_wrapper_drc_routed.rpt�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/impl_1/cms_pix_28_fw_top_bd_wrapper_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
%s4*runtcl2�
�Executing : report_methodology -file cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_methodology -file cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
82default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
609*	vivadotcl2�
�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/impl_1/cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpt�/asic/projects/C/CMS_PIX_28/gingu/spacely/spacely-caribou-common-blocks/cms_pix_28_test_firmware/vivado/cms_pix_28_test_firmware.runs/impl_1/cms_pix_28_fw_top_bd_wrapper_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
%s4*runtcl2�
�Executing : report_power -file cms_pix_28_fw_top_bd_wrapper_power_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_power_summary_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_power_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_power -file cms_pix_28_fw_top_bd_wrapper_power_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_power_summary_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_power_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1212default:default2
02default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
report_power: 2default:default2
00:00:152default:default2
00:00:072default:default2
5339.0662default:default2
72.2732default:default2
404862default:default2
3995612default:defaultZ17-722h px� 
�
%s4*runtcl2�
�Executing : report_route_status -file cms_pix_28_fw_top_bd_wrapper_route_status.rpt -pb cms_pix_28_fw_top_bd_wrapper_route_status.pb
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_timing_summary -max_paths 10 -report_unconstrained -file cms_pix_28_fw_top_bd_wrapper_timing_summary_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_timing_summary_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px� 
�
UpdateTimingParams:%s.
91*timing2O
; Speed grade: -2, Temperature grade: E, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 
�
%s4*runtcl2y
eExecuting : report_incremental_reuse -file cms_pix_28_fw_top_bd_wrapper_incremental_reuse_routed.rpt
2default:defaulth px� 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px� 
�
%s4*runtcl2y
eExecuting : report_clock_utilization -file cms_pix_28_fw_top_bd_wrapper_clock_utilization_routed.rpt
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_bus_skew -warn_on_violation -file cms_pix_28_fw_top_bd_wrapper_bus_skew_routed.rpt -pb cms_pix_28_fw_top_bd_wrapper_bus_skew_routed.pb -rpx cms_pix_28_fw_top_bd_wrapper_bus_skew_routed.rpx
2default:defaulth px� 
�
UpdateTimingParams:%s.
91*timing2O
; Speed grade: -2, Temperature grade: E, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 


End Record