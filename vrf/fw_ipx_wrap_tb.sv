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
// 2024-09-30  Cristian Gingu         Add IOB input port scan_out_test and associated logic for ip2_test2.sv
// 2024-10-01  Cristian Gingu         Add IOB input port up_event_toggle
// 2024-11-27  Cristian  Gingu        Increase dnn_reg_width from 48-bits to 64-bits
// 2024-12-18  Cristian  Gingu        Add test_number_5 for ip2_test5
// 2025-01-03  Cristian  Gingu        Add task check_r_data_array_1_pixel for ip2_test5
// 2025-03-17  Cristian  Gingu        Split tb_testcase=T3 into T31 and T32 to-be-used by Benjamin Parpillon
// 2025-03-17  Cristian  Gingu        Update task w_cfg_static_random(integer index) and  task check_r_cfg_static(integer index) for OP_CODE_W_CFG_STATIC_0/1
// 2025-03-18  Cristian  Gingu        Upgrade test-case T5 and T6 to include change of tb_test_sample parameter, to illustrate sampling of either current-bit (TB PASS) or previous-bit (TB FAIL)
// 2025-03-21  Cristian  Gingu        Upgrade test-case T5 to include change of tb_test_delay; add code for scan_in_del1,2,3,4
// 2025-04-01  Cristian  Gingu        More upgrade on test-case T5 to study tb_test_sample vs tb_test_delay 2D plots and compare withe BP and AB experimental plots.
// 2025-04-10  Cristian  Gingu        More upgrade on test-case T5 to study tb_test_sample vs tb_test_delay 2D plots and compare withe BP and AB experimental plots. Save 2D plots into https://fermicloud.sharepoint.com/:p:/r/sites/FNALO365-ASICDepartment/_layouts/15/doc2.aspx?sourcedoc=%7B0D668FF8-99D1-47AD-BC37-FAE28DE351B2%7D&file=sampleDelay.pptx&wdLOR=c0506A49F-5559-4DC8-B81D-043D6036590D&fromShare=true&action=edit&mobileredirect=true&previoussessionid=ba957705-d4c3-c057-dccc-5806084326aa
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
  //
  import cms_pix28_package::test_number_1;
  import cms_pix28_package::test_number_2;
  import cms_pix28_package::test_number_3;
  import cms_pix28_package::test_number_4;
  import cms_pix28_package::test_number_5;
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
  import cms_pix28_package::status_index_test4_done;
  import cms_pix28_package::status_index_test5_done;
  //
  import cms_pix28_package::dnn_reg_width;
  import cms_pix28_package::dnn_reg_0_default;
  import cms_pix28_package::dnn_reg_1_default;
  import cms_pix28_package::bxclk_ana_default;
  import cms_pix28_package::bxclk_default;
  import cms_pix28_package::SCANLOAD_HIGH_2_IP2_T3;
  import cms_pix28_package::SCANLOAD_HIGH_2_IP2_T4;
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
  import cms_pix28_package_vrf::tb_err_index_test4;
  import cms_pix28_package_vrf::tb_err_index_test5;
  //
  // Test Signals
  string  tb_testcase;
  integer tb_number;
  integer tb_i_test;
  integer tb_j_test;
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
  logic [5:0]  tb_scan_load_delay;
  logic        tb_scan_load_delay_disable;
  // IP2: Signals related with w_cfg_static_1_reg          // test_number_5:
  logic [7:0]  tb_select_pixel;                            // test_number_5: selected pixel for ip2_test5: 0-to-255
  logic [10:0] tb_repeat_pixel;                            // test_number_5: loop iterations in ip2_test5: 0-to-2047
  // IP2: Signals related with w_cfg_array_0/1/2_reg
  logic [255:0][15:0]   tb_w_cfg_array_counter;
  logic [255:0][15:0]   tb_w_cfg_array_random;
  logic [255:0][2:0]    tb_w_cfg_pixels_256x3;             // test_number_5: [256-pixels][3-bits-per-pixel] ==  768-bits
  logic [256*16-1:0]    tb_w_cfg_pixels_4096;              // test_number_5: [256 * 16  ]                   == 4096-bits
  logic [255:0][15:0]   tb_w_cfg_pixels_256x16;            // test_number_5: [256       ][16              ] == 4096-bits
  logic [256*16-1:0]    tb_r_cfg_pixels_4096;              // test_number_5: [256 * 16  ]                          == 4096-bits
  logic [1365-1:0][2:0] tb_r_cfg_pixels_1365x3;            // test_number_5: [1365-repeat-pixel][3-bits-per-pixel] ==  4095-bits

  // IP2: Signals related with w_execute: test_number/delay/sample, etc
  logic [5:0]  tb_test_delay;                              // on clock domain fw_axi_clk
  logic [5:0]  tb_test_sample;                             // on clock domain fw_axi_clk
  logic [3:0]  tb_test_number;                             // on clock domain fw_axi_clk
  logic        tb_test_loopback;                           // on clock domain fw_axi_clk
  logic [5:0]  tb_test_trig_out_phase;                     // on clock domain fw_axi_clk
  logic        tb_test_mask_reset_not;                     // on clock domain fw_axi_clk
  //
  logic [dnn_reg_width-1:0] tb_dnn_reg_0;                  // 400MHz clock register storing dnn_reg_width consecutive values of DUT output signal sm_testx_i_dnn_output_0
  logic [dnn_reg_width-1:0] tb_dnn_reg_1;                  // 400MHz clock register storing dnn_reg_width consecutive values of DUT output signal sm_testx_i_dnn_output_1
  logic [dnn_reg_width-1:0] tb_dnn_reg_0_predicted;        // 400MHz clock register with  predicted IP2_T3 state machine output signal sm_test3_o_dnn_output_0
  logic [dnn_reg_width-1:0] tb_dnn_reg_1_predicted;        // 400MHz clock register with  predicted IP2_T3 state machine output signal sm_test3_o_dnn_output_1
  logic [dnn_reg_width-1:0] tb_dnn_reg_0_random;
  logic [dnn_reg_width-1:0] tb_dnn_reg_1_random;
  logic [dnn_reg_width-1:0] tb_bxclk_ana_predicted;        // 400MHz clock register with  predicted IP2_T3 state machine output signal sm_test3_o_dnn_output_0
  logic [dnn_reg_width-1:0] tb_bxclk_predicted;            // 400MHz clock register with  predicted IP2_T3 state machine output signal sm_test3_o_dnn_output_1

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
  logic scan_in_del1         = 1'b0;
  logic scan_in_del2         = 1'b0;
  logic scan_in_del3         = 1'b0;
  logic scan_in_del4         = 1'b0;
  always @(posedge fw_pl_clk1) begin
    // arbitrary ONE clock delay
    scan_out      <=  scan_in;
    scan_out_test <= ~scan_in;
    // select arbitrary TWO,THREE,FOUR,FIVE clock delay
//    scan_in_del1  <=  scan_in;
//    scan_in_del2  <=  scan_in_del1;
//    scan_in_del3  <=  scan_in_del2;
//    scan_in_del4  <=  scan_in_del3;
//    scan_out      <=  scan_in_del4;
//    scan_out_test <= ~scan_in_del4;
  end
