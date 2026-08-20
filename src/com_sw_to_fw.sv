// ------------------------------------------------------------------------------------
// Author       : Cristian Gingu       gingu@fnal.gov
// Created      : 2024-05-22
// ------------------------------------------------------------------------------------
// Copyright (c) 2024 by FNAL This model is the confidential and
// proprietary property of FNAL and the possession or use of this
// file requires a written license from FNAL.
// ------------------------------------------------------------------------------------
// Revisions  :
// Date        Author                 Description
// 2024-05-22  Cristian  Gingu        Created; this is a combinatorial module
// 2024-07-23  Cristian Gingu         Add fw_op_code_w_cfg_array_2 and fw_op_code_r_cfg_array_2
// 2024-08-12  Cristian Gingu         Add references to cms_pix28_package.sv
// ------------------------------------------------------------------------------------
`ifndef __com_sw_to_fw__
`define __com_sw_to_fw__
`timescale 1 ns/ 1 ps

module com_sw_to_fw(
    // SW side ports:
    input  logic [31:0] sw_write32_0,                      // register#0 32-bit write       from SW to FW
    output logic [31:0] sw_read32_0,                       // register#0 32-bit read_data   from FW to SW
    output logic [31:0] sw_read32_1,                       // register#1 32-bit read_status from FW to SW
    // FW side ports
    output logic [3:0]  fw_dev_id_enable,                  // up to 15 FW can be connected;
    output logic        fw_op_code_w_reset,
    output logic        fw_op_code_w_cfg_static_0,
    output logic        fw_op_code_r_cfg_static_0,
    output logic        fw_op_code_w_cfg_static_1,
    output logic        fw_op_code_r_cfg_static_1,
    output logic        fw_op_code_w_cfg_array_0,
    output logic        fw_op_code_r_cfg_array_0,
    output logic        fw_op_code_w_cfg_array_1,
    output logic        fw_op_code_r_cfg_array_1,
    output logic        fw_op_code_w_cfg_array_2,
    output logic        fw_op_code_r_cfg_array_2,
    output logic        fw_op_code_r_data_array_0,
    output logic        fw_op_code_r_data_array_1,
    output logic        fw_op_code_w_status_clear,
    output logic        fw_op_code_w_execute,
    output logic [23:0]      sw_write24_0,                 // feed-through bytes 2, 1, 0 of sw_write32_0 from SW to FW
    input  logic [3:0][31:0] fw_read_data32,               // 32-bit read_data   from FW to SW
    input  logic [3:0][31:0] fw_read_status32              // 32-bit read_status from FW to SW
  );

  import cms_pix28_package::windex_device_id_max;          // write index for device_id       (upper)
  import cms_pix28_package::windex_device_id_min;          // write index for device_id       (lower)
  import cms_pix28_package::windex_op_code_max;            // write index for operation_code  (upper)
  import cms_pix28_package::windex_op_code_min;            // write index for operation_code  (lower)
  import cms_pix28_package::windex_body_max;               // write index for body_data       (upper)
  import cms_pix28_package::windex_body_min;               // write index for body_data       (lower)
  //
  import cms_pix28_package::firmware_id_1;
  import cms_pix28_package::firmware_id_2;
  import cms_pix28_package::firmware_id_3;
  import cms_pix28_package::firmware_id_4;
  import cms_pix28_package::firmware_id_none;
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
  // Device ID decoder: this is used to enable one-and-only-one firmware at a time.
  // The following is using hot bit encoding. If more than FOUR firmwares will be used, change the decoding below.
  // Simultaneously use the same always_comb to encode the sw_read32_0 and sw_read32_1
  always_comb begin
    if         (sw_write32_0[windex_device_id_max:windex_device_id_min]==firmware_id_1) begin
      fw_dev_id_enable  = firmware_id_1;
      sw_read32_0       = fw_read_data32[0];
      sw_read32_1       = fw_read_status32[0];
    end else if(sw_write32_0[windex_device_id_max:windex_device_id_min]==firmware_id_2) begin
      fw_dev_id_enable  = firmware_id_2;
      sw_read32_0       = fw_read_data32[1];
      sw_read32_1       = fw_read_status32[1];
    end else if(sw_write32_0[windex_device_id_max:windex_device_id_min]==firmware_id_3) begin
      fw_dev_id_enable  = firmware_id_3;
      sw_read32_0       = fw_read_data32[2];
      sw_read32_1       = fw_read_status32[2];
    end else if(sw_write32_0[windex_device_id_max:windex_device_id_min]==firmware_id_4) begin
      fw_dev_id_enable  = firmware_id_4;
      sw_read32_0       = fw_read_data32[3];
      sw_read32_1       = fw_read_status32[3];
    end else begin
      fw_dev_id_enable  = firmware_id_none;
      sw_read32_0       = 32'h0;
      sw_read32_1       = 32'h0;
    end
  end

  // Operation Code decoder:
  assign fw_op_code_w_reset        = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_RST_FW          ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_cfg_static_0 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_CFG_STATIC_0    ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_cfg_static_0 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_CFG_STATIC_0    ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_cfg_static_1 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_CFG_STATIC_1    ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_cfg_static_1 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_CFG_STATIC_1    ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_cfg_array_0  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_CFG_ARRAY_0     ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_cfg_array_0  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_CFG_ARRAY_0     ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_cfg_array_1  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_CFG_ARRAY_1     ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_cfg_array_1  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_CFG_ARRAY_1     ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_cfg_array_2  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_CFG_ARRAY_2     ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_cfg_array_2  = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_CFG_ARRAY_2     ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_data_array_0 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_DATA_ARRAY_0    ) ? 1'b1 : 1'b0;
  assign fw_op_code_r_data_array_1 = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_R_DATA_ARRAY_1    ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_status_clear = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_STATUS_FW_CLEAR ) ? 1'b1 : 1'b0;
  assign fw_op_code_w_execute      = (sw_write32_0[windex_op_code_max:windex_op_code_min]==OP_CODE_W_EXECUTE         ) ? 1'b1 : 1'b0;

  // Body data feed through: bytes 2, 1, 0
  assign sw_write24_0 = sw_write32_0[windex_body_max:windex_body_min];

endmodule

`endif
