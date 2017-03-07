///
/// Sensor controller
/// =================
///
/// This module implements the image processing algorithm to calculate robots
/// and obstacles positions.
///
module sensor_controller (
        input clock,
        input reset_n,
        // Select input
        input [3:0] select,
        // Control input
        input start,
        // Image size
        input [15:0] width,
        input [15:0] height,
        // Data input
        input in_write,
        input in_display,
        input in_clock,
        input [9:0] in_red,
        input [9:0] in_green,
        input [9:0] in_blue,
        input [9:0] in_gray,
        input in_done,
        // Configuration input
        input [31:0] red_threshold_min,
        input [31:0] red_threshold_max,
        input [31:0] green_threshold_min,
        input [31:0] green_threshold_max,
        input [31:0] blue_threshold_min,
        input [31:0] blue_threshold_max,
        // Data output
        output out_write,
        output out_display,
        output out_clock,
        output [9:0] out_red,
        output [9:0] out_green,
        output [9:0] out_blue,
        output [9:0] out_gray,
        output out_done,
        // Image locator input
        output out_locator_clock,
        output out_locator_write,
        output [2:0] out_locator_pixel,
        output [11:0] out_locator_x,
        output [11:0] out_locator_y,
        output out_locator_done
    );

//------------------------------------------------------------------------------
    
    // Binary threshold module
    wire out_bin_red;
    wire out_bin_green;
    wire out_bin_blue;
    wire out_bin_gray;
    wire out_bin_valid;
            
    wire [9:0] i_red;
    wire [9:0] i_green;
    wire [9:0] i_blue;
    wire [9:0] i_gray;
    
    assign i_red[9:0] = (select[2]) ? in_gray[9:0] : in_red[9:0];
    assign i_green[9:0] = (select[2]) ? in_gray[9:0] : in_green[9:0];
    assign i_blue[9:0] = (select[2]) ? in_gray[9:0] : in_blue[9:0];
    assign i_gray[9:0] = in_gray[9:0];
    
    RGB2BIN u999(
        .clock(in_clock),
        .reset_n(reset_n),
        // Data input
        .in_red(i_red[9:0]),
        .in_green(i_green[9:0]),
        .in_blue(i_blue[9:0]),
        .in_valid(in_write),
        // Configuration input (Thresholds)
        .in_red_threshold_min(red_threshold_min[31:0]),
        .in_red_threshold_max(red_threshold_max[31:0]),
        .in_green_threshold_min(green_threshold_min[31:0]),
        .in_green_threshold_max(green_threshold_max[31:0]),
        .in_blue_threshold_min(blue_threshold_min[31:0]),
        .in_blue_threshold_max(blue_threshold_max[31:0]),
        // Data output
        .out_red_threshold(out_bin_red),
        .out_green_threshold(out_bin_green),
        .out_blue_threshold(out_bin_blue),
        .out_gray_threshold(out_bin_gray),
        .out_valid_threshold(out_bin_valid)
    );
    
    reg bin_display;
    always @(posedge in_clock) bin_display <= in_display;
    
    reg bin_done;
    always @(posedge in_clock) bin_done <= in_done;
                            
//------------------------------------------------------------------------------

    // Erosion operation
    wire erosion_read;
    wire erosion_red;
    wire erosion_green;
    wire erosion_blue;
    erosion #(
        .N(3)
    ) eros (
        .clock(in_clock),
        .reset_n(reset_n),
        // Size
        .width(width[15:0]),
        // Image data input
        .in_write(out_bin_valid),
        .in_pixel({out_bin_red, out_bin_green, out_bin_blue}),
        // Image data output
        .out_read(erosion_read),
        .out_pixel({erosion_red, erosion_green, erosion_blue})
    );
    
    reg erosion_display;
    always @(posedge in_clock) erosion_display <= bin_display;
    
    reg erosion_done;
    always @(posedge in_clock) erosion_done <= bin_done;
    
