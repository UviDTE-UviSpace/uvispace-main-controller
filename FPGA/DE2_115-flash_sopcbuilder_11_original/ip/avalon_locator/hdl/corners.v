///
/// Corners block
/// -------------
///
/// This module implements the boundary corners detection of the geometrical 
/// figure, which is used by the shape detection algorithm.
///
module corners (
        input clock,
        input reset_n,
        // Region of interest
        input [11:0] left, 
        input [11:0] top,
        input [11:0] right,
        input [11:0] bottom,
        // Image data input
        input in_write,
        input in_pixel,
        input [11:0] in_x,
        input [11:0] in_y,
        // Data output
        output [11:0] out_left1_x,
        output [11:0] out_left1_y,
        output [11:0] out_left2_x,
        output [11:0] out_left2_y,
        output [11:0] out_top1_x,
        output [11:0] out_top1_y,
        output [11:0] out_top2_x,
        output [11:0] out_top2_y,
        output [11:0] out_right1_x,
        output [11:0] out_right1_y,
        output [11:0] out_right2_x,
        output [11:0] out_right2_y,
        output [11:0] out_bottom1_x,
        output [11:0] out_bottom1_y,
        output [11:0] out_bottom2_x,
        output [11:0] out_bottom2_y
    );
    
    // Corners locator
    reg [31:0] size;
    reg [11:0] left1, left2;
    reg [11:0] left1_x, left1_y;
    reg [11:0] left2_x, left2_y;
    reg [11:0] right1, right2;
    reg [11:0] right1_x, right1_y;
    reg [11:0] right2_x, right2_y;
    reg [11:0] top1, top2;
    reg [11:0] top1_x, top1_y;
    reg [11:0] top2_x, top2_y;
    reg [11:0] bottom1, bottom2;
    reg [11:0] bottom1_x, bottom1_y;
    reg [11:0] bottom2_x, bottom2_y;
    
    always @(posedge clock)
    begin
        if (reset_n) begin
            if (in_write) begin
                if (in_pixel) begin
                    // Checks that the pixel is into the ROI
                    if ((in_x >= left) && (in_x <= right) && 
                        (in_y >= top) && (in_y <= bottom)) begin
	                    size[31:0] <= size[31:0] + 1;
	                    if (left1 > in_x) begin
	                        left1[11:0] <= in_x[11:0];
	                        left1_x[11:0] <= in_x[11:0];
	                        left1_y[11:0] <= in_y[11:0];
	                    end
	                    if (left2 >= in_x) begin
	                        left2[11:0] <= in_x[11:0];
	                        left2_x[11:0] <= in_x[11:0];
	                        left2_y[11:0] <= in_y[11:0];
	                    end
	                    if (top1 > in_y) begin
	                        top1[11:0] <= in_y[11:0];
	                        top1_x[11:0] <= in_x[11:0];
	                        top1_y[11:0] <= in_y[11:0];
	                    end
	                    if (top2 >= in_y) begin
	                        top2[11:0] <= in_y[11:0];
	                        top2_x[11:0] <= in_x[11:0];
	                        top2_y[11:0] <= in_y[11:0];
	                    end
	                    if (right1 < in_x) begin
	                        right1[11:0] <= in_x[11:0];
	                        right1_x[11:0] <= in_x[11:0];
	                        right1_y[11:0] <= in_y[11:0];
	                    end
	                    if (right2 <= in_x) begin
	                        right2[11:0] <= in_x[11:0];
	                        right2_x[11:0] <= in_x[11:0];
	                        right2_y[11:0] <= in_y[11:0];
	                    end
	                    if (bottom1 < in_y) begin
	                        bottom1[11:0] <= in_y[11:0];
	                        bottom1_x[11:0] <= in_x[11:0];
	                        bottom1_y[11:0] <= in_y[11:0];
	                    end
	                    if (bottom2 <= in_y) begin
	                        bottom2[11:0] <= in_y[11:0];
	                        bottom2_x[11:0] <= in_x[11:0];
	                        bottom2_y[11:0] <= in_y[11:0];
	                    end
	                end
                end
            end
        end
        else begin
            left1[11:0] <= right[11:0];
            left2[11:0] <= right[11:0];
            top1[11:0] <= bottom[11:0];
            top2[11:0] <= bottom[11:0];
            right1[11:0] <= left[11:0];
            right2[11:0] <= left[11:0];
            bottom1[11:0] <= top[11:0];
            bottom2[11:0] <= top[11:0];
            size[31:0] <= 0;
            left1_x[11:0] <= 12'd0;
            left1_y[11:0] <= 12'd0;
            left2_x[11:0] <= 12'd0;
            left2_y[11:0] <= 12'd0;
            top1_x[11:0] <= 12'd0;
            top1_y[11:0] <= 12'd0;
            top2_x[11:0] <= 12'd0;
            top2_y[11:0] <= 12'd0;
            right1_x[11:0] <= 12'd0;
            right1_y[11:0] <= 12'd0;
            right2_x[11:0] <= 12'd0;
            right2_y[11:0] <= 12'd0;
            bottom1_x[11:0] <= 12'd0;
            bottom1_y[11:0] <= 12'd0;
            bottom2_x[11:0] <= 12'd0;
            bottom2_y[11:0] <= 12'd0;
        end
    end
    
    assign out_left1_x[11:0] = left1_x[11:0];
    assign out_left1_y[11:0] = left1_y[11:0];
    assign out_left2_x[11:0] = left2_x[11:0];
    assign out_left2_y[11:0] = left2_y[11:0];
    assign out_top1_x[11:0] = top1_x[11:0];
    assign out_top1_y[11:0] = top1_y[11:0];
    assign out_top2_x[11:0] = top2_x[11:0];
    assign out_top2_y[11:0] = top2_y[11:0];
    assign out_right1_x[11:0] = right1_x[11:0];
    assign out_right1_y[11:0] = right1_y[11:0];
    assign out_right2_x[11:0] = right2_x[11:0];
    assign out_right2_y[11:0] = right2_y[11:0];
    assign out_bottom1_x[11:0] = bottom1_x[11:0];
    assign out_bottom1_y[11:0] = bottom1_y[11:0];
    assign out_bottom2_x[11:0] = bottom2_x[11:0];
    assign out_bottom2_y[11:0] = bottom2_y[11:0];
       
endmodule
