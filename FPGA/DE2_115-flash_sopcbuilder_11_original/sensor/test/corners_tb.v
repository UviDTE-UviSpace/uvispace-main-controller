`timescale 1 ns / 100 ps

module corners_tb;

    parameter WIDTH = 320;
    parameter HEIGTH = 240;
    
    reg clock;
    reg reset_n;
    
    reg write_in;
    reg pixel_in;
    
    wire write_out;
    wire pixel_out;
    
    wire [15:0] left_x, left_y;
    wire [15:0] top_x, top_y;
    wire [15:0] right_x, right_y;
    wire [15:0] bottom_x, bottom_y;
    
    corners corn (
        .clock(clock),
        .reset_n(reset_n),
        // Image size
        .width(WIDTH),
        .height(HEIGHT),
        // Image data input
        .in_write(write_in),
        .in_pixel(pixel_in),
        // Image data output
        .out_write(write_out),
        .out_pixel(pixel_out),
        // Data output
        .out_left_x(left_x),
        .out_left_y(left_y),
        .out_top_x(top_x),
        .out_top_y(top_y),
        .out_right_x(right_x),
        .out_right_y(right_y),
        .out_bottom_x(bottom_x),
        .out_bottom_y(bottom_y)
    );
    
//    // Memory data
//    reg [0:(WIDTH * HEIGHT)-1] pixels ;
//    initial $readmemb ("memory.bin", pixels);
    
    initial clock = 1'b0;
    always #10 clock = ~clock;
    
    initial reset_n = 1'b0;
    initial #100 reset_n = 1'b1;
    
    integer i;
    always @(posedge clock)
    begin
        if (reset_n) begin
            i <= i + 1;
            pixel_in <= i[0];
            write_in <= 1'b1; 
            $display("%d: | W: %b, %b | R: %b, %b |", $time, write_in, pixel_in, write_out, pixel_out);
        end
        else begin
            i <= 0;
        end
    end
    
//   integer init = 0;
//   integer j = 0, i = 0, l = 0;
//   integer jout = 0, iout = 0, lout = 0;
//   always @(posedge clock)
//   begin
//      l = j * WIDTH + i;
//      p00=pix[l+0*WIDTH]; p01=pix[l+0*WIDTH+1]; p02=pix[l+0*WIDTH+2];
//      p10=pix[l+1*WIDTH]; p11=pix[l+1*WIDTH+1]; p12=pix[l+1*WIDTH+2];
//      p20=pix[l+2*WIDTH]; p21=pix[l+2*WIDTH+1]; p22=pix[l+2*WIDTH+2];
//      i = i + 1;
//      if (i == (WIDTH-2)) begin
//         i = 0;
//         j = j + 1;
//         if (j == (HEIGHT-2)) j = 0;
//      end
//      if (init < stages) init = init + 1;
//      else begin
//         lout = jout * WIDTH + iout;
//         if (data_out[lout] == conv) $display( "%d: %d: %h: %h [OK]", $time, lout, data_out[lout], conv );
//         else $display( "%d: %d: %h: %h [ERROR]", $time, lout, data_out[lout], conv );
//         iout = iout + 1;
//         if (iout == (WIDTH-2)) begin
//           iout = 0;
//           jout = jout + 1;
//           if (jout == (HEIGHT-2)) jout = 0;
//         end
//      end
//   end
  
    initial #10000 $finish;

endmodule
