// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-06-17
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-06-18  Cristian  Gingu        Created template
// 2024-07-xx  Cristian Gingu         Write RTL code; implement ip2_test2 ip2_test2_inst
// 2024-07-09  Cristian Gingu         Clean header file Description and Author
// 2024-07-11  Cristian Gingu         Change tests length from 768 bxclk cycles to 2*768=1536 bxclk cycles
// 2024-08-08  Cristian Gingu         Add references to cms_pix28_package.sv
// 2024-09-17  Cristian Gingu         Change scan_load to delayed version; use in ip2_test2; add 6-bit w_cfg_static_0 scan_load_delay
// ------------------------------------------------------------------------------------
`ifndef __ip2_test2__
`define __ip2_test2__

`timescale 1 ns/ 1 ps

module ip2_test2 (
    input  logic       clk,                                // FM clock 400MHz       mapped to pl_clk1
    input  logic       reset,
    input  logic       enable,                             // up to 15 FW can be connected
    // Control signals:
    input  logic [5:0] clk_counter,
    input  logic [5:0] scan_load_delay,
    input  logic [5:0] test_delay,
    input  logic [5:0] test_trig_out_phase,
    input  logic       test_mask_reset_not,
    input  logic       test2_enable_re,
    input  logic       sm_testx_i_scanchain_reg_bit0,
    input  logic [10:0]sm_testx_i_scanchain_reg_shift_cnt,
    input  logic [10:0]sm_testx_i_scanchain_reg_shift_cnt_max,
    output logic       sm_test2_o_scanchain_reg_load,
    output logic       sm_test2_o_scanchain_reg_shift,
    output logic       sm_test2_o_status_done,
    // output ports
    output cms_pix28_package::state_t_sm_ip2_test2 sm_test2_state,
    output logic       sm_test2_o_config_clk,
    output logic       sm_test2_o_reset_not,
    output logic       sm_test2_o_config_in,
    output logic       sm_test2_o_config_load,
    output logic       sm_test2_o_vin_test_trig_out,
    output logic       sm_test2_o_scan_in,
    output logic       sm_test2_o_scan_load
  );

  import cms_pix28_package::state_t_sm_ip2_test2;
  import cms_pix28_package::IDLE_IP2_T2;
  import cms_pix28_package::DELAY_TEST_IP2_T2;
  import cms_pix28_package::RESET_NOT_IP2_T2;
  import cms_pix28_package::TRIGOUT_HIGH_1_IP2_T2;
  import cms_pix28_package::TRIGOUT_HIGH_2_IP2_T2;
  import cms_pix28_package::DELAY_SCANLOAD_IP2_T2;
  import cms_pix28_package::SCANLOAD_HIGH_1_IP2_T2;
  import cms_pix28_package::SCANLOAD_HIGH_2_IP2_T2;
  import cms_pix28_package::SHIFT_IN_0_IP2_T2;
  import cms_pix28_package::SHIFT_IN_IP2_T2;
  import cms_pix28_package::DONE_IP2_T2;
  //
  import cms_pix28_package::SCAN_REG_MODE_SHIFT_IN;
  import cms_pix28_package::SCAN_REG_MODE_LOAD_COMP;

  // ------------------------------------------------------------------------------------------------------------------
  // State Machine for "test2". Test SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister.
  logic [5:0]             sm_scan_load_delay_cnt;
  state_t_sm_ip2_test2    sm_test2;
  assign sm_test2_state = sm_test2;
  //
  assign sm_test2_o_config_clk        = 1'b0;       // signal not used-in / diven-by sm_test2_proc
  assign sm_test2_o_config_in         = 1'b0;       // signal not used-in / diven-by sm_test2_proc
  assign sm_test2_o_config_load       = 1'b1;       // signal not used-in / diven-by sm_test2_proc
  always @(posedge clk) begin : vin_test_trig_out_proc
    if(~enable | reset) begin
      sm_test2_o_vin_test_trig_out     <= 1'b0;
    end else begin
      if(sm_test2==TRIGOUT_HIGH_1_IP2_T2 && clk_counter==test_trig_out_phase) begin
        sm_test2_o_vin_test_trig_out   <= 1'b1;
      end else if(sm_test2==TRIGOUT_HIGH_2_IP2_T2 && clk_counter==test_trig_out_phase) begin
        sm_test2_o_vin_test_trig_out   <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin : sm_test2_proc
    if(~enable | reset) begin
      sm_test2 <= IDLE_IP2_T2;
    end else begin
      case(sm_test2)
        IDLE_IP2_T2 : begin
          // next state machine state logic
          if(test2_enable_re) begin
            sm_test2 <= DELAY_TEST_IP2_T2;
          end else begin
            sm_test2 <= IDLE_IP2_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;                      // active  LOW signal; default is inactive
          sm_test2_o_scan_in                     <= 1'b0;                      // arbitrary chosen default LOW
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;   // scan-chain-mode: LOW==shift-register, HIGH==parallel-load-asic-internal-comparators; default=HIGH
          sm_test2_o_scanchain_reg_load          <= 1'b0;                      //
          sm_test2_o_scanchain_reg_shift         <= 1'b0;                      // LOW==do-not-shift, HIGH==do-shift-right
          sm_test2_o_status_done                 <= sm_test2_o_status_done;    // state machine STATUS flag
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        DELAY_TEST_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= RESET_NOT_IP2_T2;
          end else begin
            sm_test2 <= DELAY_TEST_IP2_T2;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter) begin
            if(test_mask_reset_not==1'b1) begin
              sm_test2_o_reset_not               <= 1'b1;
            end else begin
              sm_test2_o_reset_not               <= 1'b0;
            end
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end else begin
            sm_test2_o_reset_not                 <= 1'b1;
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b1;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        RESET_NOT_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= TRIGOUT_HIGH_1_IP2_T2;
          end else begin
            sm_test2 <= RESET_NOT_IP2_T2;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter) begin
            sm_test2_o_reset_not                 <= 1'b1;
          end else begin
            if(test_mask_reset_not==1'b1) begin
              sm_test2_o_reset_not               <= 1'b1;
            end else begin
              sm_test2_o_reset_not               <= 1'b0;
            end
          end
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_SHIFT_IN;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        //
        TRIGOUT_HIGH_1_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= TRIGOUT_HIGH_2_IP2_T2;
          end else begin
            sm_test2 <= TRIGOUT_HIGH_1_IP2_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_SHIFT_IN;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        TRIGOUT_HIGH_2_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            if(scan_load_delay==0) begin
              sm_test2 <= SCANLOAD_HIGH_1_IP2_T2;
            end else begin
              sm_test2 <= DELAY_SCANLOAD_IP2_T2;
            end
          end else begin
            sm_test2 <= TRIGOUT_HIGH_2_IP2_T2;
          end
          // output state machine signal assignment
          if((test_delay==clk_counter) && (scan_load_delay==0)) begin
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end else begin
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          if(test_delay==clk_counter) begin
            sm_scan_load_delay_cnt               <= sm_scan_load_delay_cnt + 1;
          end else begin
            sm_scan_load_delay_cnt               <= sm_scan_load_delay_cnt;
          end
        end
        //
        DELAY_SCANLOAD_IP2_T2 : begin
          // next state machine state logic
          if((test_delay==clk_counter) && (scan_load_delay==sm_scan_load_delay_cnt)) begin
            sm_test2 <= SCANLOAD_HIGH_1_IP2_T2;
          end else begin
            sm_test2 <= DELAY_SCANLOAD_IP2_T2;
          end
          // output state machine signal assignment
          if((test_delay==clk_counter) && (scan_load_delay==sm_scan_load_delay_cnt)) begin
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end else begin
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          if(test_delay==clk_counter) begin
            sm_scan_load_delay_cnt               <= sm_scan_load_delay_cnt + 1;
          end else begin
            sm_scan_load_delay_cnt               <= sm_scan_load_delay_cnt;
          end
        end
        //
        SCANLOAD_HIGH_1_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= SCANLOAD_HIGH_2_IP2_T2;
          end else begin
            sm_test2 <= SCANLOAD_HIGH_1_IP2_T2;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        SCANLOAD_HIGH_2_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= SHIFT_IN_0_IP2_T2;
          end else begin
            sm_test2 <= SCANLOAD_HIGH_2_IP2_T2;
          end
          if(test_delay==clk_counter) begin
            sm_test2_o_scan_in                   <= sm_testx_i_scanchain_reg_bit0;
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
          end else begin
            sm_test2_o_scan_in                   <= 1'b0;
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
          end
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
          // internal state machine signal assignment
          sm_scan_load_delay_cnt                 <= 6'b0;
        end
        //
        SHIFT_IN_0_IP2_T2 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test2 <= SHIFT_IN_IP2_T2;
          end else begin
            sm_test2 <= SHIFT_IN_0_IP2_T2;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter) begin
            // latency sm_test2_o_scanchain_reg_shift to sm_testx_i_scanchain_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test2_o_scanchain_reg_shift
            // * one clk latency due to process sm_testx_i_scanchain_reg_proc to execute the shift-right
            sm_test2_o_scanchain_reg_shift       <= 1'b1;
          end else begin
            sm_test2_o_scanchain_reg_shift       <= 1'b0;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_in                     <= sm_testx_i_scanchain_reg_bit0;
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_SHIFT_IN;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_status_done                 <= 1'b0;
        end
        SHIFT_IN_IP2_T2 : begin
          // next state machine state logic
          if(sm_testx_i_scanchain_reg_shift_cnt==sm_testx_i_scanchain_reg_shift_cnt_max) begin
            // done shifting all 768 bits;
            sm_test2 <= DONE_IP2_T2;
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_LOAD_COMP;
            sm_test2_o_status_done               <= 1'b1;
          end else begin
            // continue shifting
            sm_test2 <= SHIFT_IN_IP2_T2;
            sm_test2_o_scan_load                 <= SCAN_REG_MODE_SHIFT_IN;
            sm_test2_o_status_done               <= 1'b0;
          end
          // output state machine signal assignment
          if(test_delay-2==clk_counter) begin
            // latency sm_test2_o_scanchain_reg_shift to sm_testx_i_scanchain_reg is TWO clk clocks:
            // * one clk latency due to this process for asserting signal sm_test2_o_scanchain_reg_shift
            // * one clk latency due to process sm_testx_i_scanchain_reg_proc to execute the shift-right
            sm_test2_o_scanchain_reg_shift       <= 1'b1;
          end else begin
            sm_test2_o_scanchain_reg_shift       <= 1'b0;
          end
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_in                     <= sm_testx_i_scanchain_reg_bit0;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
        end
        DONE_IP2_T2 : begin
          // next state machine state logic
          sm_test2 <= IDLE_IP2_T2;
          // output state machine signal assignment
          sm_test2_o_reset_not                   <= 1'b1;
          sm_test2_o_scan_in                     <= 1'b0;
          sm_test2_o_scan_load                   <= SCAN_REG_MODE_LOAD_COMP;
          sm_test2_o_scanchain_reg_load          <= 1'b0;
          sm_test2_o_scanchain_reg_shift         <= 1'b0;
          sm_test2_o_status_done                 <= 1'b1;
        end
        default : begin
          sm_test2 <= IDLE_IP2_T2;
        end
      endcase
    end
  end
  // ------------------------------------------------------------------------------------------------------------------

endmodule

`endif
