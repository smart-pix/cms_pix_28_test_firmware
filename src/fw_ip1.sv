// ------------------------------------------------------------------------------------
//              : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-05-22
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-05-22  Cristian Gingu         Created Template
// 2024-06-27  Cristian Gingu         Write RTL code; implement ip1_test1 ip1_test1_inst
// 2024-07-xx  Cristian Gingu         Use sm_test3 to forward internal fast_configclk to output port fw_config_clk
// 2024-07-xx  Cristian Gingu         Use sm_test4 to forward internal slow_configclk to output port fw_config_clk
// 2024-07-09  Cristian Gingu         Clean header file Description and Author
// 2024-07-09  Cristian Gingu         Fix latch inferred for signal fw_read_data32_comb
// 2024-07-10  Cristian Gingu         Update default values: fw_reset_not=1'b1; fw_config_load=1'b1;
// 2024-07-23  Cristian Gingu         Add fw_op_code_w_cfg_array_2 and fw_op_code_r_cfg_array_2
// 2024-07-23  Cristian Gingu         Change tests length from 5188 config_clk cycles to 2*5188=10376 config_clk cycles
// 2024-07-29  Cristian Gingu         Change logic for signal error_w_execute_cfg; constrain sm_test1!=IDLE_T1 and add fw_rst_n
// 2024-07-30  Cristian Gingu         Add fw_rst_n to sm_testx_i_shift_reg_proc
// 2024-07-30  Cristian Gingu         Make outputs config_clk default driven by test1 output sm_test1_o_config_clk
// 2024-08-02  Cristian Gingu         Add coding for ip2_test2
// 2024-08-06  Cristian Gingu         Add references to cms_pix28_package.sv
// 2024-08-08  Cristian Gingu         Factorize common module com_status32_reg.sv
// ------------------------------------------------------------------------------------
`ifndef __fw_ip1__
`define __fw_ip1__

