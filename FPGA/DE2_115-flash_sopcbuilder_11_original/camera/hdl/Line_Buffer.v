///
/// Line buffer
/// -----------
///
module Line_Buffer #(
        parameter N = 8
    ) (
        input clock,
        input reset_n,
        input [11:0] size,
        input in_valid,
        input [N-1:0] in_data,
        input [11:0] in_x,
        input [11:0] in_y,
        input in_done,
        output reg out_valid,
        output reg [N-1:0] out_data00,
        output reg [N-1:0] out_data01,
        output reg [N-1:0] out_data10,
        output reg [N-1:0] out_data11,
        output reg [11:0] out_x,
        output reg [11:0] out_y,
        output reg out_done 
    );
    
    parameter MEMORY_SIZE = 4096;
    parameter ADDRESS_SIZE = 12;
    
    reg valid;
    wire [N-1:0] data;
    reg [11:0] x, y;
    reg done;
    
    always @(posedge clock) 
    begin
        if (reset_n) begin
            valid <= in_valid;
            out_valid <= valid;
            x[11:0] <= in_x[11:0];
            y[11:0] <= in_y[11:0];
            out_x[11:0] <= x[11:0];
            out_y[11:0] <= y[11:0];
            done <= in_done;
            out_done <= done;
            if (in_valid) begin
                out_data11[N-1:0] <= in_data[N-1:0];
                out_data01[N-1:0] <= data[N-1:0]; 
            end
            if (valid) begin
                out_data10[N-1:0] <= out_data11[N-1:0];
                out_data00[N-1:0] <= out_data01[N-1:0];
            end
        end
        else begin
            out_data00[N-1:0] <= 0;
            out_data01[N-1:0] <= 0;
            out_data10[N-1:0] <= 0;
            out_data11[N-1:0] <= 0;
        end
    end
    
    fifo_prog #(
        .MEMORY_WIDTH(N),
        .MEMORY_SIZE(MEMORY_SIZE)
    ) fifo (
        .clk(clock),
        .reset_n(reset_n),
        .enable(out_valid),
        .data_in(out_data10[N-1:0]),
        .size({4'b0, size[11:0]} - 16'd2),
        .data_out(data[N-1:0])
    );

endmodule
