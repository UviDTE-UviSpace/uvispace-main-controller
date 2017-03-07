///
/// Camera controller
/// =================
///
/// This module of image capture ("camera controller") is divided in three blocks:
/// 
/// - The configuration module of camera sensor (camera_config.v).
///
/// - The data capture module of RAW data sensor (camera_capture.v).
/// 
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
        input clock_96,
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
        output [11:0] out_red,
        output [11:0] out_green, 
        output [11:0] out_blue,
        output [11:0] out_gray, 
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
    assign CCD_PIXCLK = GPIO_1[0];
    // Delay clock signal
    //LCELL cell_delay (.in(GPIO_1[0]), .out(CCD_PIXCLK));
    
    // Camera data input (registers data with rising edge)
    reg line_valid;
    reg frame_valid;
    reg [11:0] data;
    always @(posedge CCD_PIXCLK)
    begin
        line_valid <= CCD_LVAL;
        frame_valid <= CCD_FVAL;
        data[11:0] <= CCD_DATA[11:0];
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
    wire [11:0] capture_data;
    wire [11:0] count_x;
    wire [11:0] count_y;
    wire captured;
    camera_capture camera_cap (
        .clock(clock_96),
        .reset_n(ready),
        // Image size values
        .in_width(in_width[11:0]),
        .in_height(in_height[11:0]),
        // Capture control
        .in_start(in_start),
        // Camera sensor inputs
        .in_line_valid(line_valid),
        .in_frame_valid(frame_valid),
        .in_data(data),
        // Data output
        .out_valid(capture_valid),
        .out_data(capture_data),
        .out_count_x(count_x[11:0]),
        .out_count_y(count_y[11:0]),
        .out_captured(captured)
    );
   
//------------------------------------------------------------------------------    

    // RAW2RGB and RGB2Gray
    wire [11:0] sCCD_R;
    wire [11:0] sCCD_G;
    wire [11:0] sCCD_B;
    wire [11:0] sRGB_G;
    wire sCCD_DVAL;
    wire sCCD_DVIS;
    wire raw2rgb_done;
    wire captured_done;
    RAW2RGB rgb (
        .clock(clock_96),
        .reset_n(ready),
        // Image size values
        .width(in_width[11:0]),
        .height(in_height[11:0]),
        // Data input
        .in_valid(capture_valid),
        .in_data(capture_data),
        .in_x(count_x[11:0]),
        .in_y(count_y[11:0]),
        .in_done(captured),
        // Data output
        .out_red(sCCD_R),
        .out_green(sCCD_G),
        .out_blue(sCCD_B),
        .out_valid(sCCD_DVAL),
        .out_val00(sCCD_DVIS),
        .out_done(raw2rgb_done)
    );
    
    // Data output
    RGB2Gray gry(
        .clock(clock_96),
        .reset_n(ready),
        // Data input
        .in_red(sCCD_R[11:0]),
        .in_green(sCCD_G[11:0]),
        .in_blue(sCCD_B[11:0]),
        .in_valid(sCCD_DVAL),
        .in_visual(sCCD_DVIS),
        .in_done(raw2rgb_done),
        // Data output
        .out_red(out_red[11:0]),
        .out_green(out_green[11:0]),
        .out_blue(out_blue[11:0]),
        .out_gray(out_gray[11:0]),
        .out_valid(out_valid),
        .out_visual(out_display),
        .out_done(captured_done)
    );
    assign out_clock = CCD_PIXCLK;
    assign out_captured = captured_done;
    
//------------------------------------------------------------------------------    
   
endmodule
