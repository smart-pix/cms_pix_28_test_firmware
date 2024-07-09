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
  localparam windex_device_id_max  = 31;                   // write index for device_id       (upper)
  localparam windex_device_id_min  = 28;                   // write index for device_id       (lower)
  localparam windex_op_code_max    = 27;                   // write index for operation_code  (upper)
  localparam windex_op_code_min    = 24;                   // write index for operation_code  (lower)
  localparam windex_body_max       = 23;                   // write index for body_data       (upper)
  localparam windex_body_min       =  0;                   // write index for body_data       (lower)
  //
  typedef enum logic [3:0] {                               // operation_code enumerated type
    OP_CODE_NOOP             = 4'h0,
    OP_CODE_W_RST_FW         = 4'h1,
    OP_CODE_W_CFG_STATIC_0   = 4'h2,
    OP_CODE_R_CFG_STATIC_0   = 4'h3,
    OP_CODE_W_CFG_STATIC_1   = 4'h4,
    OP_CODE_R_CFG_STATIC_1   = 4'h5,
    OP_CODE_W_CFG_ARRAY_0    = 4'h6,
    OP_CODE_R_CFG_ARRAY_0    = 4'h7,
    OP_CODE_W_CFG_ARRAY_1    = 4'h8,
    OP_CODE_R_CFG_ARRAY_1    = 4'h9,
    OP_CODE_R_DATA_ARRAY_0   = 4'hA,
    OP_CODE_R_DATA_ARRAY_1   = 4'hB,
    OP_CODE_W_STATUS_FW_CLEAR= 4'hC,
    OP_CODE_W_EXECUTE        = 4'hD
  } op_code;
  //

  localparam w_cfg_static_0_reg_fast_configclk_period_index_min      =  0;     // fast_configCLK period is 10ns(AXI100MHz) * 2**7(7-bits) == 10*128 == 1280ns i.e. 0.78125MHz the lowest frequency, thus covering DataSheet minimum 1MHz
  localparam w_cfg_static_0_reg_fast_configclk_period_index_max      =  6;     //
  localparam w_cfg_static_0_reg_super_pix_sel_index                  =  7;     //
  localparam w_cfg_static_0_reg_slow_configclk_period_index_min      =  8;     // slow_configCLK period is 10ns(AXI100MHz) * 2**27(27-bits) == 10*134217728 == 1342177280ns i.e. 0.745Hz the lowest frequency, thus covering DataSheet minimum 1Hz
  localparam w_cfg_static_0_reg_slow_configclk_period_index_max      =  23;    // w_cfg_static_0_reg contains lower 16-bits of the 27-bit period for slow_configCLK
  localparam w_cfg_static_1_reg_slow_configclk_period_index_min      =  0;     // w_cfg_static_1_reg contains upper 11-bits of the 27-bit period for slow_configCLK
  localparam w_cfg_static_1_reg_slow_configclk_period_index_max      = 10;
  localparam w_cfg_static_1_reg_spare_index_min                      = 11;
  localparam w_cfg_static_1_reg_spare_index_max                      = 23;
  //
  localparam tb_err_index_fast_configclk_period  =  0;
  localparam tb_err_index_slow_configclk_period  =  1;
  localparam tb_err_index_op_code_r_cfg_static_0 =  2;
  localparam tb_err_index_op_code_r_cfg_static_1 =  3;
  localparam tb_err_index_op_code_r_cfg_array_0  =  4;
  localparam tb_err_index_op_code_r_cfg_array_1  =  5;
  localparam tb_err_index_op_code_r_data_array_0 =  6;
  localparam tb_err_index_op_code_r_data_array_1 =  7;
  localparam tb_err_index_test1                  =  8;
  localparam tb_err_index_test2                  =  9;
  localparam tb_err_index_test3                  = 10;
  localparam tb_err_index_test4                  = 11;
  //
  // CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. The test is configured using:
  // 1. byte#3=={fw_dev_id_enable, fw_op_code_w_execute}
  // 2. byte#2-to-byte#0==sw_write24_0 where each bit defined as follows:
  localparam w_execute_cfg_test_delay_index_min      =  0; //
  localparam w_execute_cfg_test_delay_index_max      =  6; //
  localparam w_execute_cfg_test_sample_index_min     =  7; //
  localparam w_execute_cfg_test_sample_index_max     = 13; //
  localparam w_execute_cfg_test_number_index_min     = 14; //
  localparam w_execute_cfg_test_number_index_max     = 17; //
  localparam w_execute_cfg_test_loopback             = 18; //
  localparam w_execute_cfg_spare_index_min           = 19; //
  localparam w_execute_cfg_spare_index_max           = 22; //
  localparam w_execute_cfg_test_mask_reset_not_index = 23; //
  //
  localparam logic [3:0] firmware_id_1           = 4'h1;
  localparam logic [3:0] firmware_id_2           = 4'h2;
  localparam logic [3:0] firmware_id_3           = 4'h4;
  localparam logic [3:0] firmware_id_4           = 4'h8;
  localparam logic [3:0] firmware_id_none        = 4'h0;
  //
  // Test Signals
  string  tb_testcase;
  integer tb_number;
  logic   tb_mismatch;
  integer tb_i_test;
  logic   tb_fw_pl_clk1_initial;
  logic   tb_fw_axi_clk_initial;
  logic [15:0] tb_err;
  real         tb_time_t1;
  real         tb_time_t2;
  //
  logic [3:0]  tb_firmware_id;
  op_code      tb_function_id;
  logic [23:0] tb_sw_write24_0;
  //
  // Signals related with w_cfg_static_0_reg
  logic [6:0]  tb_fast_configclk_period;
  logic        tb_super_pix_sel;
  // Signals related with w_cfg_static_1_reg (and part of w_cfg_static_0_reg)
  logic [26:0] tb_slow_configclk_period;
  // Signals related with w_cfg_array_0/1_reg
  logic [255:0][15:0] tb_w_cfg_array_counter;
  logic [255:0][15:0] tb_w_cfg_array_random;
  // Signals related with w_execute: test_number and test_delay
  logic [6:0]  tb_test_delay;                              // on clock domain fw_axi_clk
  logic [6:0]  tb_test_sample;                             // on clock domain fw_axi_clk
  logic [3:0]  tb_test_number;                             // on clock domain fw_axi_clk
  logic        tb_test_loopback;                           // on clock domain fw_axi_clk
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

  //assign config_out <= config_in;
  always @(posedge fw_axi_clk) begin
    // arbitrary one clock delay
    config_out <= config_in;
  end

  function void initialize();
    // SW side signals
    sw_write32_0             = 32'h0;
    tb_sw_write24_0          = 24'h0;
    // Inputs from DUT
    //logic config_out;
    //logic scan_out;
    //logic dnn_output_0;
    //logic dnn_output_1;
    //logic dn_event_toggle;
  endfunction

  function logic [255:0][15:0] counter_cfg_array();
    logic [255:0][15:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
//      my_cfg_array[i][ 7:0] = i       & 8'hFF;
//      my_cfg_array[i][15:8] = (255-i) & 8'hFF;
//      my_cfg_array[i][ 7:0] = (i+1) & 8'hFF;
      my_cfg_array[i][ 7:0]   = 8'h01;
      if(i==768/16-1) begin
        my_cfg_array[i][15:8] = 8'hC3;
      end else begin
        my_cfg_array[i][15:8] = 8'h00;
      end
    end
    return my_cfg_array;
  endfunction

  function logic [255:0][15:0] random_cfg_array();
    logic [255:0][15:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
      if(i==66) begin
        // the 32-bits after 256*16+66*16==4096+1056==5152 are:
        my_cfg_array[i] = 16'h0003;
      end else if(i==67) begin
        // the 32-bits after 256*16+67*16==4096+1072==5168 are:
        my_cfg_array[i] = 16'h0007;
      end else if(i==68) begin
        // the 32-bits after 256*16+68*16==4096+1088==5184 are:
        my_cfg_array[i] = 16'h000F;
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
    tb_sw_write24_0[w_execute_cfg_test_delay_index_max             : w_execute_cfg_test_delay_index_min             ] = tb_test_delay;
    tb_sw_write24_0[w_execute_cfg_test_sample_index_max            : w_execute_cfg_test_sample_index_min            ] = tb_test_sample;
    tb_sw_write24_0[w_execute_cfg_test_number_index_max            : w_execute_cfg_test_number_index_min            ] = tb_test_number;
    tb_sw_write24_0[w_execute_cfg_test_loopback                                                                     ] = tb_test_loopback;
    tb_sw_write24_0[w_execute_cfg_spare_index_max                  : w_execute_cfg_spare_index_min                  ] = 4'h0;
    tb_sw_write24_0[w_execute_cfg_test_mask_reset_not_index                                                         ] = tb_test_mask_reset_not;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(1*fw_axi_clk_period);
    $display("time=%06.2f tb_test_number=%01d tb_test_delay=%03d tb_test_sample=%03d tb_test_loopback=%01d tb_test_mask_reset_not=%01d",
      $realtime(), tb_test_number, tb_test_delay, tb_test_sample, tb_test_loopback, tb_test_mask_reset_not);
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
        tb_err[tb_err_index_fast_configclk_period]=1'b1;
      end
      // 2. CHECK slow_configclk PERIOD
      @(posedge DUT.fw_ip1_inst.slow_configclk); tb_time_t1 = $realtime();
      @(posedge DUT.fw_ip1_inst.slow_configclk); tb_time_t2 = $realtime();
      if(tb_time_t2-tb_time_t1 != tb_slow_configclk_period * fw_axi_clk_period) begin
        $display("time=%06.2f FAIL PERIOD slow_configclk: tb_time_t1=%06.2f tb_time_t2=%06.2f tb_time_t2-tb_time_t1=%06.2f tb_slow_configclk_period=%06d", $realtime(), tb_time_t1, tb_time_t2, tb_time_t2-tb_time_t1, tb_slow_configclk_period);
        tb_err[tb_err_index_slow_configclk_period]=1'b1;
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
        tb_err[tb_err_index_fast_configclk_period]=1'b1;
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
        tb_err[tb_err_index_slow_configclk_period]=1'b1;
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
    //tb_function_id           = OP_CODE_NOOP;
    //sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
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
        $display("time=%06.2f FAIL op_code_r_cfg_array_0 i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[i_addr+1], tb_w_cfg_array_counter[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_0]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    //tb_function_id           = OP_CODE_NOOP;
    //sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
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
        $display("time=%06.2f FAIL op_code_r_cfg_array_1 i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_random[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_1]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    //tb_function_id           = OP_CODE_NOOP;
    //sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
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
    //tb_function_id           = OP_CODE_NOOP;
    //sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_1_random(
      integer read_n_32bit_words
    );
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_R_DATA_ARRAY_1;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<read_n_32bit_words; i_addr++) begin
      tb_sw_write24_0[23:16] = 128 + i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = 16'hFFFF;
      sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      @(posedge fw_axi_clk);
      if(i_addr<34) begin
        // 23-bit words real-data
        if(sw_read32_0 != {tb_w_cfg_array_random[2*i_addr+1], tb_w_cfg_array_random[2*i_addr]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (random) i_addr=%03d 128+i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, 128+i_addr, sw_read32_0, tb_w_cfg_array_random[2*i_addr+1], tb_w_cfg_array_random[2*i_addr]);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end else if(i_addr==34) begin
        // 32-bit last word: contains 4-bitreal-data padded with 28-bit zero
        if(sw_read32_0 != {16'h0, tb_w_cfg_array_random[2*i_addr]}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (random) i_addr=%03d 128+i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, 128+i_addr, sw_read32_0, 16'h0, tb_w_cfg_array_random[2*i_addr]);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end else begin
        // all these 32-bit words MUST be zero, per RTL encoding
        if(sw_read32_0 != {16'h0, 16'h0}) begin
          $display("time=%06.2f FAIL op_code_r_data_array_1 (random) i_addr=%03d 128+i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, 128+i_addr, sw_read32_0, 16'h0, 16'h0);
          tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
        end
      end
      @(negedge fw_axi_clk);
    end
    //tb_function_id           = OP_CODE_NOOP;
    //sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  initial begin
    //---------------------------------------------------------------------------------------------
    initialize();
    tb_testcase = "T0. initialize";
    tb_number = 0;
    tb_mismatch = 0;
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
    // Test 2: w_status_clear
    tb_testcase = "T2. w_status_clear";
    tb_number   = 2;
    tb_firmware_id = firmware_id_1;
    w_status_clear();
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 3: fast+slow_configclk fixed period test write/read
    tb_testcase = "T30. fast+slow_configclk fixed period test write/read";
    tb_number   = 30;
    tb_firmware_id = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 300;
    #(5*fw_axi_clk_period);
    /////////////////////tb_firmware_id = firmware_id_1;
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
    // Test 33: using TEST_NUMBER==3 - fast_configclk fixed period test write/read
    tb_testcase = "T33. using TEST_NUMBER==3 - fast_configclk fixed period test write/read";
    tb_number   = 33;
    tb_firmware_id = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 330;
    #(5*fw_axi_clk_period);
    ////////////////////////tb_firmware_id = firmware_id_1;
    //
    tb_test_delay            = 7'h06;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
    tb_test_number           = (1<<2) & 4'hF;              // use test_number==test_number==4'h4 to enable test3_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
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
    // Test 34: using TEST_NUMBER==4 - slow_configclk fixed period test write/read
    tb_testcase = "T34. using TEST_NUMBER==4 - slow_configclk fixed period test write/read";
    tb_number   = 34;
    tb_firmware_id = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 340;
    #(5*fw_axi_clk_period);
    //////////////////////tb_firmware_id = firmware_id_1;
    //
    tb_test_delay            = 7'h06;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h05;                      // on clock domain fw_axi_clk
    tb_test_number           = (1<<3) & 4'hF;              // use test_number==test_number==4'h8 to enable test4_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
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
    // Dummy wait
    tb_i_test     = 0;
    #(500*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 4: cfg_array_0/1 write/read counter/random check
    tb_testcase = "T4. cfg_array_0/1 write/read counter/random check";
    tb_number   = 4;
    tb_w_cfg_array_counter = counter_cfg_array();
    tb_w_cfg_array_random  = random_cfg_array();
    tb_firmware_id       = firmware_id_1;
    #(5*fw_axi_clk_period);
    tb_number   = 401;
    // WRITE fw_op_code_w_cfg_array_0
    w_cfg_array_0_counter();
    tb_number   = 402;
    // WRITE fw_op_code_w_cfg_array_1
    w_cfg_array_1_random();
    tb_number   = 403;
    // READ fw_op_code_r_cfg_array_0
    check_r_cfg_array_0_counter();
    tb_number   = 404;
    // READ fw_op_code_r_cfg_array_1
    check_r_cfg_array_1_random();
    tb_number   = 405;
    tb_firmware_id         = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 5: Test CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==1
    tb_testcase = "T5. CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegisterr. TEST_NUMBER==1";
    tb_number   = 5;
    tb_firmware_id         = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 500;
    #(5*fw_axi_clk_period);
    // Use following defined tb_fast/slow_configclk_period parameters, configure w_cfg_static_0_and_1_fixed() bits:
    tb_fast_configclk_period = ('d100) & 7'h7F;            // 100MHz/100  => 1MHz;   fast_configclk     USED in TEST_NUMBER==1
    tb_super_pix_sel         = 1'b1;
    tb_slow_configclk_period = ('d1000) & 27'h7FFFFFF;     // 100MHz/1000 => 100KHz; slow_configclk NOT USED in TEST_NUMBER==1
    w_cfg_static_0_and_1_fixed();
    tb_number   = 501;
    // Dummy wait before doing check_r_cfg_static_0_and_1()
    #(5*fw_axi_clk_period);
    check_r_cfg_static_0_and_1();
    tb_number   = 502;
    // Dummy wait before doing check_fast_slow_configclk_period()
    #(5*fw_axi_clk_period*tb_slow_configclk_period);
    check_fast_slow_configclk_period();
    tb_number   = 503;
    #(5*fw_axi_clk_period);
    w_cfg_array_0_counter();
    tb_number   = 504;
    #(5*fw_axi_clk_period);
    w_cfg_array_1_random();
    tb_number   = 505;
    // Dummy wait before w_execute();
    #(5*fw_axi_clk_period*tb_slow_configclk_period);
    // Use following defined tb_test_* parameters for IP1 test1, configure w_execute() bits:
    tb_test_delay            = 7'h05;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h04;                      // on clock domain fw_axi_clk
    tb_test_number           = (1<<0) & 4'hF;              // use test_number==test_number==4'h1 to enable test1_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    w_execute();
    tb_number   = 506;
    #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                     alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    tb_number   = 507;
    #( 70*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 68  fast_configclk cycles 68*16 ==1088; (4096+1088==5184)s; alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    tb_number   = 508;
    // Check sm_test1_o_status_done bit is set in fw_read_status32_reg[12]:
    if(sw_read32_1[12]==1'b1) begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), firmware_id_1, tb_test_loopback);
    end else begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d mode NOT DONE", $realtime(), firmware_id_1, tb_test_loopback);
      tb_err[tb_err_index_test1] = 1'b1;
    end
    #(5*fw_axi_clk_period);
    tb_number   = 509;
    // READ DATA: done in two STEPS: first execute fw_op_code_r_data_array_0 and then execute fw_op_code_r_data_array_0.
    // The readout number of 32-bit words is (256+68)/2==324/2==162 plus one more word {28'h0, 4-bit-real-data} => 163 32-bit words; Case is for tb_test_number==1 and tb_test_loopback==HIGH
    // Step1: execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words
    $display("time=%06.2f starting to check readout data: calling check_r_data_array_0_counter()...", $realtime());
    check_r_data_array_0_counter(.read_n_32bit_words(128));
    tb_number   = 510;
    #(5*fw_axi_clk_period);
    // Step2: execute check_r_data_array_1_random and readout ONLY 68 16-bit words === 34 32-bit words
    $display("time=%06.2f starting to check readout data: calling check_r_data_array_1_random()...", $realtime());
    check_r_data_array_1_random(.read_n_32bit_words(128));
    tb_number   = 511;
    #(5*fw_axi_clk_period);
    //tb_firmware_id = firmware_id_none;
    //#(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------





    //---------------------------------------------------------------------------------------------
    // Test 6: Test CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegister. TEST_NUMBER==2
    tb_testcase = "T6. CONFIG-CLK-MODULE as a serial-in / serial-out shift-tegisterr. TEST_NUMBER==2";
    tb_number   = 6;
    tb_firmware_id         = firmware_id_1;
    #(5*fw_axi_clk_period);
    w_reset();
    tb_number   = 500;
    #(5*fw_axi_clk_period);
    // Use following defined tb_fast/slow_configclk_period parameters, configure w_cfg_static_0_and_1_fixed() bits:
    tb_fast_configclk_period = ('d10) & 7'h7F;             // 100MHz/10  => 1MHz;   fast_configclk USED in TEST_NUMBER==2
    tb_super_pix_sel         = 1'b0;
    tb_slow_configclk_period = ('d100) & 27'h7FFFFFF;      // 100MHz/100 => 100KHz; slow_configclk USED in TEST_NUMBER==2
    w_cfg_static_0_and_1_fixed();
    tb_number   = 601;
    // Dummy wait before doing check_r_cfg_static_0_and_1()
    #(5*fw_axi_clk_period);
    check_r_cfg_static_0_and_1();
    tb_number   = 602;
    // Dummy wait before doing check_fast_slow_configclk_period()
    #(5*fw_axi_clk_period*tb_slow_configclk_period);
    check_fast_slow_configclk_period();
    tb_number   = 603;
    #(5*fw_axi_clk_period);
    w_cfg_array_0_counter();
    tb_number   = 604;
    #(5*fw_axi_clk_period);
    w_cfg_array_1_random();
    tb_number   = 605;
    // Dummy wait before w_execute();
    #(5*fw_axi_clk_period*tb_slow_configclk_period);
    // Use following defined tb_test_* parameters for IP1 test1, configure w_execute() bits:
    tb_test_delay            = 7'h04;                      // on clock domain fw_axi_clk
    tb_test_sample           = 7'h03;                      // on clock domain fw_axi_clk
    tb_test_number           = (1<<1) & 4'hF;              // use test_number==test_number==4'h2 to enable test2_enable
    tb_test_loopback         = 1'b1;                       // on clock domain fw_axi_clk
    tb_test_mask_reset_not   = 1'b0;                       // on clock domain fw_axi_clk
    w_execute();
    tb_number   = 606;
    #(256*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 256 fast_configclk cycles 256*16==4096;                     alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    tb_number   = 607;
    #( 70*16*tb_fast_configclk_period*fw_axi_clk_period);     // execution: wait for 68  fast_configclk cycles 68*16 ==1088; (4096+1088==5184)s; alternatively check when bit#12 is set in fw_read_status32_reg[12] <= sm_test1_o_status_done;
    tb_number   = 608;
    // Check sm_test1_o_status_done bit is set in fw_read_status32_reg[12]:
    if(sw_read32_1[12]==1'b1) begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), firmware_id_1, tb_test_loopback);
    end else begin
      $display("time=%06.2f firmware_id=%01d test1 in loopback=%01d mode NOT DONE", $realtime(), firmware_id_1, tb_test_loopback);
      tb_err[tb_err_index_test1] = 1'b1;
    end
    #(5*fw_axi_clk_period);

    tb_number   = 609;
    // READ DATA: done in two STEPS: first execute fw_op_code_r_data_array_0 and then execute fw_op_code_r_data_array_0.
    // The readout number of 32-bit words is (256+68)/2==324/2==162 plus one more word {28'h0, 4-bit-real-data} => 163 32-bit words; Case is for tb_test_number==1 and tb_test_loopback==HIGH
    // Step1: execute fw_op_code_r_data_array_0 and readout ALL 256 16-bit words === 128 32-bit words
    $display("time=%06.2f starting to check readout data: calling check_r_data_array_0_counter()...", $realtime());
    check_r_data_array_0_counter(.read_n_32bit_words(128));
    tb_number   = 610;
    #(5*fw_axi_clk_period);
    // Step2: execute check_r_data_array_1_random and readout ONLY 68 16-bit words === 34 32-bit words
    $display("time=%06.2f starting to check readout data: calling check_r_data_array_1_random()...", $realtime());
    check_r_data_array_1_random(.read_n_32bit_words(128));
    tb_number   = 611;
    #(5*fw_axi_clk_period);
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
