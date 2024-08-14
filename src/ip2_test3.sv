// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-08-14
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-08-14  Cristian  Gingu        Created
// ------------------------------------------------------------------------------------
`ifndef __ip2_test3__
`define __ip2_test3__

`timescale 1 ns/ 1 ps

module ip2_test3 (
    input  logic       clk,                                // FM clock 400MHz       mapped to pl_clk1
    input  logic       reset,
    input  logic       enable,                             // up to 15 FW can be connected
    // Control signals:
    input  logic [5:0] clk_counter,
    input  logic [5:0] test_delay,
    input  logic [5:0] test_trig_out_phase,
    input  logic       test_mask_reset_not,
    input  logic       test2_enable_re,
    input  logic       sm_testx_i_scanchain_reg_bit0,
    input  logic [10:0]sm_testx_i_scanchain_reg_shift_cnt,
    input  logic [10:0]sm_testx_i_scanchain_reg_shift_cnt_max,
    output logic       sm_test3_o_scanchain_reg_load,
    output logic       sm_test3_o_scanchain_reg_shift,
    output logic       sm_test3_o_status_done,
    // output ports
    output cms_pix28_package::state_t_sm_ip2_test3 sm_test3_state,
    output logic       sm_test3_o_config_clk,
    output logic       sm_test3_o_reset_not,
    output logic       sm_test3_o_config_in,
    output logic       sm_test3_o_config_load,
    output logic       sm_test3_o_vin_test_trig_out,
    output logic       sm_test3_o_scan_in,
    output logic       sm_test3_o_scan_load
  );

  import cms_pix28_package::state_t_sm_ip2_test3;
  import cms_pix28_package::IDLE_IP2_T3;
  import cms_pix28_package::DELAY_TEST_IP2_T3;
  import cms_pix28_package::RESET_NOT_IP2_T3;
  import cms_pix28_package::SCANLOAD_HIGH_1_IP2_T3;
  import cms_pix28_package::SCANLOAD_HIGH_2_IP2_T3;
  import cms_pix28_package::SHIFT_IN_0_IP2_T3;
  import cms_pix28_package::SHIFT_IN_IP2_T3;
  import cms_pix28_package::DONE_IP2_T3;
  //
  import cms_pix28_package::SCAN_REG_MODE_SHIFT_IN;
  import cms_pix28_package::SCAN_REG_MODE_LOAD_COMP;

  // ------------------------------------------------------------------------------------------------------------------
  // State Machine for "test1". Test SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister.
  state_t_sm_ip2_test3    sm_test3;
  assign sm_test3_state = sm_test3;
  //
  assign sm_test3_o_config_clk        = 1'b0;       // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_config_in         = 1'b0;       // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_config_load       = 1'b1;       // signal not used-in / diven-by sm_test3_proc
  always @(posedge clk) begin : vin_test_trig_out_proc
    if(~enable | reset) begin
      sm_test3_o_vin_test_trig_out     <= 1'b0;
    end else begin
      if(sm_test3==SCANLOAD_HIGH_1_IP2_T3 && clk_counter==test_trig_out_phase) begin
        sm_test3_o_vin_test_trig_out   <= 1'b1;
      end else if(sm_test3==SCANLOAD_HIGH_2_IP2_T3 && clk_counter==test_trig_out_phase) begin
        sm_test3_o_vin_test_trig_out   <= 1'b0;
      end
    end
  end
  always @(posedge clk) begin : sm_test3_proc
    if(~enable | reset) begin
      sm_test3 <= IDLE_IP2_T3;
    end else begin
      case(sm_test3)
        IDLE_IP2_T3 : begin
          // next state machine state logic
          if(test2_enable_re) begin
            sm_test3 <= DELAY_TEST_IP2_T3;
          end else begin
            sm_test3 <= IDLE_IP2_T3;
          end
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;                      // active  LOW signal; default is inactive
          sm_test3_o_scan_in                     <= 1'b0;                      // arbitrary chosen default LOW
          sm_test3_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;   // scan-chain-mode: LOW==shift-register, HIGH==parallel-load-asic-internal-comparators; default=HIGH
          sm_test3_o_scanchain_reg_load          <= 1'b0;                      //
          sm_test3_o_scanchain_reg_shift         <= 1'b0;                      // LOW==do-not-shift, HIGH==do-shift-right
          sm_test3_o_status_done                 <= sm_test3_o_status_done;    // state machine STATUS flag
        end
        DELAY_TEST_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= RESET_NOT_IP2_T3;
          end else begin
            sm_test3 <= DELAY_TEST_IP2_T3;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter) begin
            if(test_mask_reset_not==1'b1) begin
              sm_test3_o_reset_not               <= 1'b1;
            end else begin
              sm_test3_o_reset_not               <= 1'b0;
            end
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end else begin
            sm_test3_o_reset_not                 <= 1'b1;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end
          sm_test3_o_scan_in                     <= 1'b0;
          sm_test3_o_scanchain_reg_load          <= 1'b1;
          sm_test3_o_scanchain_reg_shift         <= 1'b0;
          sm_test3_o_status_done                 <= 1'b0;
        end
        RESET_NOT_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= SCANLOAD_HIGH_1_IP2_T3;
          end else begin
            sm_test3 <= RESET_NOT_IP2_T3;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter) begin
            sm_test3_o_reset_not                 <= 1'b1;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end else begin
            if(test_mask_reset_not==1'b1) begin
              sm_test3_o_reset_not               <= 1'b1;
            end else begin
              sm_test3_o_reset_not               <= 1'b0;
            end
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end
          sm_test3_o_scan_in                     <= 1'b0;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
          sm_test3_o_scanchain_reg_shift         <= 1'b0;
          sm_test3_o_status_done                 <= 1'b0;
        end
        //
        SCANLOAD_HIGH_1_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= SCANLOAD_HIGH_2_IP2_T3;
          end else begin
            sm_test3 <= SCANLOAD_HIGH_1_IP2_T3;
          end
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;
          sm_test3_o_scan_in                     <= 1'b0;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
          sm_test3_o_scanchain_reg_shift         <= 1'b0;
          sm_test3_o_status_done                 <= 1'b0;
        end
        SCANLOAD_HIGH_2_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= SHIFT_IN_0_IP2_T3;
          end else begin
            sm_test3 <= SCANLOAD_HIGH_2_IP2_T3;
          end
          if(test_delay==clk_counter) begin
            sm_test3_o_scan_in                   <= sm_testx_i_scanchain_reg_bit0;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end else begin
            sm_test3_o_scan_in                   <= 1'b0;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
          sm_test3_o_scanchain_reg_shift         <= 1'b0;
          sm_test3_o_status_done                 <= 1'b0;
        end
        //
        SHIFT_IN_0_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= SHIFT_IN_IP2_T3;
          end else begin
            sm_test3 <= SHIFT_IN_0_IP2_T3;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter) begin
            // latency sm_test3_o_scanchain_reg_shift to sm_testx_i_scanchain_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test3_o_scanchain_reg_shift
            // * one clk latency due to process sm_testx_i_scanchain_reg_proc to execute the shift-right
            sm_test3_o_scanchain_reg_shift       <= 1'b1;
          end else begin
            sm_test3_o_scanchain_reg_shift       <= 1'b0;
          end
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_scan_in                     <= sm_testx_i_scanchain_reg_bit0;
          sm_test3_o_scan_load                   <= SCAN_REG_MODE_SHIFT_IN;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
          sm_test3_o_status_done                 <= 1'b0;
        end
        SHIFT_IN_IP2_T3 : begin
          // next state machine state logic
          if(sm_testx_i_scanchain_reg_shift_cnt==sm_testx_i_scanchain_reg_shift_cnt_max) begin
            // done shifting all 768 bits;
            sm_test3 <= DONE_IP2_T3;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
            sm_test3_o_status_done               <= 1'b1;
          end else begin
            // continue shifting
            sm_test3 <= SHIFT_IN_IP2_T3;
            sm_test3_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
            sm_test3_o_status_done               <= 1'b0;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter) begin
            // latency sm_test3_o_scanchain_reg_shift to sm_testx_i_scanchain_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test3_o_scanchain_reg_shift
            // * one clk latency due to process sm_testx_i_scanchain_reg_proc to execute the shift-right
            sm_test3_o_scanchain_reg_shift       <= 1'b1;
          end else begin
            sm_test3_o_scanchain_reg_shift       <= 1'b0;
          end
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_scan_in                     <= sm_testx_i_scanchain_reg_bit0;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
        end
        DONE_IP2_T3 : begin
          // next state machine state logic
          sm_test3 <= IDLE_IP2_T3;
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_scan_in                     <= 1'b0;
          sm_test3_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;
          sm_test3_o_scanchain_reg_load          <= 1'b0;
          sm_test3_o_scanchain_reg_shift         <= 1'b0;
          sm_test3_o_status_done                 <= 1'b1;
        end
        default : begin
          sm_test3 <= IDLE_IP2_T3;
        end
      endcase
    end
  end
  // ------------------------------------------------------------------------------------------------------------------

endmodule

`endif
