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
// 2024-08-15  Cristian  Gingu        Update state machine
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
    input  logic       sm_testx_i_dnn_output_0,
    input  logic       sm_testx_i_dnn_output_1,
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
    output logic       sm_test3_o_scan_load,
    output logic [47:0]sm_test3_o_dnn_output_0,
    output logic [47:0]sm_test3_o_dnn_output_1
  );

  import cms_pix28_package::state_t_sm_ip2_test3;
  import cms_pix28_package::IDLE_IP2_T3;
  import cms_pix28_package::DELAY_TEST_IP2_T3;
  import cms_pix28_package::RESET_NOT_IP2_T3;
  import cms_pix28_package::ACQUIRE_1_IP2_T3;
  import cms_pix28_package::ACQUIRE_2_IP2_T3;
  import cms_pix28_package::DONE_IP2_T3;
  //
  import cms_pix28_package::SCAN_REG_MODE_SHIFT_IN;
  import cms_pix28_package::SCAN_REG_MODE_LOAD_COMP;

  // ------------------------------------------------------------------------------------------------------------------
  // State Machine for "test1". Test SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister.
  state_t_sm_ip2_test3    sm_test3;
  assign sm_test3_state = sm_test3;
  //
  logic [47:0] sm_test3_o_dnn_reg_0;   // 400MHz clock register storing 48 consecutive values of DUT output signal sm_testx_i_dnn_output_0
  logic [47:0] sm_test3_o_dnn_reg_1;   // 400MHz clock register storing 48 consecutive values of DUT output signal sm_testx_i_dnn_output_1
  //
  assign sm_test3_o_config_clk        = 1'b0;       // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_config_in         = 1'b0;       // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_config_load       = 1'b1;       // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_dnn_output_0        = sm_test3_o_dnn_reg_0;                // signal is driven by state machine sm_test3_proc
  assign sm_test3_o_dnn_output_1        = sm_test3_o_dnn_reg_1;                // signal is driven by state machine sm_test3_proc
  assign sm_test3_o_scan_in             = 1'b0;                                // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_scan_load           = SCAN_REG_MODE_LOAD_COMP;             // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_scanchain_reg_load  = 1'b0;                                // signal not used-in / diven-by sm_test3_proc
  assign sm_test3_o_scanchain_reg_shift = 1'b0;                                // signal not used-in / diven-by sm_test3_proc
  always @(posedge clk) begin : vin_test_trig_out_proc
    if(~enable | reset) begin
      sm_test3_o_vin_test_trig_out     <= 1'b0;
    end else begin
      if(sm_test3==ACQUIRE_1_IP2_T3 && clk_counter==test_trig_out_phase) begin
        sm_test3_o_vin_test_trig_out   <= 1'b1;
      end else if(sm_test3==ACQUIRE_2_IP2_T3 && clk_counter==test_trig_out_phase) begin
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
          sm_test3_o_status_done                 <= sm_test3_o_status_done;    // state machine STATUS flag
          if(test2_enable_re) begin
            sm_test3_o_dnn_reg_0                   <= 48'h0;                   //
            sm_test3_o_dnn_reg_1                   <= 48'h0;
          end else begin
            sm_test3_o_dnn_reg_0                   <= sm_test3_o_dnn_reg_0;
            sm_test3_o_dnn_reg_1                   <= sm_test3_o_dnn_reg_1;
          end
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
          end else begin
            sm_test3_o_reset_not                 <= 1'b1;
          end
          sm_test3_o_status_done                 <= 1'b0;
          sm_test3_o_dnn_reg_0                   <= {sm_test3_o_dnn_reg_0[46:0], sm_testx_i_dnn_output_0};
          sm_test3_o_dnn_reg_1                   <= {sm_test3_o_dnn_reg_1[46:0], sm_testx_i_dnn_output_1};
        end
        RESET_NOT_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= ACQUIRE_1_IP2_T3;
          end else begin
            sm_test3 <= RESET_NOT_IP2_T3;
          end
          // output state machine signal assignment
          if(test_delay==clk_counter) begin
            sm_test3_o_reset_not                 <= 1'b1;
          end else begin
            if(test_mask_reset_not==1'b1) begin
              sm_test3_o_reset_not               <= 1'b1;
            end else begin
              sm_test3_o_reset_not               <= 1'b0;
            end
          end
          sm_test3_o_status_done                 <= 1'b0;
          sm_test3_o_dnn_reg_0                   <= {sm_test3_o_dnn_reg_0[46:0], sm_testx_i_dnn_output_0};
          sm_test3_o_dnn_reg_1                   <= {sm_test3_o_dnn_reg_1[46:0], sm_testx_i_dnn_output_1};
        end
        //
        ACQUIRE_1_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= ACQUIRE_2_IP2_T3;
          end else begin
            sm_test3 <= ACQUIRE_1_IP2_T3;
          end
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_status_done                 <= 1'b0;
          sm_test3_o_dnn_reg_0                   <= {sm_test3_o_dnn_reg_0[46:0], sm_testx_i_dnn_output_0};
          sm_test3_o_dnn_reg_1                   <= {sm_test3_o_dnn_reg_1[46:0], sm_testx_i_dnn_output_1};
        end
        ACQUIRE_2_IP2_T3 : begin
          // next state machine state logic
          if(test_delay==clk_counter) begin
            sm_test3 <= DONE_IP2_T3;
          end else begin
            sm_test3 <= ACQUIRE_2_IP2_T3;
          end
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_status_done                 <= 1'b0;
          sm_test3_o_dnn_reg_0                   <= {sm_test3_o_dnn_reg_0[46:0], sm_testx_i_dnn_output_0};
          sm_test3_o_dnn_reg_1                   <= {sm_test3_o_dnn_reg_1[46:0], sm_testx_i_dnn_output_1};
        end
        DONE_IP2_T3 : begin
          // next state machine state logic
          sm_test3 <= IDLE_IP2_T3;
          // output state machine signal assignment
          sm_test3_o_reset_not                   <= 1'b1;
          sm_test3_o_status_done                 <= 1'b1;
          sm_test3_o_dnn_reg_0                   <= sm_test3_o_dnn_reg_0;
          sm_test3_o_dnn_reg_1                   <= sm_test3_o_dnn_reg_1;
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
