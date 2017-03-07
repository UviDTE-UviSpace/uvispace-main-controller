/// 
/// Video Sensor System
/// ===================
///
/// The video sensor is an image capture and processing system to calculate 
/// the position of mobile robots in real time.
///
/// The image is captured and stored in SDRAM memory, and the Nios II is the
/// controller and the configurator of the system, it configures the camera
/// sensor and the image processing sensor module.
///
module DE2_115_WEB_SERVER (
        // Clock Input
        input CLOCK_50, // 50 MHz
        // Push Button
        input [3:0] KEY, // Pushbutton[3:0]
        // DPDT Switch
        input [17:0] SW, // Toggle Switch[17:0]
        // LED
        output [7:0] LEDG, // LED Green[8:0]
        output [17:0] LEDR, // LED Red[17:0]
        // 7-SEG Dispaly
        output [6:0] HEX0, // Seven Segment Digit 0
        output [6:0] HEX1, // Seven Segment Digit 1
        output [6:0] HEX2, // Seven Segment Digit 2
        output [6:0] HEX3, // Seven Segment Digit 3
        output [6:0] HEX4, // Seven Segment Digit 4
        output [6:0] HEX5, // Seven Segment Digit 5
        output [6:0] HEX6, // Seven Segment Digit 6
        output [6:0] HEX7, // Seven Segment Digit 7
        // SDRAM Interface
        inout [31:0] DRAM_DQ, // SDRAM Data bus 16 Bits
        output [12:0] DRAM_ADDR, // SDRAM Address bus 12 Bits
        output [3:0] DRAM_DQM, // SDRAM byte Data Mask 
        output DRAM_WE_N, // SDRAM Write Enable
        output DRAM_CAS_N, // SDRAM Column Address Strobe
        output DRAM_RAS_N, // SDRAM Row Address Strobe
        output DRAM_CS_N, // SDRAM Chip Select
        output [1:0] DRAM_BA, // SDRAM Bank Address
        output DRAM_CLK, // SDRAM Clock
        output DRAM_CKE, // SDRAM Clock Enable
        // SRAM Interface
        inout [15:0] SRAM_DQ, // SRAM Data bus 16 Bits
        output [19:0] SRAM_ADDR, // SRAM Address bus 20 Bits
        output SRAM_UB_N, // SRAM High-byte Data Mask 
        output SRAM_LB_N, // SRAM Low-byte Data Mask 
        output SRAM_WE_N, // SRAM Write Enable
        output SRAM_CE_N, // SRAM Chip Enable
        output SRAM_OE_N, // SRAM Output Enable
        // Ethernet Interface
        output ENET0_GTX_CLK,
        input ENET0_INT_N,
        output ENET0_MDC,
        inout ENET0_MDIO,
        output ENET0_RST_N,
        input ENET0_RX_CLK,
        input ENET0_RX_COL,
        input ENET0_RX_CRS,
        input [3:0] ENET0_RX_DATA,
        input ENET0_RX_DV,
        input ENET0_RX_ER,
        input ENET0_TX_CLK,
        output [3:0] ENET0_TX_DATA,
        output ENET0_TX_EN,
        output ENET0_TX_ER,
        input ENET0_LINK100,
        // Flash Interface
        inout [7:0] FL_DQ, // FLASH Data bus 8 Bits
        output [22:0] FL_ADDR, // FLASH Address bus 23 Bits
        output FL_WE_N, // FLASH Write Enable
        output FL_WP_N,
        output FL_RST_N, // FLASH Reset
        output FL_OE_N, // FLASH Output Enable
        output FL_CE_N, // FLASH Chip Enable
        input FL_RY,
        // LCD Module 16X2
        inout [7:0] LCD_DATA, // LCD Data bus 8 bits
        output LCD_ON, // LCD Power ON/OFF
        output LCD_BLON, // LCD Back Light ON/OFF
        output LCD_RW, // LCD Read/Write Select, 0 = Write, 1 = Read
        output LCD_EN, // LCD Enable
        output LCD_RS, // LCD Command/Data Select, 0 = Command, 1 = Data
        // VGA Interface
        output VGA_CLK, // VGA Clock
        output VGA_HS, // VGA H_SYNC
        output VGA_VS, // VGA V_SYNC
        output VGA_BLANK_N, // VGA BLANK
        output VGA_SYNC_N, // VGA SYNC
        output [7:0] VGA_R, // VGA Red[7:0]
        output [7:0] VGA_G, // VGA Green[7:0]
        output [7:0] VGA_B, // VGA Blue[7:0]
        // GPIO
        inout [35:0] GPIO // GPIO Connection
    );
    
