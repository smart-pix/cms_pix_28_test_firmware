// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-08-12
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-08-12  Cristian  Gingu        Created
// ------------------------------------------------------------------------------------

`ifndef __cms_pix28_package_vrf__
`define __cms_pix28_package_vrf__

package cms_pix28_package_vrf;
  //
  localparam tb_err_index_fast_configclk_period_IP1        =  0;
  localparam tb_err_index_slow_configclk_period_IP1        =  1;
  localparam tb_err_index_bxclk_ana_period_IP2             =  2;
  localparam tb_err_index_bxclk_period_IP2                 =  3;
  localparam tb_err_index_bxclk_phase_IP2                  =  4;
  //
  localparam tb_err_index_op_code_r_cfg_static_0           =  8;
  localparam tb_err_index_op_code_r_cfg_static_1           =  9;
  localparam tb_err_index_op_code_r_cfg_array_0            = 10;
  localparam tb_err_index_op_code_r_cfg_array_1            = 11;
  localparam tb_err_index_op_code_r_cfg_array_2            = 12;
  localparam tb_err_index_op_code_r_data_array_0           = 13;
  localparam tb_err_index_op_code_r_data_array_1           = 14;
  //
  localparam tb_err_index_test1                            = 16;
  localparam tb_err_index_test2                            = 17;
  localparam tb_err_index_test3                            = 18;
  localparam tb_err_index_test4                            = 19;
  //
endpackage

`endif
