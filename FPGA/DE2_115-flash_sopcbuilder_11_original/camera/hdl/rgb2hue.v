///
/// RGB to Hue
/// ----------
///
/// This module convert RGB output to Hue output.
///
module rgb2hue(
        input clock,
        input reset_n,
        // Data input
        input in_valid,
        input [7:0] in_red,
        input [7:0] in_green,
        input [7:0] in_blue,
        input in_visual,
        input in_done,
        // Data output
        output out_valid,
        output [7:0] out_red,
        output [7:0] out_green,
        output [7:0] out_blue,
        output [7:0] out_hue,
        output out_visual,
        output out_done
    );
       
    // Stage 1
    reg valid1;
    reg [7:0] red1;
    reg [7:0] green1;
    reg [7:0] blue1;
    reg visual1;
    reg done1;
    // Max-Min
    reg [7:0] v_max1;
    reg [1:0] i_max1;
    reg [7:0] v_min1;
    reg [1:0] i_min1;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid1 <= in_valid;
            red1[7:0] <= in_red[7:0];
            green1[7:0] <= in_green[7:0];
            blue1[7:0] <= in_blue[7:0];
            visual1 <= in_visual;
            done1 <= in_done;
            // Max
            if (in_red >= in_green) begin
                if (in_red >= in_blue) begin
                    v_max1[7:0] <= in_red[7:0];
                    i_max1[1:0] <= 1;
                end
                else begin
                    v_max1[7:0] <= in_blue[7:0];
                    i_max1[1:0] <= 3;
                end
            end
            else begin
                if (in_green >= in_blue) begin
                    v_max1[7:0] <= in_green[7:0];
                    i_max1[1:0] <= 2;
                end
                else begin
                    v_max1[7:0] <= in_blue[7:0];
                    i_max1[1:0] <= 3;
                end
            end
            // Min
            if (in_red < in_green) begin
                if (in_red < in_blue) begin
                    v_min1[7:0] <= in_red[7:0];
                    i_min1[1:0] <= 1;
                end
                else begin
                    v_min1[7:0] <= in_blue[7:0];
                    i_min1[1:0] <= 3;
                end
            end
            else begin
                if (in_green < in_blue) begin
                    v_min1[7:0] <= in_green[7:0];
                    i_min1[1:0] <= 2;
                end
                else begin
                    v_min1[7:0] <= in_blue[7:0];
                    i_min1[1:0] <= 3;
                end
            end
        end 
        else begin
            valid1 <= 1'b0;
            red1[7:0] <= 8'b0;
            green1[7:0] <= 8'b0;
            blue1[7:0] <= 8'b0;
            visual1 <= 1'b0;
            done1 <= 1'b0;
            // Max - Min
            v_max1[7:0] <= 8'd0;
            i_max1[1:0] <= 2'd0; 
            v_min1[7:0] <= 8'd0; 
            i_min1[1:0] <= 2'd0;
        end
    end
    
    // Stage 2
    reg valid2;
    reg [7:0] red2;
    reg [7:0] green2;
    reg [7:0] blue2;
    reg visual2;
    reg done2;
    // Diference
    reg [7:0] dif2;
    reg [7:0] v_max2;
    reg [1:0] i_max2;
    reg [7:0] v_min2;
    reg [1:0] i_min2;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid2 <= valid1;
            red2[7:0] <= red1[7:0];
            green2[7:0] <= green1[7:0];
            blue2[7:0] <= blue1[7:0];
            visual2 <= visual1;
            done2 <= done1;
            // Diference
            dif2[7:0] <= v_max1[7:0] - v_min1[7:0];
            // Max
            v_max2[7:0] <= v_max1[7:0];
            i_max2[1:0] <= i_max1[1:0];
            // Min
            v_min2[7:0] <= v_min1[7:0];
            i_min2[1:0] <= i_min1[1:0];
        end 
        else begin
            valid2 <= 1'b0;
            red2[7:0] <= 8'b0;
            green2[7:0] <= 8'b0;
            blue2[7:0] <= 8'b0;
            visual2 <= 1'b0;
            done2 <= 1'b0;
            // Max - Min
            dif2[7:0] <= 8'd0;
            v_max2[7:0] <= 8'd0;
            i_max2[1:0] <= 2'd0;
            v_min2[7:0] <= 8'd0; 
            i_min2[1:0] <= 2'd0;
        end
    end
    
    // Stage 3
    reg valid3;
    reg [7:0] red3;
    reg [7:0] green3;
    reg [7:0] blue3;
    reg visual3;
    reg done3;
    // Color
    reg [11:0] hue3;
    reg [7:0] dif3;
    reg [7:0] v_max3;
    reg [1:0] i_max3;
    reg [7:0] v_min3;
    reg [1:0] i_min3;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid3 <= valid2;
            red3[7:0] <= red2[7:0];
            green3[7:0] <= green2[7:0];
            blue3[7:0] <= blue2[7:0];
            visual3 <= visual2;
            done3 <= done2;
            // Diference
            dif3[7:0] <= dif2[7:0];
            v_max3[7:0] <= v_max2[7:0];
            i_max3[1:0] <= i_max2[1:0];
            v_min3[7:0] <= v_min2[7:0];
            i_min3[1:0] <= i_min2[1:0];
            // Color
            if (dif2 > 0) begin
                if (i_max2 == 1) begin
                    if (green2 < blue2) begin
                        hue3[11:0] = ((blue2 - green2) << 4);
                    end
                    else begin
                        hue3[11:0] = ((green2 - blue2) << 4);
                    end
                end
                if (i_max2 == 2) begin
                    if (blue2 < red2) begin
                        hue3[11:0] = ((red2 - blue2) << 4);
                    end
                    else begin
                        hue3[11:0] = ((blue2 - red2) << 4);
                    end
                end
                if (i_max2 == 3) begin
                    if (red2 < green2) begin
                        hue3[11:0] = ((green2 - red2) << 4);
                    end
                    else begin
                        hue3[11:0] = ((red2 - green2) << 4);
                    end
                end
            end
            else begin
                hue3[11:0] <= 12'd0;             
            end
        end
        else begin
            valid3 <= 1'b0;
            red3[7:0] <= 8'b0;
            green3[7:0] <= 8'b0;
            blue3[7:0] <= 8'b0;
            visual3 <= 1'b0;
            done3 <= 1'b0;
            // Color
            hue3[11:0] <= 12'd0;
            dif3[7:0] <= 8'd0;
            v_max3[7:0] <= 8'd0;
            i_max3[1:0] <= 2'd0;
            v_min3[7:0] <= 8'd0;
            i_min3[1:0] <= 2'd0;
        end
    end
    
    // Stage 4
    reg valid4;
    reg [7:0] red4;
    reg [7:0] green4;
    reg [7:0] blue4;
    reg visual4;
    reg done4;
    // Color
    reg [11:0] hue4;
    reg [7:0] dif4;
    reg [1:0] i_max4;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid4 <= valid3;
            red4[7:0] <= red3[7:0];
            green4[7:0] <= green3[7:0];
            blue4[7:0] <= blue3[7:0];
            visual4 <= visual3;
            done4 <= done3;          
            dif4[7:0] <= dif3[7:0];
            i_max4 <= i_max3;
            // Division
            hue4[11:0] <= (hue3 / dif3);
        end
        else begin
            valid4 <= 1'b0;
            red4[7:0] <= 8'b0;
            green4[7:0] <= 8'b0;
            blue4[7:0] <= 8'b0;
            visual4 <= 1'b0;
            done4 <= 1'b0;
            hue4[11:0] <= 12'd0;
            dif4[7:0] <= 8'd0;
            i_max4[1:0] <= 2'd0;
        end
    end
       
    // Stage 5
    reg valid5;
    reg [7:0] red5;
    reg [7:0] green5;
    reg [7:0] blue5;
    reg visual5;
    reg done5;
    // Color
    reg [11:0] hue5;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid5 <= valid4;
            red5[7:0] <= red4[7:0];
            green5[7:0] <= green4[7:0];
            blue5[7:0] <= blue4[7:0];
            visual5 <= visual4;
            done5 <= done4;
            if (dif4 > 0) begin
                if (i_max4 == 1) begin
                    if (green4 < blue4) begin
                        hue5[11:0] = 96 - hue4;
                    end
                    else begin
                        hue5[11:0] = 0 + hue4;
                    end
                end
                if (i_max4 == 2) begin
                    if (blue4 < red4) begin
                        hue5[11:0] = 32 - hue4;
                    end
                    else begin
                        hue5[11:0] = 32 + hue4;
                    end
                end
                if (i_max4 == 3) begin
                    if (red4 < green4) begin
                        hue5[11:0] = 64 - hue4;
                    end
                    else begin
                        hue5[11:0] = 64 + hue4;
                    end
                end
            end
            else begin
                hue5[11:0] <= 12'd0;             
            end
        end
        else begin
            valid5 <= 1'b0;
            red5[7:0] <= 8'b0;
            green5[7:0] <= 8'b0;
            blue5[7:0] <= 8'b0;
            visual5 <= 1'b0;
            done5 <= 1'b0;
            hue5[11:0] <= 12'd0;
        end
    end
    
    // Stage 6
    reg valid;
    reg [7:0] red;
    reg [7:0] green;
    reg [7:0] blue;
    reg visual;
    reg done;
    // Color
    reg [18:0] hue;
    always @(posedge clock)
    begin
        if (reset_n) begin
            valid <= valid5;
            red[7:0] <= red5[7:0];
            green[7:0] <= green5[7:0];
            blue[7:0] <= blue5[7:0];
            visual <= visual5;
            done <= done5;
            hue[18:0] <= (85 * hue5);
        end
        else begin 
            valid <= 1'b0;
            red[7:0] <= 8'b0;
            green[7:0] <= 8'b0;
            blue[7:0] <= 8'b0;
            visual <= 1'b0;
            done <= 1'b0;
            hue[18:0] <= 19'd0;
        end
    end
    
    assign out_valid = valid;
    assign out_red[7:0] = red[7:0];
    assign out_green[7:0] = green[7:0];  
    assign out_blue[7:0] = blue[7:0];
    assign out_hue[7:0] = hue[12:5];
    assign out_visual = visual;
    assign out_done = done;
    
endmodule
