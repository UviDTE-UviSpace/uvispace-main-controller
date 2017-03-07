`timescale 1 ns / 100 ps

module fifo_tb;

    parameter N = 1;
    parameter WIDTH = 8;
    parameter HEIGHT = 8;
   
    reg clock;
    reg reset_n;
   
    reg enable;
    
    reg [N-1:0] data_in;
    
    wire valid;
    
    wire [N-1:0] p00, p01, p02;
    wire [N-1:0] p10, p11, p12;
    wire [N-1:0] p20, p21, p22;
   
    fifo3x3 #(
        .N(N)
    ) ff (
        .clock(clock), 
        .reset_n(reset_n),
        .width(WIDTH[15:0]),
        .read(enable), 
        .pi(data_in[0]),
        .po00(p00), .po01(p01), .po02(p02), 
        .po10(p10), .po11(p11), .po12(p12), 
        .po20(p20), .po21(p21), .po22(p22), 
        .valid(valid) 
    );
      
    initial clock = 1'b0;
    always #10 clock = ~clock;
   
    initial reset_n = 1'b0;
    initial #50 reset_n = 1'b1;
   
    initial enable = 1'b1;

    initial begin
        #100 enable = 1'b0;
        #100 enable = 1'b1;
    end
   
    initial data_in = 0;
   
    integer count;
    always @(posedge clock)
    begin
        if (reset_n) data_in = data_in + 1;
        if (reset_n) begin
            if (valid) count = count + 1;
        end else count = 0;
        $display("id: %d, %d ns, %d, %b", count, $time, data_in, valid);
        $display("%d, %d, %d", p00, p01, p02);
        $display("%d, %d, %d", p10, p11, p12);
        $display("%d, %d, %d", p20, p21, p22);
    end
    
    initial #1000 $finish;
   
endmodule
