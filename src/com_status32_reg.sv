// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-08-08
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-08-08  Cristian  Gingu        Created
// ------------------------------------------------------------------------------------
`ifndef __com_status32_reg__
`define __com_status32_reg__

`timescale 1 ns/ 1 ps

module com_status32_reg (
    input  logic        fw_axi_clk,                        // FW clock 100MHz       mapped to S_AXI_ACLK
    input  logic        fw_rst_n,                          // FW reset, active low  mapped to S_AXI_ARESETN
    //
    input  logic        op_code_w_status_clear,
    input  logic        op_code_w_reset,
    input  logic        op_code_w_cfg_static_0,
    input  logic        op_code_r_cfg_static_0,
    input  logic        op_code_w_cfg_static_1,
    input  logic        op_code_r_cfg_static_1,
    input  logic        op_code_w_cfg_array_0,
    input  logic        op_code_r_cfg_array_0,
    input  logic        op_code_w_cfg_array_1,
    input  logic        op_code_r_cfg_array_1,
    input  logic        op_code_w_cfg_array_2,
    input  logic        op_code_r_cfg_array_2,
    input  logic        op_code_r_data_array_0,
    input  logic        op_code_r_data_array_1,
    input  logic        op_code_w_execute,
    input  logic        sm_test1_o_status_done,
    input  logic        sm_test2_o_status_done,
    input  logic        sm_test3_o_status_done,
    input  logic        sm_test4_o_status_done,
    input  logic        error_w_execute_cfg,
    //
    output logic [31:0] fw_read_status32_reg
  );

  import cms_pix28_package::status_index_op_code_w_reset;
  import cms_pix28_package::status_index_op_code_w_cfg_static_0;
  import cms_pix28_package::status_index_op_code_r_cfg_static_0;
  import cms_pix28_package::status_index_op_code_w_cfg_static_1;
  import cms_pix28_package::status_index_op_code_r_cfg_static_1;
  import cms_pix28_package::status_index_op_code_w_cfg_array_0;
  import cms_pix28_package::status_index_op_code_r_cfg_array_0;
  import cms_pix28_package::status_index_op_code_w_cfg_array_1;
  import cms_pix28_package::status_index_op_code_r_cfg_array_1;
  import cms_pix28_package::status_index_op_code_w_cfg_array_2;
  import cms_pix28_package::status_index_op_code_r_cfg_array_2;
  import cms_pix28_package::status_index_op_code_r_data_array_0;
  import cms_pix28_package::status_index_op_code_r_data_array_1;
  import cms_pix28_package::status_index_op_code_w_execute;
  import cms_pix28_package::status_index_test1_done;
  import cms_pix28_package::status_index_test2_done;
  import cms_pix28_package::status_index_test3_done;
  import cms_pix28_package::status_index_test4_done;
  import cms_pix28_package::status_index_spare_min;
  import cms_pix28_package::status_index_spare_max;
  import cms_pix28_package::status_index_error_w_execute_cfg;
  //
  always @(posedge fw_axi_clk) begin : fw_read_status32_reg_proc
    if(op_code_w_status_clear | ~fw_rst_n) begin
      fw_read_status32_reg <= 32'b0;                       // incoming data on clock domain fw_axi_clk
    end else begin
      if(op_code_w_reset)        fw_read_status32_reg[status_index_op_code_w_reset       ] <= 1'b1;
      if(op_code_w_cfg_static_0) fw_read_status32_reg[status_index_op_code_w_cfg_static_0] <= 1'b1;
      if(op_code_r_cfg_static_0) fw_read_status32_reg[status_index_op_code_r_cfg_static_0] <= 1'b1;
      if(op_code_w_cfg_static_1) fw_read_status32_reg[status_index_op_code_w_cfg_static_1] <= 1'b1;
      if(op_code_r_cfg_static_1) fw_read_status32_reg[status_index_op_code_r_cfg_static_1] <= 1'b1;
      if(op_code_w_cfg_array_0)  fw_read_status32_reg[status_index_op_code_w_cfg_array_0 ] <= 1'b1;
      if(op_code_r_cfg_array_0)  fw_read_status32_reg[status_index_op_code_r_cfg_array_0 ] <= 1'b1;
      if(op_code_w_cfg_array_1)  fw_read_status32_reg[status_index_op_code_w_cfg_array_1 ] <= 1'b1;
      if(op_code_r_cfg_array_1)  fw_read_status32_reg[status_index_op_code_r_cfg_array_1 ] <= 1'b1;
      if(op_code_w_cfg_array_2)  fw_read_status32_reg[status_index_op_code_w_cfg_array_2 ] <= 1'b1;
      if(op_code_r_cfg_array_2)  fw_read_status32_reg[status_index_op_code_r_cfg_array_2 ] <= 1'b1;
      if(op_code_r_data_array_0) fw_read_status32_reg[status_index_op_code_r_data_array_0] <= 1'b1;
      if(op_code_r_data_array_1) fw_read_status32_reg[status_index_op_code_r_data_array_1] <= 1'b1;
      if(op_code_w_execute)      fw_read_status32_reg[status_index_op_code_w_execute     ] <= 1'b1;
      fw_read_status32_reg[                           status_index_test1_done            ] <= sm_test1_o_status_done;
      fw_read_status32_reg[                           status_index_test2_done            ] <= sm_test2_o_status_done;
      fw_read_status32_reg[                           status_index_test3_done            ] <= sm_test3_o_status_done;
      fw_read_status32_reg[                           status_index_test4_done            ] <= sm_test4_o_status_done;
      fw_read_status32_reg[               status_index_spare_max : status_index_spare_min] <= 13'b0;
      fw_read_status32_reg[                              status_index_error_w_execute_cfg] <= error_w_execute_cfg;
    end
  end

endmodule

`endif
