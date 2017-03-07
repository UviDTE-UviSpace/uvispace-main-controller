///
/// Internal memory controller
/// --------------------------
///
/// This module contol writes and read data to internal SDRAM from binary data
/// send from camera throught to the threshold block.
///
/// .. figure:: sram_controller.png
///
///    SRAM controller block
///
/// It writes serial two bits data in internal SRAM of 32 bits word and it 
/// reads that words and send serial data to external SDRAM.
///
module sram_controller ( 
        input clock,
        input reset_n,
        // Parameters
        input [22:0] image_size,
        input [12:0] image_start_addr,
        // External data input
        input write_image_en,
        input write_image,
        input [1:0] write_image_data,
        output write_image_done,
        // External data output
        input read_image_en,
        output read_image,
        output reg [1:0] read_image_data,
        output read_image_done,
        // SRAM signals
        output sram_clock,
        output sram_write,
        output [31:0] sram_write_data,
        output [12:0] sram_write_addr,
        input [31:0] sram_read_data,
        output [12:0] sram_read_addr
    );
    
    // Reset control
    reg [12:0] image_size_addr;
    always @(posedge clock)
    begin
        if (!reset_n) begin
            image_size_addr[12:0] <= image_size[12:0] + image_start_addr[12:0];
        end
    end
    
    // Write control
    reg write;
    reg [12:0] write_addr;
    reg [31:0] w_data;
    reg [31:0] write_data;
    reg write_done;
    reg [31:0] wi;
    always @(posedge clock)
    begin
        if (write_image_en) begin
            if (write_image && !write_done) begin
                case (wi[3:0])
                    0: w_data[1:0] <= write_image_data[1:0];
                    1: w_data[3:2] <= write_image_data[1:0];
                    2: w_data[5:4] <= write_image_data[1:0];
                    3: w_data[7:6] <= write_image_data[1:0];
                    4: w_data[9:8] <= write_image_data[1:0];
                    5: w_data[11:10] <= write_image_data[1:0];
                    6: w_data[13:12] <= write_image_data[1:0];
                    7: w_data[15:14] <= write_image_data[1:0];
                    8: w_data[17:16] <= write_image_data[1:0];
                    9: w_data[19:18] <= write_image_data[1:0];
                    10: w_data[21:20] <= write_image_data[1:0];
                    11: w_data[23:22] <= write_image_data[1:0];
                    12: w_data[25:24] <= write_image_data[1:0];
                    13: w_data[27:26] <= write_image_data[1:0];
                    14: w_data[29:28] <= write_image_data[1:0];
                    15: write_data[31:0] <= {write_image_data[1:0],
                                             w_data[29:0]};
                endcase
                if (wi > 15) begin
                    if (wi[3:0] == 0) begin
                        write_addr[12:0] <= write_addr[12:0] + 13'd1;
                    end
                end
                if (wi[3:0] == 15) begin
                    write <= 1'b1;
                    if (write_addr[12:0] == (image_size_addr[12:0] - 1)) begin
                        write_done <= 1'b1;
                    end
                end
                else begin
                    write <= 1'b0;
                end
                wi <= wi + 1;
            end
            else begin
                write <= 1'b0;
            end
        end
        else begin
            wi <= 0;
            write <= 1'b0;
            write_addr[12:0] <= image_start_addr[12:0];
            write_data[31:0] <= 32'd0;
            write_done <= 1'b0;
        end
    end
    
    assign write_image_done = write_done;
    	
    // Read control
    reg read;
    reg [12:0] read_addr;
    reg [31:0] read_data;
    reg read_done;
    reg [31:0] ri;	    
    always @(posedge clock)
    begin
        if (read_image_en) begin
            if (!read_done) begin
                case (ri[4:0])
                    0: read_image_data[1:0] <= read_data[1:0];
                    1: read_image_data[1:0] <= read_data[3:2];
                    2: read_image_data[1:0] <= read_data[5:4];
                    3: read_image_data[1:0] <= read_data[7:6];
                    4: read_image_data[1:0] <= read_data[9:8];
                    5: read_image_data[1:0] <= read_data[11:10];
                    6: read_image_data[1:0] <= read_data[13:12];
                    7: read_image_data[1:0] <= read_data[15:14];
                    8: read_image_data[1:0] <= read_data[17:16];
                    9: read_image_data[1:0] <= read_data[19:18];
                    10: read_image_data[1:0] <= read_data[21:20];
                    11: read_image_data[1:0] <= read_data[23:22];
                    12: read_image_data[1:0] <= read_data[25:24];
                    13: read_image_data[1:0] <= read_data[27:26];
                    14: read_image_data[1:0] <= read_data[29:28];
                    15: read_image_data[1:0] <= read_data[31:30];
                endcase
                if (ri[4:0] < 16) begin
                    if (ri[3:0] == 0) begin
                        read_addr[12:0] <= read_addr[12:0] + 13'd1;
                    end
                    ri <= ri + 1;
                    read <= 1'b1;
                end
                else begin
                    // -- ADDED --
                    if (ri < 31) begin
                        ri <= ri + 1;
                    end
                    else begin
                        ri <= 0;
                    end
                    // -----------
                    //ri <= 0;
                    read <= 1'b0;
                    read_data[31:0] <= sram_read_data[31:0];
                    if (read_addr[12:0] == image_size_addr[12:0]) begin
                        read_done <= 1'b1;
                    end
                end
            end
            else begin
                read <= 1'b0;
            end
        end
        else begin
            ri <= 0;
            read <= 1'b0;
            read_addr[12:0] <= image_start_addr[12:0];
            read_data[31:0] <= sram_read_data[31:0];
            read_done <= 1'b0;
        end
    end
    
    assign read_image = read;
    assign read_image_done = read_done;

    // SRAM control signals
    assign sram_clock = clock;
    assign sram_write = write;
    assign sram_write_data[31:0] = write_data[31:0];
    assign sram_write_addr[12:0] = write_addr[12:0];
    assign sram_read_addr[12:0] = read_addr[12:0];
        
endmodule				
