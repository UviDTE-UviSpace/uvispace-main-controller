// camera.v

// This file was auto-generated as part of a generation operation.
// If you edit it your changes will probably be lost.

`timescale 1 ps / 1 ps
module camera (
		input  wire        csi_clk,                          //       clock.clk
		input  wire        csi_reset_n,                      // clock_reset.reset_n
		input  wire [4:0]  avs_s1_address,                   //          s1.address
		input  wire        avs_s1_chipselect,                //            .chipselect
		input  wire        avs_s1_read,                      //            .read
		output wire [31:0] avs_s1_readdata,                  //            .readdata
		input  wire        avs_s1_write,                     //            .write
		input  wire [31:0] avs_s1_writedata,                 //            .writedata
		output wire        avs_export_clk,                   //      export.export
		output wire        avs_export_capture_start,         //            .export
		input  wire        avs_export_capture_done,          //            .export
		output wire        avs_export_capture_configure,     //            .export
		input  wire        avs_export_capture_ready,         //            .export
		output wire        avs_export_capture_select_vga,    //            .export
		output wire [7:0]  avs_export_capture_select_output, //            .export
		output wire        avs_export_capture_read,          //            .export
		input  wire [31:0] avs_export_capture_readdata,      //            .export
		output wire [15:0] avs_export_width,                 //            .export
		output wire [15:0] avs_export_height,                //            .export
		output wire [15:0] avs_export_start_row,             //            .export
		output wire [15:0] avs_export_start_column,          //            .export
		output wire [15:0] avs_export_row_size,              //            .export
		output wire [15:0] avs_export_column_size,           //            .export
		output wire [15:0] avs_export_row_mode,              //            .export
		output wire [15:0] avs_export_column_mode,           //            .export
		output wire [15:0] avs_export_exposure               //            .export
	);

	avalon_camera #(
		.WIDTH        (18'b000000000101000000),
		.HEIGHT       (18'b000000000011110000),
		.START_ROW    (18'b000000000000110110),
		.START_COLUMN (18'b000000000000010000),
		.ROW_SIZE     (18'b000000010110011111),
		.COLUMN_SIZE  (18'b000000011101111111),
		.ROW_MODE     (18'b000000000000000010),
		.COLUMN_MODE  (18'b000000000000000010),
		.EXPOSURE     (18'b000000011111000000)
	) camera (
		.csi_clk                          (csi_clk),                          //       clock.clk
		.csi_reset_n                      (csi_reset_n),                      // clock_reset.reset_n
		.avs_s1_address                   (avs_s1_address),                   //          s1.address
		.avs_s1_chipselect                (avs_s1_chipselect),                //            .chipselect
		.avs_s1_read                      (avs_s1_read),                      //            .read
		.avs_s1_readdata                  (avs_s1_readdata),                  //            .readdata
		.avs_s1_write                     (avs_s1_write),                     //            .write
		.avs_s1_writedata                 (avs_s1_writedata),                 //            .writedata
		.avs_export_clk                   (avs_export_clk),                   //      export.export
		.avs_export_capture_start         (avs_export_capture_start),         //            .export
		.avs_export_capture_done          (avs_export_capture_done),          //            .export
		.avs_export_capture_configure     (avs_export_capture_configure),     //            .export
		.avs_export_capture_ready         (avs_export_capture_ready),         //            .export
		.avs_export_capture_select_vga    (avs_export_capture_select_vga),    //            .export
		.avs_export_capture_select_output (avs_export_capture_select_output), //            .export
		.avs_export_capture_read          (avs_export_capture_read),          //            .export
		.avs_export_capture_readdata      (avs_export_capture_readdata),      //            .export
		.avs_export_width                 (avs_export_width),                 //            .export
		.avs_export_height                (avs_export_height),                //            .export
		.avs_export_start_row             (avs_export_start_row),             //            .export
		.avs_export_start_column          (avs_export_start_column),          //            .export
		.avs_export_row_size              (avs_export_row_size),              //            .export
		.avs_export_column_size           (avs_export_column_size),           //            .export
		.avs_export_row_mode              (avs_export_row_mode),              //            .export
		.avs_export_column_mode           (avs_export_column_mode),           //            .export
		.avs_export_exposure              (avs_export_exposure)               //            .export
	);

endmodule
