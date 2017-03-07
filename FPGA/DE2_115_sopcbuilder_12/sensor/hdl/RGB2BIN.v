///
/// RGB to BIN
/// ----------
///
/// This module converts RGB to binary image from defined color thresholds.
///
/// .. figure:: RGB2BIN.png
///    
///    RGB to BIN block
///
/// The color thresholds are defined as maximum and minimum values of color.
///
module RGB2BIN(
        input clock,
        input reset_n,
        // Data input
        input [9:0] in_red,
        input [9:0] in_green,
        input [9:0] in_blue,
        input in_valid,
        // Configure options (Thresholds)
        input [31:0] in_red_threshold_min,
        input [31:0] in_red_threshold_max,
        input [31:0] in_green_threshold_min,
        input [31:0] in_green_threshold_max,
        input [31:0] in_blue_threshold_min,
        input [31:0] in_blue_threshold_max,
        // Data output
        output out_red_threshold,
        output out_green_threshold,
        output out_blue_threshold,
        output out_gray_threshold,
        output out_valid_threshold
    );
    
    // Thresholds (maximum of 4096 by color component)
    wire [9:0] thr_min_RR;
    wire [9:0] thr_min_RG;
    wire [9:0] thr_min_RB;
    wire [9:0] thr_max_RR;
    wire [9:0] thr_max_RG;
    wire [9:0] thr_max_RB;
    
    wire [9:0] thr_min_GR;
    wire [9:0] thr_min_GG;
    wire [9:0] thr_min_GB;
    wire [9:0] thr_max_GR;
    wire [9:0] thr_max_GG;
    wire [9:0] thr_max_GB;
    
    wire [9:0] thr_min_BR;
    wire [9:0] thr_min_BG;
    wire [9:0] thr_min_BB;
    wire [9:0] thr_max_BR;
    wire [9:0] thr_max_BG;
    wire [9:0] thr_max_BB;
    
    // Red threshold {10'd405, 10'd325, 10'd325}
    assign thr_min_RR[9:0] = in_red_threshold_min[29:20];
    assign thr_min_RG[9:0] = in_red_threshold_min[19:10];
    assign thr_min_RB[9:0] = in_red_threshold_min[9:0];
    assign thr_max_RR[9:0] = in_red_threshold_max[29:20];
    assign thr_max_RG[9:0] = in_red_threshold_max[19:10];
    assign thr_max_RB[9:0] = in_red_threshold_max[9:0];
    
    // Green threshold {10'd571, 10'd275, 10'd571}
    assign thr_min_GR[9:0] = in_green_threshold_min[29:20];
    assign thr_min_GG[9:0] = in_green_threshold_min[19:10];
    assign thr_min_GB[9:0] = in_green_threshold_min[9:0];
    assign thr_max_GR[9:0] = in_green_threshold_max[29:20];
    assign thr_max_GG[9:0] = in_green_threshold_max[19:10];
    assign thr_max_GB[9:0] = in_green_threshold_max[9:0];
    
    // Blue threshold {10'd550, 10'd550, 10'd212}
    assign thr_min_BR[9:0] = in_blue_threshold_min[29:20];
    assign thr_min_BG[9:0] = in_blue_threshold_min[19:10];
    assign thr_min_BB[9:0] = in_blue_threshold_min[9:0];
    assign thr_max_BR[9:0] = in_blue_threshold_max[29:20];
    assign thr_max_BG[9:0] = in_blue_threshold_max[19:10];
    assign thr_max_BB[9:0] = in_blue_threshold_max[9:0];
    
    // Color binarization
    reg valid_bit;
    reg red_bit;
    reg green_bit;
    reg blue_bit;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid_bit <= in_valid;
            // Red threshold
            if (((in_red >= thr_min_RR) && (in_green >= thr_min_RG) && (in_blue >= thr_min_RB)) &&
                ((in_red <= thr_max_RR) && (in_green <= thr_max_RG) && (in_blue <= thr_max_RB))) begin 
                red_bit <= 1'b1;
            end
            else begin
                red_bit <= 1'b0;
            end
            // Green threshold
            if (((in_red >= thr_min_GR) && (in_green >= thr_min_GG) && (in_blue >= thr_min_GB)) &&
                ((in_red <= thr_max_GR) && (in_green <= thr_max_GG) && (in_blue <= thr_max_GB))) begin 
                green_bit <= 1'b1 ;
            end
            else begin
                green_bit <= 1'b0 ;
            end
		    // Blue threshold
            if (((in_red >= thr_min_BR) && (in_green >= thr_min_BG) && (in_blue >= thr_min_BB)) &&
                ((in_red <= thr_max_BR) && (in_green <= thr_max_BG) && (in_blue <= thr_max_BB))) begin 
                blue_bit <= 1'b1;
            end
            else begin
                blue_bit <= 1'b0 ;
            end	
        end
        else begin
            valid_bit <= 1'b0;
            red_bit <= 1'b0;
            green_bit <= 1'b0;
            blue_bit <= 1'b0;
        end
    end
    
    assign out_red_threshold = red_bit;
    assign out_green_threshold = green_bit;
    assign out_blue_threshold = blue_bit;
    assign out_gray_threshold = red_bit | green_bit | blue_bit; // Gray threshold
    assign out_valid_threshold = valid_bit;

endmodule
