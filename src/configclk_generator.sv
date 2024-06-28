// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-06-27
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-06-27  Cristian  Gingu        Created
// ------------------------------------------------------------------------------------
`ifndef __configclk_generator__
`define __configclk_generator__

`timescale 1 ns/ 1 ps

module configclk_generator #(
    parameter integer CNT_WIDTH = 8
  ) (
    input  logic                 clk,
    input  logic                 reset,
    input  logic                 enable,
    // Input signals: controls
    input  logic [CNT_WIDTH-1:0] configclk_period,
    // output ports
    output logic [CNT_WIDTH-1:0] clk_counter,
    output logic                 configclk
  );

  // Create helper counter clk_counter_ff used to create signals configclk_ff
  logic [CNT_WIDTH-1:0] clk_counter_ff;
  always @(posedge clk) begin : clk_counter_ff_proc
    if(reset) begin
      clk_counter_ff <= 'd0;
    end else begin
      if(enable) begin
        // this module is active
        if (clk_counter_ff == configclk_period) begin
          // reached maximum => rollover counter to ONE
          clk_counter_ff <= 'd1;
        end else begin
          clk_counter_ff <= clk_counter_ff + 1;
        end
      end else begin
        // this module is NOT active
        clk_counter_ff <= 'd0;
      end
    end
  end
  assign clk_counter = clk_counter_ff;

  // Create and Assign output port signal configclk
  logic configclk_ff;
  always @(posedge clk) begin : configclk_ff_proc
    if(clk_counter_ff == 'd0) begin
      // keep configclk_ana LOW while in RESET
      configclk_ff <= 1'b0;
    end else begin
      if(enable) begin
        // this module is active
        if(clk_counter_ff <= (configclk_period>>1))  begin
          // keep configclk_ff HIGH for first half of configclk_period
          configclk_ff <= 1'b1;
        end else begin
          // keep configclk_ff LOW for second half of configclk_period
          configclk_ff <= 1'b0;
        end
      end else begin
        // this module is NOT active
        configclk_ff <= 1'b0;
      end
    end
  end
  assign configclk = configclk_ff;
endmodule

`endif
