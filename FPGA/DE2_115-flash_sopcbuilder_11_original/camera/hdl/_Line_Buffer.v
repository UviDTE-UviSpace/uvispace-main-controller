///
/// Line buffer
/// -----------
///
module Line_Buffer (
        input clock,
        input reset_n,
        input enable,
        input [15:0] size,
        input [11:0] data_in,
        output [11:0] taps0x,
        output [11:0] taps1x 
    );
    
    parameter N = 12;
    parameter MEMORY_SIZE = 4096;
    parameter ADDRESS_SIZE = 12;
    
    wire [N-1:0] taps0;
    wire [N-1:0] taps1;
    
    fifo_prog #(
        .MEMORY_WIDTH(N),
        .MEMORY_SIZE(MEMORY_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    ) fifo0 (
        .clk(clock),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(data_in[N-1:0]),
        .size(size[15:0]),
        .data_out(taps0[N-1:0])
    );
    
    fifo_prog #(
        .MEMORY_WIDTH(N),
        .MEMORY_SIZE(MEMORY_SIZE)
    ) fifo1 (
        .clk(clock),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(taps0[N-1:0]),
        .size(size[15:0]),
        .data_out(taps1[N-1:0])
    );
    
    assign taps0x[N-1:0] = taps0[N-1:0];
    assign taps1x[N-1:0] = taps1[N-1:0];

endmodule
