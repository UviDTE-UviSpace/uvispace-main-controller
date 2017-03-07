`timescale 1 ns / 100 ps

module sram_controller_tb;
    
    reg clock;
    reg reset_n;
    
    reg write_en;
    reg read_en;
    
    wire write_done;
    wire read_done;
    
    reg write;
    reg [1:0] write_data;
    
    wire read;
    wire [1:0] read_data;
    
    wire sram_clock;
    wire sram_write;
    wire [31:0] sram_write_data;
    wire [12:0] sram_write_addr;
    reg [31:0] sram_read_data;
    wire [12:0] sram_read_addr;
    
    sram_controller sram_ctrl (
        .clock(clock),
        .reset_n(reset_n),
        // Parameters
        .image_size(23'd64),
        .image_start_addr(13'd0),
        // External data input
        .write_image_en(write_en),
        .write_image(write),
        .write_image_data(write_data[1:0]),
        .write_image_done(write_done),
        // External data output
        .read_image_en(read_en),
        .read_image(read),
        .read_image_data(read_data[1:0]),
        .read_image_done(read_done),
        // SRAM signals
        .sram_clock(sram_clock),
        .sram_write(sram_write),
        .sram_write_data(sram_write_data[31:0]),
        .sram_write_addr(sram_write_addr[12:0]),
        .sram_read_data(sram_read_data[31:0]),
        .sram_read_addr(sram_read_addr[12:0])
    );
    
    initial clock = 1'b0;
    always #5 clock = ~clock;
    
    initial reset_n = 1'b0;
    initial #100 reset_n = 1'b1;
    
    initial write_en = 1'b0;
    initial #150 write_en = 1'b1;
    initial write = 1'b0;
    
    initial read_en = 1'b0;
    initial sram_read_data = 32'h99999999;
        
    integer i = 0;
    always @(posedge clock)
    begin
        if (reset_n) begin
            if (write_en) begin
                write <= 1'b1;
	            write_data[1:0] <= i[1:0];
	            if (i < 64) begin
	                i <= i + 1;
	            end
	            else begin
	                write_en <= 1'b0;
	                read_en <= 1'b1;
	            end
	        end
	    end
    end
    
    initial $dumpvars;
    initial #1500 $finish;

endmodule

