///
/// Camera controller
/// =================
///
/// This module of image capture ("camera controller") is divided in three blocks:
/// 
/// - The configuration module of camera sensor (camera_config.v).
/// - The data capture module of RAW data sensor (camera_capture.v).
/// - The RAW data conversion module to RGB (RAW2RGB.v).
///
/// The outputs of camera controller block are stored in memory SDRAM, frame to frame.
/// 
/// .. figure:: camera_controller.png
///    
///    Camera controller block
///
/// This modules are derived of original example from camera project, and they are modified
/// to be configured in execution time.
///
module camera_controller (
        input clock_24,
        input reset_n,
        // Capture signals
        input in_start,
        // Image configuration values
        input [15:0] in_width,
        input [15:0] in_height,
        input [15:0] in_exposure,
        input [15:0] in_start_row,
        input [15:0] in_start_column,
        input [15:0] in_row_size,
        input [15:0] in_column_size,
        input [15:0] in_row_mode,
        input [15:0] in_column_mode,
        output out_ready,
        // Image data output
        output out_clock,
        output out_valid,
        output out_display,
        output [9:0] out_red,
        output [9:0] out_green, 
        output [9:0] out_blue,
        output [9:0] out_gray, 
        output out_captured,
        // GPIO
        inout [35:0] GPIO_1 // GPIO Connection 1
    );
      
//------------------------------------------------------------------------------
   
    // I/O Camera signals
    
    // Data signals
    wire [11:0] CCD_DATA;
    wire CCD_FVAL;
    wire CCD_LVAL;
    
    assign CCD_DATA[0] = GPIO_1[13];
    assign CCD_DATA[1] = GPIO_1[12];
    assign CCD_DATA[2] = GPIO_1[11];
    assign CCD_DATA[3] = GPIO_1[10];
    assign CCD_DATA[4] = GPIO_1[9];
    assign CCD_DATA[5] = GPIO_1[8];
    assign CCD_DATA[6] = GPIO_1[7];
    assign CCD_DATA[7] = GPIO_1[6];
    assign CCD_DATA[8] = GPIO_1[5];
    assign CCD_DATA[9] = GPIO_1[4];
    assign CCD_DATA[10] = GPIO_1[3];
    assign CCD_DATA[11] = GPIO_1[1];
    assign CCD_FVAL = GPIO_1[22]; // Frame valid
    assign CCD_LVAL = GPIO_1[21]; // Line valid
    
    // Clock signal
    wire CCD_PIXCLK;	 	
	// External clock ampilfier
    clock_buffer clk_buff(.inclk(GPIO_1[0]), .outclk(CCD_PIXCLK));
    
    // Camera data input (registers data with rising edge)
    reg line_valid;
    reg frame_valid;
    reg [7:0] data;
    always @(posedge CCD_PIXCLK)
    begin
        line_valid <= CCD_LVAL;
        frame_valid <= CCD_FVAL;
        if (CCD_DATA[11] == 1'b1) begin
            data[7:0] <= 8'b11111111;
        end
        else begin
            data[7:0] <= CCD_DATA[10:3]; //CCD_DATA[10:1];
        end
    end 
    
    // CCD Master Clock (master clock signal)
    assign GPIO_1[16] = clock_24;
    
    // Trigger and reset signals
    assign GPIO_1[19] = ready;//1'b1;
    assign GPIO_1[17] = reset_n;
    
//------------------------------------------------------------------------------    
    
    // Camera config (I2C)
    wire ready;
    camera_config #(
        .CLK_FREQ(24000000), // 24 MHz
        .I2C_FREQ(20000) // 20 kHz
    ) camera_conf (
        // Host Side
        .clock(clock_24),
        .reset_n(reset_n),
        // Configuration registers
        .exposure(in_exposure),
        .start_row(in_start_row),
        .start_column(in_start_column),
        .row_size(in_row_size),
        .column_size(in_column_size),
        .row_mode(in_row_mode),
        .column_mode(in_column_mode),
        // Ready signal
        .out_ready(ready),
        // I2C Side
        .I2C_SCLK(GPIO_1[24]),
        .I2C_SDAT(GPIO_1[23])
    );
    assign out_ready = ready;
    
