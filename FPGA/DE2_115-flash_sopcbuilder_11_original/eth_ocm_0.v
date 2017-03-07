// eth_ocm_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module eth_ocm_0 (
		input  wire        av_chipselect,       //       control_port.chipselect
		input  wire        av_write,            //                   .write
		input  wire        av_read,             //                   .read
		input  wire [31:0] av_writedata,        //                   .writedata
		output wire [31:0] av_readdata,         //                   .readdata
		output wire        av_waitrequest_n,    //                   .waitrequest_n
		input  wire [9:0]  av_address,          //                   .address
		input  wire        av_clk,              //       avalon_clock.clk
		input  wire        av_reset,            // avalon_clock_reset.reset
		input  wire [31:0] av_tx_readdata,      //          tx_master.readdata
		input  wire        av_tx_waitrequest,   //                   .waitrequest
		input  wire        av_tx_readdatavalid, //                   .readdatavalid
		output wire [31:0] av_tx_address,       //                   .address
		output wire        av_tx_read,          //                   .read
		output wire [3:0]  av_tx_burstcount,    //                   .burstcount
		input  wire        av_rx_waitrequest,   //          rx_master.waitrequest
		output wire [31:0] av_rx_address,       //                   .address
		output wire        av_rx_write,         //                   .write
		output wire [31:0] av_rx_writedata,     //                   .writedata
		output wire [3:0]  av_rx_byteenable,    //                   .byteenable
		output wire [3:0]  av_rx_burstcount,    //                   .burstcount
		output wire [3:0]  mtxd_pad_o,          //             global.export
		output wire        mtxen_pad_o,         //                   .export
		output wire        mtxerr_pad_o,        //                   .export
		input  wire        mrx_clk_pad_i,       //                   .export
		input  wire [3:0]  mrxd_pad_i,          //                   .export
		input  wire        mrxdv_pad_i,         //                   .export
		input  wire        mrxerr_pad_i,        //                   .export
		input  wire        mcoll_pad_i,         //                   .export
		input  wire        mcrs_pad_i,          //                   .export
		output wire        mdc_pad_o,           //                   .export
		input  wire        md_pad_i,            //                   .export
		output wire        md_pad_o,            //                   .export
		output wire        md_padoe_o,          //                   .export
		input  wire        mtx_clk_pad_i,       //                   .export
		output wire        av_irq               //        control_irq.irq
	);

	eth_ocm #(
		.MEM_WIDTH         (32),
		.TOTAL_DESCRIPTORS (128),
		.TX_FIFO_DEPTH     (128),
		.TX_BURST_ENABLE   (1),
		.TX_BURST_TARGET   (8),
		.RX_FIFO_DEPTH     (1024),
		.RX_BURST_ENABLE   (1),
		.RX_BURST_TARGET   (8)
	) eth_ocm_0 (
		.av_chipselect       (av_chipselect),       //       control_port.chipselect
		.av_write            (av_write),            //                   .write
		.av_read             (av_read),             //                   .read
		.av_writedata        (av_writedata),        //                   .writedata
		.av_readdata         (av_readdata),         //                   .readdata
		.av_waitrequest_n    (av_waitrequest_n),    //                   .waitrequest_n
		.av_address          (av_address),          //                   .address
		.av_clk              (av_clk),              //       avalon_clock.clk
		.av_reset            (av_reset),            // avalon_clock_reset.reset
		.av_tx_readdata      (av_tx_readdata),      //          tx_master.readdata
		.av_tx_waitrequest   (av_tx_waitrequest),   //                   .waitrequest
		.av_tx_readdatavalid (av_tx_readdatavalid), //                   .readdatavalid
		.av_tx_address       (av_tx_address),       //                   .address
		.av_tx_read          (av_tx_read),          //                   .read
		.av_tx_burstcount    (av_tx_burstcount),    //                   .burstcount
		.av_rx_waitrequest   (av_rx_waitrequest),   //          rx_master.waitrequest
		.av_rx_address       (av_rx_address),       //                   .address
		.av_rx_write         (av_rx_write),         //                   .write
		.av_rx_writedata     (av_rx_writedata),     //                   .writedata
		.av_rx_byteenable    (av_rx_byteenable),    //                   .byteenable
		.av_rx_burstcount    (av_rx_burstcount),    //                   .burstcount
		.mtxd_pad_o          (mtxd_pad_o),          //             global.export
		.mtxen_pad_o         (mtxen_pad_o),         //                   .export
		.mtxerr_pad_o        (mtxerr_pad_o),        //                   .export
		.mrx_clk_pad_i       (mrx_clk_pad_i),       //                   .export
		.mrxd_pad_i          (mrxd_pad_i),          //                   .export
		.mrxdv_pad_i         (mrxdv_pad_i),         //                   .export
		.mrxerr_pad_i        (mrxerr_pad_i),        //                   .export
		.mcoll_pad_i         (mcoll_pad_i),         //                   .export
		.mcrs_pad_i          (mcrs_pad_i),          //                   .export
		.mdc_pad_o           (mdc_pad_o),           //                   .export
		.md_pad_i            (md_pad_i),            //                   .export
		.md_pad_o            (md_pad_o),            //                   .export
		.md_padoe_o          (md_padoe_o),          //                   .export
		.mtx_clk_pad_i       (mtx_clk_pad_i),       //                   .export
		.av_irq              (av_irq)               //        control_irq.irq
	);

endmodule
