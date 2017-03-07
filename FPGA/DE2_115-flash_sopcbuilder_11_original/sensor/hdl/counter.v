///
/// The stream counter block counts pixels that goes through it.
///
module counter #(
        parameter N = 3
    ) (
        input clock,
        input reset_n,
        // Image size
        input [11:0] width,
        input [11:0] height,
        // Image data input
        input in_write,
        input [N-1:0] in_data,
        // Image data output
        output out_clock,
        output out_reset_n,
        output out_write,
        output [N-1:0] out_data,
        output [11:0] out_x,
        output [11:0] out_y,
        output out_done
    );
         
    reg [11:0] WIDTH;
    reg [11:0] HEIGHT;
    always @(posedge clock)
    begin
        if (!reset_n) begin
            WIDTH[11:0] <= width[11:0];
            HEIGHT[11:0] <= height[11:0];
        end
    end
        
    // Data counter 
    reg write;
    reg [N-1:0] data;
    reg [11:0] x;
    reg [11:0] y;
    reg done;
    always @(posedge clock)
    begin
        if (reset_n) begin
            write <= in_write;
            data[N-1:0] <= in_data[N-1:0];
            if (write) begin
                if (x < (WIDTH - 1)) begin
                    x[11:0] <= x[11:0] + 12'd1;    
                end
                else begin
                    x[11:0] <= 12'd0;
                    if (y < (HEIGHT - 1)) begin    
                        y[11:0] <= y[11:0] + 12'd1;
                    end
                    else begin
                        y[11:0] <= 12'd0;
                    end
                end
	            if ((x == (WIDTH - 1)) && (y == (HEIGHT - 1))) begin
	                done <= 1'b1;
	            end
	            else begin
	                done <= 1'b0;
	            end
            end
        end
        else begin
            write <= 1'b0;
            data[N-1:0] <= 0;
            x[11:0] <= 12'd0;
            y[11:0] <= 12'd0;
            done <= 1'b0;
        end
    end
    
    assign out_clock = clock;
    assign out_reset_n = reset_n;
    assign out_write = write;
    assign out_data[N-1:0] = data[N-1:0];
    assign out_x[11:0] = x[11:0];
    assign out_y[11:0] = y[11:0];
    assign out_done = done;
        
endmodule
