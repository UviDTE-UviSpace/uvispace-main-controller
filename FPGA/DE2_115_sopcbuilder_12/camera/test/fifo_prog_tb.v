`timescale 1 ns / 100 ps

module fifo_prog_tb;
    
    parameter N = 8;
    
    reg clock;
    reg reset_n;
    reg enable;
    reg [N-1:0] data_in;
    reg [15:0] size;
    wire [N-1:0] data_out;
    
    fifo_prog #(
        .MEMORY_WIDTH(N),
        .MEMORY_SIZE(1024)
    ) fifo (
        .clk(clock),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(data_in[N-1:0]),
        .size(size),
        .data_out(data_out[N-1:0])
    );
      
    initial clock = 1'b0;
    always #10 clock = ~clock;
   
    initial reset_n = 1'b0;
    initial #10 reset_n = 1'b1;
    initial #20 enable = 1'b1;
    initial data_in = 0;
    initial size = 64;
    
    always @(posedge clock) 
    begin
        if (enable) begin
            $display("%d ns: %d in, %d out", $time, data_in, data_out);
            data_in = data_in + 1;
        end    
    end
   
    initial #5000 $finish;
   
endmodule
