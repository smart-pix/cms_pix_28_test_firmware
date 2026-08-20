// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-11-07
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// https://adaptivesupport.amd.com/s/article/1033206?language=en_US
// https://adaptivesupport.amd.com/s/article/1033251?language=en_US
// https://adaptivesupport.amd.com/s/article/73688?language=en_US
// https://adaptivesupport.amd.com/s/article/63684?language=en_US
// 2024-11-07  Cristian Gingu         Add IOB FF IDDR
// ------------------------------------------------------------------------------------
`ifndef __iob_iddr__
`define __iob_iddr__

`timescale 1 ns/ 1 ps

module iob_iddr (
    input  wire pl_clk1,
    //
    input  wire config_out_i,
    input  wire scan_out_i,
    input  wire scan_out_test_i,
    input  wire dnn_output_0_i,
    input  wire dnn_output_1_i,
    //
    output wire config_out_o,
    output wire scan_out_o,
    output wire scan_out_test_o,
    output wire dnn_output_0_o,
    output wire dnn_output_1_o
  );

  // Instantiate IDDR (not available in IP Catalog) https://docs.amd.com/r/2021.2-English/ug953-vivado-7series-libraries/IDDR

  IDDR #(
    .DDR_CLK_EDGE  ("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1       (1'b0),             // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2       (1'b0),             // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) IDDR_config_out (
    .Q1            (config_out_o),     // 1-bit output for positive edge of clock
    .Q2            (),                 // 1-bit output for negative edge of clock
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D             (config_out_i),     // 1-bit DDR data input
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  IDDR #(
    .DDR_CLK_EDGE  ("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1       (1'b0),             // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2       (1'b0),             // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) IDDR_scan_out (
    .Q1            (scan_out_o),       // 1-bit output for positive edge of clock
    .Q2            (),                 // 1-bit output for negative edge of clock
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D             (scan_out_i),       // 1-bit DDR data input
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  IDDR #(
    .DDR_CLK_EDGE  ("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1       (1'b0),             // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2       (1'b0),             // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) IDDR_scan_out_test (
    .Q1            (scan_out_test_o),  // 1-bit output for positive edge of clock
    .Q2            (),                 // 1-bit output for negative edge of clock
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D             (scan_out_test_i),  // 1-bit DDR data input
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  IDDR #(
    .DDR_CLK_EDGE  ("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1       (1'b0),             // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2       (1'b0),             // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) IDDR_dnn_output_0 (
    .Q1            (dnn_output_0_o),   // 1-bit output for positive edge of clock
    .Q2            (),                 // 1-bit output for negative edge of clock
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D             (dnn_output_0_i),   // 1-bit DDR data input
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  IDDR #(
    .DDR_CLK_EDGE  ("OPPOSITE_EDGE"),  // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    .INIT_Q1       (1'b0),             // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2       (1'b0),             // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) IDDR_dnn_output_1 (
    .Q1            (dnn_output_1_o),   // 1-bit output for positive edge of clock
    .Q2            (),                 // 1-bit output for negative edge of clock
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D             (dnn_output_1_i),   // 1-bit DDR data input
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

endmodule

`endif
