///
/// RGB to Gray
/// -----------
///
/// This module convert RGB output to Gray scale output.
///
/// .. figure:: RGB2Gray.png
///
///    RGB to Gray block
///
module RGB2Gray(
        input clock,
        input reset_n,
        // Data input
        input in_valid,
        input [9:0] in_red,
        input [9:0] in_green,
        input [9:0] in_blue,
        input in_visual,
        input in_done,
        // Data output
        output out_valid,
        output [9:0] out_red,
        output [9:0] out_green,
        output [9:0] out_blue,
        output [9:0] out_gray,
        output out_visual,
        output out_done
    );
    
    reg valid;
    reg [9:0] red;
    reg [9:0] green;
    reg [9:0] blue;
    reg [19:0] gray;
    reg visual;
    reg done;
    
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid <= in_valid;
            red[9:0] <= in_red[9:0];
            green[9:0] <= in_green[9:0];
            blue[9:0] <= in_blue[9:0];
            // Gray (RGB2Gray: Gray = 0.2989 * R + 0.5870 * G + 0.1140 * B)
            // gray = (306 * red + 601 * green + 117 * blue) / 1024 = 0.2988 * R + 0.5869 * G + 0.1143 * B 
            gray[19:0] <= (306 * in_red + 601 * in_green + 117 * in_blue);
            visual <= in_visual;
            done <= in_done;
        end
        else begin
            valid <= 1'b0;
            red[9:0] <= 10'b0;
            green[9:0] <= 10'b0;
            blue[9:0] <= 10'b0;
            gray[19:0] <= 20'b0;
            visual <= 1'b0;
            done <= 1'b0;
        end
    end
    
    assign out_valid = valid;
    assign out_red[9:0] = red[9:0];
    assign out_green[9:0] = green[9:0];  
    assign out_blue[9:0] = blue[9:0];
    assign out_gray[9:0] = gray[19:10]; // Divides by 1024
    assign out_visual = visual;
    assign out_done = done;
    
endmodule
