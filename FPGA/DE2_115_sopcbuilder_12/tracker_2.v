// tracker_2.v

// This file was auto-generated as part of a generation operation.
// If you edit it your changes will probably be lost.

`timescale 1 ps / 1 ps
module tracker_2 (
		input  wire        csi_clk,           //       clock.clk
		input  wire        csi_reset_n,       // clock_reset.reset_n
		input  wire [5:0]  avs_s1_address,    //          s1.address
		input  wire        avs_s1_chipselect, //            .chipselect
		input  wire        avs_s1_read,       //            .read
		output wire [31:0] avs_s1_readdata,   //            .readdata
		input  wire        avs_s1_write,      //            .write
		input  wire [31:0] avs_s1_writedata,  //            .writedata
		input  wire        avs_export_clock,  //      export.export
		input  wire        avs_export_write,  //            .export
		input  wire        avs_export_pixel,  //            .export
		input  wire [11:0] avs_export_x,      //            .export
		input  wire [11:0] avs_export_y,      //            .export
		input  wire        avs_export_done,   //            .export
		input  wire [11:0] avs_export_width,  //            .export
		input  wire [11:0] avs_export_height  //            .export
	);

	avalon_locator #(
		.X      (14'b00000000000000),
		.Y      (14'b00000000000000),
		.WIDTH  (14'b00101000100000),
		.HEIGHT (14'b00011110011000)
	) tracker_2 (
		.csi_clk           (csi_clk),           //       clock.clk
		.csi_reset_n       (csi_reset_n),       // clock_reset.reset_n
		.avs_s1_address    (avs_s1_address),    //          s1.address
		.avs_s1_chipselect (avs_s1_chipselect), //            .chipselect
		.avs_s1_read       (avs_s1_read),       //            .read
		.avs_s1_readdata   (avs_s1_readdata),   //            .readdata
		.avs_s1_write      (avs_s1_write),      //            .write
		.avs_s1_writedata  (avs_s1_writedata),  //            .writedata
		.avs_export_clock  (avs_export_clock),  //      export.export
		.avs_export_write  (avs_export_write),  //            .export
		.avs_export_pixel  (avs_export_pixel),  //            .export
		.avs_export_x      (avs_export_x),      //            .export
		.avs_export_y      (avs_export_y),      //            .export
		.avs_export_done   (avs_export_done),   //            .export
		.avs_export_width  (avs_export_width),  //            .export
		.avs_export_height (avs_export_height)  //            .export
	);

endmodule