//------------------------------------------------------------------------------  
    
    // CCD capture
    wire capture_valid;
    wire [7:0] capture_data;
    wire [11:0] count_x;
    wire [11:0] count_y;
    wire captured;
    camera_capture #(
        .N(8)
    ) camera_cap (
        .clock(CCD_PIXCLK),
        .reset_n(ready),
        // Image size values
        .in_width(in_width[11:0]),
        .in_height(in_height[11:0]),
        // Capture control
        .in_start(in_start),
        // Camera sensor inputs
        .in_line_valid(line_valid),
        .in_frame_valid(frame_valid),
        .in_data(data[7:0]),
        // Data output
        .out_valid(capture_valid),
        .out_data(capture_data[7:0]),
        .out_count_x(count_x[11:0]),
        .out_count_y(count_y[11:0]),
        .out_captured(captured)
    );
   
//------------------------------------------------------------------------------    

    // RAW2RGB and RGB2Gray
    wire [7:0] sCCD_R;
    wire [7:0] sCCD_G;
    wire [7:0] sCCD_B;
    wire [7:0] sRGB_G;
    wire sCCD_DVAL;
    wire sCCD_DVIS;
    wire raw2rgb_done;
    wire captured_done;
    raw2rgb #(
        .N(8)
    ) rgb (
        .clock(CCD_PIXCLK),
        .reset_n(ready),
        // Image size values
        .width(in_width[11:0]),
        .height(in_height[11:0]),
        // Data input
        .in_valid(capture_valid),
        .in_data(capture_data[7:0]),
        .in_x(count_x[11:0]),
        .in_y(count_y[11:0]),
        .in_done(captured),
        // Data output
        .out_red(sCCD_R[7:0]),
        .out_green(sCCD_G[7:0]),
        .out_blue(sCCD_B[7:0]),
        .out_valid(sCCD_DVAL),
        .out_val00(sCCD_DVIS),
        .out_done(raw2rgb_done)
    );
    
    // Hue color conversion
    wire [7:0] o_red;
    wire [7:0] o_green;
    wire [7:0] o_blue;
    wire [7:0] o_hue;
    rgb2hue hue(
        .clock(CCD_PIXCLK),
        .reset_n(ready),
        // Data input
        .in_red(sCCD_B[7:0]),
        .in_green(sCCD_G[7:0]),
        .in_blue(sCCD_R[7:0]),
        .in_valid(sCCD_DVAL),
        .in_visual(sCCD_DVIS),
        .in_done(raw2rgb_done),
        // Data output
        .out_red(o_blue[7:0]),
        .out_green(o_green[7:0]),
        .out_blue(o_red[7:0]),
        .out_hue(o_hue[7:0]),
        .out_valid(out_valid),
        .out_visual(out_display),
        .out_done(out_captured)
    );
    assign out_clock = CCD_PIXCLK;
    assign out_red[9:0] = {o_red[7:0], 2'b0};
    assign out_green[9:0] = {o_green[7:0], 2'b0};
    assign out_blue[9:0] = {o_blue[7:0], 2'b0};
    assign out_gray[9:0] = {o_hue[7:0], 2'b0};

//    assign out_clock = CCD_PIXCLK;
//    assign out_red[9:0] = sCCD_R[9:0];
//    assign out_green[9:0] = sCCD_G[9:0];
//    assign out_blue[9:0] = sCCD_B[9:0];
//    assign out_gray[9:0] = sCCD_R[9:0];
//    assign out_valid = sCCD_DVAL;
//    assign out_display = sCCD_DVIS;
//    assign out_captured = raw2rgb_done;
    
//------------------------------------------------------------------------------    
   
endmodule
