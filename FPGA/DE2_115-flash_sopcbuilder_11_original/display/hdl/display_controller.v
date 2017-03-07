///
/// Display controller
/// ------------------
///
/// This module calculates the frame rate of image capture.
/// 
/// .. figure:: display_controller.png
///    
///    Display controller block
///
module display_controller (
        input clock_50,
        input reset_n,
        // Input signals
        input image_captured,
        input algorithm_done,
        // 7-SEG Dispaly outputs
        output [6:0] HEX0, 
        output [6:0] HEX1, 
        output [6:0] HEX2, 
        output [6:0] HEX3, 
        output [6:0] HEX4, 
        output [6:0] HEX5, 
        output [6:0] HEX6, 
        output [6:0] HEX7
    );
   
//------------------------------------------------------------------------------
   
    // Camera frame counter and algorithm frame counter
    reg [7:0] camera_frame;
    reg [7:0] camera_frame_rate;
    reg [7:0] algorithm_frame;
    reg [7:0] algorithm_frame_rate;
    reg _image_captured;
    reg _algorithm_done;
    reg [31:0] time_counter;
    
    always @(posedge clock_50)
    begin
        if (reset_n) begin
            _image_captured <= image_captured;
            _algorithm_done <= algorithm_done;
            if (image_captured && !_image_captured) begin
                camera_frame[7:0] <= camera_frame[7:0] + 8'd1;
            end
            if (algorithm_done && !_algorithm_done) begin
                algorithm_frame[7:0] <= algorithm_frame[7:0] + 8'd1;
            end
            if (time_counter < (100000000 - 1)) begin
                time_counter <= time_counter + 1;
            end
            else begin
                time_counter <= 0;
                camera_frame_rate[7:0] <= {1'b0, camera_frame[7:1]};
                algorithm_frame_rate[7:0] <= {1'b0, algorithm_frame[7:1]};
                camera_frame <= 8'd0;
                algorithm_frame <= 8'd0;
            end
        end
        else begin
            _image_captured <= image_captured;
            camera_frame <= 8'd0;
            _algorithm_done <= algorithm_done;
            algorithm_frame <= 8'd0;
            time_counter <= 32'd0;
        end
    end
   
//------------------------------------------------------------------------------    
       
    // 7-SEG displays
    SEG7_LUT_8 u5 (
        .iDIG({camera_frame_rate[7:0], algorithm_frame_rate[7:0], 16'b0}),
        .oSEG0(HEX0[6:0]),.oSEG1(HEX1[6:0]),
        .oSEG2(HEX2[6:0]),.oSEG3(HEX3[6:0]),
        .oSEG4(HEX4[6:0]),.oSEG5(HEX5[6:0]),
        .oSEG6(HEX6[6:0]),.oSEG7(HEX7[6:0])
    );

//------------------------------------------------------------------------------
   
endmodule
