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
/// Each primary color does not receive an equal fraction of the total area 
/// because the human eye is more sensitive to green light than both red and 
/// blue light. Redundancy with green pixels produces an image which appears 
/// less noisy and has finer detail than could be accomplished if each color 
/// were treated equally.
///
/// The first raw outputs data alternates between green1 and red pixels, and 
/// the second raw output alternates between blue and green2 pixels. The green1 
/// and green2 have the same colour filter and are outputted as green.
///
module raw2rgb #(
        parameter N = 8
    ) (
        input clock,
        input reset_n,
        // Image size input
        input [11:0] width,
        input [11:0] height,
        // Data input
        input in_valid,
        input [N-1:0] in_data,
        input [11:0] in_x,
        input [11:0] in_y,
        input in_done,
        // Data output
        output [N-1:0] out_red,
        output [N-1:0] out_green,
        output [N-1:0] out_blue,
        output out_valid,
        output out_val00,
        output out_val01,
        output out_val10,
        output out_val11,
        output out_done
    );
    
//------------------------------------------------------------------------------
    
    // Programmable FIFO (COLUMN_WIDTH)
    reg [11:0] COLUMN_WIDTH;
    always @(posedge clock)
    begin
        if (!reset_n) begin
            COLUMN_WIDTH[11:0] <= {width[10:0], 1'b0}; // COLUMN_WIDTH = 2 * WIDTH
        end
    end
      
    // Two lines input buffer, for RGB calculation
    wire valid;
    wire [N-1:0] data00, data01;
    wire [N-1:0] data10, data11;
    wire [11:0] x, y;
    wire done;
    Line_Buffer #(
        .N(N)
    ) lbuff (
        .clock(clock),
        .reset_n(reset_n),
        .size(COLUMN_WIDTH[11:0]),
        .in_valid(in_valid),
        .in_data(in_data[N-1:0]),
        .in_x(in_x[11:0]),
        .in_y(in_y[11:0]),
        .in_done(in_done),
        .out_valid(valid),
        .out_data00(data00[N-1:0]),
        .out_data01(data01[N-1:0]),
        .out_data10(data10[N-1:0]),
        .out_data11(data11[N-1:0]),
        .out_x(x[11:0]),
        .out_y(y[11:0]),
        .out_done(done)
    );
   
//------------------------------------------------------------------------------

    reg [N-1:0] red;
    reg [N:0] green;
    reg [N-1:0] blue;
    
    reg val00;
    reg val01;
    reg val10;
    reg val11;
    
    reg _valid;
    reg _done;
    
    always @(posedge clock)
    begin
        if (reset_n) begin
            _valid <= valid;
            _done <= done;
            if (valid) begin
                if({y[0], x[0]} == 2'b01) begin
                    red[N-1:0] <= data00[N-1:0];
                    green[N:0] <= {1'b0, data01[N-1:0]} + {1'b0, data10[N-1:0]};
                    blue[N-1:0] <= data11[N-1:0];
                    val00 <= 1'b1;
                    val01 <= 1'b0;
                    val10 <= 1'b0;
                    val11 <= 1'b0;
                end
                if({y[0], x[0]} == 2'b00) begin
                    red[N-1:0] <= data01[N-1:0];
                    green[N:0] <= {1'b0, data00[N-1:0]} + {1'b0, data11[N-1:0]};
                    blue[N-1:0] <= data10[N-1:0];
                    val00 <= 1'b0;
                    val01 <= 1'b1;
                    val10 <= 1'b0;
                    val11 <= 1'b0;
                end
	            if ({y[0], x[0]} == 2'b11) begin
	                red[N-1:0] <= data10[N-1:0];
	                green[N:0] <= {1'b0, data00[N-1:0]} + {1'b0, data11[N-1:0]};
	                blue[N-1:0] <= data01[N-1:0];
	                val00 <= 1'b0;
	                val01 <= 1'b0;
	                val10 <= 1'b1;
	                val11 <= 1'b0;
	            end	
	            if({y[0], x[0]} == 2'b10) begin
	                red[N-1:0] <= data11[N-1:0];
	                green[N:0] <= {1'b0, data01[N-1:0]} + {1'b0, data10[N-1:0]};
	                blue[N-1:0] <= data00[N-1:0];
	                val00 <= 1'b0;
	                val01 <= 1'b0;
	                val10 <= 1'b0;
	                val11 <= 1'b1;
	            end 
	       end
	       else begin
	           red[N-1:0] <= 0;
               green[N:0] <= 0;
               blue[N-1:0] <= 0;
	           val00 <= 1'b0;
               val01 <= 1'b0;
               val10 <= 1'b0;
               val11 <= 1'b0;
	       end
        end
        else begin
            red[N-1:0] <= 0;
            green[N:0] <= 0;
            blue[N-1:0] <= 0;
            val00 <= 1'b0;
            val01 <= 1'b0;
            val10 <= 1'b0;
            val11 <= 1'b0;
            _valid <= 1'b0;
            _done <= 1'b0;
        end
    end
    
    assign out_red[N-1:0] = red[N-1:0];
    assign out_green[N-1:0] = green[N:1];
    assign out_blue[N-1:0] = blue[N-1:0];
    assign out_valid = _valid;//val00 | val01 | val10 | val11;
    assign out_val00 = val00;
    assign out_val01 = val01;
    assign out_val10 = val10;
    assign out_val11 = val11;
    assign out_done = _done;
    
//------------------------------------------------------------------------------

endmodule
