// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-07-03
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-07-03  Cristian  Gingu        Created
// 2024-12-13  Cristian  Gingu        Add output logic test5_enable,  output logic test5_enable_re
// ------------------------------------------------------------------------------------
`ifndef __com_testx_decoder__
`define __com_testx_decoder__

`timescale 1 ns/ 1 ps

module com_testx_decoder (
    input  logic        clk,                               // mapped to appropriate clock: S_AXI_ACLK or pl_clk1
    input  logic        op_code_w_reset,
    input  logic        op_code_w_execute,
    input  logic [3:0]  test_number,
    output logic test1_enable,  output logic test1_enable_re,
    output logic test2_enable,  output logic test2_enable_re,
    output logic test3_enable,  output logic test3_enable_re,
    output logic test4_enable,  output logic test4_enable_re,
    output logic test5_enable,  output logic test5_enable_re
  );

  import cms_pix28_package::test_number_1;
  import cms_pix28_package::test_number_2;
  import cms_pix28_package::test_number_3;
  import cms_pix28_package::test_number_4;
  import cms_pix28_package::test_number_5;

  logic test1_enable_ff; logic test1_enable_ff_del;
  logic test2_enable_ff; logic test2_enable_ff_del;
  logic test3_enable_ff; logic test3_enable_ff_del;
  logic test4_enable_ff; logic test4_enable_ff_del;
  logic test5_enable_ff; logic test5_enable_ff_del;

  always @(posedge clk) begin
    if(op_code_w_reset) begin
      test1_enable_ff  <= 1'b0;
      test2_enable_ff  <= 1'b0;
      test3_enable_ff  <= 1'b0;
      test4_enable_ff  <= 1'b0;
      test5_enable_ff  <= 1'b0;
    end else begin
      if(op_code_w_execute==1'b1 && test_number==test_number_1) begin
        test1_enable_ff <= 1'b1;
      end else begin
        test1_enable_ff <= 1'b0;
      end
      //
      if(op_code_w_execute==1'b1 && test_number==test_number_2) begin
        test2_enable_ff <= 1'b1;
      end else begin
        test2_enable_ff <= 1'b0;
      end
      //
      if(op_code_w_execute==1'b1 && test_number==test_number_3) begin
        test3_enable_ff <= 1'b1;
      end else begin
        test3_enable_ff <= 1'b0;
      end
      //
      if(op_code_w_execute==1'b1 && test_number==test_number_4) begin
        test4_enable_ff <= 1'b1;
      end else begin
        test4_enable_ff <= 1'b0;
      end
      //
      if(op_code_w_execute==1'b1 && test_number==test_number_5) begin
        test5_enable_ff <= 1'b1;
      end else begin
        test5_enable_ff <= 1'b0;
      end
    end
  end
  assign test1_enable = test1_enable_ff;
  assign test2_enable = test2_enable_ff;
  assign test3_enable = test3_enable_ff;
  assign test4_enable = test4_enable_ff;
  assign test5_enable = test5_enable_ff;

  always @(posedge clk) begin
    test1_enable_ff_del <= test1_enable_ff;
    test2_enable_ff_del <= test2_enable_ff;
    test3_enable_ff_del <= test3_enable_ff;
    test4_enable_ff_del <= test4_enable_ff;
    test5_enable_ff_del <= test5_enable_ff;
  end
  assign test1_enable_re = test1_enable_ff & ~test1_enable_ff_del;
  assign test2_enable_re = test2_enable_ff & ~test2_enable_ff_del;
  assign test3_enable_re = test3_enable_ff & ~test3_enable_ff_del;
  assign test4_enable_re = test4_enable_ff & ~test4_enable_ff_del;
  assign test5_enable_re = test5_enable_ff & ~test5_enable_ff_del;


endmodule

`endif
