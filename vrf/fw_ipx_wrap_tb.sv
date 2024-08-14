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
// 2024-07-11  Cristian Gingu         Change tests length from 768 bxclk cycles to 2*768=1536 bxclk cycles
// 2024-07-23  Cristian Gingu         Add fw_op_code_w_cfg_array_2 and fw_op_code_r_cfg_array_2
// 2024-07-23  Cristian Gingu         Add task w_cfg_array_2_mixed() task check_r_cfg_array_2_mixed()
// 2024-08-12  Cristian Gingu         Add references to src/cms_pix28_package.sv vrf/cms_pix28_package_vrf.sv
// ------------------------------------------------------------------------------------
`ifndef __fw_ipx_wrap_tb__
`define __fw_ipx_wrap_tb__

`timescale 1 ns/ 1 ps

module fw_ipx_wrap_tb ();

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
  logic dnn_output_0;
  logic dnn_output_1;
  logic dn_event_toggle;

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
    .dnn_output_0            (dnn_output_0),
    .dnn_output_1            (dnn_output_1),
    .dn_event_toggle         (dn_event_toggle)
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
  //
  import cms_pix28_package::test_number_1;
  import cms_pix28_package::test_number_2;
  import cms_pix28_package::test_number_3;
  import cms_pix28_package::test_number_4;
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
  import cms_pix28_package::w_execute_cfg_test_delay_index_min_IP2;
  import cms_pix28_package::w_execute_cfg_test_delay_index_max_IP2;
  import cms_pix28_package::w_execute_cfg_test_sample_index_min_IP2;
  import cms_pix28_package::w_execute_cfg_test_sample_index_max_IP2;
  import cms_pix28_package::w_execute_cfg_test_number_index_min_IP2;
  import cms_pix28_package::w_execute_cfg_test_number_index_max_IP2;
  import cms_pix28_package::w_execute_cfg_test_loopback_IP2;
  import cms_pix28_package::w_execute_cfg_test_vin_test_trig_out_index_min_IP2;
  import cms_pix28_package::w_execute_cfg_test_vin_test_trig_out_index_max_IP2;
  import cms_pix28_package::w_execute_cfg_test_mask_reset_not_index_IP2;
  //
  import cms_pix28_package::status_index_test1_done;
  import cms_pix28_package::status_index_test2_done;
  import cms_pix28_package::status_index_test3_done;
  //
  import cms_pix28_package_vrf::tb_err_index_bxclk_ana_period_IP2;
  import cms_pix28_package_vrf::tb_err_index_bxclk_period_IP2;
  import cms_pix28_package_vrf::tb_err_index_bxclk_phase_IP2;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_static_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_static_1;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_1;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_cfg_array_2;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_data_array_0;
  import cms_pix28_package_vrf::tb_err_index_op_code_r_data_array_1;
  import cms_pix28_package_vrf::tb_err_index_test1;
  import cms_pix28_package_vrf::tb_err_index_test2;
  import cms_pix28_package_vrf::tb_err_index_test3;
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
  logic        tb_super_pix_sel;                           // this signal is defined in both IP1 and IP2
  // IP2: Signals related with w_cfg_array_0/1_reg
  logic [255:0][15:0] tb_w_cfg_array_counter;
  logic [255:0][15:0] tb_w_cfg_array_random;
  // IP2: Signals related with w_execute: test_number/delay/sample, etc
  logic [5:0]  tb_test_delay;                              // on clock domain fw_axi_clk
  logic [5:0]  tb_test_sample;                             // on clock domain fw_axi_clk
  logic [3:0]  tb_test_number;                             // on clock domain fw_axi_clk
  logic        tb_test_loopback;                           // on clock domain fw_axi_clk
  logic [5:0]  tb_test_trig_out_phase;                     // on clock domain fw_axi_clk
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
  assign config_out          = 1'b0;
  always @(posedge fw_pl_clk1) begin
    // arbitrary one clock delay
    scan_out <= scan_in;
  end
  assign dnn_output_0        = 1'b0;
  assign dnn_output_1        = 1'b0;
  assign dn_event_toggle     = 1'b0;

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
      my_cfg_array[i][ 7:0]   = 8'h01;
      if(i==768/16-1) begin                      // 768/16  ==48
        my_cfg_array[i][15:8] = 8'hC3;
      end else if(i==2*768/16-1) begin           // 2*768/16==96
        my_cfg_array[i][15:8] = 8'hE7;
      end else begin
        my_cfg_array[i][15:8] = 8'h00;
      end
    end
    return my_cfg_array;
  endfunction

  function logic [255:0][15:0] random_cfg_array();
    logic [255:0][15:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
      my_cfg_array[i] = $urandom_range(2**16-1, 0) & 16'hFFFF;
    end
    return my_cfg_array;
  endfunction

  task w_cfg_static_random(integer index);
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(index%2==0) tb_function_id = OP_CODE_W_CFG_STATIC_0; else tb_function_id = OP_CODE_W_CFG_STATIC_1;
    //if(tb_i_test%3==0) tb_bxclk_period = 6'h0A;                    //(400/10=40MHz)
    //if(tb_i_test%3==1) tb_bxclk_period = 6'h14;                    //(400/20=20MHz)
    //if(tb_i_test%3==2) tb_bxclk_period = 6'h28;                    //(400/40=10MHz)
    //tb_bxclk_period                    = 6'h0A;
    tb_bxclk_period          = $urandom_range(40, 10)               & 6'h3F;   //6'h0A => 40MHz
    tb_bxclk_delay           = $urandom_range(tb_bxclk_period/2, 0) & 5'h1F;   //5'h2;
    tb_bxclk_delay_sign      = $urandom_range(1, 0)                 & 1'h1;
    tb_super_pix_sel         = $urandom_range(1, 0)                 & 1'h1;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 11'b0, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
    #(1*fw_axi_clk_period);
    $display("time=%06.2f tb_i_test=%02d tb_bxclk_period=%02d tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d tb_super_pix_sel=%01d", $realtime(), tb_i_test, tb_bxclk_period, tb_bxclk_delay, tb_bxclk_delay_sign, tb_super_pix_sel);
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
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
    tb_sw_write24_0[w_execute_cfg_test_delay_index_max_IP2             : w_execute_cfg_test_delay_index_min_IP2             ] = tb_test_delay;
    tb_sw_write24_0[w_execute_cfg_test_sample_index_max_IP2            : w_execute_cfg_test_sample_index_min_IP2            ] = tb_test_sample;
    tb_sw_write24_0[w_execute_cfg_test_number_index_max_IP2            : w_execute_cfg_test_number_index_min_IP2            ] = tb_test_number;
    tb_sw_write24_0[w_execute_cfg_test_loopback_IP2                                                                     ] = tb_test_loopback;
    tb_sw_write24_0[w_execute_cfg_test_vin_test_trig_out_index_max_IP2 : w_execute_cfg_test_vin_test_trig_out_index_min_IP2 ] = tb_test_trig_out_phase;
    tb_sw_write24_0[w_execute_cfg_test_mask_reset_not_index_IP2                                                         ] = tb_test_mask_reset_not;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    $display("time=%06.2f tb_test_number=0x%01h tb_test_delay=0x%02h tb_test_sample=0x%02h tb_test_loopback=0x%01h tb_test_trig_out_phase=0x%02h tb_test_mask_reset_not=0x%01h",
      $realtime(), tb_test_number, tb_test_delay, tb_test_sample, tb_test_loopback, tb_test_trig_out_phase, tb_test_mask_reset_not);
    //fw_op_code_w_execute     = 1'b0;
    //sw_write24_0             = 24'h0;
  endtask

  task check_bxclk_period_and_delay();
    begin
      // $time returns the current simulation time as a 64-bit unsigned integer
      // $stime returns the lower 32-bits of the current simulation time as an unsigned integer.
      // $realtime returns the current simulation time as a real number.
      // 1. CHECK fw_bxclk_ana PERIOD
      @(posedge bxclk_ana); tb_time_t1 = $realtime();
      @(posedge bxclk_ana); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_bxclk_period * fw_pl_clk1_period) begin
        $display("time=%06.2f FAIL PERIOD fw_bxclk_ana: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f bxclk_period=%02d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_bxclk_period);
        tb_err[tb_err_index_bxclk_ana_period_IP2]=1'b1;
      end
      // 2. CHECK fw_bxclk PERIOD
      @(posedge bxclk); tb_time_t1 = $realtime();
      @(posedge bxclk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_bxclk_period * fw_pl_clk1_period) begin
        $display("time=%06.2f FAIL PERIOD fw_bxclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f bxclk_period=%02d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_bxclk_period);
        tb_err[tb_err_index_bxclk_period_IP2]=1'b1;
      end
      // 3. CHECK fw_bxclk vs fw_bxclk_ana PHASE DELAY
      if(tb_bxclk_delay_sign==1'b0) begin
        @(posedge bxclk_ana); tb_time_t1 = $realtime();
        @(posedge bxclk    ); tb_time_t2 = $realtime();
        // bxclk_delay_sign is ZERO. The RE of bxclk is after RE of bxclk_ana by bxclk_delay ticks.
        // keep bxclk LOW for bxclk_delay; then HIGH for bxclk_period/2; then again LOW for bxclk_period/2-bxclk_delay
      end
      if(tb_bxclk_delay_sign==1'b1) begin
        @(posedge bxclk_ana); tb_time_t1 = $realtime();
        @(negedge bxclk    ); tb_time_t2 = $realtime();
        // bxclk_delay_sign is ONE. The FE of bxclk is after RE of bxclk_ana by bxclk_delay ticks
        // keep bxclk HIGH for bxclk_delay; then LOW for bxclk_period/2; then again HIGH for bxclk_period/2-bxclk_delay
      end
      if(tb_bxclk_delay==0) begin
        // in this case the signals are either in phase (if tb_bxclk_delay_sign==1'b0) or inverted (if tb_bxclk_delay_sign==1'b1)
        if(tb_time_t2-tb_time_t1 != tb_bxclk_period * fw_pl_clk1_period) begin
          $display("time=%06.2f FAIL DELAY fw_bxclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_bxclk_delay, tb_bxclk_delay_sign);
          tb_err[tb_err_index_bxclk_phase_IP2]=1'b1;
        end
      end else begin
        if(tb_time_t2-tb_time_t1 != tb_bxclk_delay * fw_pl_clk1_period) begin
          $display("time=%06.2f FAIL DELAY fw_bxclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_bxclk_delay, tb_bxclk_delay_sign);
          tb_err[tb_err_index_bxclk_phase_IP2]=1'b1;
        end
      end
      @(negedge fw_axi_clk);           // ensure exit on FE of AXI CLK
    end
  endtask

  task check_r_cfg_static(integer index);
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(index%2==0) tb_function_id = OP_CODE_R_CFG_STATIC_0; else tb_function_id = OP_CODE_R_CFG_STATIC_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    if(sw_read32_0 != {11'h0, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period}) begin
      $display("time=%06.2f FAIL op_code_r_cfg_static_0 sw_read32_0=0x%08h expected 0x%08h", $realtime(), sw_read32_0, {11'h0, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period});
      tb_err[tb_err_index_op_code_r_cfg_static_0]=1'b1;
    end
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

  task check_r_data_array_0_counter(
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
      if(sw_read32_0 != {tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_0 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]);
        tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
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
    tb_err = 32'b0;
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
    //---------------------------------------------------------------------------------------------
    // Test 3: BXCLK/ANA random period and delay test write/read
    tb_testcase = "T3. BXCLK/ANA random period and delay test write/read";
    tb_number   = 3;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    //tb_bxclk_period          = 6'h0A;                      // on clock domain fw_axi_clk
    //tb_bxclk_delay           = 5'h2;                       // on clock domain fw_axi_clk
    //tb_bxclk_delay_sign      = 1'h0;                       // on clock domain fw_axi_clk
    //tb_super_pix_sel         = 1'h0;                       // on clock domain fw_axi_clk
    //w_cfg_static_fixed(0);
    //tb_number   = 502;                                     // BXCLK/ANA is programmed
    //#(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    for (integer i=0; i<2; i++) begin
      for (tb_i_test = 0; tb_i_test < 50; tb_i_test++) begin
        tb_firmware_id = firmware_id_2;
        // Randomize sw_write24_0 content and issue fw_op_code_w_cfg_static_0 for ONE fw_axi_clk_period
        w_cfg_static_random(.index(i));
        tb_number   = 301;
        // Dummy wait before doing check_bxclk_period_and_delay()
        #(5*fw_axi_clk_period);
        if(i==0) check_bxclk_period_and_delay();
        tb_number   = 302;
        // Dummy wait before doing check_r_cfg_static()
        #(5*fw_axi_clk_period);
        check_r_cfg_static(.index(i));
        tb_number   = 303;
        // Dummy wait before disable tb_firmware_id => clocks will become ZERO
        #(5*fw_axi_clk_period);
        tb_firmware_id = firmware_id_none;
        tb_number   = 304;
        // Dummy wait before next tb_i_test
        #(5*fw_axi_clk_period);
      end
    end
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 4: cfg_array_0/1/2 write/read counter/random/mixed
    tb_testcase = "T4. cfg_array_0/1/2 write/read counter/random/mixed";
    tb_number   = 4;
    tb_w_cfg_array_counter = counter_cfg_array();
    tb_w_cfg_array_random  = random_cfg_array();
    tb_firmware_id       = firmware_id_2;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 401;
    // WRITE fw_op_code_w_cfg_array_0
    w_cfg_array_0_counter();
    tb_number   = 402;
    // WRITE fw_op_code_w_cfg_array_1
    w_cfg_array_1_random();
    tb_number   = 403;
    // WRITE fw_op_code_w_cfg_array_2
    w_cfg_array_2_mixed();
    tb_number   = 404;
    // READ fw_op_code_r_cfg_array_0
    check_r_cfg_array_0_counter();
    tb_number   = 405;
    // READ fw_op_code_r_cfg_array_1
    check_r_cfg_array_1_random();
    tb_number   = 406;
    // READ fw_op_code_r_cfg_array_2
    check_r_cfg_array_2_mixed();
    tb_number   = 407;
    tb_firmware_id         = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 5: Test SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==1
    tb_testcase = "T5. SCAN-CHAIN-MODULE as a serial-in / serial-out shift-tegister";
    tb_number   = 5;
    tb_firmware_id         = firmware_id_2;
//    w_reset();
    tb_number   = 501;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period          = 6'h0A;                      // on clock domain fw_axi_clk
    tb_bxclk_delay           = 5'h2;                       // on clock domain fw_axi_clk
    tb_bxclk_delay_sign      = 1'h0;                       // on clock domain fw_axi_clk
    tb_super_pix_sel         = 1'h0;                       // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 502;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    tb_test_delay            = 6'h08;                      // on clock domain fw_axi_clk
    tb_test_sample           = 6'h04;                      // on clock domain fw_axi_clk
    tb_test_number           = test_number_1;              // on clock domain fw_axi_clk
    tb_test_loopback         = 1'b0;                       // on clock domain fw_axi_clk
    tb_test_trig_out_phase   = 6'h00;                      // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    w_execute();
    tb_number   = 503;
    #(2*770*tb_bxclk_period*fw_pl_clk1_period);            // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    if(sw_read32_1[status_index_test1_done]==1'b1) begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), tb_firmware_id, tb_test_loopback);
    end else begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d mode NOT DONE", $realtime(), tb_firmware_id, tb_test_loopback);
      tb_err[tb_err_index_test1] = 1'b1;
    end
    #(10*fw_axi_clk_period);
    tb_number   = 504;
    // READ fw_op_code_r_data_array_0
    check_r_data_array_0_counter(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for tb_test_number==1 and tb_test_loopback==HIGH
    #(50*fw_axi_clk_period);                               // readout: wait for at least 48 AXI clock cycles
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 6: Test SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister. TEST_NUMBER==2
    tb_testcase = "T6. SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister";
    tb_number   = 6;
    tb_firmware_id         = firmware_id_2;
//    w_reset();
    tb_number   = 601;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period          = 6'h0A;                      // on clock domain fw_axi_clk
    tb_bxclk_delay           = 5'h3;                       // on clock domain fw_axi_clk
    tb_bxclk_delay_sign      = 1'h0;                       // on clock domain fw_axi_clk
    tb_super_pix_sel         = 1'h1;                       // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 602;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    tb_test_delay            = 6'h07;                      // on clock domain fw_axi_clk
    tb_test_sample           = 6'h05;                      // on clock domain fw_axi_clk
    tb_test_number           = test_number_2;              // on clock domain fw_axi_clk
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
    tb_test_trig_out_phase   = 6'h04;                      // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    w_execute();
    tb_number   = 603;
    #(2*770*tb_bxclk_period*fw_pl_clk1_period);            // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    if(sw_read32_1[status_index_test2_done]==1'b1) begin
      $display("time=%06.2f firmware_id=%01d test2 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), tb_firmware_id, tb_test_loopback);
    end else begin
      $display("time=%06.2f firmware_id=%01d test2 in loopback=%01d mode NOT DONE", $realtime(), tb_firmware_id, tb_test_loopback);
      tb_err[tb_err_index_test2] = 1'b1;
    end
    #(10*fw_axi_clk_period);
    tb_number   = 604;
    // READ fw_op_code_r_data_array_0
    check_r_data_array_0_counter(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for tb_test_number==1 and tb_test_loopback==HIGH
    #(50*fw_axi_clk_period);                               // readout: wait for at least 48 AXI clock cycles
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------



    //---------------------------------------------------------------------------------------------
    // Test 7: Test DNN ReadOut. TEST_NUMBER==3
    tb_testcase = "T7. DNN ReadOut";
    tb_number   = 7;
    tb_firmware_id         = firmware_id_2;
//    w_reset();
    tb_number   = 701;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period          = 6'h0A;                      // on clock domain fw_axi_clk
    tb_bxclk_delay           = 5'h4;                       // on clock domain fw_axi_clk
    tb_bxclk_delay_sign      = 1'h0;                       // on clock domain fw_axi_clk
    tb_super_pix_sel         = 1'h0;                       // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 702;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    tb_test_delay            = 6'h06;                      // on clock domain fw_axi_clk
    tb_test_sample           = 6'h06;                      // on clock domain fw_axi_clk
    tb_test_number           = test_number_3;              // on clock domain fw_axi_clk
    tb_test_loopback         = 1'b0;                       // on clock domain fw_axi_clk
    tb_test_trig_out_phase   = 6'h05;                      // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    w_execute();
    tb_number   = 703;
    #(2*770*tb_bxclk_period*fw_pl_clk1_period);            // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    if(sw_read32_1[status_index_test3_done]==1'b1) begin
      $display("time=%06.2f firmware_id=%01d test2 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), tb_firmware_id, tb_test_loopback);
    end else begin
      $display("time=%06.2f firmware_id=%01d test2 in loopback=%01d mode NOT DONE", $realtime(), tb_firmware_id, tb_test_loopback);
      tb_err[tb_err_index_test3] = 1'b1;
    end
    #(10*fw_axi_clk_period);
    tb_number   = 704;
    // READ fw_op_code_r_data_array_0
    check_r_data_array_0_counter(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for tb_test_number==1 and tb_test_loopback==HIGH
    #(50*fw_axi_clk_period);                               // readout: wait for at least 48 AXI clock cycles
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------



    $display("%s", {80{"-"}});
    $display("simulation done: time %06.2f tb_err = %016b", $realtime, tb_err);
    $display("%s", {80{"-"}});

    #(10*fw_axi_clk_period);
    $finish;

  end

endmodule

`endif
