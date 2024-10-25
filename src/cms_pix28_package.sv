// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-08-05
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-08-06  Cristian  Gingu        Created
// 2024-09-17  Cristian  Gingu        Add w_cfg_static_0_reg_scan_load_delay_index_min/max_IP2
// 2024-10-17  Cristian  Gingu        Add delayed vin_test_trig_out in ip2_tes3.sv
// 2024-10-25  Cristian  Gingu        Add state_t_sm_ip2_test4; merging state_t_sm_ip2_test2 and state_t_sm_ip2_test3. Add localparam dnn_reg_width
// ------------------------------------------------------------------------------------

`ifndef __cms_pix28_package__
`define __cms_pix28_package__

package cms_pix28_package;
  //
  parameter cfg_reg_bits_total         = 5188;             // configuration register total bits number (including test bits)
  parameter cfg_reg_bits_test          = 24;               // configuration register test  bits number
  parameter scan_reg_bits_total        = 768;              // scan-chain    register total bits number
  //
  parameter windex_device_id_max       = 31;               // write index for device_id       (upper)
  parameter windex_device_id_min       = 28;               // write index for device_id       (lower)
  parameter windex_op_code_max         = 27;               // write index for operation_code  (upper)
  parameter windex_op_code_min         = 24;               // write index for operation_code  (lower)
  parameter windex_body_max            = 23;               // write index for body_data       (upper)
  parameter windex_body_min            =  0;               // write index for body_data       (lower)
  //
  parameter logic [3:0] firmware_id_1            = 4'h1;
  parameter logic [3:0] firmware_id_2            = 4'h2;
  parameter logic [3:0] firmware_id_3            = 4'h4;
  parameter logic [3:0] firmware_id_4            = 4'h8;
  parameter logic [3:0] firmware_id_none         = 4'h0;
  //
  parameter logic [3:0] test_number_1            = 4'h1;
  parameter logic [3:0] test_number_2            = 4'h2;
  parameter logic [3:0] test_number_3            = 4'h4;
  parameter logic [3:0] test_number_4            = 4'h8;
  //
  typedef enum logic [3:0] {                               // operation_code enumerated type
    OP_CODE_NOOP                       = 4'h0,
    OP_CODE_W_RST_FW                   = 4'h1,
    OP_CODE_W_CFG_STATIC_0             = 4'h2,
    OP_CODE_R_CFG_STATIC_0             = 4'h3,
    OP_CODE_W_CFG_STATIC_1             = 4'h4,
    OP_CODE_R_CFG_STATIC_1             = 4'h5,
    OP_CODE_W_CFG_ARRAY_0              = 4'h6,
    OP_CODE_R_CFG_ARRAY_0              = 4'h7,
    OP_CODE_W_CFG_ARRAY_1              = 4'h8,
    OP_CODE_R_CFG_ARRAY_1              = 4'h9,
    OP_CODE_W_CFG_ARRAY_2              = 4'hA,
    OP_CODE_R_CFG_ARRAY_2              = 4'hB,
    OP_CODE_R_DATA_ARRAY_0             = 4'hC,
    OP_CODE_R_DATA_ARRAY_1             = 4'hD,
    OP_CODE_W_STATUS_FW_CLEAR          = 4'hE,
    OP_CODE_W_EXECUTE                  = 4'hF
  } op_code;
  //
  parameter status_index_op_code_w_reset         = 0;
  parameter status_index_op_code_w_cfg_static_0  = 1;
  parameter status_index_op_code_r_cfg_static_0  = 2;
  parameter status_index_op_code_w_cfg_static_1  = 3;
  parameter status_index_op_code_r_cfg_static_1  = 4;
  parameter status_index_op_code_w_cfg_array_0   = 5;
  parameter status_index_op_code_r_cfg_array_0   = 6;
  parameter status_index_op_code_w_cfg_array_1   = 7;
  parameter status_index_op_code_r_cfg_array_1   = 8;
  parameter status_index_op_code_w_cfg_array_2   = 9;
  parameter status_index_op_code_r_cfg_array_2   = 10;
  parameter status_index_op_code_r_data_array_0  = 11;
  parameter status_index_op_code_r_data_array_1  = 12;
  parameter status_index_op_code_w_execute       = 13;
  parameter status_index_test1_done              = 14;
  parameter status_index_test2_done              = 15;
  parameter status_index_test3_done              = 16;
  parameter status_index_test4_done              = 17;
  parameter status_index_spare_min               = 18;
  parameter status_index_spare_max               = 30;
  parameter status_index_error_w_execute_cfg     = 31;
  //
  //---------------------------------------------------------------------------
  // fw_ip1.sv
  //---------------------------------------------------------------------------
  parameter w_cfg_static_0_reg_fast_configclk_period_index_min_IP1   =  0;     // fast_configCLK period is 10ns(AXI100MHz) * 2**7(7-bits) == 10*128 == 1280ns i.e. 0.78125MHz the lowest frequency, thus covering DataSheet minimum 1MHz
  parameter w_cfg_static_0_reg_fast_configclk_period_index_max_IP1   =  6;     //
  parameter w_cfg_static_0_reg_super_pix_sel_index_IP1               =  7;     //
  parameter w_cfg_static_0_reg_slow_configclk_period_index_min_IP1   =  8;     // slow_configCLK period is 10ns(AXI100MHz) * 2**27(27-bits) == 10*134217728 == 1342177280ns i.e. 0.745Hz the lowest frequency, thus covering DataSheet minimum 1Hz
  parameter w_cfg_static_0_reg_slow_configclk_period_index_max_IP1   =  23;    // w_cfg_static_0_reg contains lower 16-bits of the 27-bit period for slow_configCLK
  parameter w_cfg_static_1_reg_slow_configclk_period_index_min_IP1   =  0;     // w_cfg_static_1_reg contains upper 11-bits of the 27-bit period for slow_configCLK
  parameter w_cfg_static_1_reg_slow_configclk_period_index_max_IP1   = 10;
  parameter w_cfg_static_1_reg_spare_index_min_IP1                   = 11;
  parameter w_cfg_static_1_reg_spare_index_max_IP1                   = 23;
  //
  parameter w_execute_cfg_test_delay_index_min_IP1                   =  0;     //
  parameter w_execute_cfg_test_delay_index_max_IP1                   =  6;     //
  parameter w_execute_cfg_test_sample_index_min_IP1                  =  7;     //
  parameter w_execute_cfg_test_sample_index_max_IP1                  = 13;     //
  parameter w_execute_cfg_test_number_index_min_IP1                  = 14;     //
  parameter w_execute_cfg_test_number_index_max_IP1                  = 17;     //
  parameter w_execute_cfg_test_loopback_IP1                          = 18;     //
  parameter w_execute_cfg_test_spare_index_min_IP1                   = 19;     //
  parameter w_execute_cfg_test_spare_index_max_IP1                   = 22;     //
  parameter w_execute_cfg_test_mask_reset_not_index_IP1              = 23;     //
  // IP1 TEST1
  typedef enum logic [2:0] {
    IDLE_IP1_T1        = 3'b000,
    DELAY_TEST_IP1_T1  = 3'b001,
    RESET_NOT_IP1_T1   = 3'b010,
    SHIFT_IN_0_IP1_T1  = 3'b011,
    SHIFT_IN_IP1_T1    = 3'b100,
    DONE_IP1_T1        = 3'b101
  } state_t_sm_ip1_test1;
  // IP1 TEST2
  typedef enum logic [3:0] {
    IDLE_IP1_T2                = 4'b0000,
    DELAY_TEST_IP1_T2          = 4'b0001,
    RESET_NOT_IP1_T2           = 4'b0010,
    SHIFT_IN_0_IP1_T2          = 4'b0011,
    SHIFT_IN_IP1_T2            = 4'b0100,
    WAIT_FAST_CLK_IP1_T2       = 4'b0101,
    WAIT_SLOW_CLK_IP1_T2       = 4'b0110,
    WAIT2_SLOW_CLK_IP1_T2      = 4'b0111,
    SHIFT_IN_SLOW_CLK_IP1_T2   = 4'b1000,
    DONE_IP1_T2                = 4'b1001,
    WAIT_DONE_SLOW_CLK_IP1_T2  = 4'b1010,
    WAIT_DONE_FAST_CLK_IP1_T2  = 4'b1011
  } state_t_sm_ip1_test2;
  //
  // Define enumerated type shift_reg_mode: LOW==shift-register, HIGH==parallel-output-config-internal-comparators; default=HIGH
  typedef enum logic {
    SHIFT_REG_IP1    = 1'b0,
    PARALLEL_OUT_IP1 = 1'b1
  } config_shift_reg_mode_ip1;
  parameter CONFIG_REG_MODE_SHIFT_IN     = SHIFT_REG_IP1;
  parameter CONFIG_REG_MODE_PARALLEL_OUT = PARALLEL_OUT_IP1;
  //
  //---------------------------------------------------------------------------
  // fw_ip2.sv
  //---------------------------------------------------------------------------
  localparam w_cfg_static_0_reg_bxclk_period_index_min_IP2           =  0;     // USAGE of first 6-bits: bit#0-to-5. USE to set clock PERIOD
  localparam w_cfg_static_0_reg_bxclk_period_index_max_IP2           =  5;     // example for setting bxclk==40MHz derived from fw_pl_clk1==400MHz: write 6'h0A => 10*2.5ns=25ns;
  localparam w_cfg_static_0_reg_bxclk_delay_index_min_IP2            =  6;     // USAGE of next  5-bits: bit#6-to-10. Use to set clock DELAY (maximum is half clock PERIOD as set by bits 0-to-5)
  localparam w_cfg_static_0_reg_bxclk_delay_index_max_IP2            = 10;     //
  localparam w_cfg_static_0_reg_bxclk_delay_sign_index_IP2           = 11;     // USAGE of next 1-bit: bit#11. Use it to set clock value (Lor H) in the first bxclk_delay clocks within a bxclk_period
  // 00.00.00.01.02.03.04.05.06.07.08.09.10.01.02.03.04.05.06.07.08.09.10.               fw_pl_clk1_cnt
  // LL.LL.LL.LL.HH.HH.HH.HH.HH.LL.LL.LL.LL.LL.HH.HH.HH.HH.HH.LL.LL.LL.LL.LL.            fw_bxclk_ana_ff
  // LL.LL.LL.LL.LL.LL.HH.HH.HH.HH.HH.LL.LL.LL.LL.LL.HH.HH.HH.HH.HH.LL.LL.LL.LL.LL.      fw_bxclk_ff when bxclk_delay_sign==0 and bxclk_delay==2
  // LL.LL.LL.LL.HH.HH.HH.LL.LL.LL.LL.LL.HH.HH.HH.HH.HH.LL.LL.LL.LL.LL.                  fw_bxclk_ff when bxclk_delay_sign==1 and bxclk_delay==2
  localparam w_cfg_static_0_reg_super_pix_sel_index_IP2              = 12;     //
  localparam w_cfg_static_0_reg_scan_load_delay_index_min_IP2        = 13;     //
  localparam w_cfg_static_0_reg_scan_load_delay_index_max_IP2        = 18;     //
  localparam w_cfg_static_0_reg_scan_load_delay_disable_index_IP2    = 19;     //
  localparam w_cfg_static_0_reg_spare_index_min_IP2                  = 20;     //
  localparam w_cfg_static_0_reg_spare_index_max_IP2                  = 23;     //
  //
  localparam w_execute_cfg_test_delay_index_min_IP2                  =  0;     //
  localparam w_execute_cfg_test_delay_index_max_IP2                  =  5;     //
  localparam w_execute_cfg_test_sample_index_min_IP2                 =  6;     //
  localparam w_execute_cfg_test_sample_index_max_IP2                 = 11;     //
  localparam w_execute_cfg_test_number_index_min_IP2                 = 12;     //
  localparam w_execute_cfg_test_number_index_max_IP2                 = 15;     //
  localparam w_execute_cfg_test_loopback_IP2                         = 16;     //
  localparam w_execute_cfg_test_vin_test_trig_out_index_min_IP2      = 17;     // this field controls the position of vin_test_trig_out pulse, one bxclk_period wide, within
  localparam w_execute_cfg_test_vin_test_trig_out_index_max_IP2      = 22;     // within time-window defined by state machine sm_test2==SCANLOAD_HIGH_1_T2 + SCANLOAD_HIGH_2_T2
  localparam w_execute_cfg_test_mask_reset_not_index_IP2             = 23;     //
  // IP2 TEST1
  typedef enum logic [2:0] {
    IDLE_IP2_T1        = 3'b000,
    DELAY_TEST_IP2_T1  = 3'b001,
    RESET_NOT_IP2_T1   = 3'b010,
    SHIFT_IN_0_IP2_T1  = 3'b011,
    SHIFT_IN_IP2_T1    = 3'b100,
    DONE_IP2_T1        = 3'b101
  } state_t_sm_ip2_test1;
  // IP2 TEST2
  typedef enum logic [3:0] {
    IDLE_IP2_T2            = 4'b0000,
    DELAY_TEST_IP2_T2      = 4'b0001,
    RESET_NOT_IP2_T2       = 4'b0010,
    TRIGOUT_HIGH_1_IP2_T2  = 4'b0011,
    TRIGOUT_HIGH_2_IP2_T2  = 4'b0100,
    DELAY_SCANLOAD_IP2_T2  = 4'b0101,
    SCANLOAD_HIGH_1_IP2_T2 = 4'b0110,
    SCANLOAD_HIGH_2_IP2_T2 = 4'b0111,
    SHIFT_IN_0_IP2_T2      = 4'b1000,
    SHIFT_IN_IP2_T2        = 4'b1001,
    DONE_IP2_T2            = 4'b1010
  } state_t_sm_ip2_test2;
  // IP2 TEST3
  localparam                           dnn_reg_width     = 48;
  localparam logic [dnn_reg_width-1:0] dnn_reg_0_default = 48'h123456789ABC;   // default value for 48-bits storage dnn_reg_0
  localparam logic [dnn_reg_width-1:0] dnn_reg_1_default = 48'hDEF0FEDCBA98;   // default value for 48-bits storage dnn_reg_1
  typedef enum logic [3:0] {
    IDLE_IP2_T3            = 4'b0000,
    DELAY_TEST_IP2_T3      = 4'b0001,
    RESET_NOT_IP2_T3       = 4'b0010,
    TRIGOUT_HIGH_1_IP2_T3  = 4'b0011,
    TRIGOUT_HIGH_2_IP2_T3  = 4'b0100,
    DELAY_SCANLOAD_IP2_T3  = 4'b0101,
    SCANLOAD_HIGH_1_IP2_T3 = 4'b0110,
    SCANLOAD_HIGH_2_IP2_T3 = 4'b0111,
    DONE_IP2_T3            = 4'b1000
  } state_t_sm_ip2_test3;
  // IP2 TEST4
  typedef enum logic [3:0] {
    IDLE_IP2_T4            = 4'b0000,
    DELAY_TEST_IP2_T4      = 4'b0001,
    RESET_NOT_IP2_T4       = 4'b0010,
    TRIGOUT_HIGH_1_IP2_T4  = 4'b0011,
    TRIGOUT_HIGH_2_IP2_T4  = 4'b0100,
    DELAY_SCANLOAD_IP2_T4  = 4'b0101,
    SCANLOAD_HIGH_1_IP2_T4 = 4'b0110,
    SCANLOAD_HIGH_2_IP2_T4 = 4'b0111,
    SHIFT_IN_0_IP2_T4      = 4'b1000,
    SHIFT_IN_IP2_T4        = 4'b1001,
    DONE_IP2_T4            = 4'b1010
  } state_t_sm_ip2_test4;
  //
  // Define enumerated type scan_chain_mode: LOW==shift-register, HIGH==parallel-load-asic-internal-comparators; default=HIGH
  typedef enum logic {
    SHIFT_REG_IP2 = 1'b0,
    LOAD_COMP_IP2 = 1'b1
  } scan_chain_reg_mode_ip2;
  parameter SCAN_REG_MODE_SHIFT_IN  = SHIFT_REG_IP2;
  parameter SCAN_REG_MODE_LOAD_COMP = LOAD_COMP_IP2;
  //
  //---------------------------------------------------------------------------
endpackage

`endif
