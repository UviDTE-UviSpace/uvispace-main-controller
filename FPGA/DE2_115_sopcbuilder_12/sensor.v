// sensor.v

// This file was auto-generated as part of a generation operation.
// If you edit it your changes will probably be lost.

`timescale 1 ps / 1 ps
module sensor (
		input  wire        csi_clk,                        //       clock.clk
		input  wire        csi_reset_n,                    // clock_reset.reset_n
		input  wire [7:0]  avs_s1_address,                 //          s1.address
		input  wire        avs_s1_chipselect,              //            .chipselect
		input  wire        avs_s1_read,                    //            .read
		output wire [31:0] avs_s1_readdata,                //            .readdata
		input  wire        avs_s1_write,                   //            .write
		input  wire [31:0] avs_s1_writedata,               //            .writedata
		output wire [31:0] avs_export_red_threshold_min,   //      export.export
		output wire [31:0] avs_export_red_threshold_max,   //            .export
		output wire [31:0] avs_export_green_threshold_min, //            .export
		output wire [31:0] avs_export_green_threshold_max, //            .export
		output wire [31:0] avs_export_blue_threshold_min,  //            .export
		output wire [31:0] avs_export_blue_threshold_max   //            .export
	);

	apio_sensor #(
		.RED_THRESHOLD_MIN   (34'b0000011001010100000000000000000000),
		.RED_THRESHOLD_MAX   (34'b0000111111111101010001010101000101),
		.GREEN_THRESHOLD_MIN (34'b0000000000000001000100110000000000),
		.GREEN_THRESHOLD_MAX (34'b0000100011101111111111111000111011),
		.BLUE_THRESHOLD_MIN  (34'b0000000000000000000000000011010100),
		.BLUE_THRESHOLD_MAX  (34'b0000100010011010001001101111111111)
	) sensor (
		.csi_clk                        (csi_clk),                        //       clock.clk
		.csi_reset_n                    (csi_reset_n),                    // clock_reset.reset_n
		.avs_s1_address                 (avs_s1_address),                 //          s1.address
		.avs_s1_chipselect              (avs_s1_chipselect),              //            .chipselect
		.avs_s1_read                    (avs_s1_read),                    //            .read
		.avs_s1_readdata                (avs_s1_readdata),                //            .readdata
		.avs_s1_write                   (avs_s1_write),                   //            .write
		.avs_s1_writedata               (avs_s1_writedata),               //            .writedata
		.avs_export_red_threshold_min   (avs_export_red_threshold_min),   //      export.export
		.avs_export_red_threshold_max   (avs_export_red_threshold_max),   //            .export
		.avs_export_green_threshold_min (avs_export_green_threshold_min), //            .export
		.avs_export_green_threshold_max (avs_export_green_threshold_max), //            .export
		.avs_export_blue_threshold_min  (avs_export_blue_threshold_min),  //            .export
		.avs_export_blue_threshold_max  (avs_export_blue_threshold_max)   //            .export
	);

endmodule
