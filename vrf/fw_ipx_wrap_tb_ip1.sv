// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-06-13
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-06-13  Cristian  Gingu        Created template
// 2024-06-27  Cristian Gingu         Write RTL code; implement ip1_test1 ip1_test1_inst
// 2024-07-xx  Cristian Gingu         Use sm_test3 to forward internal fast_configclk to output port fw_config_clk
// 2024-07-xx  Cristian Gingu         Use sm_test4 to forward internal slow_configclk to output port fw_config_clk
// 2024-07-09  Cristian Gingu         Clean header file Description and Author
// 2024-07-23  Cristian Gingu         Add fw_op_code_w_cfg_array_2 and fw_op_code_r_cfg_array_2
// 2024-07-23  Cristian Gingu         Change tests length from 5188 config_clk cycles to 2*5188=10376 config_clk cycles
// 2024-08-02  Cristian Gingu         Add Test 7: Test CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==2
// 2024-08-12  Cristian Gingu         Add references to src/cms_pix28_package.sv vrf/cms_pix28_package_vrf.sv
// 2024-11-11  Cristian Gingu         Add IOB input port up_event_toggle
// 2024-11-26  Cristian Gingu         Add signal and logic for cms_pix28_package::w_execute_cfg_test_gate_config_clk_IP1
// ------------------------------------------------------------------------------------
`ifndef __fw_ipx_wrap_tb_ip1__
`define __fw_ipx_wrap_tb_ip1__

