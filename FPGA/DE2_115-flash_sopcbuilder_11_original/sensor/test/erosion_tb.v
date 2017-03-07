`timescale 1 ns / 100 ps

module erosion_tb;
    
    reg clock;
    reg reset_n;
    
    reg write;
    reg pixel_in;
    
    wire read;
    wire pixel_out;
      
    erosion #( 
        .WIDTH(8),
        .HEIGHT(8) 
    ) eros (
        .clock(clock),
        .reset_n(reset_n),
        // Image data input
        .in_write(write),
        .in_pixel(pixel_in),
        // Image data output
        .out_read(read),
        .out_pixel(pixel_out)
    );
   
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
            write <= 1'b1; 
            $display("%d: | W: %b, %b | R: %b, %b |", $time, write, pixel_in, read, pixel_out);
        end
        else begin
            i <= 0;
        end
    end
    
    initial #1000 $finish;

endmodule

//module convolution3_tb;
//   
//   parameter N = 8;
//   parameter WIDTH = 32;
//   parameter HEIGHT = 32;
//   parameter stages = 1; // Número de etapas  
//   
//   reg en;
//   reg clock;
//      
//   // Datos de memoria
//   reg [N-1:0] pix [0:(WIDTH * HEIGHT)-1];
//   reg [N-1:0] data_out [0:(WIDTH * HEIGHT)-1];
//   
//   // Pixels de imagen
//   reg [N-1:0] p00, p01, p02;
//   reg [N-1:0] p10, p11, p12;
//   reg [N-1:0] p20, p21, p22;
//   
//   wire [N-1:0] conv;
//   wire sign;
//   
//   convolution #( .N(N),
//      .k00(15), .k01(25), .k02(15),
//      .k10(25), .k11(41), .k12(25),
//      .k20(15), .k21(25), .k22(15),
//      .s(8) )
//    convol3 (
//      .p00(p00), .p01(p01), .p02(p02),
//      .p10(p10), .p11(p11), .p12(p12),
//      .p20(p20), .p21(p21), .p22(p22),
//      .conv(conv), .sign(sign) );
//
//   initial
//    begin
//      en = 1'b1;
//      clock = 1'b0;
//      // Lee el archivo de memoria de datos de entrada
//      $readmemb ("memory3in.bin", pix);
//      // Lee el archivo de memoria de datos de salida
//      $readmemb ("memory3out.bin", data_out);
//   end
//   
//   always #10 clock = ~clock;
//   
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
//    
//   initial #10000 $finish;
//
//endmodule