//------------------------------------------------------------------------------

    // Clock signals
    wire clock_50;
    assign clock_50 = CLOCK_50;
    
    // SDRAM clock signals
    wire sdram_clock;
    wire dram_clock;
    wire clock_24;
    wire clock_25;
	
    sdram_pll u6 (
        .inclk0(clock_50),
        .c0(sdram_clock),
        .c1(dram_clock),
        .c2(clock_24),
        .c3(clock_25)
    );

//------------------------------------------------------------------------------
   
    // Switchs and Keys map (Push Buttons and Toggle Switches)
   
    // System reset
    wire reset_n;
    assign reset_n = KEY[0];
   
    // Image capture and reconfiguration of camera sensor
    wire configure_n; // Reconfigure camera sensor (reset_n)
    wire select_vga;
    
    wire [17:0] led_red;
    wire [7:0] led_green;
    
    assign led_red[17] = configure_n;
    assign led_red[16] = camera_ready;
    assign led_red[15] = select_vga;
    assign led_red[14] = capture_start;
    assign led_red[13] = image_captured;
    assign led_red[12] = sensor_done;
    assign led_red[11] = out_camera_write;
    assign led_red[10:4] = 7'b0;
    assign led_red[3:0] = capture_select_sensor[3:0];
   
    // VGA/Nios read SDRAM selection
    assign out_sdram_clock = capture_clk;
    assign out_sdram_read = (select_vga) ? vga_read : capture_read;
    assign vga_red[9:0] = (select_vga) ? {out_sdram_red[7:0], 2'b0} : 10'b0;
    assign vga_green[9:0] = (select_vga) ? {out_sdram_green[7:0], 2'b0} : 10'b0;
    assign vga_blue[9:0] = (select_vga) ? {out_sdram_blue[7:0], 2'b0} : 10'b0;
   
    // LED indicators
    assign LEDR[17:0] = led_red[17:0];
    assign LEDG[7:0] = led_green[7:0];
   
//------------------------------------------------------------------------------
   
    // Camera controller
    wire camera_ready;
    wire image_captured;
   
    // Camera output data
    wire out_camera_write;
    wire out_camera_display;
    wire out_camera_clock;
    wire [9:0] out_camera_red;
    wire [9:0] out_camera_green;
    wire [9:0] out_camera_blue;
    wire [9:0] out_camera_gray;

    camera_controller camera_ctrl (
        .clock_24(clock_24),
        .reset_n(configure_n),
        // Capture signals
        .in_start(capture_start & sensor_done),
        // Image and camera configuration values
        .in_width(width[15:0]),
        .in_height(height[15:0]),
        .in_exposure(exposure),
        .in_start_row(start_row),
        .in_start_column(start_column),
        .in_row_size(row_size),
        .in_column_size(column_size),
        .in_row_mode(row_mode),
        .in_column_mode(column_mode),
        .out_ready(camera_ready),
        // Image data signals
        .out_clock(out_camera_clock),
        .out_valid(out_camera_write),
        .out_display(out_camera_display),
        .out_red(out_camera_red[9:0]),
        .out_green(out_camera_green[9:0]),
        .out_blue(out_camera_blue[9:0]),
        .out_gray(out_camera_gray[9:0]),
        .out_captured(image_captured),
        // GPIO
        .GPIO_1(GPIO) // GPIO Connection
    );

//------------------------------------------------------------------------------
   
   // SDRAM controller
   wire in_sdram_write;
   wire in_sdram_clock;
   wire [7:0] in_sdram_red;
   wire [7:0] in_sdram_green;
   wire [7:0] in_sdram_blue;
   wire [7:0] in_sdram_gray;
   
   wire out_sdram_read;
   wire out_sdram_clock;
   wire [7:0] out_sdram_red;
   wire [7:0] out_sdram_green;
   wire [7:0] out_sdram_blue;
   wire [7:0] out_sdram_gray;
      
   sdram_controller sdram_ctrl (
      .clock_50(clock_50),
      .sdram_clock(sdram_clock),
      .dram_clock(dram_clock),
      .reset_n(camera_ready),
      // Image size input
      .width(width[15:0]),
      .height(height[15:0]),
      // Image data input
      .iWrite(in_sdram_write),
      .iWriteClock(in_sdram_clock),
	  .iRed(in_sdram_red[7:0]),
      .iGreen(in_sdram_green[7:0]),
      .iBlue(in_sdram_blue[7:0]),
      .iGray(in_sdram_gray[7:0]),
      // Image data output
      .iRead(out_sdram_read),
      .iReadClock(out_sdram_clock),
      .oRed(out_sdram_red[7:0]),
      .oGreen(out_sdram_green[7:0]),
      .oBlue(out_sdram_blue[7:0]),
      .oGray(out_sdram_gray[7:0]),
      // SDRAM Interface
      .DRAM_DQ(DRAM_DQ),
      .DRAM_ADDR(DRAM_ADDR),
      .DRAM_LDQM(DRAM_DQM[0]),
      .DRAM_UDQM(DRAM_DQM[1]),
      .DRAM_WE_N(DRAM_WE_N),
      .DRAM_CAS_N(DRAM_CAS_N),
      .DRAM_RAS_N(DRAM_RAS_N),
      .DRAM_CS_N(DRAM_CS_N),
      .DRAM_BA_0(DRAM_BA[0]),
      .DRAM_BA_1(DRAM_BA[1]),
      .DRAM_CLK(DRAM_CLK),
      .DRAM_CKE(DRAM_CKE)
   );
   
//------------------------------------------------------------------------------

    // Sensor controller 
    wire out_sensor_clock;
    wire out_sensor_write;
    wire out_sensor_display;
    wire [9:0] out_sensor_red;
    wire [9:0] out_sensor_green;
    wire [9:0] out_sensor_blue;
    wire [9:0] out_sensor_gray;
    wire sensor_done;
    
   // Sensor registers signals
   wire [31:0] red_threshold_min;
   wire [31:0] red_threshold_max;
   wire [31:0] green_threshold_min;
   wire [31:0] green_threshold_max;
   wire [31:0] blue_threshold_min;
   wire [31:0] blue_threshold_max;
   
   // Locator inputs
   wire locator_clock;
   wire locator_write;
   wire locator_red;
   wire locator_green;
   wire locator_blue;
   wire locator_pixel;
   wire [11:0] locator_x;
   wire [11:0] locator_y;
   wire locator_done;
    
    sensor_controller sensor_ctrl (
        .clock(clock_50), // Not used
        .reset_n(camera_ready),
        // Select input
        .select(capture_select_sensor[3:0]),
        // Control input
        .start(capture_start & sensor_done),
        // Image size input
        .width({width[14:0], 1'b0}),
        .height({height[14:0], 1'b0}),
        // Data input
        .in_write(out_camera_write),
        .in_display(out_camera_display),
        .in_clock(out_camera_clock),
        .in_red(out_camera_red[9:0]),
        .in_green(out_camera_green[9:0]),
        .in_blue(out_camera_blue[9:0]),
        .in_gray(out_camera_gray[9:0]),
        .in_done(image_captured),
        // Configuration input
        .red_threshold_min(red_threshold_min[31:0]),
        .red_threshold_max(red_threshold_max[31:0]),
        .green_threshold_min(green_threshold_min[31:0]),
        .green_threshold_max(green_threshold_max[31:0]),
        .blue_threshold_min(blue_threshold_min[31:0]),
        .blue_threshold_max(blue_threshold_max[31:0]),
        // Data output
        .out_write(out_sensor_write),
        .out_display(out_sensor_display),
        .out_clock(out_sensor_clock),
        .out_red(out_sensor_red[9:0]),
        .out_green(out_sensor_green[9:0]),
        .out_blue(out_sensor_blue[9:0]),
        .out_gray(out_sensor_gray[9:0]),
        .out_done(sensor_done),
        // Image locator input
        .out_locator_clock(locator_clock),
        .out_locator_write(locator_write),
        .out_locator_pixel({locator_red, locator_green, locator_blue}),
        .out_locator_x(locator_x[11:0]),
        .out_locator_y(locator_y[11:0]),
        .out_locator_done(locator_done)
    );
    
    assign locator_pixel = locator_red | locator_green | locator_blue;
    
    // Sensor to SDRAM
    assign in_sdram_clock = out_sensor_clock;
    assign in_sdram_write = out_sensor_display;
    assign in_sdram_red[7:0] = out_sensor_red[9:2];
    assign in_sdram_green[7:0] = out_sensor_green[9:2];
    assign in_sdram_blue[7:0] = out_sensor_blue[9:2];
    assign in_sdram_gray[7:0] = out_sensor_gray[9:2];
   
//------------------------------------------------------------------------------

//=======================================================
//  REG/WIRE declarations
//=======================================================
//=======================================================
wire			global_reset_n;
wire			enet_resetn;
//===== ethernet =====
wire			enet_tx_clk_mac;
wire			enet_tx_clk_phy;
wire			enet_rx_clk_270deg;

wire			enet_gtx_clk;
wire			enet_tx_clk;
wire			enet_rx_clk;

wire			NET0_mdio_in;
wire			NET0_mdio_oen;
wire			NET0_mdio_out;

wire			ena_10_from_the_tse_mac;
wire			eth_mode_from_the_tse_mac;
wire			set_1000_to_the_tse_mac;
wire			set_10_to_the_tse_mac;

// ===== ethernet clock =====
assign enet_rx_clk		= ENET0_RX_CLK;
assign enet_tx_clk		= ENET0_TX_CLK;
assign ENET0_GTX_CLK		= enet_gtx_clk;

// ===== MDIO Tristate
assign NET0_mdio_in		= ENET0_MDIO;
assign ENET0_MDIO		= NET0_mdio_oen ? 1'bz : NET0_mdio_out;

// ===== ethernet signal =====
assign ENET0_RST_N		= enet_resetn;

//=======================================================
//  Structural coding
//=======================================================
assign enet_gtx_clk = 1'b0; //set the gtx_clock 0


gen_reset_n	system_gen_reset_n (
		.tx_clk(CLOCK_50),
		.reset_n_in(1'b1),
		.reset_n_out(global_reset_n)
		);

gen_reset_n	net_gen_reset_n(
		.tx_clk(CLOCK_50),
		.reset_n_in(global_reset_n),
		.reset_n_out(enet_resetn)
);

//------------------------------------------------------------------------------

   // Nios system
   wire capture_start;
   wire [7:0] capture_select_sensor;
   
   wire capture_clk;
   wire capture_read;
   wire [31:0] capture_data;
      
   // Camera registers signals
   wire [15:0] exposure;
   wire [15:0] width;
   wire [15:0] height;
   wire [15:0] start_row;
   wire [15:0] start_column;
   wire [15:0] row_size;
   wire [15:0] column_size;
   wire [15:0] row_mode;
   wire [15:0] column_mode;
   
DE2_115_SOPC DE2_115_SOPC_inst(
      // Global signals
      .clk_50(clock_50),
      .reset_n(reset_n),
//      .altpll_sys(sdram_clock),
//      .altpll_sdram(dram_clock),
//      .altpll_25(clock_25),
//      .altpll_24(clock_24),
//      .altpll_io(),  
      // SRAM signals
      .SRAM_ADDR_from_the_sram(SRAM_ADDR[19:0]), 
      .SRAM_CE_n_from_the_sram(SRAM_CE_N), 
      .SRAM_DQ_to_and_from_the_sram(SRAM_DQ[15:0]), 
      .SRAM_LB_n_from_the_sram(SRAM_LB_N), 
      .SRAM_OE_n_from_the_sram(SRAM_OE_N), 
      .SRAM_UB_n_from_the_sram(SRAM_UB_N), 
      .SRAM_WE_n_from_the_sram(SRAM_WE_N),                                    
      // Ethernet signals (MII)
      .mcoll_pad_i_to_the_eth_ocm_0(ENET0_RX_COL),
      .mcrs_pad_i_to_the_eth_ocm_0(ENET0_RX_CRS),
      .md_pad_i_to_the_eth_ocm_0(NET0_mdio_in),
      .md_pad_o_from_the_eth_ocm_0(NET0_mdio_out),
      .md_padoe_o_from_the_eth_ocm_0(NET0_mdio_oen),
      .mdc_pad_o_from_the_eth_ocm_0(ENET0_MDC),
      .mrx_clk_pad_i_to_the_eth_ocm_0(enet_rx_clk),
      .mrxd_pad_i_to_the_eth_ocm_0(ENET0_RX_DATA),
      .mrxdv_pad_i_to_the_eth_ocm_0(ENET0_RX_DV),
      .mrxerr_pad_i_to_the_eth_ocm_0(ENET0_RX_ER),
      .mtx_clk_pad_i_to_the_eth_ocm_0(enet_tx_clk),
      .mtxd_pad_o_from_the_eth_ocm_0(ENET0_TX_DATA),
      .mtxen_pad_o_from_the_eth_ocm_0(ENET0_TX_EN),
	  .mtxerr_pad_o_from_the_eth_ocm_0(ENET0_TX_ER),  
      // Flash signals
      .address_to_the_ext_flash(FL_ADDR[22:0]),
      .tri_state_bridge_flash_data(FL_DQ[7:0]),
      .read_n_to_the_ext_flash(FL_OE_N),
      .select_n_to_the_ext_flash(FL_CE_N),
      .write_n_to_the_ext_flash(FL_WE_N), 
      // LCD signals
      .LCD_E_from_the_lcd(LCD_EN),
      .LCD_RS_from_the_lcd(LCD_RS),
      .LCD_RW_from_the_lcd(LCD_RW),
      .LCD_data_to_and_from_the_lcd(LCD_DATA[7:0]),
      // Led signals
      .out_port_from_the_led_pio(led_green[7:0]),
      // Camera signals
      .avs_export_capture_start_from_the_camera(capture_start),
      .avs_export_capture_done_to_the_camera(sensor_done),
      .avs_export_capture_configure_from_the_camera(configure_n),
      .avs_export_capture_ready_to_the_camera(camera_ready),
      .avs_export_capture_select_vga_from_the_camera(select_vga),
      .avs_export_capture_select_output_from_the_camera(capture_select_sensor[7:0]),
      .avs_export_clk_from_the_camera(capture_clk),
      .avs_export_capture_read_from_the_camera(capture_read),
      .avs_export_capture_readdata_to_the_camera(capture_data[31:0]), 
      // Image size registers
      .avs_export_width_from_the_camera(width[15:0]),
      .avs_export_height_from_the_camera(height[15:0]),
      // Camera register signals
      .avs_export_start_row_from_the_camera(start_row),
      .avs_export_start_column_from_the_camera(start_column),
      .avs_export_row_size_from_the_camera(row_size),
      .avs_export_column_size_from_the_camera(column_size),
      .avs_export_row_mode_from_the_camera(row_mode),
      .avs_export_column_mode_from_the_camera(column_mode),
      .avs_export_exposure_from_the_camera(exposure),
      // Tracker 0
      .avs_export_width_to_the_tracker_0({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_0({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_0(locator_clock),
      .avs_export_write_to_the_tracker_0(locator_write),
      .avs_export_pixel_to_the_tracker_0(locator_pixel),
      .avs_export_x_to_the_tracker_0(locator_x[11:0]),
      .avs_export_y_to_the_tracker_0(locator_y[11:0]),
      .avs_export_done_to_the_tracker_0(locator_done),
      // Tracker 1
      .avs_export_width_to_the_tracker_1({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_1({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_1(locator_clock),
      .avs_export_write_to_the_tracker_1(locator_write),
      .avs_export_pixel_to_the_tracker_1(locator_pixel),
      .avs_export_x_to_the_tracker_1(locator_x[11:0]),
      .avs_export_y_to_the_tracker_1(locator_y[11:0]),
      .avs_export_done_to_the_tracker_1(locator_done),
       // Tracker 2
      .avs_export_width_to_the_tracker_2({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_2({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_2(locator_clock),
      .avs_export_write_to_the_tracker_2(locator_write),
      .avs_export_pixel_to_the_tracker_2(locator_pixel),
      .avs_export_x_to_the_tracker_2(locator_x[11:0]),
      .avs_export_y_to_the_tracker_2(locator_y[11:0]),
      .avs_export_done_to_the_tracker_2(locator_done),
       // Tracker 3
      .avs_export_width_to_the_tracker_3({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_3({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_3(locator_clock),
      .avs_export_write_to_the_tracker_3(locator_write),
      .avs_export_pixel_to_the_tracker_3(locator_pixel),
      .avs_export_x_to_the_tracker_3(locator_x[11:0]),
      .avs_export_y_to_the_tracker_3(locator_y[11:0]),
      .avs_export_done_to_the_tracker_3(locator_done),
       // Tracker 4
      .avs_export_width_to_the_tracker_4({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_4({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_4(locator_clock),
      .avs_export_write_to_the_tracker_4(locator_write),
      .avs_export_pixel_to_the_tracker_4(locator_pixel),
      .avs_export_x_to_the_tracker_4(locator_x[11:0]),
      .avs_export_y_to_the_tracker_4(locator_y[11:0]),
      .avs_export_done_to_the_tracker_4(locator_done),
       // Tracker 5
      .avs_export_width_to_the_tracker_5({width[10:0], 1'b0}),
      .avs_export_height_to_the_tracker_5({height[10:0], 1'b0}),
      .avs_export_clock_to_the_tracker_5(locator_clock),
      .avs_export_write_to_the_tracker_5(locator_write),
      .avs_export_pixel_to_the_tracker_5(locator_pixel),
      .avs_export_x_to_the_tracker_5(locator_x[11:0]),
      .avs_export_y_to_the_tracker_5(locator_y[11:0]),
      .avs_export_done_to_the_tracker_5(locator_done),
      // Sensor registers signals
      .avs_export_red_threshold_min_from_the_sensor(red_threshold_min[31:0]),
      .avs_export_red_threshold_max_from_the_sensor(red_threshold_max[31:0]),
      .avs_export_green_threshold_min_from_the_sensor(green_threshold_min[31:0]),
      .avs_export_green_threshold_max_from_the_sensor(green_threshold_max[31:0]),
      .avs_export_blue_threshold_min_from_the_sensor(blue_threshold_min[31:0]),
      .avs_export_blue_threshold_max_from_the_sensor(blue_threshold_max[31:0])
   );
   
   assign capture_data[31:0] = {out_sdram_gray[7:0], out_sdram_red[7:0],
                                out_sdram_green[7:0], out_sdram_blue[7:0]};
   
   assign FL_RST_N = 1'b1;
   assign FL_WP_N = 1'b1;
   assign LCD_ON = 1'b1;
   assign LCD_BLON = 1'b0;
       
//------------------------------------------------------------------------------  
            
    // Frame counter
    display_controller display_ctrl (
        .clock_50(clock_50),
        .reset_n(camera_ready),
        // Input signals
        .image_captured(image_captured),
        .algorithm_done(sensor_done),
        // 7-SEG Dispaly outputs
        .HEX0(HEX0[6:0]),
        .HEX1(HEX1[6:0]),
        .HEX2(HEX2[6:0]),
        .HEX3(HEX3[6:0]),
        .HEX4(HEX4[6:0]),
        .HEX5(HEX5[6:0]),
        .HEX6(HEX6[6:0]),
        .HEX7(HEX7[6:0])
    );
    
    // VGA display
    wire vga_read;
    wire vga_clock;
    wire [9:0] vga_red;
    wire [9:0] vga_green;
    wire [9:0] vga_blue;
    vga_controller vga_ctrl (
        .clock_50(capture_clk),
        .clock_25(clock_25),
        .reset_n(camera_ready),
        // Image size input
        .width(width[15:0]),
        .height(height[15:0]),
        // Data color input
        .iRed(vga_red[9:0]),
        .iGreen(vga_green[9:0]),
        .iBlue(vga_blue[9:0]),
        .oRequest(vga_read),
        .oCtrlClock(vga_clock),
        // VGA Interfase
        .VGA_CLK(VGA_CLK), // VGA Clock
        .VGA_HS(VGA_HS), // VGA H_SYNC
        .VGA_VS(VGA_VS), // VGA V_SYNC
        .VGA_BLANK(VGA_BLANK_N), // VGA BLANK
        .VGA_SYNC(VGA_SYNC_N), // VGA SYNC
        .VGA_R(VGA_R[7:0]), // VGA Red[9:0]
        .VGA_G(VGA_G[7:0]), // VGA Green[9:0]
        .VGA_B(VGA_B[7:0]) // VGA Blue[9:0]
    );
   
//------------------------------------------------------------------------------

endmodule