`timescale 1 ns/ 1 ps

module fw_ip1 (
    input  logic        fw_axi_clk,                        // FW clock 100MHz       mapped to S_AXI_ACLK
    input  logic        fw_rst_n,                          // FW reset, active low  mapped to S_AXI_ARESETN
    // SW side signals from/to com_sw_to_fw.sv
    input  logic        fw_dev_id_enable,                  // up to 15 FW can be connected
    input  logic        fw_op_code_w_reset,
    input  logic        fw_op_code_w_cfg_static_0,
    input  logic        fw_op_code_r_cfg_static_0,
    input  logic        fw_op_code_w_cfg_static_1,
    input  logic        fw_op_code_r_cfg_static_1,
    input  logic        fw_op_code_w_cfg_array_0,
    input  logic        fw_op_code_r_cfg_array_0,
    input  logic        fw_op_code_w_cfg_array_1,
    input  logic        fw_op_code_r_cfg_array_1,
    input  logic        fw_op_code_w_cfg_array_2,
    input  logic        fw_op_code_r_cfg_array_2,
    input  logic        fw_op_code_r_data_array_0,
    input  logic        fw_op_code_r_data_array_1,
    input  logic        fw_op_code_w_status_clear,
    input  logic        fw_op_code_w_execute,
    input  logic [23:0] sw_write24_0,                      // feed-through bytes 2, 1, 0 of sw_write32_0 from SW to FW
    output logic [31:0] fw_read_data32,                    // 32-bit read_data   from FW to SW
    output logic [31:0] fw_read_status32,                  // 32-bit read_status from FW to SW
    // DUT side signals to/from com_fw_to_dut.sv           // up to 15 FWs can be connected
    // output signals from FW to DUT
    output logic fw_super_pixel_sel,
    output logic fw_config_clk,
    output logic fw_reset_not,
    output logic fw_config_in,
    output logic fw_config_load,
    output logic fw_bxclk_ana,
    output logic fw_bxclk,
    output logic fw_vin_test_trig_out,
    output logic fw_scan_in,
    output logic fw_scan_load,
    // input signals to FW from DUT
    input  logic fw_config_out,
    input  logic fw_scan_out,
    input  logic fw_dnn_output_0,
    input  logic fw_dnn_output_1,
    input  logic fw_dn_event_toggle
  );

  import cms_pix28_package::cfg_reg_bits_total;
  import cms_pix28_package::cfg_reg_bits_test;
  //
  import cms_pix28_package::w_cfg_static_0_reg_fast_configclk_period_index_min;     // fast_configCLK period is 10ns(AXI100MHz) * 2**7(7-bits) == 10*128 == 1280ns i.e. 0.78125MHz the lowest frequency, thus covering DataSheet minimum 1MHz
  import cms_pix28_package::w_cfg_static_0_reg_fast_configclk_period_index_max;     //
  import cms_pix28_package::w_cfg_static_0_reg_super_pix_sel_index;                 //
  import cms_pix28_package::w_cfg_static_0_reg_slow_configclk_period_index_min;     // slow_configCLK period is 10ns(AXI100MHz) * 2**27(27-bits) == 10*134217728 == 1342177280ns i.e. 0.745Hz the lowest frequency, thus covering DataSheet minimum 1Hz
  import cms_pix28_package::w_cfg_static_0_reg_slow_configclk_period_index_max;     // w_cfg_static_0_reg contains lower 16-bits of the 27-bit period for slow_configCLK
  import cms_pix28_package::w_cfg_static_1_reg_slow_configclk_period_index_min;     // w_cfg_static_1_reg contains upper 11-bits of the 27-bit period for slow_configCLK
  import cms_pix28_package::w_cfg_static_1_reg_slow_configclk_period_index_max;
  import cms_pix28_package::w_cfg_static_1_reg_spare_index_min;
  import cms_pix28_package::w_cfg_static_1_reg_spare_index_max;
  //
  import cms_pix28_package::w_execute_cfg_test_delay_index_min;                     //
  import cms_pix28_package::w_execute_cfg_test_delay_index_max;                     //
  import cms_pix28_package::w_execute_cfg_test_sample_index_min;                    //
  import cms_pix28_package::w_execute_cfg_test_sample_index_max;                    //
  import cms_pix28_package::w_execute_cfg_test_number_index_min;                    //
  import cms_pix28_package::w_execute_cfg_test_number_index_max;                    //
  import cms_pix28_package::w_execute_cfg_test_loopback;                            //
  import cms_pix28_package::w_execute_cfg_test_spare_index_min;                     //
  import cms_pix28_package::w_execute_cfg_test_spare_index_max;                     //
  import cms_pix28_package::w_execute_cfg_test_mask_reset_not_index;                //
  //
  import cms_pix28_package::state_t_sm_ip1_test1;
  import cms_pix28_package::IDLE_IP1_T1;
  import cms_pix28_package::SHIFT_IN_0_IP1_T1;
  import cms_pix28_package::SHIFT_IN_IP1_T1;
  //
  import cms_pix28_package::state_t_sm_ip1_test2;
  import cms_pix28_package::IDLE_IP1_T2;
  import cms_pix28_package::SHIFT_IN_0_IP1_T2;
  import cms_pix28_package::SHIFT_IN_IP1_T2;
  import cms_pix28_package::SHIFT_IN_SLOW_CLK_IP1_T2;
  //
  import cms_pix28_package::CONFIG_REG_MODE_SHIFT_IN;
  import cms_pix28_package::CONFIG_REG_MODE_PARALLEL_OUT;
  //
  // Instantiate module com_op_code_decoder.sv
  logic op_code_w_reset;
  logic op_code_w_cfg_static_0;
  logic op_code_r_cfg_static_0;
  logic op_code_w_cfg_static_1;
  logic op_code_r_cfg_static_1;
  logic op_code_w_cfg_array_0;
  logic op_code_r_cfg_array_0;
  logic op_code_w_cfg_array_1;
  logic op_code_r_cfg_array_1;
  logic op_code_w_cfg_array_2;
  logic op_code_r_cfg_array_2;
  logic op_code_r_data_array_0;
  logic op_code_r_data_array_1;
  logic op_code_w_status_clear;
  logic op_code_w_execute;
  com_op_code_decoder com_op_code_decoder_inst(
    .fw_dev_id_enable          (fw_dev_id_enable),
    .fw_op_code_w_reset        (fw_op_code_w_reset),
    .fw_op_code_w_cfg_static_0 (fw_op_code_w_cfg_static_0),
    .fw_op_code_r_cfg_static_0 (fw_op_code_r_cfg_static_0),
    .fw_op_code_w_cfg_static_1 (fw_op_code_w_cfg_static_1),
    .fw_op_code_r_cfg_static_1 (fw_op_code_r_cfg_static_1),
    .fw_op_code_w_cfg_array_0  (fw_op_code_w_cfg_array_0),
    .fw_op_code_r_cfg_array_0  (fw_op_code_r_cfg_array_0),
    .fw_op_code_w_cfg_array_1  (fw_op_code_w_cfg_array_1),
    .fw_op_code_r_cfg_array_1  (fw_op_code_r_cfg_array_1),
    .fw_op_code_w_cfg_array_2  (fw_op_code_w_cfg_array_2),
    .fw_op_code_r_cfg_array_2  (fw_op_code_r_cfg_array_2),
    .fw_op_code_r_data_array_0 (fw_op_code_r_data_array_0),
    .fw_op_code_r_data_array_1 (fw_op_code_r_data_array_1),
    .fw_op_code_w_status_clear (fw_op_code_w_status_clear),
    .fw_op_code_w_execute      (fw_op_code_w_execute),
    //
    .op_code_w_reset         (op_code_w_reset),
    .op_code_w_cfg_static_0  (op_code_w_cfg_static_0),
    .op_code_r_cfg_static_0  (op_code_r_cfg_static_0),
    .op_code_w_cfg_static_1  (op_code_w_cfg_static_1),
    .op_code_r_cfg_static_1  (op_code_r_cfg_static_1),
    .op_code_w_cfg_array_0   (op_code_w_cfg_array_0),
    .op_code_r_cfg_array_0   (op_code_r_cfg_array_0),
    .op_code_w_cfg_array_1   (op_code_w_cfg_array_1),
    .op_code_r_cfg_array_1   (op_code_r_cfg_array_1),
    .op_code_w_cfg_array_2   (op_code_w_cfg_array_2),
    .op_code_r_cfg_array_2   (op_code_r_cfg_array_2),
    .op_code_r_data_array_0  (op_code_r_data_array_0),
    .op_code_r_data_array_1  (op_code_r_data_array_1),
    .op_code_w_status_clear  (op_code_w_status_clear),
    .op_code_w_execute       (op_code_w_execute)
  );

  // Instantiate module com_config_write_regs.sv
  logic [23:0]        w_cfg_static_0_reg;
  logic [23:0]        w_cfg_static_1_reg;
  logic [255:0][15:0] w_cfg_array_0_reg;
  logic [255:0][15:0] w_cfg_array_1_reg;
  logic [255:0][15:0] w_cfg_array_2_reg;
  com_config_write_regs com_config_write_regs_inst (
    .fw_clk_100              (fw_axi_clk),                 // FW clock 100MHz       mapped to S_AXI_ACLK
    .fw_rst_n                (fw_rst_n),                   // FW reset, active low  mapped to S_AXI_ARESETN
    //
    .op_code_w_reset         (op_code_w_reset),
    .op_code_w_cfg_static_0  (op_code_w_cfg_static_0),
    .op_code_w_cfg_static_1  (op_code_w_cfg_static_1),
    .op_code_w_cfg_array_0   (op_code_w_cfg_array_0),
    .op_code_w_cfg_array_1   (op_code_w_cfg_array_1),
    .op_code_w_cfg_array_2   (op_code_w_cfg_array_2),
    .sw_write24_0            (sw_write24_0),               // feed-through bytes 2, 1, 0 of sw_write32_0 from SW to FW
    //
    .w_cfg_static_0_reg      (w_cfg_static_0_reg),         // on clock domain fw_axi_clk
    .w_cfg_static_1_reg      (w_cfg_static_1_reg),         // on clock domain fw_axi_clk
    .w_cfg_array_0_reg       (w_cfg_array_0_reg),          // on clock domain fw_axi_clk
    .w_cfg_array_1_reg       (w_cfg_array_1_reg),          // on clock domain fw_axi_clk
    .w_cfg_array_2_reg       (w_cfg_array_2_reg)           // on clock domain fw_axi_clk           // on clock domain fw_axi_clk
  );

  // Combinatorial logic for SW readout data fw_read_data32
  logic [31:0] fw_read_data32_comb;                        // 32-bit read_data   from FW to SW
  localparam                                           sm_testx_o_shift_reg_width = 2*cfg_reg_bits_total;
  logic [sm_testx_o_shift_reg_width-1   :0]            sm_testx_o_shift_reg;                       // 2*5188 bit shift register == 2*{4652(NWEIGHTS) + 512(PIXEL_CONFIG) + 24(HIDDEN)} == 10376-bits
  logic [(sm_testx_o_shift_reg_width+24)/32-1:0][31:0] sm_testx_o_shift_reg_array32;               // add 24 to round up to nearest whole number of 32-bits; 10376+24=10400; 10400/32=325 32-bit words
  for(genvar i = 0; i <= (sm_testx_o_shift_reg_width+24)/32-1; i++) begin: sm_testx_o_shift_reg_array32_gen
    if(i==(sm_testx_o_shift_reg_width+24)/32-1) begin
      assign sm_testx_o_shift_reg_array32[i] = {24'h000000, sm_testx_o_shift_reg[10375:10368]};    // last:  325 32-bit word: this contains most-significant-eight-bits and must be pad with zero
    end else begin
      assign sm_testx_o_shift_reg_array32[i] = sm_testx_o_shift_reg[(i+1)*32-1 : i*32];            // first: 325 32-bit words
    end
  end
  always_comb begin : fw_read_data32_comb_proc
    if(op_code_r_cfg_static_0) begin
      // AXI SW will readout com_config_write_regs.sv output signal w_cfg_static_0_reg, which is 24-bits. Must pad with zero up to 32-bits.
      fw_read_data32_comb = {8'h0, w_cfg_static_0_reg};
    end else if(op_code_r_cfg_static_1) begin
      // AXI SW will readout com_config_write_regs.sv output signal w_cfg_static_1_reg, which is 24-bits. Must pad with zero up to 32-bits.
      fw_read_data32_comb = {8'h0, w_cfg_static_1_reg};
    end else if(op_code_r_cfg_array_0) begin
      // AXI SW will readout com_config_write_regs.sv output signal w_cfg_array_0_reg, which is 16-bits for the requested address sw_write24_0[23:16].
      // For efficiency, read also w_cfg_array_0_reg at next address. CAUTION: SW must take care not to OVERFLOW addresses
      fw_read_data32_comb = {w_cfg_array_0_reg[sw_write24_0[23:16]+1], w_cfg_array_0_reg[sw_write24_0[23:16]]};
    end else if(op_code_r_cfg_array_1) begin
      // AXI SW will readout com_config_write_regs.sv output signal w_cfg_array_1_reg, which is 16-bits for the requested address sw_write24_0[23:16].
      // For efficiency, read also w_cfg_array_1_reg at next address. CAUTION: SW must take care not to OVERFLOW addresses
      fw_read_data32_comb = {w_cfg_array_1_reg[sw_write24_0[23:16]+1], w_cfg_array_1_reg[sw_write24_0[23:16]]};
    end else if(op_code_r_cfg_array_2) begin
      // AXI SW will readout com_config_write_regs.sv output signal w_cfg_array_2_reg, which is 16-bits for the requested address sw_write24_0[23:16].
      // For efficiency, read also w_cfg_array_2_reg at next address. CAUTION: SW must take care not to OVERFLOW addresses
      fw_read_data32_comb = {w_cfg_array_2_reg[sw_write24_0[23:16]+1], w_cfg_array_2_reg[sw_write24_0[23:16]]};
    end else if(op_code_r_data_array_0) begin
      // AXI SW will readout sm_testx_o_shift_reg signal which is 2*5188-bits for the requested address sw_write24_0[23:16].
      // CAUTION: SW must take care not to OVERFLOW addresses: for op_code_r_data_array_0, valid addresses are 0-to-255 which means first 256 out of total 325 addresses each containing one 32-bit word
      fw_read_data32_comb = sm_testx_o_shift_reg_array32[sw_write24_0[23:16]];
    end else if(op_code_r_data_array_1) begin
      // AXI SW will readout sm_testx_o_shift_reg signal which is 2*5188-bits for the requested address sw_write24_0[23:16].
      // CAUTION: SW must take care not to OVERFLOW addresses: for op_code_r_data_array_1, valid addresses are 0-to-68  which means next   69 out of total 325 addresses each containing one 32-bit word
      if(sw_write24_0[23:16]<69) begin
        fw_read_data32_comb = sm_testx_o_shift_reg_array32[256+sw_write24_0[23:16]];               // apply address offset 256
      end else begin
        fw_read_data32_comb = 32'b0;                       // return ZERO if address is outside range for op_code_r_data_array_1
      end
    end else begin
      fw_read_data32_comb = 32'b0;
    end
  end
  assign fw_read_data32 = fw_read_data32_comb;

  // Logic for SW readout data fw_read_status32
  logic [31:0] fw_read_status32_reg;                       // 32-bit read_status from FW to SW
  logic sm_test1_o_status_done;
  logic sm_test2_o_status_done;
  logic sm_test3_o_status_done; assign sm_test3_o_status_done = 1'b0;          // TODO to be driven by sm_test3
  logic sm_test4_o_status_done; assign sm_test4_o_status_done = 1'b0;          // TODO to be driven by sm_test4
  logic error_w_execute_cfg;
  // Instantiate module com_status32_reg.sv
  com_status32_reg com_status32_reg_inst (
    .fw_axi_clk              (fw_axi_clk),                 // FW clock 100MHz       mapped to S_AXI_ACLK
    .fw_rst_n                (fw_rst_n),                   // FW reset, active low  mapped to S_AXI_ARESETN
    //
    .op_code_w_status_clear  (op_code_w_status_clear),
    .op_code_w_reset         (op_code_w_reset),
    .op_code_w_cfg_static_0  (op_code_w_cfg_static_0),
    .op_code_r_cfg_static_0  (op_code_r_cfg_static_0),
    .op_code_w_cfg_static_1  (op_code_w_cfg_static_1),
    .op_code_r_cfg_static_1  (op_code_r_cfg_static_1),
    .op_code_w_cfg_array_0   (op_code_w_cfg_array_0),
    .op_code_r_cfg_array_0   (op_code_r_cfg_array_0),
    .op_code_w_cfg_array_1   (op_code_w_cfg_array_1),
    .op_code_r_cfg_array_1   (op_code_r_cfg_array_1),
    .op_code_w_cfg_array_2   (op_code_w_cfg_array_2),
    .op_code_r_cfg_array_2   (op_code_r_cfg_array_2),
    .op_code_r_data_array_0  (op_code_r_data_array_0),
    .op_code_r_data_array_1  (op_code_r_data_array_1),
    .op_code_w_execute       (op_code_w_execute),
    .sm_test1_o_status_done  (sm_test1_o_status_done),
    .sm_test2_o_status_done  (sm_test2_o_status_done),
    .sm_test3_o_status_done  (sm_test3_o_status_done),
    .sm_test4_o_status_done  (sm_test4_o_status_done),
    .error_w_execute_cfg     (error_w_execute_cfg),
    //
    .fw_read_status32_reg    (fw_read_status32_reg)
  );
  assign fw_read_status32 = fw_read_status32_reg;

  logic [6:0]  fast_configclk_period;                      // on clock domain fw_axi_clk
  logic [26:0] slow_configclk_period;                      // on clock domain fw_axi_clk
  logic        super_pixel_sel;                            // on clock domain fw_axi_clk
  assign fast_configclk_period = w_cfg_static_0_reg[w_cfg_static_0_reg_fast_configclk_period_index_max:w_cfg_static_0_reg_fast_configclk_period_index_min];
  assign slow_configclk_period = {
      w_cfg_static_1_reg[w_cfg_static_1_reg_slow_configclk_period_index_max:w_cfg_static_1_reg_slow_configclk_period_index_min],
      w_cfg_static_0_reg[w_cfg_static_0_reg_slow_configclk_period_index_max:w_cfg_static_0_reg_slow_configclk_period_index_min] };
  assign super_pixel_sel       = w_cfg_static_0_reg[w_cfg_static_0_reg_super_pix_sel_index];
  //
  logic fast_configclk;
  logic slow_configclk;
  logic [
    w_cfg_static_0_reg_fast_configclk_period_index_max-w_cfg_static_0_reg_fast_configclk_period_index_min+1-1 : 0] fast_configclk_clk_counter;
  logic [
    w_cfg_static_1_reg_slow_configclk_period_index_max-w_cfg_static_1_reg_slow_configclk_period_index_min+1+
    w_cfg_static_0_reg_slow_configclk_period_index_max-w_cfg_static_0_reg_slow_configclk_period_index_min+1-1 : 0] slow_configclk_clk_counter;
  //
  // Instantiate module configclk_generator.sv
  configclk_generator #(
    .CNT_WIDTH(w_cfg_static_0_reg_fast_configclk_period_index_max-w_cfg_static_0_reg_fast_configclk_period_index_min+1)
  ) fast_configclk_generator_inst (
    .clk                     (fw_axi_clk),
    .reset                   (op_code_w_reset),
    .enable                  (fw_dev_id_enable),
    // Input ports: controls
    .configclk_period        (fast_configclk_period),
    // output ports
    .clk_counter             (fast_configclk_clk_counter),
    .configclk               (fast_configclk)
  );
  configclk_generator #(
    .CNT_WIDTH(
      w_cfg_static_1_reg_slow_configclk_period_index_max-w_cfg_static_1_reg_slow_configclk_period_index_min+1+
      w_cfg_static_0_reg_slow_configclk_period_index_max-w_cfg_static_0_reg_slow_configclk_period_index_min+1 )
  ) slow_configclk_generator_inst (
    .clk                     (fw_axi_clk),
    .reset                   (op_code_w_reset),
    .enable                  (fw_dev_id_enable),
    // Input ports: controls
    .configclk_period        (slow_configclk_period),
    // output ports
    .clk_counter             (slow_configclk_clk_counter),
    .configclk               (slow_configclk)
  );

  // CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. The test is configured using:
  // 1. byte#3=={fw_dev_id_enable, fw_op_code_w_execute}
  // 2. byte#2-to-byte#0==sw_write24_0 where each bit defined as follows:
  //
  logic [6:0] test_delay;                                  // on clock domain fw_axi_clk
  logic [6:0] test_sample;                                 // on clock domain fw_axi_clk
  logic [3:0] test_number;                                 // on clock domain fw_axi_clk
  logic       test_loopback;                               // on clock domain fw_axi_clk
  logic       test_mask_reset_not;                         // on clock domain fw_axi_clk
  assign test_delay          = sw_write24_0[w_execute_cfg_test_delay_index_max  : w_execute_cfg_test_delay_index_min ];
  assign test_sample         = sw_write24_0[w_execute_cfg_test_sample_index_max : w_execute_cfg_test_sample_index_min];
  assign test_number         = sw_write24_0[w_execute_cfg_test_number_index_max : w_execute_cfg_test_number_index_min];
  assign test_loopback       = sw_write24_0[w_execute_cfg_test_loopback                                              ];
  assign test_mask_reset_not = sw_write24_0[w_execute_cfg_test_mask_reset_not_index                                  ];
  //
  // Instantiate module com_testx_decoder.sv
  logic test1_enable; logic test1_enable_re;
  logic test2_enable; logic test2_enable_re;
  logic test3_enable; logic test3_enable_re;                                   // TODO to be used by sm_test3
  logic test4_enable; logic test4_enable_re;                                   // TODO to be used by sm_test4
  com_testx_decoder com_testx_decoder_inst (
    .clk                     (fw_axi_clk),                 // mapped to appropriate clock: S_AXI_ACLK or pl_clk1
    .op_code_w_reset         (op_code_w_reset),
    .op_code_w_execute       (op_code_w_execute),
    .test_number             (test_number),
    .test1_enable            (test1_enable),
    .test2_enable            (test2_enable),
    .test3_enable            (test3_enable),
    .test4_enable            (test4_enable),
    .test1_enable_re         (test1_enable_re),
    .test2_enable_re         (test2_enable_re),
    .test3_enable_re         (test3_enable_re),
    .test4_enable_re         (test4_enable_re)
  );
  //
  // State Machine Output signals to DUT
  logic           sm_test1_o_config_clk;
  logic           sm_test1_o_reset_not;
  logic           sm_test1_o_config_in;
  logic           sm_test1_o_config_load;
  logic           sm_test1_o_vin_test_trig_out;
  logic           sm_test1_o_scan_in;
  logic           sm_test1_o_scan_load;
  logic           sm_test2_o_config_clk;
  logic           sm_test2_o_reset_not;
  logic           sm_test2_o_config_in;
  logic           sm_test2_o_config_load;
  logic           sm_test2_o_vin_test_trig_out;
  logic           sm_test2_o_scan_in;
  logic           sm_test2_o_scan_load;
  logic           sm_test3_o_config_clk;         assign sm_test3_o_config_clk        = fast_configclk;                 // Debug assignment; sm_test3 is not defined
  logic           sm_test3_o_reset_not;          assign sm_test3_o_reset_not         = 1'b0;                           // TODO to be driven by sm_test3
  logic           sm_test3_o_config_in;          assign sm_test3_o_config_in         = 1'b0;                           // TODO to be driven by sm_test3
  logic           sm_test3_o_config_load;        assign sm_test3_o_config_load       = CONFIG_REG_MODE_PARALLEL_OUT;   // TODO to be driven by sm_test3
  logic           sm_test3_o_vin_test_trig_out;  assign sm_test3_o_vin_test_trig_out = 1'b0;                           // TODO to be driven by sm_test3
  logic           sm_test3_o_scan_in;            assign sm_test3_o_scan_in           = 1'b0;                           // TODO to be driven by sm_test3
  logic           sm_test3_o_scan_load;          assign sm_test3_o_scan_load         = 1'b0;                           // TODO to be driven by sm_test3
  logic           sm_test4_o_config_clk;         assign sm_test4_o_config_clk        = slow_configclk;                 // Debug assignment; sm_test3 is not defined
  logic           sm_test4_o_reset_not;          assign sm_test4_o_reset_not         = 1'b0;                           // TODO to be driven by sm_test4
  logic           sm_test4_o_config_in;          assign sm_test4_o_config_in         = 1'b0;                           // TODO to be driven by sm_test4
  logic           sm_test4_o_config_load;        assign sm_test4_o_config_load       = CONFIG_REG_MODE_PARALLEL_OUT;   // TODO to be driven by sm_test4
  logic           sm_test4_o_vin_test_trig_out;  assign sm_test4_o_vin_test_trig_out = 1'b0;                           // TODO to be driven by sm_test4
  logic           sm_test4_o_scan_in;            assign sm_test4_o_scan_in           = 1'b0;                           // TODO to be driven by sm_test4
  logic           sm_test4_o_scan_load;          assign sm_test4_o_scan_load         = 1'b0;                           // TODO to be driven by sm_test4
  // Input signals to FW from DUT; assign to State Machine Input signals:
  logic           sm_testx_i_config_out;         assign sm_testx_i_config_out        = fw_config_out;        // input signal (output from DUT)     used in IP1 test 1,2
  logic           sm_testx_i_scan_out;           assign sm_testx_i_scan_out          = fw_scan_out;          // input signal (output from DUT) not used in IP1
  logic           sm_testx_i_dnn_output_0;       assign sm_testx_i_dnn_output_0      = fw_dnn_output_0;      // input signal (output from DUT) not used in IP1
  logic           sm_testx_i_dnn_output_1;       assign sm_testx_i_dnn_output_1      = fw_dnn_output_1;      // input signal (output from DUT) not used in IP1
  logic           sm_testx_i_dn_event_toggle;    assign sm_testx_i_dn_event_toggle   = fw_dn_event_toggle;   // input signal (output from DUT) not used in IP1
  // State Machine Control signals from logic/configuration
  localparam logic [13 : 0]                      sm_testx_i_shift_reg_width    = 2*cfg_reg_bits_total;                                          // 2*5188 == 10376 ==0x2888
  localparam logic [13 : 0]                      sm_testx_i_shift_reg_width_sc = cfg_reg_bits_test;                                             // SLOW config clock related max counter == 24 bits
  localparam logic [13 : 0]                      sm_testx_i_shift_reg_width_fc = sm_testx_i_shift_reg_width - sm_testx_i_shift_reg_width_sc;    // FAST config clock related max counter == 2*5188-24 == 10376-24 == 10352 bits
  logic [sm_testx_i_shift_reg_width-1 : 0]       sm_testx_i_shift_reg;               // 2*5188-bits shift register; bit#0 drives DUT config_in; used by all tests 1,2,3,4
  logic [13 : 0]                                 sm_testx_i_shift_reg_shift_cnt;     // counting from 0 to sm_testx_i_shift_reg_width = 2*5188=10376 == 0x2888
  logic                                          sm_test1_o_shift_reg_load;          // LOAD  control for shift register; independent control by each test 1,2,3,4
  logic                                          sm_test1_o_shift_reg_shift_right;   // SHIFT control for shift register; independent control by each test 1,2,3,4
  logic                                          sm_test2_o_shift_reg_load;          //
  logic                                          sm_test2_o_shift_reg_shift_right;   //
  logic                                          sm_test3_o_shift_reg_load;          assign sm_test3_o_shift_reg_load        = 1'b0;    // TODO to be driven by sm_test3
  logic                                          sm_test3_o_shift_reg_shift_right;   assign sm_test3_o_shift_reg_shift_right = 1'b0;    // TODO to be driven by sm_test3
  logic                                          sm_test4_o_shift_reg_load;          assign sm_test4_o_shift_reg_load        = 1'b0;    // TODO to be driven by sm_test4
  logic                                          sm_test4_o_shift_reg_shift_right;   assign sm_test4_o_shift_reg_shift_right = 1'b0;    // TODO to be driven by sm_test4
  //
  always @(posedge fw_axi_clk or negedge fw_rst_n) begin : sm_testx_i_shift_reg_proc
    if(~fw_rst_n) begin
      sm_testx_i_shift_reg             <= {sm_testx_i_shift_reg_width{1'b0}};
      sm_testx_i_shift_reg_shift_cnt   <= 14'h0;
    end else begin
      if(sm_test1_o_shift_reg_load | sm_test2_o_shift_reg_load | sm_test3_o_shift_reg_load | sm_test4_o_shift_reg_load) begin
        sm_testx_i_shift_reg           <= {w_cfg_array_2_reg[136][7:0], w_cfg_array_2_reg[135:0], w_cfg_array_1_reg, w_cfg_array_0_reg};  // all 256-addresses of 16-bit words from w_cfg_array_0_reg and w_cfg_array_1_reg; then 137-addresses from w_cfg_array_2_reg : 136full + 8-bits from 137th.
        sm_testx_i_shift_reg_shift_cnt <= 14'h0;
      end else if(sm_test1_o_shift_reg_shift_right | sm_test2_o_shift_reg_shift_right | sm_test3_o_shift_reg_shift_right | sm_test4_o_shift_reg_shift_right) begin
        sm_testx_i_shift_reg           <= {1'b0, sm_testx_i_shift_reg[sm_testx_i_shift_reg_width-1 : 1]};
        sm_testx_i_shift_reg_shift_cnt <= sm_testx_i_shift_reg_shift_cnt + 1'b1;
      end
    end
  end

  // State Machine for "test1": instantiate module ip1_test1.sv
  state_t_sm_ip1_test1 sm_test1;
  ip1_test1 ip1_test1_inst (
    .clk                                     (fw_axi_clk),                     // mapped to appropriate clock: S_AXI_ACLK or pl_clk1
    .reset                                   (op_code_w_reset),
    .enable                                  (fw_dev_id_enable),               // up to 15 FW can be connected
    // Control signals:
    .clk_counter                             (fast_configclk_clk_counter),
    .test_delay                              (test_delay),
    .test_mask_reset_not                     (test_mask_reset_not),
    .test1_enable_re                         (test1_enable_re),
    .sm_testx_i_fast_config_clk              (fast_configclk),
    .sm_testx_i_shift_reg_bit0               (sm_testx_i_shift_reg[0]),
    .sm_testx_i_shift_reg_shift_cnt          (sm_testx_i_shift_reg_shift_cnt),
    .sm_testx_i_shift_reg_shift_cnt_max      (sm_testx_i_shift_reg_width),
    .sm_test1_o_shift_reg_load               (sm_test1_o_shift_reg_load),
    .sm_test1_o_shift_reg_shift              (sm_test1_o_shift_reg_shift_right),
    .sm_test1_o_status_done                  (sm_test1_o_status_done),
    // output ports
    .sm_test1_state                          (sm_test1),
    .sm_test1_o_config_clk                   (sm_test1_o_config_clk),
    .sm_test1_o_reset_not                    (sm_test1_o_reset_not),
    .sm_test1_o_config_in                    (sm_test1_o_config_in),
    .sm_test1_o_config_load                  (sm_test1_o_config_load),
    .sm_test1_o_vin_test_trig_out            (sm_test1_o_vin_test_trig_out),
    .sm_test1_o_scan_in                      (sm_test1_o_scan_in),
    .sm_test1_o_scan_load                    (sm_test1_o_scan_load)
  );

  // State Machine for "test2": instantiate module ip1_test2.sv
  state_t_sm_ip1_test2 sm_test2;
  ip1_test2 ip1_test2_inst (
    .clk                                     (fw_axi_clk),                     // mapped to appropriate clock: S_AXI_ACLK or pl_clk1
    .reset                                   (op_code_w_reset),
    .enable                                  (fw_dev_id_enable),               // up to 15 FW can be connected
    // Control signals:
    .clk_counter_fc                          (fast_configclk_clk_counter),
    .clk_counter_sc                          (slow_configclk_clk_counter),
    .fast_configclk_period                   (fast_configclk_period),
    .slow_configclk_period                   (slow_configclk_period),
    .test_delay                              (test_delay),
    .test_mask_reset_not                     (test_mask_reset_not),
    .test2_enable_re                         (test2_enable_re),
    .sm_testx_i_fast_config_clk              (fast_configclk),
    .sm_testx_i_slow_config_clk              (slow_configclk),
    .sm_testx_i_shift_reg_bit0               (sm_testx_i_shift_reg[0]),
    .sm_testx_i_shift_reg_shift_cnt          (sm_testx_i_shift_reg_shift_cnt),
    .sm_testx_i_shift_reg_shift_cnt_max_fc   (sm_testx_i_shift_reg_width_fc),  // FAST config clock related max counter == 5188-24 ==5164 bits
    .sm_testx_i_shift_reg_shift_cnt_max_sc   (sm_testx_i_shift_reg_width_sc),  // SLOW config clock related max counter == 24 bits
    .sm_test2_o_shift_reg_load               (sm_test2_o_shift_reg_load),
    .sm_test2_o_shift_reg_shift              (sm_test2_o_shift_reg_shift_right),
    .sm_test2_o_status_done                  (sm_test2_o_status_done),
    // output ports
    .sm_test2_state                          (sm_test2),
    .sm_test2_o_config_clk                   (sm_test2_o_config_clk),
    .sm_test2_o_reset_not                    (sm_test2_o_reset_not),
    .sm_test2_o_config_in                    (sm_test2_o_config_in),
    .sm_test2_o_config_load                  (sm_test2_o_config_load),
    .sm_test2_o_vin_test_trig_out            (sm_test2_o_vin_test_trig_out),
    .sm_test2_o_scan_in                      (sm_test2_o_scan_in),
    .sm_test2_o_scan_load                    (sm_test2_o_scan_load)
  );

  // Logic related with readout data from DUT: sm_testx_o_shift_reg
  // This is State Machine for test dependent: sm_test1, sm_test2, sm_test3, sm_test4
  always @(posedge fw_axi_clk) begin : sm_testx_o_shift_reg_proc
    if(test1_enable) begin
      // use data specific for test case test1
      if(sm_test1==SHIFT_IN_0_IP1_T1 | sm_test1==SHIFT_IN_IP1_T1) begin
        if(test_sample==fast_configclk_clk_counter) begin
          if(test_loopback) begin
            // shift-in new bit using loop-back data from sm_test1_o_scan_in
            sm_testx_o_shift_reg <= {sm_test1_o_config_in,  sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end else begin
            // shift-in new bit using readout-data from DUT
            sm_testx_o_shift_reg <= {sm_testx_i_config_out, sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end
        end else begin
          // keep old value
          sm_testx_o_shift_reg   <= sm_testx_o_shift_reg;
        end
      end else begin
        // keep old value
        sm_testx_o_shift_reg     <= sm_testx_o_shift_reg;
      end
    end else if(test2_enable) begin
      // use data specific for test case test2
      if(sm_test2==SHIFT_IN_0_IP1_T2 | sm_test2==SHIFT_IN_IP1_T2) begin      // test2_enable: using fast_configclk to shift-in and fast_configclk_clk_counter to sample at programmable counter value == test_sample
        if(test_sample==fast_configclk_clk_counter) begin
          if(test_loopback) begin
            // shift-in new bit using loop-back data from sm_test1_o_scan_in
            sm_testx_o_shift_reg <= {sm_test2_o_config_in,  sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end else begin
            // shift-in new bit using readout-data from DUT
            sm_testx_o_shift_reg <= {sm_testx_i_config_out, sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end
        end else begin
          // keep old value
          sm_testx_o_shift_reg   <= sm_testx_o_shift_reg;
        end
      end else if(sm_test2==SHIFT_IN_SLOW_CLK_IP1_T2) begin              // test2_enable: using slow_configclk to shift-in and slow_configclk_clk_counter to sample at fixed counter value == 27'h1
        if(27'h1==slow_configclk_clk_counter) begin
          if(test_loopback) begin
            // shift-in new bit using loop-back data from sm_test1_o_scan_in
            sm_testx_o_shift_reg <= {sm_test2_o_config_in,  sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end else begin
            // shift-in new bit using readout-data from DUT
            sm_testx_o_shift_reg <= {sm_testx_i_config_out, sm_testx_o_shift_reg[sm_testx_o_shift_reg_width-1 : 1]};
          end
        end else begin
          // keep old value
          sm_testx_o_shift_reg   <= sm_testx_o_shift_reg;
        end
      end else begin
        // keep old value
        sm_testx_o_shift_reg     <= sm_testx_o_shift_reg;
      end
    end else if(test3_enable) begin
      // use data specific for test case test3
      sm_testx_o_shift_reg <= {sm_testx_o_shift_reg_width*{1'b0}};     // TODO
    end else if(test4_enable) begin
      // use data specific for test case test4
      sm_testx_o_shift_reg <= {sm_testx_o_shift_reg_width*{1'b0}};     // TODO
    end else begin
      // keep old value; need to do this way to preserve sm_testx_o_shift_reg after any of test1,2,3,4 are done
      // and the operation code is no more "op_code_w_execute" but instead "op_code_r_data_array_0" for the purpose of AXI readout
      sm_testx_o_shift_reg <= sm_testx_o_shift_reg;
    end
  end

  // Assign module output signals:
  // They may be or may be not dependent of State Machine sm_test1, sm_test2, sm_test3, sm_test4
  assign fw_bxclk_ana        = 1'b0;
  assign fw_bxclk            = 1'b0;
  always_comb begin
    if(test1_enable) begin
      fw_super_pixel_sel     = super_pixel_sel;
      fw_config_clk          = sm_test1_o_config_clk;
      fw_reset_not           = sm_test1_o_reset_not;
      fw_config_in           = sm_test1_o_config_in;
      fw_config_load         = sm_test1_o_config_load;
      fw_vin_test_trig_out   = sm_test1_o_vin_test_trig_out;    // signal not used-in / diven-by sm_test1_proc
      fw_scan_in             = sm_test1_o_scan_in;              // signal not used-in / diven-by sm_test1_proc
      fw_scan_load           = sm_test1_o_scan_load;            // signal not used-in / diven-by sm_test1_proc
    end else if(test2_enable) begin
      fw_super_pixel_sel     = super_pixel_sel;
      fw_config_clk          = sm_test2_o_config_clk;
      fw_reset_not           = sm_test2_o_reset_not;
      fw_config_in           = sm_test2_o_config_in;
      fw_config_load         = sm_test2_o_config_load;
      fw_vin_test_trig_out   = sm_test2_o_vin_test_trig_out;    // signal not used-in / diven-by sm_test2_proc
      fw_scan_in             = sm_test2_o_scan_in;              // signal not used-in / diven-by sm_test2_proc
      fw_scan_load           = sm_test2_o_scan_load;            // signal not used-in / diven-by sm_test2_proc
    end else if(test3_enable) begin
      fw_super_pixel_sel     = super_pixel_sel;
      fw_config_clk          = sm_test3_o_config_clk;
      fw_reset_not           = sm_test3_o_reset_not;
      fw_config_in           = sm_test3_o_config_in;
      fw_config_load         = sm_test3_o_config_load;
      fw_vin_test_trig_out   = sm_test3_o_vin_test_trig_out;
      fw_scan_in             = sm_test3_o_scan_in;
      fw_scan_load           = sm_test3_o_scan_load;
    end else if(test4_enable) begin
      fw_super_pixel_sel     = super_pixel_sel;
      fw_config_clk          = sm_test4_o_config_clk;
      fw_reset_not           = sm_test4_o_reset_not;
      fw_config_in           = sm_test4_o_config_in;
      fw_config_load         = sm_test4_o_config_load;
      fw_vin_test_trig_out   = sm_test4_o_vin_test_trig_out;
      fw_scan_in             = sm_test4_o_scan_in;
      fw_scan_load           = sm_test4_o_scan_load;
    end else begin
      fw_super_pixel_sel     = 1'b0;
      fw_config_clk          = sm_test1_o_config_clk;      // Make outputs config_clk default driven by test1 output sm_test1_o_config_clk
      fw_reset_not           = 1'b1;
      fw_config_in           = 1'b0;
      fw_config_load         = 1'b1;
      fw_vin_test_trig_out   = 1'b0;
      fw_scan_in             = 1'b0;
      fw_scan_load           = 1'b0;
    end
  end

  // Create signal error_w_execute_cfg; used as a bit in fw_read_status32 to flag wrong user settings
  always @(posedge fw_axi_clk or negedge fw_rst_n) begin
    if(~fw_rst_n) begin
      error_w_execute_cfg <= 1'b0;
    end else begin
      if(test1_enable) begin
        if(sm_test1!=IDLE_IP1_T1 & (test_delay==6'h0 | test_delay==6'h1 | test_delay==6'h2 | (test_delay>fast_configclk_period))) begin
          // inferred from state machine sm_test1 logic
          error_w_execute_cfg <= 1'b1;
        end else begin
          error_w_execute_cfg <= 1'b0;
        end
      end else if(test2_enable) begin
        if(sm_test2!=IDLE_IP1_T2 & (test_delay==6'h0 | test_delay==6'h1 | test_delay==6'h2 | (test_delay>fast_configclk_period))) begin
          // inferred from state machine sm_test1 logic
          error_w_execute_cfg <= 1'b1;
        end else begin
          error_w_execute_cfg <= 1'b0;
        end
      end else if(test3_enable) begin
        // use data specific for test case test3
        error_w_execute_cfg <= 1'b0;     // TODO
      end else if(test4_enable) begin
        // use data specific for test case test4
        error_w_execute_cfg <= 1'b0;     // TODO
      end else begin
        // keep old value;
        error_w_execute_cfg <= error_w_execute_cfg;
      end
    end
  end
  //

endmodule

`endif
