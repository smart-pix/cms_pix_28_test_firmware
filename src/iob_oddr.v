// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-11-08
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
// 2024-11-08  Cristian Gingu         Add IOB FF ODDR
// https://docs.amd.com/r/2021.2-English/ug953-vivado-7series-libraries/ODDR
// https://users.ece.utexas.edu/~mcdermot/arch/articles/Zynq/ug571-ultrascale-selectio.pdf page 160
// ------------------------------------------------------------------------------------
`ifndef __iob_oddr__
`define __iob_oddr__

`timescale 1 ns/ 1 ps

module iob_oddr (
    input  wire pl_clk1,
    //
    input  wire super_pixel_sel_i,
    input  wire config_clk_i,
    input  wire dut_rst_port_i,
    input  wire config_in_i,
    input  wire config_load_i,
    input  wire bxclk_ana_i,
    input  wire bxclk_i,
    input  wire vin_test_trig_out_i,
    input  wire scan_in_i,
    input  wire scan_load_i,
    //
    output wire super_pixel_sel_o,
    output wire config_clk_o,
    output wire dut_rst_port_o,
    output wire config_in_o,
    output wire config_load_o,
    output wire bxclk_ana_o,
    output wire bxclk_o,
    output wire vin_test_trig_out_o,
    output wire scan_in_o,
    output wire scan_load_o
  );

  // Instantiate ODDR (not available in IP Catalog) https://docs.amd.com/r/2021.2-English/ug953-vivado-7series-libraries/ODDR

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_super_pixel_sel (
    .Q             (super_pixel_sel_o),// 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (super_pixel_sel_i),// 1-bit data input (positive edge)
    .D2            (super_pixel_sel_i),// 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_config_clk (
    .Q             (config_clk_o),     // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (config_clk_i),     // 1-bit data input (positive edge)
    .D2            (config_clk_i),     // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_dut_rst_port (
    .Q             (dut_rst_port_o),   // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (dut_rst_port_i),   // 1-bit data input (positive edge)
    .D2            (dut_rst_port_i),   // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_config_in (
    .Q             (config_in_o),      // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (config_in_i),      // 1-bit data input (positive edge)
    .D2            (config_in_i),      // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_config_load (
    .Q             (config_load_o),    // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (config_load_i),    // 1-bit data input (positive edge)
    .D2            (config_load_i),    // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_bxclk_ana (
    .Q             (bxclk_ana_o),      // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (bxclk_ana_i),      // 1-bit data input (positive edge)
    .D2            (bxclk_ana_i),      // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_bxclk (
    .Q             (bxclk_o),          // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (bxclk_i),          // 1-bit data input (positive edge)
    .D2            (bxclk_i),          // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_vin_test_trig_out (
    .Q             (vin_test_trig_out_o),// 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (vin_test_trig_out_i),// 1-bit data input (positive edge)
    .D2            (vin_test_trig_out_i),// 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_scan_in (
    .Q             (scan_in_o),        // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (scan_in_i),        // 1-bit data input (positive edge)
    .D2            (scan_in_i),        // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

  ODDR #(
    .DDR_CLK_EDGE  ("SAME_EDGE"),      // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT          (1'b0),             // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE        ("ASYNC")           // Set/Reset type: "SYNC" or "ASYNC"
  ) ODDR_scan_load (
    .Q             (scan_load_o),      // 1-bit DDR output
    .C             (pl_clk1),          // 1-bit clock input
    .CE            (1'b1),             // 1-bit clock enable input
    .D1            (scan_load_i),      // 1-bit data input (positive edge)
    .D2            (scan_load_i),      // 1-bit data input (negative edge)
    .R             (1'b0),             // 1-bit reset
    .S             (1'b0)              // 1-bit set
  );

endmodule

`endif
