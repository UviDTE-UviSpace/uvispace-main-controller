///
/// RAW to RGB
/// ----------
///
/// This module calculates the 30 bit RGB pixel data from the RAW data of the
/// camera sensor, through the position coordinates X and Y.
///
/// .. figure:: RAW2RGB.png
///
///    RAW to RGB block
///
/// When a pixel is ready (in_valid), reads each pixel using in_data and in_x 
/// and in_y, give the exact coordinates of the pixel, helping to calculate 
/// out_red, out_green, and out_blue value, for each valid frame (out_valid is 1).
/// 
/// Pixels are output in a Bayer pattern format consisting of four colors:
/// green1, green2, red, and blue. 
///
/// .. Note::
///    Each primary color does not receive an equal fraction of the total area 
///    because the human eye is more sensitive to green light than both red and 
///    blue light. Redundancy with green pixels produces an image which appears 
///    less noisy and has finer detail than could be accomplished if each color 
///    were treated equally.
///
/// The first raw outputs data alternates between green1 and red pixels, and 
/// the second raw output alternates between blue and green2 pixels. The green1 
/// and green2 have the same colour filter and are outputted as green.
///
module RAW2RGB (
        input clock,
        input reset_n,
        // Image size input
        input [15:0] width,
        input [15:0] height,
        // Data input
        input in_valid,
        input [11:0] in_data,
        input [10:0] in_x,
        input [10:0] in_y,
        input in_done,
        // Data output
        output [11:0] out_red,
        output [11:0] out_green,
        output [11:0] out_blue,
        output out_valid,
        output out_val00,
        output out_val01,
        output out_val10,
        output out_val11,
        output out_done
    );
    
//------------------------------------------------------------------------------
    
    reg done;
    always @(posedge clock) done <= in_done;
    assign out_done = done;
    
    // Programmable FIFO (COLUMN_WIDTH)
    reg [15:0] COLUMN_WIDTH;
    always @(posedge clock or negedge reset_n)
    begin
        if (!reset_n) begin
            COLUMN_WIDTH[15:0] <= {width[14:0], 1'b0}; // COLUMN_WIDTH = 2 * WIDTH
        end
    end
      
    // Two lines input buffer, for RGB calculation
    wire [11:0] mDATA_0;
    wire [11:0] mDATA_1;
    Line_Buffer buffer (
        .clock(clock),
        .reset_n(reset_n),
        .enable(in_valid),
        .size(COLUMN_WIDTH[15:0]),
        .data_in(in_data[11:0]),
        .taps0x(mDATA_1[11:0]),
        .taps1x(mDATA_0[11:0]) 
    );
   
//------------------------------------------------------------------------------

    reg [11:0] mDATAd_0;
    reg [11:0] mDATAd_1;
    reg [11:0] mCCD_R;
    reg [12:0] mCCD_G;
    reg [11:0] mCCD_B;
    reg mDVAL;
    
    reg val00;
    reg val01;
    reg val10;
    reg val11;
    
    reg [11:0] ColorR;
    reg [11:0] ColorG;
    reg [11:0] ColorB;
    
    always @(posedge clock or negedge reset_n)
    begin
        if (!reset_n) begin
            mCCD_R[11:0] <= 12'd0;
            mCCD_G[12:0] <= 13'd0;
            mCCD_B[11:0] <= 12'd0;
            mDATAd_0[11:0] <= 12'd0;
            mDATAd_1[11:0] <= 12'd0;
            mDVAL <= 1'b0;
            val00 <= 1'b0;
            val01 <= 1'b0;
            val10 <= 1'b0;
            val11 <= 1'b0;
        end
        else begin
            mDATAd_0[11:0] <= mDATA_0[11:0];
            mDATAd_1[11:0] <= mDATA_1[11:0];
            mDVAL <= (in_y[0] | in_x[0]) ? 1'b0 : in_valid;
            val00 <= 1'b0;
            val01 <= 1'b0;
            val10 <= 1'b0;
            val11 <= 1'b0;
            if ({in_y[0], in_x[0]} == 2'b10) begin
                mCCD_R[11:0] <= mDATA_0[11:0];
                mCCD_G[12:0] <= {1'b0, mDATAd_0[11:0]} + {1'b0, mDATA_1[11:0]};
                mCCD_B[11:0] <= mDATAd_1[11:0];
                val10 <= in_valid;
            end	
            else if({in_y[0], in_x[0]} == 2'b11) begin
                mCCD_R[11:0] <= mDATAd_0[11:0];
                mCCD_G[12:0] <= {1'b0, mDATA_0[11:0]} + {1'b0, mDATAd_1[11:0]};
                mCCD_B[11:0] <= mDATA_1[11:0];
                val11 <= in_valid;
            end 
            else if({in_y[0], in_x[0]} == 2'b00) begin
                mCCD_R[11:0] <= mDATA_1[11:0];
                mCCD_G[12:0] <= {1'b0, mDATA_0[11:0]} + {1'b0, mDATAd_1[11:0]};
                mCCD_B[11:0] <= mDATAd_0[11:0];
                val00 <= in_valid;
            end
            else if({in_y[0], in_x[0]} == 2'b01) begin
                mCCD_R[11:0] <= mDATAd_1[11:0];
                mCCD_G[12:0] <= {1'b0, mDATAd_0[11:0]} + {1'b0, mDATA_1[11:0]};
                mCCD_B[11:0] <= mDATA_0[11:0];
                val01 <= in_valid;
            end
            ColorR[11:0] <= mCCD_R[11:0];
            ColorG[11:0] <= mCCD_G[12:1];
            ColorB[11:0] <= mCCD_B[11:0];
        end
    end
    
    assign out_red[11:0] = ColorR[11:0];
    assign out_green[11:0] = ColorG[11:0];
    assign out_blue[11:0] = ColorB[11:0];
    //assign out_valid = mDVAL;
    assign out_valid = val00 | val01 | val10 | val11;
    
    assign out_val00 = val00;
    assign out_val01 = val01;
    assign out_val10 = val10;
    assign out_val11 = val11;
    
//------------------------------------------------------------------------------

endmodule