`timescale 1 ns/ 1 ps

module fw_ipx_wrap_tb_ip1 ();

  // AXI side signals
  logic        fw_axi_clk;                                 // FW clock 100MHz       mapped to S_AXI_ACLK
  logic        fw_rst_n;                                   // FW reset, active low  mapped to S_AXI_ARESETN
  logic [31:0] sw_write32_0;                               // register#0 32-bit write from SW to FW
  logic [31:0] sw_read32_0;                                // register#0 32-bit read  from FW to SW
  logic [31:0] sw_read32_1;                                // register#1 32-bit read  from FW to SW
  // DUT side signals
  logic fw_pl_clk1;                                        // FM clock 400MHz       mapped to pl_clk1
  // Outputs to DUT
  logic super_pixel_sel;
  logic config_clk;
  logic reset_not;
  logic config_in;
  logic config_load;
  logic bxclk_ana;
  logic bxclk;
  logic vin_test_trig_out;
  logic scan_in;
  logic scan_load;
  // Inputs from DUT
  logic config_out;
  logic scan_out;
  logic scan_out_test;
  logic dnn_output_0;
  logic dnn_output_1;
  logic dn_event_toggle;
  logic up_event_toggle;

  fw_ipx_wrap DUT (
    //////////////////////////////
    //    AXI BUS SIGNALS       //
    //////////////////////////////
    .S_AXI_ACLK              (fw_axi_clk),                 // FW clock 100MHz       mapped to S_AXI_ACLK
    .S_AXI_ARESETN           (fw_rst_n),                   // FW reset, active low  mapped to S_AXI_ARESETN
    .sw_write32_0            (sw_write32_0),               // register#0 32-bit write from SW to FW
    .sw_read32_0             (sw_read32_0),                // register#0 32-bit read  from FW to SW (used to read DATA)
    .sw_read32_1             (sw_read32_1),                // register#1 32-bit read  from FW to SW (used to read STATUS)
    //////////////////////////////////
    // DUT side ports == FPGA pins: //
    //////////////////////////////////
    .pl_clk1                 (fw_pl_clk1),                 // FM clock 400MHz       mapped to pl_clk1
    // Outputs to DUT
    .super_pixel_sel         (super_pixel_sel),
    .config_clk              (config_clk),
    .reset_not               (reset_not),
    .config_in               (config_in),
    .config_load             (config_load),
    .bxclk_ana               (bxclk_ana),
    .bxclk                   (bxclk),
    .vin_test_trig_out       (vin_test_trig_out),
    .scan_in                 (scan_in),
    .scan_load               (scan_load),
    // Inputs from DUT
    .config_out              (config_out),
    .scan_out                (scan_out),
    .scan_out_test           (scan_out_test),
    .dnn_output_0            (dnn_output_0),
    .dnn_output_1            (dnn_output_1),
    .dn_event_toggle         (dn_event_toggle),
    .up_event_toggle         (up_event_toggle)
  );

  // Constants
  localparam fw_pl_clk1_period =  2.5;           // FM clock 400MHz       mapped to pl_clk1
  localparam fw_axi_clk_period = 10.0;           // FW clock 100MHz       mapped to S_AXI_ACLK
  //
  import cms_pix28_package::firmware_id_1;
  import cms_pix28_package::firmware_id_2;
  import cms_pix28_package::firmware_id_3;
  import cms_pix28_package::firmware_id_4;
  import cms_pix28_package::firmware_id_none;
  import cms_pix28_package::test_number_1;
  import cms_pix28_package::test_number_2;
  //
  import cms_pix28_package::op_code;
  import cms_pix28_package::OP_CODE_NOOP;
  import cms_pix28_package::OP_CODE_W_RST_FW;
  import cms_pix28_package::OP_CODE_W_CFG_STATIC_0;
  import cms_pix28_package::OP_CODE_R_CFG_STATIC_0;
  import cms_pix28_package::OP_CODE_W_CFG_STATIC_1;
  import cms_pix28_package::OP_CODE_R_CFG_STATIC_1;
  import cms_pix28_package::OP_CODE_W_CFG_ARRAY_0;
  import cms_pix28_package::OP_CODE_R_CFG_ARRAY_0;
  import cms_pix28_package::OP_CODE_W_CFG_ARRAY_1;
  import cms_pix28_package::OP_CODE_R_CFG_ARRAY_1;
  import cms_pix28_package::OP_CODE_W_CFG_ARRAY_2;
  import cms_pix28_package::OP_CODE_R_CFG_ARRAY_2;
  import cms_pix28_package::OP_CODE_R_DATA_ARRAY_0;
  import cms_pix28_package::OP_CODE_R_DATA_ARRAY_1;
  import cms_pix28_package::OP_CODE_W_STATUS_FW_CLEAR;
  import cms_pix28_package::OP_CODE_W_EXECUTE;
  //
  import cms_pix28_package::w_execute_cfg_test_delay_index_min_IP1;
  import cms_pix28_package::w_execute_cfg_test_delay_index_max_IP1;
  import cms_pix28_package::w_execute_cfg_test_sample_index_min_IP1;
  import cms_pix28_package::w_execute_cfg_test_sample_index_max_IP1;
  import cms_pix28_package::w_execute_cfg_test_number_index_min_IP1;
  import cms_pix28_package::w_execute_cfg_test_number_index_max_IP1;
  import cms_pix28_package::w_execute_cfg_test_loopback_IP1;
  import cms_pix28_package::w_execute_cfg_test_gate_config_clk_IP1;
  import cms_pix28_package::w_execute_cfg_test_spare_index_min_IP1;
  import cms_pix28_package::w_execute_cfg_test_spare_index_max_IP1;
  import cms_pix28_package::w_execute_cfg_test_mask_reset_not_index_IP1;
  //
  import cms_pix28_package::status_index_test1_done;
  import cms_pix28_package::status_index_test2_done;
  //
  import cms_pix28_package_vrf::tb_err_index_fast_configclk_period_IP1;
  import cms_pix28_package_vrf::tb_err_index_slow_configclk_period_IP1;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_static_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_static_1;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_1;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_2;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_data_array_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_data_array_1;
  import cms_pix28_package_vrf::tb_err_index_test1;
  import cms_pix28_package_vrf::tb_err_index_test2;
  //
  // Test Signals
  string  tb_testcase;
  integer tb_number;
  integer tb_i_test;
  logic   tb_fw_pl_clk1_initial;
  logic   tb_fw_axi_clk_initial;
  logic [31:0] tb_err;
  real         tb_time_t1;
  real         tb_time_t2;
  //
  logic [3:0]  tb_firmware_id;
  op_code      tb_function_id;
  logic [23:0] tb_sw_write24_0;
  //
  // IP2: Signals related with w_cfg_static_0_reg
  logic [5:0]  tb_bxclk_period;
  logic [4:0]  tb_bxclk_delay;
  logic        tb_bxclk_delay_sign;
  // IP1: Signals related with w_cfg_static_0_reg
  logic [6:0]  tb_fast_configclk_period;
  logic        tb_super_pix_sel;                           // this signal is defined in both IP1 and IP2
  // IP1: Signals related with w_cfg_static_1_reg (and part of w_cfg_static_0_reg)
  logic [26:0] tb_slow_configclk_period;
  // IP1: Signals related with w_cfg_array_0/1/2_reg
  logic [255:0][15:0] tb_w_cfg_array_counter;
  logic [255:0][15:0] tb_w_cfg_array_random;
  // IP1: Signals related with w_execute: test_number/delay/sample, etc
  logic [6:0]  tb_test_delay;                              // on clock domain fw_axi_clk
  logic [6:0]  tb_test_sample;                             // on clock domain fw_axi_clk
  logic [3:0]  tb_test_number;                             // on clock domain fw_axi_clk
  logic        tb_test_loopback;                           // on clock domain fw_axi_clk
  logic        tb_test_gate_config_clk;                    // on clock domain fw_axi_clk
  logic        tb_test_mask_reset_not;                     // on clock domain fw_axi_clk

  // Generate free running fw_pl_clk1;           // FM clock 400MHz       mapped to pl_clk1
  always begin: gen_fw_pl_clk1
    fw_pl_clk1 = tb_fw_pl_clk1_initial;          //1'b0;
    #(fw_pl_clk1_period / 2);
    fw_pl_clk1 = ~fw_pl_clk1;                    //1'b1;
    #(fw_pl_clk1_period / 2);
  end

  // Generate free running fw_axi_clk;           // FW clock 100MHz       mapped to S_AXI_ACLK
  always begin: gen_fw_axi_clk
    fw_axi_clk = tb_fw_axi_clk_initial;          //1'b0;
    #(fw_axi_clk_period / 2);
    fw_axi_clk = ~fw_axi_clk;                    //1'b1;
    #(fw_axi_clk_period / 2);
  end

  // Generate fw_rst_n;                          // FW reset, active low  mapped to S_AXI_ARESETN
  task axi_reset;
    begin
      @(negedge fw_axi_clk);
      fw_rst_n = 1'b0;
      #(fw_axi_clk_period*$urandom_range(5, 1));
      fw_rst_n = 1'b1;
      #(fw_axi_clk_period*$urandom_range(5, 1));
    end
  endtask

  // Inputs from DUT
  always @(posedge fw_axi_clk) begin
    // arbitrary one clock delay
    config_out    <= config_in;
    scan_out      <=  scan_in;
    scan_out_test <= ~scan_in;
  end
  assign dnn_output_0        = 1'b0;
  assign dnn_output_1        = 1'b0;
  assign dn_event_toggle     = 1'b0;
  assign up_event_toggle     = 1'b0;

  function void initialize();
    // SW side signals
    sw_write32_0             = 32'h0;
    tb_sw_write24_0          = 24'h0;
  endfunction

  function logic [255:0][15:0] counter_cfg_array();
    logic [255:0][15:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
//      my_cfg_array[i][ 7:0] = i       & 8'hFF;
//      my_cfg_array[i][15:8] = (255-i) & 8'hFF;
//      my_cfg_array[i][ 7:0] = (i+1) & 8'hFF;
      if(i==135) begin
        my_cfg_array[i][ 7:0] = 8'hE7;
        my_cfg_array[i][15:8] = 8'hFF;
      end else if(i==136) begin
        my_cfg_array[i][ 7:0] = 8'h81;
        my_cfg_array[i][15:8] = 8'hC3;
      end else begin
        my_cfg_array[i][ 7:0] = 8'h01;
        my_cfg_array[i][15:8] = 8'h00;
      end
    end
    return my_cfg_array;
  endfunction

  function logic [255:0][15:0] random_cfg_array();
    logic [255:0][15:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
      if(i==135) begin
        // the 16-bits after 256*16+256*16+135*16==4096+4096+2160==10352 up to 10352+16-1==10368-1 are (2*5188==10376):
        my_cfg_array[i] = 16'h137F;
      end else if(i==136) begin
        // the 16-bits after 256*16+256*16+136*16==4096+4096+2176==10368 up to 10368+16-1==10384-1 are (2*5188==10376):
        my_cfg_array[i] = 16'h00E7;    // E7 will be the last byte of 2*5188/8=10376-bits/8=1297-bytes of the configuration
      end else begin
        my_cfg_array[i] = $urandom_range(2**16-1, 0) & 16'hFFFF;
      end
    end
    return my_cfg_array;
  endfunction

  task w_cfg_static_0_and_1_random;
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_fast_configclk_period = $urandom_range(10,100) & 7'h7F;                 // arbitrary chosen limits: fast_configclk between 10MHz and 1MHz
    tb_super_pix_sel         = $urandom_range(1, 0)   & 1'h1;
    tb_slow_configclk_period = $urandom_range(100,100000000) & 27'h7FFFFFF;    // arbitrary chosen limits: slow_configclk between 1MHz  and 1Hz
    // execute OP_CODE_W_CFG_STATIC_0
    tb_function_id = OP_CODE_W_CFG_STATIC_0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_slow_configclk_period[15:0], tb_super_pix_sel, tb_fast_configclk_period};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
    #(1*fw_axi_clk_period);
    // execute OP_CODE_W_CFG_STATIC_1
    tb_function_id = OP_CODE_W_CFG_STATIC_1;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 13'h0, tb_slow_configclk_period[26:16]};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
    #(1*fw_axi_clk_period);
    // display helper
    $display("time=%06.2f tb_i_test=%02d tb_slow_configclk_period=%09d tb_super_pix_sel=%01d tb_fast_configclk_period=%03d", $realtime(), tb_i_test, tb_slow_configclk_period, tb_super_pix_sel, tb_fast_configclk_period);
  endtask

  task w_cfg_static_0_and_1_fixed;
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    // execute OP_CODE_W_CFG_STATIC_0
    tb_function_id = OP_CODE_W_CFG_STATIC_0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_slow_configclk_period[15:0], tb_super_pix_sel, tb_fast_configclk_period};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
    #(1*fw_axi_clk_period);
    // execute OP_CODE_W_CFG_STATIC_1
    tb_function_id = OP_CODE_W_CFG_STATIC_1;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 13'h0, tb_slow_configclk_period[26:16]};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
    #(1*fw_axi_clk_period);
    // display helper
    $display("time=%06.2f tb_i_test=%02d tb_slow_configclk_period=%09d tb_super_pix_sel=%01d tb_fast_configclk_period=%03d", $realtime(), tb_i_test, tb_slow_configclk_period, tb_super_pix_sel, tb_fast_configclk_period);
  endtask

  task w_cfg_static_fixed(integer index);
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(index%2==0) tb_function_id = OP_CODE_W_CFG_STATIC_0; else tb_function_id = OP_CODE_W_CFG_STATIC_1;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 11'b0, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
    #(1*fw_axi_clk_period);
    $display("time=%06.2f tb_bxclk_period=%02d tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d tb_super_pix_sel=%01d", $realtime(), tb_bxclk_period, tb_bxclk_delay, tb_bxclk_delay_sign, tb_super_pix_sel);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 11'b0, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
  endtask

  task w_cfg_array_0_counter();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_CFG_ARRAY_0;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = tb_w_cfg_array_counter[i_addr];
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      #(1*fw_axi_clk_period);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_cfg_array_1_random();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_CFG_ARRAY_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = tb_w_cfg_array_random[i_addr];
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      #(1*fw_axi_clk_period);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_cfg_array_2_mixed();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_CFG_ARRAY_2;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      if(i_addr%2==0)
        tb_sw_write24_0[15: 0] = tb_w_cfg_array_counter[i_addr];
      else
        tb_sw_write24_0[15: 0] = tb_w_cfg_array_random[i_addr];
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      #(1*fw_axi_clk_period);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_status_clear();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_STATUS_FW_CLEAR;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_reset();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_RST_FW;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_execute();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_EXECUTE;
    tb_sw_write24_0[w_execute_cfg_test_delay_index_max_IP1         : w_execute_cfg_test_delay_index_min_IP1         ] = tb_test_delay;
    tb_sw_write24_0[w_execute_cfg_test_sample_index_max_IP1        : w_execute_cfg_test_sample_index_min_IP1        ] = tb_test_sample;
    tb_sw_write24_0[w_execute_cfg_test_number_index_max_IP1        : w_execute_cfg_test_number_index_min_IP1        ] = tb_test_number;
    tb_sw_write24_0[w_execute_cfg_test_loopback_IP1                                                                 ] = tb_test_loopback;
    tb_sw_write24_0[w_execute_cfg_test_gate_config_clk_IP1                                                          ] = tb_test_gate_config_clk;
    tb_sw_write24_0[w_execute_cfg_test_spare_index_max_IP1         : w_execute_cfg_test_spare_index_min_IP1         ] = 3'h0;
    tb_sw_write24_0[w_execute_cfg_test_mask_reset_not_index_IP1                                                     ] = tb_test_mask_reset_not;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    $display("time=%06.2f tb_test_number=%01d tb_test_delay=%03d tb_test_sample=%03d tb_test_loopback=%01d tb_test_gate_config_clk=%01d tb_test_mask_reset_not=%01d",
      $realtime(), tb_test_number, tb_test_delay, tb_test_sample, tb_test_loopback, tb_test_gate_config_clk, tb_test_mask_reset_not);
    //fw_op_code_w_execute     = 1'b0;
    //sw_write24_0             = 24'h0;
  endtask

  task check_fast_slow_configclk_period();
    begin
      // $time returns the current simulation time as a 64-bit unsigned integer
      // $stime returns the lower 32-bits of the current simulation time as an unsigned integer.
      // $realtime returns the current simulation time as a real number.
      // 1. CHECK fast_configclk PERIOD
      @(posedge DUT.fw_ip1_inst.fast_configclk); tb_time_t1 = $realtime();
      @(posedge DUT.fw_ip1_inst.fast_configclk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_fast_configclk_period * fw_axi_clk_period) begin
        $display("time=%06.2f FAIL PERIOD fast_configclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_fast_configclk_period=%03d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_fast_configclk_period);
        tb_err[tb_err_index_fast_configclk_period_IP1]=1'b1;
      end
      // 2. CHECK slow_configclk PERIOD
      @(posedge DUT.fw_ip1_inst.slow_configclk); tb_time_t1 = $realtime();
      @(posedge DUT.fw_ip1_inst.slow_configclk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_slow_configclk_period * fw_axi_clk_period) begin
        $display("time=%06.2f FAIL PERIOD slow_configclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_slow_configclk_period=%06d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_slow_configclk_period);
        tb_err[tb_err_index_slow_configclk_period_IP1]=1'b1;
      end
      @(negedge fw_axi_clk);           // ensure exit on FE of AXI CLK
    end
  endtask

  task check_fast_configclk_period_test3();
    begin
      // 1. CHECK fast_configclk PERIOD
      @(posedge DUT.config_clk); tb_time_t1 = $realtime();
      @(posedge DUT.config_clk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_fast_configclk_period * fw_axi_clk_period) begin
        $display("time=%06.2f FAIL PERIOD fast_configclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_fast_configclk_period=%03d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_fast_configclk_period);
        tb_err[tb_err_index_fast_configclk_period_IP1]=1'b1;
      end
      @(negedge fw_axi_clk);           // ensure exit on FE of AXI CLK
    end
  endtask

  task check_slow_configclk_period_test4();
    begin
      // 2. CHECK slow_configclk PERIOD
      @(posedge DUT.config_clk); tb_time_t1 = $realtime();
      @(posedge DUT.config_clk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_slow_configclk_period * fw_axi_clk_period) begin
        $display("time=%06.2f FAIL PERIOD slow_configclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_slow_configclk_period=%06d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_slow_configclk_period);
        tb_err[tb_err_index_slow_configclk_period_IP1]=1'b1;
      end
      @(negedge fw_axi_clk);           // ensure exit on FE of AXI CLK
    end
  endtask

  task check_r_cfg_static_0_and_1();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    // execute OP_CODE_R_CFG_STATIC_0
    tb_function_id = OP_CODE_R_CFG_STATIC_0;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    if(sw_read32_0 != {8'h0, tb_slow_configclk_period[15:0], tb_super_pix_sel, tb_fast_configclk_period}) begin
      $display("time=%06.2f FAIL op_code_r_cfg_static_0 sw_read32_0=0x%08h expected 0x%08h", $realtime(), sw_read32_0, {8'h0, tb_slow_configclk_period[15:0], tb_super_pix_sel, tb_fast_configclk_period});
      tb_err[tb_err_index_op_code_r_cfg_static_0]=1'b1;
    end
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
    #(1*fw_axi_clk_period);
    // execute OP_CODE_R_CFG_STATIC_1
    tb_function_id = OP_CODE_R_CFG_STATIC_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    if(sw_read32_0 != {8'h0, 13'h0, tb_slow_configclk_period[26:16]}) begin
      $display("time=%06.2f FAIL op_code_r_cfg_static_1 sw_read32_0=0x%08h expected 0x%08h", $realtime(), sw_read32_0, {8'h0, 13'h0, tb_slow_configclk_period[26:16]});
      tb_err[tb_err_index_op_code_r_cfg_static_1]=1'b1;
    end
    #(1*fw_axi_clk_period);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_cfg_array_0_counter();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_CFG_ARRAY_0;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr=i_addr+2) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(sw_read32_0 != {tb_w_cfg_array_counter[i_addr+1], tb_w_cfg_array_counter[i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_array_0 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[i_addr+1], tb_w_cfg_array_counter[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_0]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_cfg_array_1_random();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_CFG_ARRAY_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr=i_addr+2) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(sw_read32_0 != {tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_random[i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_array_1 (random) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_random[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_1]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_cfg_array_2_mixed();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_CFG_ARRAY_2;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr=i_addr+2) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(sw_read32_0 != {tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_counter[i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_array_2 (mixed) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_counter[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_2]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_0(
      integer read_n_32bit_words
    );
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_DATA_ARRAY_0;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<read_n_32bit_words; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(i_addr<128) begin
        if(sw_read32_0 != {tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_0 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]);
          tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
        end
      end else begin
        if(sw_read32_0 != {tb_w_cfg_array_random[2*(i_addr-128)+1], tb_w_cfg_array_random[2*(i_addr-128)]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_0 (random) i_addr=%03d i_addr-128=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, i_addr-128, sw_read32_0, tb_w_cfg_array_random[2*(i_addr+1-128)], tb_w_cfg_array_random[2*(i_addr-128)]);
          tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
        end
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_1(
      integer read_n_32bit_words
    );
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_DATA_ARRAY_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<read_n_32bit_words; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(i_addr<68) begin
        if(sw_read32_0 != {tb_w_cfg_array_random[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (mixed) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_random[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end else if(i_addr==68) begin
        if(sw_read32_0 != {16'h0000, 8'h00, tb_w_cfg_array_counter[2*i_addr][7:0]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (mixed) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%02h 0x%02h}", $realtime(), i_addr, sw_read32_0, 16'h0000, 8'h00, tb_w_cfg_array_counter[2*i_addr][7:0]);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end else if(i_addr>68) begin
        if(sw_read32_0 != {16'h0000, 16'h0000}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (mixed) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, 16'h0000, 16'h0000);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask



  initial begin
    //---------------------------------------------------------------------------------------------
    initialize();
    tb_testcase = "T0. initialize";
    tb_number = 0;
    tb_err = 16'b0;
    tb_w_cfg_array_counter = {256{16'h0}};
    tb_w_cfg_array_random  = {256{16'hFFFF}};
    tb_fw_pl_clk1_initial  = $urandom_range(1, 0) & 1'b1;
    tb_fw_axi_clk_initial  = $urandom_range(1, 0) & 1'b1;
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 1: axi_reset
    tb_testcase = "T1. axi_reset";
    tb_number   = 1;
    axi_reset();
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    #(10*fw_axi_clk_period);
    //---------------------------------------------------------------------------------------------
    // Test 2: w_reset() w_status_clear()
    tb_testcase = "T2. w_reset() w_status_clear()";
    tb_number   = 2;
    tb_firmware_id = firmware_id_1; w_reset(); #(5*fw_axi_clk_period); w_status_clear(); #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_2; w_reset(); #(5*fw_axi_clk_period); w_status_clear(); #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_3; w_reset(); #(5*fw_axi_clk_period); w_status_clear(); #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_4; w_reset(); #(5*fw_axi_clk_period); w_status_clear(); #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    #(5*fw_axi_clk_period);
    //---------------------------------------------------------------------------------------------
    // Test 21: IP2 related - set predefined BXCLK/ANA 40MHz with 5ns delay
    tb_testcase = "T21. IP2 related - set predefined BXCLK/ANA 40MHz with 5ns delay";
    tb_number   = 21;
    tb_firmware_id           = firmware_id_2;              // use firmware_id_2 to program BXCLK and BXCLK_ANA
    tb_bxclk_period          = 6'h0A;                      // on clock domain fw_axi_clk
    tb_bxclk_delay           = 5'h2;                       // on clock domain fw_axi_clk
    tb_bxclk_delay_sign      = 1'h0;                       // on clock domain fw_axi_clk
    tb_super_pix_sel         = 1'h0;                       // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 210;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    tb_firmware_id           = firmware_id_1;              // put back current firmware_id_1
    tb_number   = 211;
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    #(5*fw_axi_clk_period);
    //---------------------------------------------------------------------------------------------
    // Test 3: fast/slow_configclk fixed period test write/read
    tb_testcase = "T3. fast/slow_configclk fixed period test write/read";
    tb_number   = 3;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 300;
    #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_1;
    for (tb_i_test = 1; tb_i_test <= 3; tb_i_test++) begin           // use limit tb_i_test <= 8; to test all tb_slow_configclk_period; CAUTION: test-run-time very long....
      tb_fast_configclk_period = ('d10 * tb_i_test) & 7'h7F;
      tb_super_pix_sel         = tb_i_test % 2;
      tb_slow_configclk_period = (10**tb_i_test) & 27'h7FFFFFF;
      w_cfg_static_0_and_1_fixed();
      tb_number   = 301;
      // Dummy wait before doing check_fast_slow_configclk_period()
      #(5*fw_axi_clk_period);
      check_fast_slow_configclk_period();
      tb_number   = 302;
      // Dummy wait before doing check_r_cfg_static_0_and_1()
      #(5*fw_axi_clk_period);
      check_r_cfg_static_0_and_1();
      tb_number   = 303;
      // Dummy wait before next tb_i_test
      #(5*tb_slow_configclk_period);
    end
    // Dummy wait before next TEST
    #(500*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 33: using test3 - fast_configclk fixed period test write/read
    tb_testcase = "T33. using test3 - fast_configclk fixed period test write/read";
    tb_number   = 33;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 330;
    #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_1;
    //
    tb_test_delay            = 7'h06;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
    tb_test_number           = 4'h4;                       // use test_number==test_number==4'h4 to enable test3_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
    tb_test_gate_config_clk  = 1'b0;                       // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    //
    for (tb_i_test = 1; tb_i_test <= 3; tb_i_test++) begin           // use maximum tb_i_test <= 8; to test all tb_slow_configclk_period; CAUTION: test-run-time very long....
      tb_fast_configclk_period = ('d10 * tb_i_test) & 7'h7F;
      tb_super_pix_sel         = tb_i_test % 2;
      tb_slow_configclk_period = (10**tb_i_test) & 27'h7FFFFFF;
      w_cfg_static_0_and_1_fixed();
      tb_number   = 331;
      // Dummy wait before doing check_r_cfg_static_0_and_1()
      #(5*fw_axi_clk_period);
      check_r_cfg_static_0_and_1();
      tb_number   = 332;
      // Dummy wait before doing w_execute();
      #(5*fw_axi_clk_period);
      w_execute();
      tb_number   = 333;
      // Dummy wait before doing check_fast_configclk_period_test3()
      #(2*fw_axi_clk_period*tb_slow_configclk_period);
      check_fast_configclk_period_test3();
      tb_number   = 334;
      // Dummy wait before next tb_i_test
      #(2*fw_axi_clk_period*tb_slow_configclk_period);
    end
    // Dummy wait before next TEST
    #(500*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 34: using test4 - slow_configclk fixed period test write/read
    tb_testcase = "T34. using test4 - slow_configclk fixed period test write/read";
    tb_number   = 34;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 340;
    #(5*fw_axi_clk_period);
    tb_firmware_id = firmware_id_1;
    //
    tb_test_delay            = 7'h06;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
    tb_test_number           = 4'h8;                       // use test_number==test_number==4'h4 to enable test3_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
    tb_test_gate_config_clk  = 1'b0;                       // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    //
    for (tb_i_test = 1; tb_i_test <= 3; tb_i_test++) begin           // use maximum tb_i_test <= 8; to test all tb_slow_configclk_period; CAUTION: test-run-time very long....
      tb_fast_configclk_period = ('d10 * tb_i_test) & 7'h7F;
      tb_super_pix_sel         = tb_i_test % 2;
      tb_slow_configclk_period = (10**tb_i_test) & 27'h7FFFFFF;
      w_cfg_static_0_and_1_fixed();
      tb_number   = 341;
      // Dummy wait before doing check_r_cfg_static_0_and_1()
      #(5*fw_axi_clk_period);
      check_r_cfg_static_0_and_1();
      tb_number   = 342;
      // Dummy wait before doing w_execute();
      #(5*fw_axi_clk_period);
      w_execute();
      tb_number   = 343;
      // Dummy wait before doing check_slow_configclk_period_test4()
      #(2*fw_axi_clk_period*tb_slow_configclk_period);
      check_slow_configclk_period_test4();
      tb_number   = 344;
      // Dummy wait before next tb_i_test
      #(2*fw_axi_clk_period*tb_slow_configclk_period);
    end
    // Dummy wait before next tb_i_test
    #(500*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 5: cfg_array_0/1/2 write/read counter/random
    tb_testcase = "T5. cfg_array_0/1/2 write/read counter/random";
    tb_number   = 5;
    tb_w_cfg_array_counter = counter_cfg_array();
    tb_w_cfg_array_random  = random_cfg_array();
    tb_firmware_id       = firmware_id_1;
    #(5*fw_axi_clk_period);
    tb_number   = 501;
    // WRITE fw_op_code_w_cfg_array_0
    w_cfg_array_0_counter();
    tb_number   = 502;
    // WRITE fw_op_code_w_cfg_array_1
    w_cfg_array_1_random();
    tb_number   = 503;
    // WRITE fw_op_code_w_cfg_array_2
    w_cfg_array_2_mixed();
    tb_number   = 504;
    // READ fw_op_code_r_cfg_array_0
    check_r_cfg_array_0_counter();
    tb_number   = 505;
    // READ fw_op_code_r_cfg_array_1
    check_r_cfg_array_1_random();
    tb_number   = 506;
    // READ fw_op_code_r_cfg_array_2
    check_r_cfg_array_2_mixed();
    tb_number   = 507;
    tb_firmware_id         = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 6: Test CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==1
    tb_testcase = "T6. CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister ip1_test1";
    tb_number   = 6;
    tb_firmware_id         = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();                                             // do reset fast/slow config clock counters to prepare for new period settings (simulation only)
    tb_number   = 600;
    #(5*fw_axi_clk_period);
    // Use following defined tb_fast/slow_configclk_period parameters, configure w_cfg_static_0_and_1_fixed() bits:
    tb_i_test                = 0;
    tb_fast_configclk_period = ('d100) & 7'h7F;            // 100MHz/100  => 1MHz
    tb_super_pix_sel         = 1'b1;
    tb_slow_configclk_period = ('d1000) & 27'h7FFFFFF;     // 100MHz/1000 => 100KHz; NOT USED in TEST_NUMBER==1
    for (tb_i_test = 0; tb_i_test <= 3; tb_i_test++) begin
      w_cfg_static_0_and_1_fixed();
      tb_number   = 601;
      #(5*fw_axi_clk_period);
      check_r_cfg_static_0_and_1();
      tb_number   = 602;
      #(5*fw_axi_clk_period);
      check_fast_slow_configclk_period();
      tb_number   = 603;
      #(5*fw_axi_clk_period);
      w_cfg_array_0_counter();
      tb_number   = 604;
      #(5*fw_axi_clk_period);
      w_cfg_array_1_random();
      tb_number   = 605;
      w_cfg_array_2_mixed();
      tb_number   = 606;
      // Dummy wait before w_execute();
      #(5*tb_slow_configclk_period);
      // Use following defined tb_test_* parameters for IP1 test1, configure w_execute() bits:
      tb_test_delay            = {1'b0, (tb_fast_configclk_period[6:1]+6'h1)};          // on clock domain fw_axi_clk, make it half tb_fast_configclk_period such as to align serial-data-out with FE of config-clk
      tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
      tb_test_number           = test_number_1;              // use test_number==4'h1 to enable test1_enable
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      tb_test_gate_config_clk  = $urandom_range(1, 0) & 1'b1;// on clock domain fw_axi_clk
      w_execute();
      $display("time=%06.2f tb_i_test=%01d w_execute() completed", $realtime(), tb_i_test);
      tb_number   = 607;
      #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                          alternatively check when bit#14 test1_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_0 256*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 608;
      #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                          alternatively check when bit#14 test1_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_1 256*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 609;
      #(150*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 138 fast_configclk cycles 138*16==2208; (4096+4096+2208==10400); alternatively check when bit#14 test1_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_2 150*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 610;
      // Check sm_test1_o_status_done bit is set in fw_read_status32_reg[14]:
      if(sw_read32_1[status_index_test1_done]==1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test%1d in loopback=%01d DONE; starting to check readout data:", $realtime(), tb_i_test, firmware_id_1, 1, tb_test_loopback);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test%1d in loopback=%01d mode NOT DONE", $realtime(), tb_i_test, firmware_id_1, 1, tb_test_loopback);
        tb_err[tb_err_index_test1] = 1'b1;
      end
      #(5*fw_axi_clk_period);
      tb_number   = 611;
      // READ DATA: done in two STEPS: first execute fw_op_code_r_data_array_0 and then execute fw_op_code_r_data_array_1.
      // The readout number of 32-bit words is (256+68)/2==324/2==162 plus one more word {28'h0, 4-bit-real-data} => 163 32-bit words; Case is for tb_test_number==1 and tb_test_loopback==HIGH/LOW
      // Step1: execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words 000-127 associated with task w_cfg_array_0_counter() OP_CODE_W_CFG_ARRAY_0
      //      : execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words 128-255 associated with task w_cfg_array_1_random()  OP_CODE_W_CFG_ARRAY_1
      $display("time=%06.2f tb_i_test=%01d starting to check readout data: calling check_r_data_array_0()...", $realtime(), tb_i_test);
      check_r_data_array_0(.read_n_32bit_words(256));
      tb_number   = 612;
      #(5*fw_axi_clk_period);
      // Step2: execute check_r_data_array_1 and readout all ONLY 138 (may read also ALL 256) 16-bit words === 69 32-bit words associated with task w_cfg_array_2_mixed() OP_CODE_W_CFG_ARRAY_2
      $display("time=%06.2f tb_i_test=%01d starting to check readout data: calling check_r_data_array_1()...", $realtime(), tb_i_test);
      check_r_data_array_1(.read_n_32bit_words(256));
      tb_number   = 613;
      #(5*fw_axi_clk_period);
    end
    //tb_firmware_id = firmware_id_none;
    //#(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 7: Test CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==2
    tb_testcase = "T7. CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister ip1_test2";
    tb_number   = 7;
    tb_firmware_id         = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();                                             // do reset fast/slow config clock counters to prepare for new period settings (simulation only)
    tb_number   = 700;
    #(5*fw_axi_clk_period);
    // Use following defined tb_fast/slow_configclk_period parameters, configure w_cfg_static_0_and_1_fixed() bits:
    tb_i_test                = 0;
    tb_fast_configclk_period = ('d12) & 7'h7F;             // 100MHz/10 => 10MHz
    tb_super_pix_sel         = 1'b1;
    tb_slow_configclk_period = ('d52) & 27'h7FFFFFF;       // 100MHz/50 => 2MHz; USED in TEST_NUMBER==2
    for (tb_i_test = 0; tb_i_test <= 3; tb_i_test++) begin
      w_cfg_static_0_and_1_fixed();
      tb_number   = 701;
      #(5*fw_axi_clk_period);
      check_r_cfg_static_0_and_1();
      tb_number   = 702;
      #(5*fw_axi_clk_period);
      check_fast_slow_configclk_period();
      tb_number   = 703;
      #(5*fw_axi_clk_period);
      w_cfg_array_0_counter();
      tb_number   = 704;
      #(5*fw_axi_clk_period);
      w_cfg_array_1_random();
      tb_number   = 705;
      w_cfg_array_2_mixed();
      tb_number   = 706;
      // Dummy wait before w_execute();
      #(5*tb_slow_configclk_period);
      // Use following defined tb_test_* parameters for IP1 test1, configure w_execute() bits:
      tb_test_delay            = {1'b0,( tb_fast_configclk_period[6:1]+6'h1)};          // on clock domain fw_axi_clk, make it half tb_fast_configclk_period such as to align serial-data-out with FE of config-clk
      tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
      tb_test_number           = test_number_2;              // use test_number==4'h2 to enable test2_enable
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      tb_test_gate_config_clk  = $urandom_range(1, 0) & 1'b1;// on clock domain fw_axi_clk
      w_execute();
      $display("time=%06.2f tb_i_test=%01d w_execute() completed", $realtime(), tb_i_test);
      tb_number   = 707;
      #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                          alternatively check when bit#15 test2_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_0 256*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 708;
      #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                          alternatively check when bit#15 test2_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_1 256*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 709;
      #(140*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 138 fast_configclk cycles 138*16==2208; (4096+4096+2208==10400); alternatively check when bit#15 test2_done is set in fw_read_status32_reg[14] <= sm_test1_o_status_done;
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_2 150*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 710;
      #(25*16*tb_slow_configclk_period*fw_axi_clk_period);      // execution: wait for  25 slow_configclk cycles
      $display("time=%06.2f tb_i_test=%01d ... done waiting cfg_array_2 150*16*%03d*%03.1f ns ", $realtime(), tb_i_test, tb_fast_configclk_period, fw_axi_clk_period);
      tb_number   = 711;
      // Check sm_test1_o_status_done bit is set in fw_read_status32_reg[14]:
      if(sw_read32_1[status_index_test2_done]==1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test%1d in loopback=%01d DONE; starting to check readout data:", $realtime(), tb_i_test, firmware_id_1, 2, tb_test_loopback);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test%1d in loopback=%01d mode NOT DONE", $realtime(), tb_i_test, firmware_id_1, 2, tb_test_loopback);
        tb_err[tb_err_index_test2] = 1'b1;
      end
      #(5*fw_axi_clk_period);
      tb_number   = 712;
      // READ DATA: done in two STEPS: first execute fw_op_code_r_data_array_0 and then execute fw_op_code_r_data_array_1.
      // The readout number of 32-bit words is (256+68)/2==324/2==162 plus one more word {28'h0, 4-bit-real-data} => 163 32-bit words; Case is for tb_test_number==2 and tb_test_loopback==HIGH/LOW
      // Step1: execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words 000-127 associated with task w_cfg_array_0_counter() OP_CODE_W_CFG_ARRAY_0
      //      : execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words 128-255 associated with task w_cfg_array_1_random()  OP_CODE_W_CFG_ARRAY_1
      $display("time=%06.2f tb_i_test=%01d starting to check readout data: calling check_r_data_array_0()...", $realtime(), tb_i_test);
      check_r_data_array_0(.read_n_32bit_words(256));
      tb_number   = 713;
      #(5*fw_axi_clk_period);
      // Step2: execute check_r_data_array_1 and readout all ONLY 138 (may read also ALL 256) 16-bit words === 69 32-bit words associated with task w_cfg_array_2_mixed() OP_CODE_W_CFG_ARRAY_2
      $display("time=%06.2f tb_i_test=%01d starting to check readout data: calling check_r_data_array_1()...", $realtime(), tb_i_test);
      check_r_data_array_1(.read_n_32bit_words(256));
      tb_number   = 714;
      #(5*fw_axi_clk_period);
    end
    //tb_firmware_id = firmware_id_none;
    //#(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------


    // Dummy wait before next TEST
    tb_number   = 999;
    #(500*fw_axi_clk_period);

    $display("%s", {80{"-"}});
    $display("simulation done: time %06.2f tb_err = %016b", $realtime, tb_err);
    $display("%s", {80{"-"}});

    #(10*fw_axi_clk_period);
    $finish;

  end

endmodule

`endif