//------------------------------------------------------------------------------

    // Stream counter
    counter #(
        .N(3)
    ) stream_counter (
        .clock(in_clock),
        .reset_n(reset_n),
        // Image size
        .width(width[11:0]),
        .height(height[11:0]),
        // Image data input
        .in_write(erosion_read),
        .in_data({erosion_red, erosion_green, erosion_blue}),
        // Image data output
        .out_clock(out_locator_clock),
        .out_write(out_locator_write),
        .out_data(out_locator_pixel[2:0]),
        .out_x(out_locator_x[11:0]),
        .out_y(out_locator_y[11:0]),
        .out_done(out_locator_done)
    );
    
    reg location_done;
    always @(posedge in_clock) location_done <= erosion_done;

//------------------------------------------------------------------------------

    // Selects data output of sensor
    reg write;
    reg display;
    reg [9:0] red;
    reg [9:0] green;
    reg [9:0] blue;
    reg [9:0] gray;
    reg red_bit;
    reg green_bit;
    reg blue_bit;
    reg gray_bit;
    reg done;
    always @(posedge in_clock) done <= location_done;
    
    always @(posedge in_clock) begin
        if (reset_n) begin
	        case (select[1:0])
	            0: begin // Camera output
	                write <= in_write;
	                display <= in_display;
	                red[9:0] <= i_red[9:0];
	                green[9:0] <= i_green[9:0];
	                blue[9:0] <= i_blue[9:0];
	                gray[9:0] <= i_gray[9:0];
	            end
	            1: begin // Threshold output
	                write <= out_bin_valid;
	                display <= bin_display;
	                red_bit <= out_bin_red;
	                green_bit <= out_bin_green;
	                blue_bit <= out_bin_blue;
	                gray_bit <= out_bin_gray;
	            end
                2: begin // Erosion output
                    write <= erosion_read;
                    display <= erosion_display;
                    red_bit <= erosion_red;
                    green_bit <= erosion_green;
                    blue_bit <= erosion_blue;
                    gray_bit <= erosion_red | erosion_green | erosion_blue;
                end
	        endcase
	   end
	   else begin
	       write <= 1'b0;
           red[9:0] <= 10'b0;
           green[9:0] <= 10'b0;
           blue[9:0] <= 10'b0;
           gray[9:0] <= 10'b0;
           red_bit <= 1'b0;
           green_bit <= 1'b0;
           blue_bit <= 1'b0;
           gray_bit <= 1'b0; 
	   end
    end
    
    assign out_clock = in_clock;
    assign out_write = write;
    assign out_display = display;
    assign out_red[9:0] = (select[3:0] == 0) ? red[9:0] :
                          (select[3:0] == 4) ? red[9:0] :
                          {red_bit, red_bit, red_bit, red_bit, red_bit, 
                           red_bit, red_bit, red_bit, red_bit, red_bit};
    assign out_green[9:0] = (select[3:0] == 0) ? green[9:0] :
                            (select[3:0] == 4) ? green[9:0] :
                            {green_bit, green_bit, green_bit, green_bit, green_bit, 
                             green_bit, green_bit, green_bit, green_bit, green_bit};
    assign out_blue[9:0] = (select[3:0] == 0) ? blue[9:0] :
                           (select[3:0] == 4) ? blue[9:0] :
                           {blue_bit, blue_bit, blue_bit, blue_bit, blue_bit, 
                            blue_bit, blue_bit, blue_bit, blue_bit, blue_bit};
    assign out_gray[9:0] = (select[3:0] == 0) ? gray[9:0] :
                           (select[3:0] == 4) ? gray[9:0] :
                           {gray_bit, gray_bit, gray_bit, gray_bit, gray_bit, 
                            gray_bit, gray_bit, gray_bit, gray_bit, gray_bit};
                            
//------------------------------------------------------------------------------

    // Start control (generation of start and reset signals)
    reg _location_done;
    reg enable;
    always @(posedge in_clock)
    begin
        if (reset_n) begin
            _location_done <= location_done;
            if (location_done && !_location_done) begin
                enable <= 1'b0;
            end
            else if (start) begin
                enable <= 1'b1;
            end
        end
        else begin
            enable <= 1'b0;
        end
    end
                            
    assign out_done = (reset_n) ? ((enable) ? done : 1'b1) : 1'b0;
    
//------------------------------------------------------------------------------
   
endmodule
