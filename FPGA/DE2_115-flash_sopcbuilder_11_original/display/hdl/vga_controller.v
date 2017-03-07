/// 
/// VGA controller
/// --------------
///
/// This module shows the images on the VGA monitor.
///
/// .. figure:: vga_controller.png
///
///    VGA controller block
///  
module vga_controller #(
        // Horizontal Parameter ( Pixel )
        parameter H_SYNC_CYC = 96,
        parameter H_SYNC_BACK = 48,
        parameter H_SYNC_ACT = 640,
        parameter H_SYNC_FRONT = 16,
        parameter H_SYNC_TOTAL = 800,
        // Virtical Parameter ( Line )
        parameter V_SYNC_CYC = 2,
        parameter V_SYNC_BACK = 33,
        parameter V_SYNC_ACT = 480,
        parameter V_SYNC_FRONT = 10,
        parameter V_SYNC_TOTAL = 525,
        // Start Offset
        parameter X_START = 0,//160,
        parameter Y_START = 0//120
    ) (
        // Control Signal
        input clock_50,
        input clock_25,
        input reset_n,
        // Image size input
        input [15:0] width,
        input [15:0] height,
        //input iZOOM_MODE_SW,
        // Data color input
        input [9:0] iRed,
        input [9:0] iGreen,
        input [9:0] iBlue,
        output oRequest,
        output oCtrlClock,
        // VGA Interfase
        output VGA_CLK, // VGA Clock
        output VGA_HS, // VGA H_SYNC
        output VGA_VS, // VGA V_SYNC
        output VGA_BLANK, // VGA BLANK
        output VGA_SYNC, // VGA SYNC
        output [9:0] VGA_R, // VGA Red[9:0]
        output [9:0] VGA_G, // VGA Green[9:0]
        output [9:0] VGA_B // VGA Blue[9:0]
    );
    
//------------------------------------------------------------------------------

    reg [12:0] X_END;
    reg [12:0] Y_END;
    always @(posedge clock_50 or negedge reset_n)
    begin
        if (!reset_n) begin
            X_END[12:0] <= X_START[12:0] + width[12:0];
            Y_END[12:0] <= Y_START[12:0] + height[12:0];
        end
    end
    
//------------------------------------------------------------------------------

    // Sync signal generation
    reg [12:0] hcounter;
    reg [12:0] vcounter;
    
    reg hsync;
    reg vsync;
    
    always @(posedge clock_25 or negedge reset_n)
    begin
        if (!reset_n) begin
            hcounter <= 13'd0;
            vcounter <= 13'd0;
            hsync <= 1'b0;
            vsync <= 1'b0;
        end
        else begin
            // Horizontal sync
            if ((hcounter >= H_SYNC_ACT + H_SYNC_FRONT) &&
                (hcounter <= H_SYNC_ACT + H_SYNC_FRONT + H_SYNC_CYC)) begin
                hsync <= 1'b0;
            end
            else begin
                hsync <= 1'b1;
            end
            // Vertical sync
            if ((vcounter >= V_SYNC_ACT + V_SYNC_FRONT) &&
                (vcounter <= V_SYNC_ACT + V_SYNC_FRONT + V_SYNC_CYC)) begin
                vsync <= 1'b0;
            end
            else begin
                vsync <= 1'b1;
            end
            // Horizontal and vertical counts
            if (hcounter < (H_SYNC_TOTAL - 1)) begin
                hcounter[12:0] <= hcounter[12:0] + 13'd1;
            end 
            else begin
                hcounter[12:0] <= 13'd0;
                if (vcounter < (V_SYNC_TOTAL - 1)) begin
                    vcounter[12:0] <= vcounter[12:0] + 13'd1;
                end 
                else begin
                    vcounter[12:0] <= 13'd0;
                end
            end
        end
    end
    
//------------------------------------------------------------------------------
    
//    // Data generation (test)
//    reg [9:0] red;
//    reg [9:0] green;
//    reg [9:0] blue;
//    
//    always @(posedge clock_25)
//    begin
//        if (reset_n) begin
//            if (vcounter < 480) begin
//                if (hcounter < 320) begin
//                    red[9:0] <= 10'b1111111111;
//                end
//                else begin
//                    red[9:0] <= 10'b0000000000;
//                end
//            end
//            else begin
//                red[9:0] <= 10'b0000000000;
//            end
//            if (hcounter < 640) begin
//                if (vcounter < 240) begin
//                    blue[9:0] <= 10'b1111111111;
//                end
//                else begin
//                    blue[9:0] <= 10'b0000000000;
//                end
//                if ((vcounter > 120) && (vcounter < 360)) begin
//                    green[9:0] <= 10'b1111111111;
//                end
//                else begin
//                    green[9:0] <= 10'b0000000000;
//                end
//            end
//            else begin
//                green[9:0] <= 10'b0000000000;
//                blue[9:0] <= 10'b0000000000;
//            end
//        end
//        else begin
//            red[9:0] <= 10'd0;
//            green[9:0] <= 10'd0;
//            blue[9:0] <= 10'd0;
//        end
//    end
    
//------------------------------------------------------------------------------
       
    // Pixel LUT Address Generator
    reg request;
    always @(posedge clock_50 or negedge reset_n)
    begin
        if (!reset_n) begin
            request <= 1'b0;
        end
        else begin
            if ((hcounter >= X_START && hcounter < X_END) && 
                (vcounter >= Y_START && vcounter < Y_END)) begin
                request <= ~request;//1'b1;
            end
            else begin
                request <= 1'b0;
            end
        end 
    end
    assign oRequest = request;
    assign oCtrlClock = clock_25;
    
    // Data generation
    reg [9:0] red;
    reg [9:0] green;
    reg [9:0] blue;
    
    always @(posedge clock_50 or negedge reset_n)//clock_25
    begin
        if (!reset_n) begin
            red[9:0] <= 10'd0;
            green[9:0] <= 10'd0;
            blue[9:0] <= 10'd0;
        end
        else begin
            if ((hcounter > X_START && hcounter <= X_END) && 
                (vcounter > Y_START && vcounter <= Y_END)) begin
                red[9:0] <= iRed[9:0];
                green[9:0] <= iGreen[9:0];
                blue[9:0] <= iBlue[9:0];
            end
            else begin
                red[9:0] <= 10'd0;
                green[9:0] <= 10'd0;
                blue[9:0] <= 10'd0;
            end
        end
    end
    
//------------------------------------------------------------------------------
    
    assign VGA_CLK = clock_25;
    assign VGA_R[9:0] = red[9:0];
    assign VGA_G[9:0] = green[9:0];
    assign VGA_B[9:0] = blue[9:0];
    assign VGA_HS = hsync;
    assign VGA_VS = vsync;
    assign VGA_SYNC = 1'b0;
    assign VGA_BLANK = hsync & vsync;
    
//------------------------------------------------------------------------------

endmodule