//  always @(posedge bxclk) begin
//    // this emulation is more close to ASIC behavior => scan_out toggle @(posedge bxclk)
//    scan_out      <=  scan_in;
//    scan_out_test <= ~scan_in;
//  end
//  always @(posedge bxclk) begin
//    // this emulation (feature1) is more close to ASIC behavior => scan_out toggle @(posedge bxclk)
////    scan_in_del1  <=  scan_in;
//    scan_in_del2  <=  scan_in_del1;
//  end
//  always @(negedge fw_pl_clk1) begin
//    // this emulation (feature 2) is more close to ASIC behavior => scan_out is delayed an additional 4*2.5ns
//    scan_in_del1  <=  scan_in;
////    scan_in_del2  <=  scan_in_del1;
//    scan_in_del3  <=  scan_in_del2;
////    scan_in_del4  <=  scan_in_del3;
//    scan_out      <=  scan_in_del3;
//    scan_out_test <= ~scan_in_del3;
//  end

  always @(posedge fw_pl_clk1) begin : dnn_proc
    if((DUT.fw_ip2_inst.test3_enable===1'b1) || (DUT.fw_ip2_inst.test4_enable===1'b1)) begin
      // when test3 is active OR test4 is active do:
      if(
          ((DUT.fw_ip2_inst.test3_enable===1'b1) && (DUT.fw_ip2_inst.test3_enable_re===1'b1)) ||
          ((DUT.fw_ip2_inst.test4_enable===1'b1) && (DUT.fw_ip2_inst.test4_enable_re===1'b1))    )  begin
        // at test3 rising edge or test3 rising edge do:
        if(tb_test_loopback==1'b1) begin
          tb_dnn_reg_0            <= dnn_reg_0_default;
          tb_dnn_reg_1            <= dnn_reg_1_default;
          tb_dnn_reg_0_predicted  <= 64'h0;
          tb_dnn_reg_1_predicted  <= 64'h0;
        end else begin
          tb_dnn_reg_0            <= tb_dnn_reg_0_random;
          tb_dnn_reg_1            <= tb_dnn_reg_1_random;
          tb_dnn_reg_0_predicted  <= {63'h0, tb_dnn_reg_0_random[63]};
          tb_dnn_reg_1_predicted  <= {63'h0, tb_dnn_reg_1_random[63]};
        end
        tb_bxclk_ana_predicted    <= 64'h0;
        tb_bxclk_predicted        <= 64'h0;
      end else begin
        if(
            ((DUT.fw_ip2_inst.test3_enable===1'b1) && (DUT.fw_ip2_inst.sm_test3==SCANLOAD_HIGH_2_IP2_T3)) ||
            ((DUT.fw_ip2_inst.test4_enable===1'b1) && (DUT.fw_ip2_inst.sm_test4==SCANLOAD_HIGH_2_IP2_T4))    ) begin
          // rotate left every fw_pl_clk1 400MHz cycle
          tb_dnn_reg_0            <= {tb_dnn_reg_0          [62:0], tb_dnn_reg_0[63]};
          tb_dnn_reg_1            <= {tb_dnn_reg_1          [62:0], tb_dnn_reg_1[63]};
          tb_dnn_reg_0_predicted  <= {tb_dnn_reg_0_predicted[62:0], tb_dnn_reg_0[63]};
          tb_dnn_reg_1_predicted  <= {tb_dnn_reg_1_predicted[62:0], tb_dnn_reg_1[63]};
          tb_bxclk_ana_predicted  <= {tb_bxclk_ana_predicted[62:0], DUT.com_fw_to_dut_inst.bxclk_ana_mux};
          tb_bxclk_predicted      <= {tb_bxclk_predicted    [62:0], DUT.com_fw_to_dut_inst.bxclk_mux    };
        end else begin
          // do NOT rotate, just keep/preserve values
          tb_dnn_reg_0            <= tb_dnn_reg_0;
          tb_dnn_reg_1            <= tb_dnn_reg_1;
          tb_dnn_reg_0_predicted  <= tb_dnn_reg_0_predicted;
          tb_dnn_reg_1_predicted  <= tb_dnn_reg_1_predicted;
          tb_bxclk_ana_predicted  <= tb_bxclk_ana_predicted;
          tb_bxclk_predicted      <= tb_bxclk_predicted;
        end
      end
    end else begin
      // when test3 is not active AND test4 is not active
      tb_dnn_reg_0                <= 64'h0;
      tb_dnn_reg_1                <= 64'h0;
      tb_dnn_reg_0_predicted      <= tb_dnn_reg_0_predicted;
      tb_dnn_reg_1_predicted      <= tb_dnn_reg_1_predicted;
      tb_bxclk_ana_predicted      <= tb_bxclk_ana_predicted;
      tb_bxclk_predicted          <= tb_bxclk_predicted;
    end
  end
  // NOTE: The above signals tb_dnn_reg_0/1_predicted are one clock ahead (shifted left one more bit)
  // when compared with sm_test3_o_dnn_reg_0/1 while reading out data fw_read_data32
  assign dnn_output_0        = tb_dnn_reg_0[63];
  assign dnn_output_1        = tb_dnn_reg_1[63];
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
      my_cfg_array[i][ 7:0]   = 8'h01;
      if(i==0) begin
        my_cfg_array[i][15:8] = 8'h81;
      end else if(i==768/16-1) begin             // 768/16  ==48
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

  //logic [255:0][2:0]  tb_w_cfg_pixels_256x3;               // test_number_5: [256-pixels][3-bits-per-pixel] ==  768-bits
  //logic [256*16-1:0]  tb_w_cfg_pixels_4096;                // test_number_5: [256 * 16  ]                   == 4096-bits
  //logic [255:0][15:0] tb_w_cfg_pixels_256x16;              // test_number_5: [256       ][16              ] == 4096-bits
  // 1. Create two-dimensional array [256-pixels][3-bit-per-pixel]
  function logic [255:0][2:0] pixel_cfg_array();
    logic [255:0][2:0] my_cfg_array;
    for(int i=0; i<256; i++) begin
      //my_cfg_array[i] = i & 3'h7;
      my_cfg_array[i] = $urandom_range(2**3-1, 0) & 3'h7;
    end
    return my_cfg_array;
  endfunction
  // 2. Create one-dimensional array [256*16]
  assign tb_w_cfg_pixels_4096[4095 : 768] = 3328'h0;
  for(genvar i=0; i<256; i++) begin
    assign tb_w_cfg_pixels_4096[3*i+2 : 3*i] = tb_w_cfg_pixels_256x3[i];
  end
  // 3. Create two-dimensional array [256*16]
  for(genvar i=0; i<256; i++) begin
    assign tb_w_cfg_pixels_256x16[i] = tb_w_cfg_pixels_4096[16*i+15 : 16*i];
  end
  //
  for(genvar i=0; i<1365; i++) begin
    assign tb_r_cfg_pixels_1365x3[i] = tb_r_cfg_pixels_4096[4096-3*i-1 : 4096-3*i-3];
  end

  task w_cfg_static_random(integer index);
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(index%2==0) begin
      tb_function_id = OP_CODE_W_CFG_STATIC_0;
      tb_bxclk_period            = $urandom_range(40, 10)               & 6'h3F;   //6'h0A => 40MHz
      tb_bxclk_delay             = $urandom_range(tb_bxclk_period/2, 0) & 5'h1F;   //5'h2;
      tb_bxclk_delay_sign        = $urandom_range(1, 0)                 & 1'h1;
      tb_super_pix_sel           = $urandom_range(1, 0)                 & 1'h1;
      tb_scan_load_delay         = $urandom_range(63, 0)                & 6'h3F;
      tb_scan_load_delay_disable = $urandom_range(1, 0)                 & 1'h1;
      sw_write32_0               = {tb_firmware_id, tb_function_id, 4'b0, tb_scan_load_delay_disable, tb_scan_load_delay, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
      #(1*fw_axi_clk_period);
      $display("time=%06.2f tb_i_test=%02d tb_bxclk_period=%02d tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d tb_super_pix_sel=%01d tb_scan_load_delay=%02d tb_scan_load_delay_disable=%01d",
        $realtime(), tb_i_test, tb_bxclk_period, tb_bxclk_delay, tb_bxclk_delay_sign, tb_super_pix_sel, tb_scan_load_delay, tb_scan_load_delay_disable);
    end else begin
      tb_function_id = OP_CODE_W_CFG_STATIC_1;
      tb_select_pixel            = $urandom_range(2**8-1, 0)            & 8'hFF;
      tb_repeat_pixel            = $urandom_range(2**11-1, 1)           & 11'h7FF;
      sw_write32_0               = {tb_firmware_id, tb_function_id, 5'b0, tb_repeat_pixel, tb_select_pixel};
      #(1*fw_axi_clk_period);
      $display("time=%06.2f tb_i_test=%02d tb_repeat_pixel=%04d tb_select_pixel=%01d",
        $realtime(), tb_i_test, tb_repeat_pixel, tb_select_pixel);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task w_cfg_static_fixed(integer index);
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(index%2==0) begin
      tb_function_id         = OP_CODE_W_CFG_STATIC_0;
      sw_write32_0           = {tb_firmware_id, tb_function_id, 4'b0, tb_scan_load_delay_disable, tb_scan_load_delay, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
      #(1*fw_axi_clk_period);
      $display("time=%06.2f OP_CODE_W_CFG_STATIC_0 tb_bxclk_period=%02d tb_bxclk_delay=%02d tb_bxclk_delay_sign=%01d tb_super_pix_sel=%01d tb_scan_load_delay=%02d tb_scan_load_delay_disable=%01d",
        $realtime(), tb_bxclk_period, tb_bxclk_delay, tb_bxclk_delay_sign, tb_super_pix_sel, tb_scan_load_delay, tb_scan_load_delay_disable);
    end else begin
      tb_function_id         = OP_CODE_W_CFG_STATIC_1;
      sw_write32_0           = {tb_firmware_id, tb_function_id, 5'b0, tb_repeat_pixel, tb_select_pixel};
      #(1*fw_axi_clk_period);
      $display("time=%06.2f OP_CODE_W_CFG_STATIC_1 tb_repeat_pixel=%04d tb_select_pixel=%01d",
        $realtime(), tb_repeat_pixel, tb_select_pixel);
    end
    tb_function_id         = OP_CODE_NOOP;
    sw_write32_0           = {tb_firmware_id, tb_function_id, 24'b0};
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

  task w_cfg_array_0_pixel();
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    tb_function_id           = OP_CODE_W_CFG_ARRAY_0;
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    for(int i_addr=0; i_addr<256; i_addr++) begin
      tb_sw_write24_0[23:16] = i_addr & 8'hFF;
      tb_sw_write24_0[15: 0] = tb_w_cfg_pixels_256x16[i_addr];
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
    tb_sw_write24_0[w_execute_cfg_test_loopback_IP2                                                                         ] = tb_test_loopback;
    tb_sw_write24_0[w_execute_cfg_test_vin_test_trig_out_index_max_IP2 : w_execute_cfg_test_vin_test_trig_out_index_min_IP2 ] = tb_test_trig_out_phase;
    tb_sw_write24_0[w_execute_cfg_test_mask_reset_not_index_IP2                                                             ] = tb_test_mask_reset_not;
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
      if(tb_bxclk_delay_sign===1'b0) begin
        @(posedge bxclk_ana); tb_time_t1 = $realtime();
        @(posedge bxclk    ); tb_time_t2 = $realtime();
        // bxclk_delay_sign is ZERO. The RE of bxclk is after RE of bxclk_ana by bxclk_delay ticks.
        // keep bxclk LOW for bxclk_delay; then HIGH for bxclk_period/2; then again LOW for bxclk_period/2-bxclk_delay
      end
      if(tb_bxclk_delay_sign===1'b1) begin
        @(posedge bxclk_ana); tb_time_t1 = $realtime();
        @(negedge bxclk    ); tb_time_t2 = $realtime();
        // bxclk_delay_sign is ONE. The FE of bxclk is after RE of bxclk_ana by bxclk_delay ticks
        // keep bxclk HIGH for bxclk_delay; then LOW for bxclk_period/2; then again HIGH for bxclk_period/2-bxclk_delay
      end
      if(tb_bxclk_delay===0) begin
        // in this case the signals are either in phase (if tb_bxclk_delay_sign===1'b0) or inverted (if tb_bxclk_delay_sign===1'b1)
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
    if(index%2==0) begin
      tb_function_id = OP_CODE_R_CFG_STATIC_0;
      tb_sw_write24_0          = 24'h0;
      sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      #(1*fw_axi_clk_period);
      if(sw_read32_0 !== {4'h0, tb_scan_load_delay_disable, tb_scan_load_delay, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_static_0 sw_read32_0=0x%08h expected 0x%08h", $realtime(), sw_read32_0, {4'h0, tb_scan_load_delay_disable, tb_scan_load_delay, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period});
        tb_err[tb_err_index_op_code_r_cfg_static_0]=1'b1;
      end
    end else begin
      tb_function_id = OP_CODE_R_CFG_STATIC_1;
      tb_sw_write24_0          = 24'h0;
      sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
      #(1*fw_axi_clk_period);
      if(sw_read32_0 !== {5'b0, tb_repeat_pixel, tb_select_pixel}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_static_1 sw_read32_0=0x%08h expected 0x%08h", $realtime(), sw_read32_0, {5'b0, tb_repeat_pixel, tb_select_pixel});
        tb_err[tb_err_index_op_code_r_cfg_static_1]=1'b1;
      end
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
      if(sw_read32_0 !== {tb_w_cfg_array_counter[i_addr+1], tb_w_cfg_array_counter[i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_array_0 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[i_addr+1], tb_w_cfg_array_counter[i_addr]);
        tb_err[tb_err_index_op_code_r_cfg_array_0]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_cfg_array_0_pixel();
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
      if(sw_read32_0 !== {tb_w_cfg_pixels_256x16[i_addr+1], tb_w_cfg_pixels_256x16[i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_cfg_array_1 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_pixels_256x16[i_addr+1], tb_w_cfg_pixels_256x16[i_addr]);
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
      if(sw_read32_0 !== {tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_random[i_addr]}) begin
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
      if(sw_read32_0 !== {tb_w_cfg_array_random[i_addr+1], tb_w_cfg_array_counter[i_addr]}) begin
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
      if(sw_read32_0 !== {tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_0 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_array_counter[2*i_addr+1], tb_w_cfg_array_counter[2*i_addr]);
        tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_1_counter_b(
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
      if(sw_read32_0 !== {~tb_w_cfg_array_counter[2*i_addr+1], ~tb_w_cfg_array_counter[2*i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_1 (counter) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, ~tb_w_cfg_array_counter[2*i_addr+1], ~tb_w_cfg_array_counter[2*i_addr]);
        tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_0_pixel(
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
      if(sw_read32_0 !== {tb_w_cfg_pixels_256x16[2*i_addr+1], tb_w_cfg_pixels_256x16[2*i_addr]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_0 (pixel) i_addr=%03d sw_read32_0=0x%08h expected {0x%04h 0x%04h}", $realtime(), i_addr, sw_read32_0, tb_w_cfg_pixels_256x16[2*i_addr+1], tb_w_cfg_pixels_256x16[2*i_addr]);
        tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
      end
      @(negedge fw_axi_clk);
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_1_pixel(
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
      tb_r_cfg_pixels_4096[4096-1:0] = {sw_read32_0, tb_r_cfg_pixels_4096[4096-1:32]};
      $display("time=%06.2f DEBUG task check_r_data_array_1_pixel i_addr=%03d sw_read32_0=%032b", $realtime(), i_addr, sw_read32_0);
      @(negedge fw_axi_clk);
    end
    $display("time=%06.2f DEBUG task check_r_data_array_1_pixel tb_r_cfg_pixels_4096=%01024h", $realtime(), tb_r_cfg_pixels_4096);
    //
    for(int i_pixel=0; i_pixel<tb_repeat_pixel; i_pixel++) begin
      if(tb_r_cfg_pixels_1365x3[i_pixel] !== tb_w_cfg_pixels_256x3[tb_select_pixel]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_1 (pixel) i_pixel=%03d tb_select_pixel=%03d tb_r_cfg_pixels_1365x3[%03d]=%03b expected tb_w_cfg_pixels_256x3[%03d]=%03b",
          $realtime(), i_pixel, tb_select_pixel, i_pixel, tb_r_cfg_pixels_1365x3[i_pixel], tb_select_pixel, tb_w_cfg_pixels_256x3[tb_select_pixel]);
        tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
      end
    end
    //
    for(logic[10:0] i_pixel=tb_repeat_pixel; i_pixel<1365; i_pixel++) begin
      if(tb_r_cfg_pixels_1365x3[i_pixel] !== 3'b0) begin
        $display("time=%06.2f FAIL op_code_r_data_array_1 (pixel) i_pixel=%03d tb_select_pixel=%03d tb_r_cfg_pixels_1365x3[%03d]=%03b expected 3'b0",
          $realtime(), i_pixel, tb_select_pixel, i_pixel, tb_r_cfg_pixels_1365x3[i_pixel]);
        tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
      end
    end
    tb_function_id           = OP_CODE_NOOP;
    sw_write32_0             = {tb_firmware_id, tb_function_id, 24'h0};
  endtask

  task check_r_data_array_n_dnn(
      integer r_data_array_n
    );
    @(negedge fw_axi_clk);             // ensure enter on FE of AXI CLK
    if(r_data_array_n==0) begin
      tb_function_id         = OP_CODE_R_DATA_ARRAY_0;
    end else if(r_data_array_n==1) begin
      tb_function_id         = OP_CODE_R_DATA_ARRAY_1;
    end else begin
      $display("time=%06.2f FAIL argument value op_code_r_data_array_n=%01d (dnn) is not supported", $realtime(), 0, r_data_array_n);
      tb_err[tb_err_index_op_code_r_data_array_0]=1'b1;
      tb_err[tb_err_index_op_code_r_data_array_1]=1'b1;
    end
    tb_sw_write24_0          = 24'h0;
    sw_write32_0             = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    #(5*fw_axi_clk_period);
    // i_addr==0
    tb_sw_write24_0[23:16] = 0 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_dnn_reg_0_predicted[32:1]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected tb_dnn_reg_0_predicted[32:1]=0x%08h", $realtime(), r_data_array_n, 0, sw_read32_0, tb_dnn_reg_0_predicted[32:1]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== dnn_reg_0_default[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn+loopback) i_addr=%03d sw_read32_0=0x%08h expected dnn_reg_0_default[31:0]]=0x%08h", $realtime(), r_data_array_n, 0, sw_read32_0, dnn_reg_0_default[31:0]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==1
      tb_sw_write24_0[23:16] = 1 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== {1'b0, tb_dnn_reg_0_predicted[63:33]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected {1'b0, tb_dnn_reg_0_predicted[63:33]=0x%04h}", $realtime(), r_data_array_n, 1, sw_read32_0, tb_dnn_reg_0_predicted[63:33]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== {dnn_reg_0_default[63:32]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn+loopback) i_addr=%03d sw_read32_0=0x%08h expected dnn_reg_0_default[63:32]]=0x%04h", $realtime(), r_data_array_n, 1, sw_read32_0, dnn_reg_0_default[63:32]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==2
      tb_sw_write24_0[23:16] = 2 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_dnn_reg_1_predicted[32:1]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected tb_dnn_reg_1_predicted[32:1]=0x%08h", $realtime(), r_data_array_n, 2, sw_read32_0, tb_dnn_reg_1_predicted[32:1]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== dnn_reg_1_default[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn+loopback) i_addr=%03d sw_read32_0=0x%08h expected dnn_reg_1_default[31:0]]=0x%08h", $realtime(), r_data_array_n, 2, sw_read32_0, dnn_reg_1_default[31:0]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==3
      tb_sw_write24_0[23:16] = 3 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== {1'b0, tb_dnn_reg_1_predicted[63:33]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected {1'b0, tb_dnn_reg_1_predicted[63:33]=0x%04h}", $realtime(), r_data_array_n, 3, sw_read32_0, tb_dnn_reg_1_predicted[63:33]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== {dnn_reg_1_default[63:32]}) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn+loopback) i_addr=%03d sw_read32_0=0x%08h expected dnn_reg_1_default[63:32]]=0x%04h", $realtime(), r_data_array_n, 3, sw_read32_0, dnn_reg_1_default[63:32]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==4
      tb_sw_write24_0[23:16] = 4 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_bxclk_ana_predicted[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 4, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== bxclk_ana_default[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 4, sw_read32_0, bxclk_ana_default[31:0]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==5
      tb_sw_write24_0[23:16] = 5 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_bxclk_ana_predicted[63:32]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 5, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== bxclk_ana_default[63:32]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 5, sw_read32_0, bxclk_ana_default[63:32]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==6
      tb_sw_write24_0[23:16] = 6 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_bxclk_predicted[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 6, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== bxclk_default[31:0]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 6, sw_read32_0, bxclk_default[31:0]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==7
      tb_sw_write24_0[23:16] = 7 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== tb_bxclk_predicted[63:32]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 7, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== bxclk_default[63:32]) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 7, sw_read32_0, bxclk_default[63:32]);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
      // i_addr==8
      tb_sw_write24_0[23:16] = 8 & 8'hFF;
    tb_sw_write24_0[15: 0] = 16'hFFFF;
    sw_write32_0           = {tb_firmware_id, tb_function_id, tb_sw_write24_0};
    @(posedge fw_axi_clk);
    if(tb_test_loopback===1'b0) begin
      if(sw_read32_0 !== 32'h0) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 8, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end else begin
      if(sw_read32_0 !== 32'h0) begin
        $display("time=%06.2f FAIL op_code_r_data_array_n=%01d (dnn) i_addr=%03d sw_read32_0=0x%08h expected 0x%08h", $realtime(), r_data_array_n, 8, sw_read32_0, 32'h0);
        if(r_data_array_n==0) begin tb_err[tb_err_index_op_code_r_data_array_0]=1'b1; end
        if(r_data_array_n==1) begin tb_err[tb_err_index_op_code_r_data_array_1]=1'b1; end
      end
    end
    //
    @(negedge fw_axi_clk)
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
    tb_w_cfg_pixels_256x3  = {256{3'h0}};
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
    // Test 31: BXCLK/ANA random period and delay test write/read
    tb_testcase = "T31. BXCLK/ANA random period and delay test write/read";
    tb_number   = 31;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    //tb_bxclk_period            = 6'h0A;                    // on clock domain fw_axi_clk
    //tb_bxclk_delay             = 5'h2;                     // on clock domain fw_axi_clk
    //tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    //tb_super_pix_sel           = 1'h0;                     // on clock domain fw_axi_clk
    //tb_scan_load_delay         = 6'h05;                    // on clock domain fw_axi_clk
    //tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    //w_cfg_static_fixed(0);
    //tb_number   = 502;                                     // BXCLK/ANA is programmed
    //#(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    tb_firmware_id = firmware_id_2;
    tb_bxclk_period            = 6'h0A;
    //tb_bxclk_delay             = 5'h2;
    //tb_bxclk_delay_sign        = 1'h0;
    tb_super_pix_sel           = 1'h0;
    tb_scan_load_delay         = 6'h05;
    tb_scan_load_delay_disable = 1'h0;
    tb_select_pixel            = 8'h80;
    tb_repeat_pixel            = 11'h700;
    for (integer i_w_config_static =0; i_w_config_static<2; i_w_config_static++) begin
      for (integer i_tb_bxclk_delay_sign=0; i_tb_bxclk_delay_sign<=2; i_tb_bxclk_delay_sign++) begin         // NOTE: TB PASS for out-of-range bxclk_delay_sign (should be 0,1)
        tb_bxclk_delay_sign      = i_tb_bxclk_delay_sign  & 1'h1;
        for (integer i_tb_bxclk_delay = 0; i_tb_bxclk_delay <=tb_bxclk_period+2; i_tb_bxclk_delay++) begin   // NOTE: for out-of-range tb_bxclk_delay (should be 0 to tb_bxclk_period-1) the BXCLK remains LOW or HIGH (if tb_bxclk_delay_sign==LOW or HIGH)
          tb_bxclk_delay         = i_tb_bxclk_delay       & 5'h1F;
          // Write fixed values (not randomized) sw_write24_0 content and issue fw_op_code_w_cfg_static_0 for ONE fw_axi_clk_period
          w_cfg_static_fixed(.index(i_w_config_static));
          //index=0 => tb_function_id=OP_CODE_W_CFG_STATIC_0; sw_write32_0 = {tb_firmware_id, tb_function_id, 4'b0, tb_scan_load_delay_disable, tb_scan_load_delay, tb_super_pix_sel, tb_bxclk_delay_sign, tb_bxclk_delay, tb_bxclk_period};
          //index=1 => tb_function_id=OP_CODE_W_CFG_STATIC_1; sw_write32_0 = {tb_firmware_id, tb_function_id, 5'b0, tb_repeat_pixel, tb_select_pixel};
          tb_number   = 311;
          // Dummy wait before doing check_bxclk_period_and_delay()
          #(5*fw_axi_clk_period);
          if(i_w_config_static==0 && i_tb_bxclk_delay<tb_bxclk_period) check_bxclk_period_and_delay();
          tb_number   = 312;
          // Dummy wait before doing check_r_cfg_static()
          #(5*fw_axi_clk_period);
          check_r_cfg_static(.index(i_w_config_static));
          tb_number   = 313;
          // Dummy wait before disable tb_firmware_id => clocks will become ZERO
          #(5*fw_axi_clk_period);
          //tb_firmware_id = firmware_id_none;
          tb_number   = 314;
          // Dummy wait before next tb_i_test
          #(5*fw_axi_clk_period);
        end
      end
    end
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 32: BXCLK/ANA random period and delay test write/read
    tb_testcase = "T32. BXCLK/ANA random period and delay test write/read";
    tb_number   = 32;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    //tb_bxclk_period            = 6'h0A;                    // on clock domain fw_axi_clk
    //tb_bxclk_delay             = 5'h2;                     // on clock domain fw_axi_clk
    //tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    //tb_super_pix_sel           = 1'h0;                     // on clock domain fw_axi_clk
    //tb_scan_load_delay         = 6'h05;                    // on clock domain fw_axi_clk
    //tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    //w_cfg_static_fixed(0);
    //tb_number   = 502;                                     // BXCLK/ANA is programmed
    //#(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    for (integer i=0; i<2; i++) begin
      for (tb_i_test = 0; tb_i_test < 50; tb_i_test++) begin
        tb_firmware_id = firmware_id_2;
        // Randomize sw_write24_0 content and issue fw_op_code_w_cfg_static_0 for ONE fw_axi_clk_period
        w_cfg_static_random(.index(i));
        tb_number   = 321;
        // Dummy wait before doing check_bxclk_period_and_delay()
        #(5*fw_axi_clk_period);
        if(i==0) check_bxclk_period_and_delay();
        tb_number   = 322;
        // Dummy wait before doing check_r_cfg_static()
        #(5*fw_axi_clk_period);
        check_r_cfg_static(.index(i));
        tb_number   = 323;
        // Dummy wait before disable tb_firmware_id => clocks will become ZERO
        #(5*fw_axi_clk_period);
        tb_firmware_id = firmware_id_none;
        tb_number   = 324;
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
    tb_firmware_id         = firmware_id_2;
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
    tb_i_test   = 0;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period            = 6'h0A;                    // on clock domain fw_axi_clk
    tb_bxclk_delay             = 5'h04;                    // on clock domain fw_axi_clk
    tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    tb_super_pix_sel           = 1'h0;                     // on clock domain fw_axi_clk
    tb_scan_load_delay         = 6'h05;                    // on clock domain fw_axi_clk
    tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 502;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
//    for (tb_j_test = 3; tb_j_test <= tb_bxclk_period; tb_j_test++) begin
//      for (tb_i_test = 1; tb_i_test <= tb_bxclk_period; tb_i_test++) begin
    for (tb_j_test = 3; tb_j_test <= 5; tb_j_test++) begin
      for (tb_i_test = 2; tb_i_test <= 3; tb_i_test++) begin
        //
//      tb_test_delay            = 6'h08;                      // on clock domain fw_axi_clk
//      tb_test_sample           = 6'h04;                      // for NORMAL testing, use this statement for which TB PASS; to simulate TB FAIL due to wrong tb_test_sample, use following 14 statements
//      // the following statements and PASS / FAIL are for different values of tb_test_delay = 6'h08;                               6'h09 6'h0A 6'h03 6'h04 6'h05 6'h06 6'h07 6'h08
////      if(tb_i_test==0) tb_test_sample = 6'h09;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
////      if(tb_i_test==1) tb_test_sample = 6'h0A;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==2) tb_test_sample = 6'h01;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  PASS  PASS  PASS  PASS  FAIL
////      if(tb_i_test==3) tb_test_sample = 6'h02;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==4) tb_test_sample = 6'h03;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  FAIL  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==5) tb_test_sample = 6'h04;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==6) tb_test_sample = 6'h05;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  FAIL  FAIL  PASS  PASS  PASS  PASS
////      if(tb_i_test==7) tb_test_sample = 6'h06;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==8) tb_test_sample = 6'h07;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  FAIL  PASS  PASS
////      if(tb_i_test==9) tb_test_sample = 6'h08;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==10) tb_test_sample = 6'h09;              // this will FAIL - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
////      if(tb_i_test==11) tb_test_sample = 6'h0A;              // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==12) tb_test_sample = 6'h0B;              // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
////      if(tb_i_test==13) tb_test_sample = 6'h0C;              // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1 PASS  PASS  PASS  PASS  PASS  PASS  PASS  PASS
//      tb_test_number           = test_number_1;              // on clock domain fw_axi_clk
//      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
//      tb_test_trig_out_phase   = 6'h00;                      // on clock domain fw_axi_clk
//      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
        //
//      tb_test_delay            = 6'h09;                      // on clock domain fw_axi_clk
//      tb_test_sample           = 6'h04;                      // for NORMAL testing, use this statement for which TB PASS; to simulate TB FAIL due to wrong tb_test_sample, use following 14 statements
//      // the following statements and PASS / FAIL are for different values of tb_test_delay = 6'h08;                               6'h09 6'h0A 6'h03 6'h04 6'h05 6'h06 6'h07 6'h08 6'h08+FOUR-more-2.5ns-delay-scan-in-to-scan-out
//      if(tb_i_test==0) tb_test_sample = 6'h09;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==1) tb_test_sample = 6'h0A;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
//      if(tb_i_test==2) tb_test_sample = 6'h01;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  PASS  PASS  PASS  PASS  FAIL  FAIL
//      if(tb_i_test==3) tb_test_sample = 6'h02;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  PASS  PASS  PASS  PASS  PASS  FAIL
//      if(tb_i_test==4) tb_test_sample = 6'h03;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  FAIL  PASS  PASS  PASS  PASS  PASS  PASS  FAIL
//      if(tb_i_test==5) tb_test_sample = 6'h04;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  FAIL  PASS  PASS  PASS  PASS  PASS  FAIL
//      if(tb_i_test==6) tb_test_sample = 6'h05;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  FAIL  FAIL  PASS  PASS  PASS  PASS  FAIL
//      if(tb_i_test==7) tb_test_sample = 6'h06;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  FAIL  FAIL  FAIL  PASS  PASS  PASS  PASS
//      if(tb_i_test==8) tb_test_sample = 6'h07;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  FAIL  PASS  PASS  PASS
//      if(tb_i_test==9) tb_test_sample = 6'h08;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL  PASS  PASS
//      //if(tb_i_test==10) tb_test_sample = 6'h09;              // this will FAIL - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL  FAIL
//      //if(tb_i_test==11) tb_test_sample = 6'h0A;              // this will FAIL - sampling CORRECT  scan_out bit tb_test_loopback==0 FAIL  PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
//      //if(tb_i_test==12) tb_test_sample = 6'h0B;              // this will FAIL - sampling CORRECT  scan_out bit tb_test_loopback==0 FAIL  PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
//      //if(tb_i_test==13) tb_test_sample = 6'h0C;              // this will FAIL - sampling CORRECT  scan_out bit tb_test_loopback==0 FAIL  PASS  PASS  PASS  PASS  PASS  FAIL  FAIL  FAIL
//      tb_test_number           = test_number_1;              // on clock domain fw_axi_clk
//      tb_test_loopback         = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
//      tb_test_trig_out_phase   = 6'h00;                      // on clock domain fw_axi_clk
//      tb_test_mask_reset_not   = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
        //
//      // use this section to record behavior when scan_out test-bench emulation is more close to ASIC behavior => scan_out==scan_in BUT make it toggle @(posedge bxclk)
//      // BXCLKANA RE is always on same counter, by design feature: counter==2
//      // BXCLK    RE is constant for this test and it is set by tb_bxclk_delay = 5'h2 => BXCLK RE will be at counter==4
//      tb_test_delay            = 6'h08;                      // on clock domain fw_axi_clk
//      tb_test_sample           = 6'h04;                      // for NORMAL testing, use this statement for which TB PASS; to simulate TB FAIL due to wrong tb_test_sample                     MY SUMMARY PLOT ARRANGED LIKE BEN'S PLOTS!
//      // the following statements and PASS / FAIL are for different values of tb_test_delay (6'h08,9,A,3,4,5,6,7,8)                6'h09 6'h0A 6'h03 6'h04 6'h05 6'h06 6'h07 6'h08      A   PASS  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  PASS
//      if(tb_i_test==0) tb_test_sample = 6'h09;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  FAIL  FAIL  FAIL      9   PASS  FAIL  FAIL  FAIL  FAIL  FAIL  PASS  PASS
//      if(tb_i_test==1) tb_test_sample = 6'h0A;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  PASS  PASS  FAIL  FAIL  FAIL  FAIL  FAIL      8   PASS  FAIL  FAIL  FAIL  FAIL  PASS  PASS  PASS
//      if(tb_i_test==2) tb_test_sample = 6'h01;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  FAIL  FAIL  FAIL  FAIL  FAIL      7   PASS  FAIL  FAIL  FAIL  PASS  PASS  PASS  PASS
//      if(tb_i_test==3) tb_test_sample = 6'h02;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  FAIL  FAIL  FAIL  FAIL  FAIL      6   PASS  FAIL  FAIL  PASS  PASS  PASS  PASS  PASS
//      if(tb_i_test==4) tb_test_sample = 6'h03;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  PASS  FAIL  FAIL  FAIL  FAIL  FAIL      5   FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==5) tb_test_sample = 6'h04;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL      4   FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==6) tb_test_sample = 6'h05;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0 FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL      3   PASS  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==7) tb_test_sample = 6'h06;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  PASS  PASS  PASS      2   PASS  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==8) tb_test_sample = 6'h07;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  FAIL  PASS  PASS      1   PASS  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL  FAIL
//      if(tb_i_test==9) tb_test_sample = 6'h08;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0 PASS  PASS  PASS  FAIL  FAIL  FAIL  FAIL  PASS         6'h03 6'h04 6'h05 6'h06 6'h07 6'h08 6'h09 6'h0A
//      tb_test_number           = test_number_1;              // on clock domain fw_axi_clk
//      tb_test_loopback         = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
//      tb_test_trig_out_phase   = 6'h00;                      // on clock domain fw_axi_clk
//      tb_test_mask_reset_not   = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
        //
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        // 10  P  P  P  F  F  F  F  P | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  9  P  P  P  F  F  F  P  P |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  8  P  P  P  F  F  P  P  P |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  7  F  F  F  F  F  F  F  F |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  6  F  F  F  F  F  F  F  F |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  5  F  F  P  F  F  F  F  F |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  4  F  P  P  F  F  F  F  F |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  3  P  P  P  F  F  F  F  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  2  P  P  P  F  F  F  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  1  P  P  P  F  F  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11; REPORT: /asic/projects/C/CMS_PIX_28/gingu/cms_pix_28_test_firmware/xrun_bxclk_period_h28_bxclk_delay_h11.log
        //
        //
        //
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 23  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 22  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 21  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        //                            | tb_bxclk_period = 6'h28; plus additional 4*2.5ns delay of scan_out after sampling with BXCLK.
        //                            | tb_bxclk_delay  = 5'h11; REPORT: /asic/projects/C/CMS_PIX_28/gingu/cms_pix_28_test_firmware/xrun_bxclk_period_h28_bxclk_delay_h11_plus10ns.log
        //
        //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //
        // Simulations done on 2025-04-09 * commit 4614de29de8d6906c4acefaca84fd192ee0ed25d (HEAD -> cg_ip2_test5, origin/cg_ip2_test5)
        // CASE 1: one FF on fw_pl_clk1 RE
        //always @(posedge fw_pl_clk1) begin
        //  scan_out      <=  scan_in;
        //  scan_out_test <= ~scan_in;
        //end
        // SUMMARY: three diagonal FAIL lines
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 20  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 19  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 18  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 17  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 16  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 15  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 14  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 13  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 12  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 11  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        // 10  P  P  P  P  F  F  F  P | 10  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  9  P  P  P  F  F  F  P  P |  9  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  8  P  P  F  F  F  P  P  P |  8  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  7  F  F  F  F  P  P  P  P |  7  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  6  F  F  F  P  P  P  P  P |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  5  F  F  P  P  P  P  P  P |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  4  F  P  P  P  P  P  P  P |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //  3  P  P  P  P  P  P  P  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F
        //  2  P  P  P  P  P  P  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F
        //  1  P  P  P  P  P  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11;
        //
        //
        // Simulations done on 2025-04-09 * commit 4614de29de8d6906c4acefaca84fd192ee0ed25d (HEAD -> cg_ip2_test5, origin/cg_ip2_test5)
        // CASE 2: one FF on bxclk RE
        //always @(posedge bxclk) begin
        //  scan_out      <=  scan_in;
        //  scan_out_test <= ~scan_in;
        //end
        // SUMMARY: TWO horizontal and TWO vertical FAIL lines at: a) at 2+4=6,7 b) respectively at 2+17=19,20
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        // 10  P  P  P  F  F  F  F  P | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  9  P  P  P  F  F  F  P  P |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  8  P  P  P  F  F  P  P  P |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  7  F  F  F  F  F  F  F  F |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  6  F  F  F  F  F  F  F  F |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  5  F  F  P  F  F  F  F  F |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  4  F  P  P  F  F  F  F  F |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  3  P  P  P  F  F  F  F  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  2  P  P  P  F  F  F  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  1  P  P  P  F  F  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11;
        //
        //
        // Simulations done on 2025-04-09 * commit 4614de29de8d6906c4acefaca84fd192ee0ed25d (HEAD -> cg_ip2_test5, origin/cg_ip2_test5)
        // CASE 3: one FF on bxclk RE + one FF on fw_pl_clk1 FE
        //always @(posedge bxclk) begin
        //  scan_in_del1  <=  scan_in;
        //end
        //always @(negedge fw_pl_clk1) begin     // FE of fw_pl_clk1
        //  scan_out      <=  scan_in_del1;
        //  scan_out_test <= ~scan_in_del1;
        //end
        // SUMMARY: TWO horizontal and TWO vertical FAIL lines at: a) at 2+4=6,7 b) respectively at 2+17=19,20
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        // 10  P  P  P  F  F  F  F  P | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  9  P  P  P  F  F  F  P  P |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  8  P  P  P  F  F  P  P  P |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  7  F  F  F  F  F  F  F  F |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  6  F  F  F  F  F  F  F  F |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  5  F  F  P  F  F  F  F  F |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  4  F  P  P  F  F  F  F  F |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  3  P  P  P  F  F  F  F  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  2  P  P  P  F  F  F  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  1  P  P  P  F  F  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11;
        //
        //
        // Simulations done on 2025-04-09 * commit 4614de29de8d6906c4acefaca84fd192ee0ed25d (HEAD -> cg_ip2_test5, origin/cg_ip2_test5)
        // CASE 4: one FF on bxclk RE + two FF on fw_pl_clk1 FE
        //always @(posedge bxclk) begin
        //  scan_in_del1  <=  scan_in;
        //end
        //always @(negedge fw_pl_clk1) begin
        //  scan_in_del2  <=  scan_in_del1;
        //  scan_out      <=  scan_in_del2;
        //  scan_out_test <= ~scan_in_del2;
        //end
        // SUMMARY: THREE horizontal and THREE vertical FAIL lines at: a) at 2+4=6,7,8 b) respectively at 2+17=19,20,21
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        // 10  P  P  P  F  F  F  F  P | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  9  P  P  P  F  F  F  P  P |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  8  F  F  F  F  F  F  F  F |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  7  F  F  F  F  F  F  F  F |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  6  F  F  F  F  F  F  F  F |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  5  F  F  P  F  F  F  F  F |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  4  F  P  P  F  F  F  F  F |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  3  P  P  P  F  F  F  F  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  2  P  P  P  F  F  F  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  1  P  P  P  F  F  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11;
        //
        //
        // Simulations done on 2025-04-09 * commit 4614de29de8d6906c4acefaca84fd192ee0ed25d (HEAD -> cg_ip2_test5, origin/cg_ip2_test5)
        // CASE 5: one FF on fw_pl_clk1 FE + one FF on bxclk RE + two FF on fw_pl_clk1 FE
        //always @(posedge bxclk) begin
        //  scan_in_del2  <=  scan_in_del1;
        //end
        //always @(negedge fw_pl_clk1) begin
        //  scan_in_del1  <=  scan_in;
        //  scan_in_del3  <=  scan_in_del2;
        //  scan_out      <=  scan_in_del3;
        //  scan_out_test <= ~scan_in_del3;
        // SUMMARY: FOUR horizontal and FOUR vertical FAIL lines at, CAUTION!!!: a) at 2+4-1=5,6,7,8 b) respectively at 2+17-1=18,19,20,21
        //                            | 40  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P
        //                            | 39  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P
        //                            | 38  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P
        //                            | 37  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P
        //                            | 36  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P
        //                            | 35  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P
        //                            | 34  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P
        //                            | 33  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P
        //                            | 32  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P
        //                            | 31  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P
        //                            | 30  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P
        //                            | 29  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 28  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 27  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 26  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 25  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 24  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 23  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 22  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P
        //                            | 21  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 20  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 19  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 18  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 17  F  F  F  F  F  F  F  F  F  F  F  F  F  F  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 16  F  F  F  F  F  F  F  F  F  F  F  F  F  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 15  F  F  F  F  F  F  F  F  F  F  F  F  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 14  F  F  F  F  F  F  F  F  F  F  F  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 13  F  F  F  F  F  F  F  F  F  F  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 12  F  F  F  F  F  F  F  F  F  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //                            | 11  F  F  F  F  F  F  F  F  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        // 10  P  P  F  F  F  F  F  P | 10  F  F  F  F  F  F  F  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  9  P  P  F  F  F  F  P  P |  9  F  F  F  F  F  F  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  8  F  F  F  F  F  F  F  F |  8  F  F  F  F  F  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  7  F  F  F  F  F  F  F  F |  7  F  F  F  F  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  6  F  F  F  F  F  F  F  F |  6  F  F  F  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  5  F  F  F  F  F  F  F  F |  5  F  F  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  4  F  P  F  F  F  F  F  F |  4  F  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  3  P  P  F  F  F  F  F  F |  3  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  2  P  P  F  F  F  F  F  F |  2  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //  1  P  P  F  F  F  F  F  F |  1  P  P  P  P  P  P  P  P  P  P  P  P  P  P  P  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F  F
        //     3  4  5  6  7  8  9 10 |     3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
        //                            |
        // tb_bxclk_period = 6'h0A;   | tb_bxclk_period = 6'h28;
        // tb_bxclk_delay  = 5'h4;    | tb_bxclk_delay  = 5'h11;
        //
        //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //
        // use this section to record behavior when scan_out test-bench emulation is more close to ASIC behavior => scan_out==scan_in BUT make it toggle @(posedge bxclk)
        // BXCLKANA RE is always on same counter, by design feature: counter==2
        // BXCLK    RE is constant for this test and it is set by tb_bxclk_delay = 5'h2 => BXCLK RE will be at counter==4
        tb_test_delay            = tb_j_test & 6'h3F;
        tb_test_sample           = tb_i_test & 6'h3F;
        tb_test_number           = test_number_1;              // on clock domain fw_axi_clk
        tb_test_loopback         = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
        tb_test_trig_out_phase   = 6'h00;                      // on clock domain fw_axi_clk
        tb_test_mask_reset_not   = 1'b0;      //$urandom_range(1, 0) & 1'h1;// on clock domain fw_axi_clk
        //
        w_execute();
        tb_number   = 503;
        #(2*770*tb_bxclk_period*fw_pl_clk1_period);            // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when sm_test1_o_status_done is asserted
        if(sw_read32_1[status_index_test1_done]===1'b1) begin
          $display("time=%06.2f tb_j_test=%01d tb_i_test=%01d tb_test_delay=%01d tb_test_sample=%01d tb_firmware_id=%01d test1 in tb_test_loopback=%01d tb_test_mask_reset_not=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...",
            $realtime(), tb_j_test, tb_i_test, tb_test_delay, tb_test_sample, tb_firmware_id, tb_test_loopback, tb_test_mask_reset_not);
        end else begin
          $display("time=%06.2f tb_j_test=%01d tb_i_test=%01d tb_test_delay=%01d tb_test_sample=%01d tb_firmware_id=%01d test1 in tb_test_loopback=%01d tb_test_mask_reset_not=%01d NOT DONE",
            $realtime(), tb_j_test, tb_i_test, tb_test_delay, tb_test_sample, tb_firmware_id, tb_test_loopback, tb_test_mask_reset_not);
          tb_err[tb_err_index_test1] = 1'b1;
        end
        #(10*fw_axi_clk_period);
        tb_number   = 504;
        // READ fw_op_code_r_data_array_0
        check_r_data_array_0_counter(.read_n_32bit_words(48));   // readout: number of 32-bit words is 48 for firmware_id_2 and test_number_1
        #(50*fw_axi_clk_period);                                 // readout: wait for at least 48 AXI clock cycles
        tb_number   = 505;
        // READ fw_op_code_r_data_array_1
        check_r_data_array_1_counter_b(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for firmware_id_2 and test_number_1
        #(50*fw_axi_clk_period);                                 // readout: wait for at least 48 AXI clock cycles
      end
    end
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
    tb_i_test   = 0;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period            = 6'h0A;                    // on clock domain fw_axi_clk
    tb_bxclk_delay             = 5'h3;                     // on clock domain fw_axi_clk
    tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    tb_super_pix_sel           = 1'h1;                     // on clock domain fw_axi_clk
    tb_scan_load_delay         = 6'h0A;                    // on clock domain fw_axi_clk
    tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 602;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    for (tb_i_test = 0; tb_i_test <= 5; tb_i_test++) begin
      tb_test_delay            = 6'h08;                      // on clock domain fw_axi_clk
      tb_test_sample           = 6'h05;                      // for NORMAL testing, use this statement for which TB PASS; to simulate TB FAIL due to wrong tb_test_sample, use following 6 statements
//      if(tb_i_test==0) tb_test_sample = 6'h09;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0
//      if(tb_i_test==1) tb_test_sample = 6'h0A;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1
//      if(tb_i_test==2) tb_test_sample = 6'h01;               // this will FAIL - sampling PREVIOUS scan_out bit tb_test_loopback==0
//      if(tb_i_test==3) tb_test_sample = 6'h02;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1
//      if(tb_i_test==4) tb_test_sample = 6'h03;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==0
//      if(tb_i_test==5) tb_test_sample = 6'h04;               // this will PASS - sampling CORRECT  scan_out bit tb_test_loopback==1
      tb_test_number           = test_number_2;              // on clock domain fw_axi_clk
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_trig_out_phase   = 6'h04;                      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      w_execute();
      tb_number   = 603;
      #(2*(770+tb_scan_load_delay+2)*tb_bxclk_period*fw_pl_clk1_period);         // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when sm_test2_o_status_done is asserted
      if(sw_read32_1[status_index_test2_done]===1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test2 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_counter()...", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test2 in loopback=%01d NOT DONE", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback);
        tb_err[tb_err_index_test2] = 1'b1;
      end
      #(10*fw_axi_clk_period);
      tb_number   = 604;
      // READ fw_op_code_r_data_array_0
      check_r_data_array_0_counter(.read_n_32bit_words(48));   // readout: number of 32-bit words is 48 for firmware_id_2 and test_number_2
      #(50*fw_axi_clk_period);                                 // readout: wait for at least 48 AXI clock cycles
      tb_number   = 605;
      // READ fw_op_code_r_data_array_1
      check_r_data_array_1_counter_b(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for firmware_id_2 and test_number_2
      #(50*fw_axi_clk_period);                                 // readout: wait for at least 48 AXI clock cycles
    end
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 7: Test DNN ReadOut. TEST_NUMBER==3
    tb_testcase = "T7. DNN ReadOut";
    tb_number   = 7;
    tb_firmware_id         = firmware_id_2;
//    w_reset();
    tb_dnn_reg_0_random[63:32] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_1_random[63:32] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_0_random[31: 0] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_1_random[31: 0] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_number   = 701;
    tb_i_test   = 0;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period            = 6'h0A;                    // on clock domain fw_axi_clk
    tb_bxclk_delay             = 5'h4;                     // on clock domain fw_axi_clk
    tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    tb_super_pix_sel           = 1'h0;                     // on clock domain fw_axi_clk
    tb_scan_load_delay         = 6'h05;                    // on clock domain fw_axi_clk
    tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 702;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    for (tb_i_test = 0; tb_i_test <= 3; tb_i_test++) begin
      tb_test_delay            = 6'h05;                      // on clock domain fw_axi_clk
      tb_test_sample           = 6'h06;                      // on clock domain fw_axi_clk
      tb_test_number           = test_number_3;              // on clock domain fw_axi_clk
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_trig_out_phase   = 6'h03;                      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      w_execute();
      tb_number   = 703;
//  #(2*(770+tb_scan_load_delay+2)*tb_bxclk_period*fw_pl_clk1_period);         // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when sm_test2_o_status_done is asserted
      #((5+tb_scan_load_delay+2)*tb_bxclk_period*fw_pl_clk1_period);             // execution: wait for at least 5 BXCLK cycles; alternatively check when sm_test3_o_status_done;
      if(sw_read32_1[status_index_test3_done]===1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test3 in loopback=%01d DONE tb_dnn_reg_0_random=%016h tb_dnn_reg_1_random=%016h; starting to check readout data: calling check_r_data_array_0_dnn()...", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback, tb_dnn_reg_0_random, tb_dnn_reg_1_random);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test3 in loopback=%01d NOT DONE tb_dnn_reg_0_random=%016h tb_dnn_reg_1_random=%016h", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback, tb_dnn_reg_0_random, tb_dnn_reg_1_random);
        tb_err[tb_err_index_test3] = 1'b1;
      end
      #(10*fw_axi_clk_period);
      tb_number   = 704;
      // READ fw_op_code_r_data_array_0
      check_r_data_array_n_dnn(.r_data_array_n(0));          // readout: R_DATA_ARRAY_0 for test_number_3;
      #(10*fw_axi_clk_period);                               // readout: wait for at least 4 AXI clock cycles
    end
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 8: Test SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister (see Test 6) + Test DNN ReadOut (see Test 7). TEST_NUMBER==4
    tb_testcase = "T8. SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister + DNN ReadOut";
    tb_number   = 8;
    tb_firmware_id         = firmware_id_2;
//    w_reset();
    tb_dnn_reg_0_random[63:32] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_1_random[63:32] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_0_random[31: 0] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_dnn_reg_1_random[31: 0] = $urandom_range(2**32-1, 0) & 32'hFFFFFFFF;
    tb_number   = 801;
    tb_i_test   = 0;
    #(5*fw_axi_clk_period);
    // Use predefined BXCLK/ANA 40MHz with 5ns delay
    tb_bxclk_period            = 6'h28;                    // on clock domain fw_axi_clk
    tb_bxclk_delay             = 5'h3;                     // on clock domain fw_axi_clk
    tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
    tb_super_pix_sel           = 1'h1;                     // on clock domain fw_axi_clk
    tb_scan_load_delay         = 6'h0A;                    // on clock domain fw_axi_clk
    tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
    w_cfg_static_fixed(.index(0));
    tb_number   = 802;                                     // BXCLK/ANA is programmed
    #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
    for (tb_i_test = 0; tb_i_test <= 3; tb_i_test++) begin
      tb_test_delay            = 6'h08;                      // on clock domain fw_axi_clk
      tb_test_sample           = 6'h07;                      // on clock domain fw_axi_clk
      tb_test_number           = test_number_4;              // on clock domain fw_axi_clk
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_trig_out_phase   = 6'h04;                      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      w_execute();
      tb_number   = 803;
      #(2*(770+tb_scan_load_delay+2)*tb_bxclk_period*fw_pl_clk1_period);         // execution: wait for at least 2*768+1 BXCLK cycles; alternatively check when sm_test4_o_status_done is asserted
      if(sw_read32_1[status_index_test4_done]===1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test4 in loopback=%01d DONE tb_dnn_reg_0_random=%016h tb_dnn_reg_1_random=%016h; starting to check readout data: calling check_r_data_array_0_counter()...check_r_data_array_1_dnn()", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback, tb_dnn_reg_0_random, tb_dnn_reg_1_random);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test4 in loopback=%01d NOT DONE tb_dnn_reg_0_random=%016h tb_dnn_reg_1_random=%016h", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback, tb_dnn_reg_0_random, tb_dnn_reg_1_random);
        tb_err[tb_err_index_test4] = 1'b1;
      end
      #(10*fw_axi_clk_period);
      tb_number   = 804;
      // READ fw_op_code_r_data_array_0
      check_r_data_array_0_counter(.read_n_32bit_words(48)); // readout: number of 32-bit words is 48 for firmware_id_2 and test_number_4
      #(50*fw_axi_clk_period);                               // readout: wait for at least 48 AXI clock cycles
      tb_number   = 805;
      // READ fw_op_code_r_data_array_1
      check_r_data_array_n_dnn(.r_data_array_n(1));          // readout: R_DATA_ARRAY_1 for test_number_3;
      #(5*fw_axi_clk_period);                                // readout: wait for at least 4 AXI clock cycles
    end
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    // Test 9: Test SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister (see Test 6). TEST_NUMBER==5
    tb_testcase = "T9. SCAN-CHAIN-MODULE as a parallel-in / serial-out shift-tegister";
    tb_number   = 9;
    //logic [255:0][2:0]  tb_w_cfg_pixels_256x3;               // test_number_5: [256-pixels][3-bits-per-pixel] ==  768-bits
    //logic [256*16-1:0]  tb_w_cfg_pixels_4096;                // test_number_5: [256 * 16  ]                   == 4096-bits
    //logic [255:0][15:0] tb_w_cfg_pixels_256x16;              // test_number_5: [256       ][16              ] == 4096-bits
    tb_firmware_id = firmware_id_2;
    tb_i_test      = 0;
    for (tb_i_test = 0; tb_i_test <= 3; tb_i_test++) begin
      tb_w_cfg_pixels_256x3  = pixel_cfg_array();
      #(5*fw_axi_clk_period);
      $display("time=%06.2f test5; PIX[015...000] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 15:  0]);
      $display("time=%06.2f test5; PIX[031...016] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 31: 16]);
      $display("time=%06.2f test5; PIX[047...032] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 47: 32]);
      $display("time=%06.2f test5; PIX[063...048] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 63: 48]);
      $display("time=%06.2f test5; PIX[079...064] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 79: 64]);
      $display("time=%06.2f test5; PIX[095...080] = %b", $realtime(), tb_w_cfg_pixels_256x3[ 95: 80]);
      $display("time=%06.2f test5; PIX[111...096] = %b", $realtime(), tb_w_cfg_pixels_256x3[111: 96]);
      $display("time=%06.2f test5; PIX[127...112] = %b", $realtime(), tb_w_cfg_pixels_256x3[127:112]);
      $display("time=%06.2f test5; PIX[143...128] = %b", $realtime(), tb_w_cfg_pixels_256x3[143:128]);
      $display("time=%06.2f test5; PIX[159...144] = %b", $realtime(), tb_w_cfg_pixels_256x3[159:144]);
      $display("time=%06.2f test5; PIX[175...160] = %b", $realtime(), tb_w_cfg_pixels_256x3[175:160]);
      $display("time=%06.2f test5; PIX[191...176] = %b", $realtime(), tb_w_cfg_pixels_256x3[191:176]);
      $display("time=%06.2f test5; PIX[207...192] = %b", $realtime(), tb_w_cfg_pixels_256x3[207:192]);
      $display("time=%06.2f test5; PIX[223...208] = %b", $realtime(), tb_w_cfg_pixels_256x3[223:208]);
      $display("time=%06.2f test5; PIX[239...224] = %b", $realtime(), tb_w_cfg_pixels_256x3[239:224]);
      $display("time=%06.2f test5; PIX[255...240] = %b", $realtime(), tb_w_cfg_pixels_256x3[255:240]);
      //for(int i=0; i<16; i++)begin
      //  $display("time=%06.2f test5; PIX[%03d..%03d] = %b", $realtime(), i*16, (i+1)*16-1, tb_w_cfg_pixels_256x3[i*16+15 : i*16]);  // xmvlog: *E,NOTPAR (./vrf/fw_ipx_wrap_tb.sv,1247|113): Illegal operand for constant expression [4(IEEE)].
      //end
      tb_number   = 901;
      // WRITE fw_op_code_w_cfg_array_0
      w_cfg_array_0_pixel();
      #(5*fw_axi_clk_period);
      tb_number   = 902;
      // READ fw_op_code_r_cfg_array_0
      check_r_cfg_array_0_pixel();
      #(5*fw_axi_clk_period);
      tb_number   = 903;
      // Use predefined BXCLK/ANA 40MHz with 5ns delay
      tb_bxclk_period            = 6'h28;                    // on clock domain fw_axi_clk
      tb_bxclk_delay             = 5'h3;                     // on clock domain fw_axi_clk
      tb_bxclk_delay_sign        = 1'h0;                     // on clock domain fw_axi_clk
      tb_super_pix_sel           = 1'h1;                     // on clock domain fw_axi_clk
      tb_scan_load_delay         = 6'h0A;                    // on clock domain fw_axi_clk
      tb_scan_load_delay_disable = 1'h0;                     // on clock domain fw_axi_clk
      w_cfg_static_fixed(.index(0));
      #(5*fw_axi_clk_period);
      tb_number   = 904;
      tb_select_pixel            = $urandom_range(2**8-1, 0) & 8'hFF;
      tb_repeat_pixel            = 11'h010; // $urandom_range(1365, 1) & 11'h7FF;//11'h00C;
      w_cfg_static_fixed(.index(1));
      tb_number   = 905;                                     // BXCLK/ANA is programmed
      #(64*fw_axi_clk_period);                               // dummy wait to ensure BXCLK/ANA are started (the fw_pl_clk1_cnt did roll over)
      tb_test_delay            = 6'h08+(tb_i_test & 6'h3F);  // on clock domain fw_axi_clk
      tb_test_sample           = 6'h08;                      // on clock domain fw_axi_clk
      tb_test_number           = test_number_5;              // on clock domain fw_axi_clk
      tb_test_loopback         = (tb_i_test & 2'h1)>>0;      // on clock domain fw_axi_clk
      tb_test_trig_out_phase   = 6'h04;                      // on clock domain fw_axi_clk
      tb_test_mask_reset_not   = (tb_i_test & 2'h2)>>1;      // on clock domain fw_axi_clk
      w_execute();
      tb_number   = 906;
      #(tb_repeat_pixel*(770+tb_scan_load_delay+4)*tb_bxclk_period*fw_pl_clk1_period); // execution: wait for at least tb_repeat_pixel*(1*768+1) BXCLK cycles; alternatively check when sm_test5_o_status_done is asserted
      if(sw_read32_1[status_index_test5_done]===1'b1) begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test5 in loopback=%01d DONE; starting to check readout data: calling check_r_data_array_0_pixel()...check_r_data_array_1_pixel() PIX[%03d]=%03b", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback, tb_select_pixel, tb_w_cfg_pixels_256x3[tb_select_pixel]);
      end else begin
        $display("time=%06.2f tb_i_test=%01d firmware_id=%01d test5 in loopback=%01d NOT DONE", $realtime(), tb_i_test, tb_firmware_id, tb_test_loopback);
        tb_err[tb_err_index_test5] = 1'b1;
      end
      #(10*fw_axi_clk_period);
      tb_number   = 907;
      // READ fw_op_code_r_data_array_0
      check_r_data_array_0_pixel(.read_n_32bit_words(24));   // readout: R_DATA_ARRAY_0 for test_number_5: number of 32-bit words is 24 for firmware_id_2 and test_number_5
      #(25*fw_axi_clk_period);                               // readout: wait for at least 24 AXI clock cycles
      tb_number   = 908;
      // READ fw_op_code_r_data_array_1
      check_r_data_array_1_pixel(.read_n_32bit_words(128));  // readout: R_DATA_ARRAY_1 for test_number_5: number of 32-bit words is 128 for firmware_id_2 and test_number_5
      #(150*fw_axi_clk_period);                              // readout: wait for at least 4096/32=128 AXI clock cycles
    end
    tb_firmware_id = firmware_id_none;
    #(5*fw_axi_clk_period);
    $display("time %06.2f done: tb_testcase=%s\n%s", $realtime, tb_testcase, {80{"-"}});
    //---------------------------------------------------------------------------------------------
    #(500*fw_axi_clk_period);

    $display("%s", {80{"-"}});
    $display("simulation done: time %06.2f tb_err = %024b DUT.fw_ip2_inst.fw_read_status32=%032b", $realtime, tb_err, DUT.fw_ip2_inst.fw_read_status32);
    $display("%s", {80{"-"}});

    #(10*fw_axi_clk_period);
    $finish;

  end

  initial begin
    //$dumpfile("/asic/projects/C/CMS_PIX_28/gingu/cms_pix_28_test_firmware/vivado_runs/dump.vcd");
    //$dumpvars(1, bxclk, tb_dnn_reg_0);
    //$dumpvars(levels, list_of_modules_or_variables);
  end

endmodule

`endif
