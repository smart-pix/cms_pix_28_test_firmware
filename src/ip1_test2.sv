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
// 2024-07-08  Cristian Gingu         Created
// 2024-07-29  Cristian Gingu         Change tests length from 5188 config_clk cycles to 2*5188=10376 config_clk cycles
// 2024-07-30  Cristian Gingu         Add sm_test2_o_* assignments when reset=HIGH
// 2024-07-23  Cristian Gingu         Change tests length from 5188 config_clk cycles to 2*5188=10376 config_clk cycles
// 2024-08-02  Cristian Gingu         Update state machine for manage two clocks: sm_testx_i_fast_config_clk sm_testx_i_slow_config_clk
// 2024-08-02  Cristian Gingu         Add new information for state machine with new input port slow_configclk_period
// 2024-08-05  Cristian Gingu         Add new information for state machine with new input port fast_configclk_period
// 2024-08-07  Cristian Gingu         Add references to cms_pix28_package.sv
// ------------------------------------------------------------------------------------
`ifndef __ip1_test2__
`define __ip1_test2__

`timescale 1 ns/ 1 ps

module ip1_test2 (
    input  logic        clk,                               // FM clock 100MHz       mapped to S_AXI_ACLK
    input  logic        reset,
    input  logic        enable,                            // up to 15 FW can be connected
    // Control signals:
    input  logic [ 6:0] clk_counter_fc,
    input  logic [26:0] clk_counter_sc,
    input  logic [ 6:0] fast_configclk_period,
    input  logic [26:0] slow_configclk_period,
    input  logic [ 6:0] test_delay,
    input  logic        test_mask_reset_not,
    input  logic        test2_enable_re,
    input  logic        sm_testx_i_fast_config_clk,
    input  logic        sm_testx_i_slow_config_clk,
    input  logic        sm_testx_i_shift_reg_bit0,
    input  logic [13:0] sm_testx_i_shift_reg_shift_cnt,
    input  logic [13:0] sm_testx_i_shift_reg_shift_cnt_max_fc,  // FAST config clock related max counter == 5188-24 ==5164 bits
    input  logic [13:0] sm_testx_i_shift_reg_shift_cnt_max_sc,  // SLOW config clock related max counter == 24 bits
    output logic        sm_test2_o_shift_reg_load,
    output logic        sm_test2_o_shift_reg_shift,
    output logic        sm_test2_o_status_done,
    // output ports
    output cms_pix28_package::state_t_sm_ip1_test2 sm_test2_state,
    output logic        sm_test2_o_config_clk,
    output logic        sm_test2_o_reset_not,
    output logic        sm_test2_o_config_in,
    output logic        sm_test2_o_config_load,
    output logic        sm_test2_o_vin_test_trig_out,
    output logic        sm_test2_o_scan_in,
    output logic        sm_test2_o_scan_load
  );

  import cms_pix28_package::state_t_sm_ip1_test2;
  import cms_pix28_package::IDLE_IP1_T2;
  import cms_pix28_package::DELAY_TEST_IP1_T2;
  import cms_pix28_package::RESET_NOT_IP1_T2;
  import cms_pix28_package::SHIFT_IN_0_IP1_T2;
  import cms_pix28_package::SHIFT_IN_IP1_T2;
  import cms_pix28_package::WAIT_FAST_CLK_IP1_T2;
  import cms_pix28_package::WAIT_SLOW_CLK_IP1_T2;
  import cms_pix28_package::WAIT2_SLOW_CLK_IP1_T2;
  import cms_pix28_package::SHIFT_IN_SLOW_CLK_IP1_T2;
  import cms_pix28_package::DONE_IP1_T2;
  import cms_pix28_package::WAIT_DONE_SLOW_CLK_IP1_T2;
  import cms_pix28_package::WAIT_DONE_FAST_CLK_IP1_T2;
  //
  import cms_pix28_package::CONFIG_REG_MODE_SHIFT_IN;
  import cms_pix28_package::CONFIG_REG_MODE_PARALLEL_OUT;

  // ------------------------------------------------------------------------------------------------------------------
  // State Machine for "test2". Test SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister.
  state_t_sm_ip1_test2    sm_test2;
  assign sm_test2_state = sm_test2;
  //
  assign sm_test2_o_scan_in           = 1'b0;       // signal not used-in / driven-by sm_test2_proc
  assign sm_test2_o_scan_load         = 1'b0;       // signal not used-in / driven-by sm_test2_proc
  assign sm_test2_o_vin_test_trig_out = 1'b0;       // signal not used-in / driven-by sm_test2_proc
  always @(posedge clk) begin : sm_test2_proc
    if(~enable | reset) begin
      // next state machine state logic
      sm_test2 <= IDLE_IP1_T2;
      if(reset) begin
        // output state machine signal assignment
        sm_test2_o_reset_not                     <= 1'b1;                           // active LOW signal; default is inactive
        sm_test2_o_config_in                     <= 1'b0;                           // arbitrary chosen default LOW
        sm_test2_o_config_load                   <= CONFIG_REG_MODE_PARALLEL_OUT;   // shift_reg_mode: LOW==shift-register, HIGH==parallel-output-config-internal-comparators; default=HIGH
        sm_test2_o_shift_reg_load                <= 1'b0;                           //
        sm_test2_o_shift_reg_shift               <= 1'b0;                           // LOW==do-not-shift, HIGH==do-shift-right
        sm_test2_o_status_done                   <= 1'b0;                           // reset state machine STATUS flag
        sm_test2_o_config_clk                    <= sm_testx_i_fast_config_clk;     // default selection to sm_testx_i_fast_config_clk
      end
    end else begin
      case(sm_test2)
        IDLE_IP1_T2 : begin
          // next state machine state logic
          if(test2_enable_re) begin
            sm_test2 <= DELAY_TEST_IP1_T2;
          end else begin
            sm_test2 <= IDLE_IP1_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;                           // active LOW signal; default is inactive
          sm_test2_o_config_in                   <= 1'b0;                           // arbitrary chosen default LOW
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_PARALLEL_OUT;   // shift_reg_mode: LOW==shift-register, HIGH==parallel-output-config-internal-comparators; default=HIGH
          sm_test2_o_shift_reg_load              <= 1'b0;                           //
          sm_test2_o_shift_reg_shift             <= 1'b0;                           // LOW==do-not-shift, HIGH==do-shift-right
          sm_test2_o_status_done                 <= sm_test2_o_status_done;         // state machine STATUS flag
          sm_test2_o_config_clk                  <= sm_testx_i_fast_config_clk;
        end
        DELAY_TEST_IP1_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter_fc) begin
            sm_test2 <= RESET_NOT_IP1_T2;
          end else begin
            sm_test2 <= DELAY_TEST_IP1_T2;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter_fc) begin
            if(test_mask_reset_not==1'b1) begin
              sm_test2_o_reset_not               <= 1'b1;
            end else begin
              sm_test2_o_reset_not               <= 1'b0;
            end
            sm_test2_o_config_load               <= CONFIG_REG_MODE_SHIFT_IN;
          end else begin
            sm_test2_o_reset_not                 <= 1'b1;
            sm_test2_o_config_load               <= CONFIG_REG_MODE_PARALLEL_OUT;
          end
          sm_test2_o_config_in                   <= 1'b0;
          sm_test2_o_shift_reg_load              <= 1'b1;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          sm_test2_o_config_clk                  <= sm_testx_i_fast_config_clk;
        end
        RESET_NOT_IP1_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter_fc) begin
            sm_test2 <= SHIFT_IN_0_IP1_T2;
          end else begin
            sm_test2 <= RESET_NOT_IP1_T2;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter_fc) begin
            sm_test2_o_reset_not                 <= 1'b1;
            sm_test2_o_config_in                 <= sm_testx_i_shift_reg_bit0;
          end else begin
            if(test_mask_reset_not==1'b1) begin
              sm_test2_o_reset_not               <= 1'b1;
            end else begin
              sm_test2_o_reset_not               <= 1'b0;
            end
            sm_test2_o_config_in                 <= 1'b0;
          end
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_SHIFT_IN;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          sm_test2_o_config_clk                  <= sm_testx_i_fast_config_clk;
        end
        SHIFT_IN_0_IP1_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter_fc) begin
            sm_test2 <= SHIFT_IN_IP1_T2;
          end else begin
            sm_test2 <= SHIFT_IN_0_IP1_T2;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter_fc) begin
            // latency sm_test2_o_shift_reg_shift to sm_testx_i_shift_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test2_o_shift_reg_shift
            // * one clk latency due to process sm_testx_i_shift_reg_proc to execute the shift-right
            sm_test2_o_shift_reg_shift           <= 1'b1;
          end else begin
            sm_test2_o_shift_reg_shift           <= 1'b0;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= sm_testx_i_shift_reg_bit0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_SHIFT_IN;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          sm_test2_o_config_clk                  <= sm_testx_i_fast_config_clk;
        end
        SHIFT_IN_IP1_T2 : begin
          // next state machine state logic
          if(sm_testx_i_shift_reg_shift_cnt==sm_testx_i_shift_reg_shift_cnt_max_fc) begin
            // done shifting all 768 bits;
            sm_test2 <= WAIT_FAST_CLK_IP1_T2;
            sm_test2_o_config_load               <= CONFIG_REG_MODE_SHIFT_IN;
            sm_test2_o_status_done               <= 1'b0;
          end else begin
            // continue shifting
            sm_test2 <= SHIFT_IN_IP1_T2;
            sm_test2_o_config_load               <= CONFIG_REG_MODE_SHIFT_IN;
            sm_test2_o_status_done               <= 1'b0;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter_fc) begin
            // latency sm_test2_o_shift_reg_shift to sm_testx_i_shift_reg_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test2_o_shift_reg_shift
            // * one clk latency due to process sm_testx_i_shift_reg_reg_proc to execute the shift-right
            sm_test2_o_shift_reg_shift           <= 1'b1;
          end else begin
            sm_test2_o_shift_reg_shift           <= 1'b0;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= sm_testx_i_shift_reg_bit0;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_config_clk                  <= sm_testx_i_fast_config_clk;
        end
        WAIT_FAST_CLK_IP1_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter_fc) begin
            sm_test2 <= WAIT_SLOW_CLK_IP1_T2;
          end else begin
            sm_test2 <= WAIT_FAST_CLK_IP1_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= sm_testx_i_shift_reg_bit0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_SHIFT_IN;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          sm_test2_o_config_clk                  <= 1'b0;
        end
        WAIT_SLOW_CLK_IP1_T2 : begin
          // next state machine state logic
          if({1'b0, slow_configclk_period[26:1]}+1'b1==clk_counter_sc) begin
            sm_test2 <= SHIFT_IN_SLOW_CLK_IP1_T2;
          end else begin
            sm_test2 <= WAIT_SLOW_CLK_IP1_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= sm_testx_i_shift_reg_bit0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_SHIFT_IN;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          sm_test2_o_config_clk                  <= 1'b0;
        end
        SHIFT_IN_SLOW_CLK_IP1_T2 : begin
          // next state machine state logic
          if(sm_testx_i_shift_reg_shift_cnt==sm_testx_i_shift_reg_shift_cnt_max_fc + sm_testx_i_shift_reg_shift_cnt_max_sc) begin
            // done shifting all 2*5188 bits;
            sm_test2 <= DONE_IP1_T2;
            sm_test2_o_config_load               <= CONFIG_REG_MODE_PARALLEL_OUT;
            sm_test2_o_status_done               <= 1'b1;
          end else begin
            // continue shifting
            sm_test2 <= SHIFT_IN_SLOW_CLK_IP1_T2;
            sm_test2_o_config_load               <= CONFIG_REG_MODE_SHIFT_IN;
            sm_test2_o_status_done               <= 1'b0;
          end
          // output state machine signal assignment
          if({1'b0, slow_configclk_period[26:1]}==clk_counter_sc) begin
            // latency sm_test2_o_shift_reg_shift to sm_testx_i_shift_reg_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test2_o_shift_reg_shift
            // * one clk latency due to process sm_testx_i_shift_reg_reg_proc to execute the shift-right
            sm_test2_o_shift_reg_shift           <= 1'b1;
          end else begin
            sm_test2_o_shift_reg_shift           <= 1'b0;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= sm_testx_i_shift_reg_bit0;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_config_clk                  <= sm_testx_i_slow_config_clk;
        end
        DONE_IP1_T2 : begin
          // next state machine state logic
          sm_test2 <= WAIT_DONE_SLOW_CLK_IP1_T2;
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= 1'b0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_PARALLEL_OUT;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b1;
          sm_test2_o_config_clk                  <= 1'b0;
        end
        WAIT_DONE_SLOW_CLK_IP1_T2: begin
          // next state machine state logic
          if(slow_configclk_period==clk_counter_sc) begin
            // force/keep sm_test2_o_config_clk=LOW while sm_testx_i_slow_config_clk is LOW
            sm_test2 <= WAIT_DONE_FAST_CLK_IP1_T2;
          end else begin
            sm_test2 <= WAIT_DONE_SLOW_CLK_IP1_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= 1'b0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_PARALLEL_OUT;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b1;
          sm_test2_o_config_clk                  <= 1'b0;
        end
        WAIT_DONE_FAST_CLK_IP1_T2: begin
          // next state machine state logic
          if(fast_configclk_period==clk_counter_fc) begin
            // force/keep sm_test2_o_config_clk=LOW while sm_testx_i_fast_config_clk is LOW
            sm_test2 <= IDLE_IP1_T2;
          end else begin
            sm_test2 <= WAIT_DONE_FAST_CLK_IP1_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_config_in                   <= 1'b0;
          sm_test2_o_config_load                 <= CONFIG_REG_MODE_PARALLEL_OUT;
          sm_test2_o_shift_reg_load              <= 1'b0;
          sm_test2_o_shift_reg_shift             <= 1'b0;
          sm_test2_o_status_done                 <= 1'b1;
          sm_test2_o_config_clk                  <= 1'b0;
        end
        default : begin
          sm_test2 <= IDLE_IP1_T2;
        end
      endcase
    end
  end
  // ------------------------------------------------------------------------------------------------------------------

endmodule

`endif
