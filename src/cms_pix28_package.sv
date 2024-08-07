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
// ------------------------------------------------------------------------------------

`ifndef __cms_pix28_package__
`define __cms_pix28_package__

package cms_pix28_package;
  //
  parameter status_index_op_code_w_reset               = 0;
  parameter status_index_op_code_w_cfg_static_0        = 1;
  parameter status_index_op_code_r_cfg_static_0        = 2;
  parameter status_index_op_code_w_cfg_static_1        = 3;
  parameter status_index_op_code_r_cfg_static_1        = 4;
  parameter status_index_op_code_w_cfg_array_0         = 5;
  parameter status_index_op_code_r_cfg_array_0         = 6;
  parameter status_index_op_code_w_cfg_array_1         = 7;
  parameter status_index_op_code_r_cfg_array_1         = 8;
  parameter status_index_op_code_w_cfg_array_2         = 9;
  parameter status_index_op_code_r_cfg_array_2         = 10;
  parameter status_index_op_code_r_data_array_0        = 11;
  parameter status_index_op_code_r_data_array_1        = 12;
  parameter status_index_op_code_w_execute             = 13;
  parameter status_index_test1_done                    = 14;
  parameter status_index_test2_done                    = 15;
  parameter status_index_test3_done                    = 16;
  parameter status_index_test4_done                    = 17;
  parameter status_index_spare_min                     = 18;
  parameter status_index_spare_max                     = 30;
  parameter status_index_error_w_execute_cfg           = 31;
  //
  //---------------------------------------------------------------------------
  // fw_ip1.sv
  //---------------------------------------------------------------------------
  parameter cfg_reg_bits_total = 5188;
  parameter cfg_reg_bits_test  = 24;
  //
  parameter w_cfg_static_0_reg_fast_configclk_period_index_min       =  0;     // fast_configCLK period is 10ns(AXI100MHz) * 2**7(7-bits) == 10*128 == 1280ns i.e. 0.78125MHz the lowest frequency, thus covering DataSheet minimum 1MHz
  parameter w_cfg_static_0_reg_fast_configclk_period_index_max       =  6;     //
  parameter w_cfg_static_0_reg_super_pix_sel_index                   =  7;     //
  parameter w_cfg_static_0_reg_slow_configclk_period_index_min       =  8;     // slow_configCLK period is 10ns(AXI100MHz) * 2**27(27-bits) == 10*134217728 == 1342177280ns i.e. 0.745Hz the lowest frequency, thus covering DataSheet minimum 1Hz
  parameter w_cfg_static_0_reg_slow_configclk_period_index_max       =  23;    // w_cfg_static_0_reg contains lower 16-bits of the 27-bit period for slow_configCLK
  parameter w_cfg_static_1_reg_slow_configclk_period_index_min       =  0;     // w_cfg_static_1_reg contains upper 11-bits of the 27-bit period for slow_configCLK
  parameter w_cfg_static_1_reg_slow_configclk_period_index_max       = 10;
  parameter w_cfg_static_1_reg_spare_index_min                       = 11;
  parameter w_cfg_static_1_reg_spare_index_max                       = 23;
  //
  parameter w_execute_cfg_test_delay_index_min                       =  0;     //
  parameter w_execute_cfg_test_delay_index_max                       =  6;     //
  parameter w_execute_cfg_test_sample_index_min                      =  7;     //
  parameter w_execute_cfg_test_sample_index_max                      = 13;     //
  parameter w_execute_cfg_test_number_index_min                      = 14;     //
  parameter w_execute_cfg_test_number_index_max                      = 17;     //
  parameter w_execute_cfg_test_loopback                              = 18;     //
  parameter w_execute_cfg_test_spare_index_min                       = 19;     //
  parameter w_execute_cfg_test_spare_index_max                       = 22;     //
  parameter w_execute_cfg_test_mask_reset_not_index                  = 23;     //
  //
  typedef enum logic [2:0] {
    IDLE_IP1_T1        = 3'b000,
    DELAY_TEST_IP1_T1  = 3'b001,
    RESET_NOT_IP1_T1   = 3'b010,
    SHIFT_IN_0_IP1_T1  = 3'b011,
    SHIFT_IN_IP1_T1    = 3'b100,
    DONE_IP1_T1        = 3'b101
  } state_t_sm_ip1_test1;
  //
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
  parameter scan_reg_bits_total = 768;
  //
  typedef enum logic [2:0] {
    IDLE_IP2_T1        = 3'b000,
    DELAY_TEST_IP2_T1  = 3'b001,
    RESET_NOT_IP2_T1   = 3'b010,
    SHIFT_IN_0_IP2_T1  = 3'b011,
    SHIFT_IN_IP2_T1    = 3'b100,
    DONE_IP2_T1        = 3'b101
  } state_t_sm_ip2_test1;
  //
  typedef enum logic [2:0] {
    IDLE_IP2_T2            = 3'b000,
    DELAY_TEST_IP2_T2      = 3'b001,
    RESET_NOT_IP2_T2       = 3'b010,
    SCANLOAD_HIGH_1_IP2_T2 = 3'b011,
    SCANLOAD_HIGH_2_IP2_T2 = 3'b100,
    SHIFT_IN_0_IP2_T2      = 3'b101,
    SHIFT_IN_IP2_T2        = 3'b110,
    DONE_IP2_T2            = 3'b111
  } state_t_sm_ip2_test2;
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
