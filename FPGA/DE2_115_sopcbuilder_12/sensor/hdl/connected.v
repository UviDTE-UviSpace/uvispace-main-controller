///
/// Connected components block
/// --------------------------
///
/// This module implements a connected components algorithm to look for the 
/// corners of the detected shapes in the image.
///
module connected #(
        parameter LABEL_SIZE = 7,
        parameter WORD_SIZE = 16
    )(
        input clock,
        input reset_n,
        // Image size
        input [15:0] width,
        input [15:0] height,
        // Image data input
        input in_write,
        input in_pixel,
        input in_done,
        // Image data output
        output out_write,
        output [LABEL_SIZE-1:0] out_pixel,
        // Data output
        output reg [15:0] out1_size,
        output reg [31:0] out1_left1,
        output reg [31:0] out1_left2,
        output reg [31:0] out1_top1,
        output reg [31:0] out1_top2,
        output reg [31:0] out1_right1,
        output reg [31:0] out1_right2,
        output reg [31:0] out1_bottom1,
        output reg [31:0] out1_bottom2,
        // Data output 2
        output reg [15:0] out2_size,
        output reg [31:0] out2_left1,
        output reg [31:0] out2_left2,
        output reg [31:0] out2_top1,
        output reg [31:0] out2_top2,
        output reg [31:0] out2_right1,
        output reg [31:0] out2_right2,
        output reg [31:0] out2_bottom1,
        output reg [31:0] out2_bottom2,
        // Data output 3
        output reg [15:0] out3_size,
        output reg [31:0] out3_left1,
        output reg [31:0] out3_left2,
        output reg [31:0] out3_top1,
        output reg [31:0] out3_top2,
        output reg [31:0] out3_right1,
        output reg [31:0] out3_right2,
        output reg [31:0] out3_bottom1,
        output reg [31:0] out3_bottom2,
        // Done
        output out_done
    );
    
//------------------------------------------------------------------------------
     
    reg [15:0] WIDTH;
    reg [15:0] HEIGHT;
    always @(posedge clock)
    begin
        if (!reset_n) begin
            WIDTH[15:0] <= width[15:0];
            HEIGHT[15:0] <= height[15:0];
        end
    end
    
//------------------------------------------------------------------------------

    // Pixel position counter
    reg img_write;
    reg img_pixel;
    reg [15:0] x;
    reg [15:0] y;
    reg done;
    always @(posedge clock)
    begin
        if (reset_n) begin
            img_write <= in_write;
            img_pixel <= in_pixel;
            if (img_write && !done) begin
                if (x < (WIDTH - 1)) begin
                    x[15:0] <= x[15:0] + 16'd1;    
                end
                else begin
                    if (y < (HEIGHT - 1)) begin
                        x[15:0] <= 16'd0;
                        y[15:0] <= y[15:0] + 16'd1;
                    end
                end
            end
            if ((x == (WIDTH - 1)) && (y == (HEIGHT - 1))) begin
                done <= 1'b1;
            end
        end
        else begin
            img_write <= 1'b0;
            img_pixel <= 1'b0;
            x[15:0] <= 16'd0;
            y[15:0] <= 16'd0;
            done <= 1'b0;
        end
    end
    
//------------------------------------------------------------------------------
    
    // FIFO of labeled image
    wire [LABEL_SIZE-1:0] west;
    wire [LABEL_SIZE-1:0] north_west;
    wire [LABEL_SIZE-1:0] north;
    wire [LABEL_SIZE-1:0] north_east;
    wire [LABEL_SIZE-1:0] img_label;
    fifo_conn #(
        .N(LABEL_SIZE)
    ) fifo_img (
        .clock(clock),
        .reset_n(reset_n),
        // Size
        .width(width[15:0]),
        // Data input
        .write(img_write), 
        .pi11(img_label[LABEL_SIZE-1:0]),
        // Data output
        .po00(north_west[LABEL_SIZE-1:0]), 
        .po01(north[LABEL_SIZE-1:0]), 
        .po02(north_east[LABEL_SIZE-1:0]),
        .po10(west[LABEL_SIZE-1:0]), 
        .valid()
    );
    
//------------------------------------------------------------------------------
        
    // Labeling connected components 
    reg new_label;
    reg change_label;
    reg connected_label;
    reg [LABEL_SIZE-1:0] label;
    reg [LABEL_SIZE-1:0] prev_label;
    reg [LABEL_SIZE-1:0] next_label;
    reg [LABEL_SIZE-1:0] connected;
    always @(posedge clock)
    begin
        if (reset_n) begin
          if (!done) begin
            new_label <= 1'b0;
            change_label <= 1'b0;
            connected_label <= 1'b0;
            connected[LABEL_SIZE-1:0] <= 8'b0;
            if (in_write) begin
                if (in_pixel) begin // & (x < (WIDTH - 3)) & (y < (HEIGHT - 3))) begin
	                // Labeling
	                $display("x: %d, y: %d, label: %d", x, y, label);
	                $display("size: %d", size);
	                $display("w: %d, nw: %d, n: %d, ne: %d", west, north_west, north, north_east);
	                if (img_pixel & (label > 0)) begin // previous label is west label
	                    label[LABEL_SIZE-1:0] <= label[LABEL_SIZE-1:0];
	                    prev_label[LABEL_SIZE-1:0] <= label[LABEL_SIZE-1:0];
	                end
	                else if (north_west > 0) begin
	                    label[LABEL_SIZE-1:0] <= north_west[LABEL_SIZE-1:0];
	                end
	                else if (north > 0) begin
	                    label[LABEL_SIZE-1:0] <= north[LABEL_SIZE-1:0];
	                end
	                else if (north_east > 0) begin
	                    label[LABEL_SIZE-1:0] <= north_east[LABEL_SIZE-1:0];
	                end
	                else begin
	                    if (!new_label) begin
	                        new_label <= 1'b1;
	                        label[LABEL_SIZE-1:0] <= next_label[LABEL_SIZE-1:0];
	                        next_label[LABEL_SIZE-1:0] <= next_label[LABEL_SIZE-1:0] + 8'd1;
	                    end
	                end
	                // Changed
	                if ((!change_label)) begin
                        if (prev_label > label) begin
                            change_label <= 1'b1;
                        end
                    end
	                // Connected
	                if (!connected_label) begin
		                if ((north_east > 0) && (label > north_east)) begin
		                    connected_label <= 1'b1;
	                        connected[LABEL_SIZE-1:0] <= north_east[LABEL_SIZE-1:0];
	                    end
	                end
	            end
            end
          end
        end
        else begin
            new_label <= 1'b0;
            change_label <= 1'b0;
            connected_label <= 1'b0;
            label[LABEL_SIZE-1:0] <= 8'd0;
            prev_label[LABEL_SIZE-1:0] <= 8'd0;
            next_label[LABEL_SIZE-1:0] <= 8'd1;
            connected[LABEL_SIZE-1:0] <= 8'd0;
        end
    end
    assign img_label[LABEL_SIZE-1:0] = (img_write & img_pixel) ? label[LABEL_SIZE-1:0] : 0;
    
    // Image data output
    assign out_write = img_write;
    assign out_pixel[LABEL_SIZE-1:0] = (img_write & img_pixel) ? label[LABEL_SIZE-1:0] : 0;
    
//------------------------------------------------------------------------------   
    
    // RAM banks
    
    reg write_ram;
    reg [LABEL_SIZE-1:0] write_ram_addr;
    
    reg read_ram;
    reg [LABEL_SIZE-1:0] read_ram_addr;
    
    reg [15:0] write_size;
    wire [15:0] read_size;
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(LABEL_SIZE)
    )mem_sizes(
        .clock(clock), 
        .enable(reset_n),
        .address_write(write_ram_addr[LABEL_SIZE-1:0]),
        .write(write_ram),
        .data_in(write_size[15:0]),
        .address_read(read_ram_addr[LABEL_SIZE-1:0]),
        .read(read_ram),
        .data_out(read_size[15:0])
    );
    
    reg [15:0] left1_x, left1_y;
    reg [15:0] right1_x, right1_y;
    reg [15:0] top1_x, top1_y;
    reg [15:0] bottom1_x, bottom1_y;
    
    wire [15:0] read_left1_x, read_left1_y;
    wire [15:0] read_top1_x, read_top1_y;
    wire [15:0] read_right1_x, read_right1_y;
    wire [15:0] read_bottom1_x, read_bottom1_y;
    
    ram_banks #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(LABEL_SIZE)
    ) bank1 (
        .clock(clock),
        .enable(reset_n),
        .address_write(write_ram_addr[LABEL_SIZE-1:0]),
        .write(write_ram),
        .write_left_x(left1_x[15:0]),
        .write_left_y(left1_y[15:0]),
        .write_top_x(top1_x[15:0]),
        .write_top_y(top1_y[15:0]),
        .write_right_x(right1_x[15:0]),
        .write_right_y(right1_y[15:0]),
        .write_bottom_x(bottom1_x[15:0]),
        .write_bottom_y(bottom1_y[15:0]),
        .address_read(read_ram_addr[LABEL_SIZE-1:0]),
        .read(read_ram),
        .read_left_x(read_left1_x[15:0]),
        .read_left_y(read_left1_y[15:0]),
        .read_top_x(read_top1_x[15:0]),
        .read_top_y(read_top1_y[15:0]),
        .read_right_x(read_right1_x[15:0]),
        .read_right_y(read_right1_y[15:0]),
        .read_bottom_x(read_bottom1_x[15:0]),
        .read_bottom_y(read_bottom1_y[15:0])
    );
    
    reg [15:0] left2_x, left2_y;
    reg [15:0] top2_x, top2_y;
    reg [15:0] right2_x, right2_y;
    reg [15:0] bottom2_x, bottom2_y;
    
    wire [15:0] read_left2_x, read_left2_y;
    wire [15:0] read_top2_x, read_top2_y;
    wire [15:0] read_right2_x, read_right2_y;
    wire [15:0] read_bottom2_x, read_bottom2_y;
    
    ram_banks #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(LABEL_SIZE)
    ) bank2 (
        .clock(clock),
        .enable(reset_n),
        .address_write(write_ram_addr[LABEL_SIZE-1:0]),
        .write(write_ram),
        .write_left_x(left2_x[15:0]),
        .write_left_y(left2_y[15:0]),
        .write_top_x(top2_x[15:0]),
        .write_top_y(top2_y[15:0]),
        .write_right_x(right2_x[15:0]),
        .write_right_y(right2_y[15:0]),
        .write_bottom_x(bottom2_x[15:0]),
        .write_bottom_y(bottom2_y[15:0]),
        .address_read(read_ram_addr[LABEL_SIZE-1:0]),
        .read(read_ram),
        .read_left_x(read_left2_x[15:0]),
        .read_left_y(read_left2_y[15:0]),
        .read_top_x(read_top2_x[15:0]),
        .read_top_y(read_top2_y[15:0]),
        .read_right_x(read_right2_x[15:0]),
        .read_right_y(read_right2_y[15:0]),
        .read_bottom_x(read_bottom2_x[15:0]),
        .read_bottom_y(read_bottom2_y[15:0])
    );
    
//------------------------------------------------------------------------------    
    
    // Delayed signals (pipeline)
    
    // Stage 1 (storage)
    reg store_done;
    reg store_write;
    reg store_pixel;
    reg [15:0] store_x, store_y;
    reg [LABEL_SIZE-1:0] store_label;
    reg [LABEL_SIZE-1:0] store_connected;
    reg store_new_label;
    reg store_change_label;
    reg store_connected_label;
    always @(posedge clock)
    begin
        if (reset_n) begin
            store_done <= done;
            store_write <= img_write;
            store_pixel <= img_pixel;
            store_x[15:0] <= x[15:0];
            store_y[15:0] <= y[15:0];
            store_label[LABEL_SIZE-1:0] <= label[LABEL_SIZE-1:0];
            store_connected[LABEL_SIZE-1:0] <= connected[LABEL_SIZE-1:0];
            store_new_label <= new_label;
            store_change_label <= change_label;
            store_connected_label <= connected_label;
        end
        else begin
            store_done <= 1'b0;
            store_write <= 1'b0;
            store_pixel <= 1'b0;
            store_x[15:0] <= 16'd0;
            store_y[15:0] <= 16'd0;
            store_label[LABEL_SIZE-1:0] <= 8'd0;
            store_connected[LABEL_SIZE-1:0] <= 8'd0;
            store_new_label <= 1'b0;
            store_change_label <= 1'b0;
            store_connected_label <= 1'b0;
        end
    end
    
    // Stage 2 (processing)
    reg process_done;
    reg process_write;
    reg process_pixel;
    reg [15:0] process_x, process_y;
    reg [LABEL_SIZE-1:0] process_label;
    reg [LABEL_SIZE-1:0] process_connected;
    reg process_new_label;
    reg process_change_label;
    reg process_connected_label;
    always @(posedge clock)
    begin
        if (reset_n) begin
            process_done <= store_done;
            process_write <= store_write;
            process_pixel <= store_pixel;
            process_x[15:0] <= store_x[15:0];
            process_y[15:0] <= store_y[15:0];
            process_label[LABEL_SIZE-1:0] <= store_label[LABEL_SIZE-1:0];
            process_connected[LABEL_SIZE-1:0] <= store_connected[LABEL_SIZE-1:0];
            process_new_label <= store_new_label;
            process_change_label <= store_change_label;
            process_connected_label <= store_connected_label;
        end
        else begin
            process_done <= 1'b0;  
            process_write <= 1'b0; 
            process_pixel <= 1'b0;
            process_x[15:0] <= 16'd0;
            process_y[15:0] <= 16'd0;
            process_label[LABEL_SIZE-1:0] <= 8'd0;
            process_connected[LABEL_SIZE-1:0] <= 8'd0;
            process_new_label <= 1'b0;
            process_change_label <= 1'b0;
            process_connected_label <= 1'b0;
        end
    end
    
//------------------------------------------------------------------------------
    
    // Memory banks control
    reg [15:0] size;
    reg [15:0] size_max1;
    reg [LABEL_SIZE-1:0] label_max1;
    reg [15:0] size_max2;
    reg [LABEL_SIZE-1:0] label_max2;
    reg [15:0] size_max3;
    reg [LABEL_SIZE-1:0] label_max3;
    
    // Process maximum values
    always @(posedge clock)
    begin
        if (reset_n) begin
         if (!done) begin
          if (img_write) begin
            if (new_label || (done && !store_done)) begin // rising edge of done
                if (size_max1 < size) begin
                    size_max1[15:0] <= size[15:0];
                    label_max1[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                    size_max2[15:0] <= size_max1[15:0];
                    label_max2[LABEL_SIZE-1:0] <= label_max1[LABEL_SIZE-1:0];
                    size_max3[15:0] <= size_max2[15:0];
                    label_max3[LABEL_SIZE-1:0] <= label_max2[LABEL_SIZE-1:0];
                end
                else if (size_max2 < size) begin
                    size_max2[15:0] <= size[15:0];
                    label_max2[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                    size_max3[15:0] <= size_max2[15:0];
                    label_max3[LABEL_SIZE-1:0] <= label_max2[LABEL_SIZE-1:0];
                end
                else if (size_max3 < size) begin
                    size_max3[15:0] <= size[15:0];
                    label_max3[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                end
                $display("size_max1: %d, size_max2: %d, size_max3: %d", size_max1, size_max2, size_max3);
                $display("label_max1: %d, label_max2: %d, label_max3: %d", label_max1, label_max2, label_max3);
            end
          end
         end
        end
        else begin
            size_max1[15:0] <= 16'd0;
            label_max1[LABEL_SIZE-1:0] <= 8'd0;
            size_max2[15:0] <= 16'd0;
            label_max2[LABEL_SIZE-1:0] <= 8'd0;
        end
    end
    
    reg [3:0] state;
    reg connected_done;
    always @(posedge clock)
    begin
        if (reset_n) begin
            if (!done) begin
                if (img_write) begin
                    if (img_pixel) begin
                        if (new_label) begin
                            write_ram <= 1'b1;
                            write_ram_addr[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                            write_size[15:0] <= size[15:0];
                            $display("new_label: %d", prev_label);
                        end
                        else if (change_label) begin
                            write_ram <= 1'b1;
                            write_ram_addr[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                            write_size[15:0] <= size[15:0];
                            read_ram <= 1'b1;
                            read_ram_addr[LABEL_SIZE-1:0] <= label[LABEL_SIZE-1:0];
                            $display("change_label: %d", prev_label);
                        end
                        else if (connected_label) begin
                            write_ram <= 1'b1;
                            write_ram_addr[LABEL_SIZE-1:0] <= connected[LABEL_SIZE-1:0];
                            write_size[15:0] <= 16'd0;
                            read_ram <= 1'b1;
                            read_ram_addr[LABEL_SIZE-1:0] <= connected[LABEL_SIZE-1:0];
                            $display("connected_label: %d", connected);
                        end
                        else begin
                           write_ram <= 1'b0;
                           write_ram_addr[LABEL_SIZE-1:0] <= 8'b0;
                           write_size[15:0] <= 16'd0;
                           read_ram <= 1'b0;
                           read_ram_addr[LABEL_SIZE-1:0] <= 8'd0;
                        end
                    end
                end
            end
            else begin
                // Postprocessing save control unit (FSM)
                // In the postprocessing stage is actualized the output registers.
                case (state)
                    0: begin
                        write_ram <= 1'b1;
                        write_ram_addr[LABEL_SIZE-1:0] <= prev_label[LABEL_SIZE-1:0];
                        write_size[15:0] <= size[15:0];
                        state <= 1;
                    end
                    1: begin
                        $display("postprocessing");
                        $display("label_max1: %d, label_max2: %d", label_max1, label_max2);
                        write_ram <= 1'b0;
                        state <= 2;
                    end
                    2: begin
                        read_ram <= 1'b1;
                        read_ram_addr[LABEL_SIZE-1:0] <= label_max1[LABEL_SIZE-1:0];
                        state <= 3;
                    end
                    3: begin
                        read_ram <= 1'b0;
                        state <= 4;                    
                    end
                    4: begin
                        // Save output data 1
                        out1_size[15:0] <= read_size[15:0];
                        out1_left1[31:0] <= {read_left1_y[15:0], read_left1_x[15:0]};
                        out1_left2[31:0] <= {read_left2_y[15:0], read_left2_x[15:0]};
                        out1_top1[31:0] <= {read_top1_y[15:0], read_top1_x[15:0]};
                        out1_top2[31:0] <= {read_top2_y[15:0], read_top2_x[15:0]};
                        out1_right1[31:0] <= {read_right1_y[15:0], read_right1_x[15:0]};
                        out1_right2[31:0] <= {read_right2_y[15:0], read_right2_x[15:0]};
                        out1_bottom1[31:0] <= {read_bottom1_y[15:0], read_bottom1_x[15:0]};
                        out1_bottom2[31:0] <= {read_bottom2_y[15:0], read_bottom2_x[15:0]};
                        state <= 5;
                    end
                    5: begin
                        read_ram <= 1'b1;
                        read_ram_addr[LABEL_SIZE-1:0] <= label_max2[LABEL_SIZE-1:0];
                        state <= 6;
                    end
                    6: begin
                        read_ram <= 1'b0;
                        state <= 7;
                    end
                    7: begin
                        // Save output data 2
                        out2_size[15:0] <= read_size[15:0];
                        out2_left1[31:0] <= {read_left1_y[15:0], read_left1_x[15:0]};
                        out2_left2[31:0] <= {read_left2_y[15:0], read_left2_x[15:0]};
                        out2_top1[31:0] <= {read_top1_y[15:0], read_top1_x[15:0]};
                        out2_top2[31:0] <= {read_top2_y[15:0], read_top2_x[15:0]};
                        out2_right1[31:0] <= {read_right1_y[15:0], read_right1_x[15:0]};
                        out2_right2[31:0] <= {read_right2_y[15:0], read_right2_x[15:0]};
                        out2_bottom1[31:0] <= {read_bottom1_y[15:0], read_bottom1_x[15:0]}; 
                        out2_bottom2[31:0] <= {read_bottom2_y[15:0], read_bottom2_x[15:0]};
                        state <= 8;
                    end
                    8: begin
                        read_ram <= 1'b1;
                        read_ram_addr[LABEL_SIZE-1:0] <= label_max3[LABEL_SIZE-1:0];
                        state <= 9;                        
                    end
                    9: begin
                        read_ram <= 1'b0;
                        state <= 10;
                    end
                    10: begin
                        // Save output data 3
                        out3_size[15:0] <= read_size[15:0];
                        out3_left1[31:0] <= {read_left1_y[15:0], read_left1_x[15:0]};
                        out3_left2[31:0] <= {read_left2_y[15:0], read_left2_x[15:0]};
                        out3_top1[31:0] <= {read_top1_y[15:0], read_top1_x[15:0]};
                        out3_top2[31:0] <= {read_top2_y[15:0], read_top2_x[15:0]};
                        out3_right1[31:0] <= {read_right1_y[15:0], read_right1_x[15:0]};
                        out3_right2[31:0] <= {read_right2_y[15:0], read_right2_x[15:0]};
                        out3_bottom1[31:0] <= {read_bottom1_y[15:0], read_bottom1_x[15:0]}; 
                        out3_bottom2[31:0] <= {read_bottom2_y[15:0], read_bottom2_x[15:0]};
                        state <= 11;
                    end
                    11: begin 
                        if (connected_done) begin
                            $display("out1_size: %d", out1_size);
                            $display("out1_left1: %d, %d", out1_left1[15:0], out1_left1[31:16]);
                            $display("out1_left2: %d, %d", out1_left2[15:0], out1_left2[31:16]);
                            $display("out1_top1: %d, %d", out1_top1[15:0], out1_top1[31:16]);
                            $display("out1_top2: %d, %d", out1_top2[15:0], out1_top2[31:16]);
                            $display("out1_right1: %d, %d", out1_right1[15:0], out1_right1[31:16]);
                            $display("out1_right2: %d, %d", out1_right2[15:0], out1_right2[31:16]);
                            $display("out1_bottom1: %d, %d", out1_bottom1[15:0], out1_bottom1[31:16]);
                            $display("out1_bottom2: %d, %d", out1_bottom2[15:0], out1_bottom2[31:16]);
                            $display("out2_size: %d", out2_size);
                            $display("out2_left1: %d, %d", out2_left1[15:0], out2_left1[31:16]);
                            $display("out2_left2: %d, %d", out2_left2[15:0], out2_left2[31:16]);
                            $display("out2_top1: %d, %d", out2_top1[15:0], out2_top1[31:16]);
                            $display("out2_top2: %d, %d", out2_top2[15:0], out2_top2[31:16]);
                            $display("out2_right1: %d, %d", out2_right1[15:0], out2_right1[31:16]);
                            $display("out2_right2: %d, %d", out2_right2[15:0], out2_right2[31:16]);
                            $display("out2_bottom1: %d, %d", out2_bottom1[15:0], out2_bottom1[31:16]);
                            $display("out2_bottom2: %d, %d", out2_bottom2[15:0], out2_bottom2[31:16]);
                        end
                        if ((x == (WIDTH - 1)) && (y == (HEIGHT - 1))) begin
                            connected_done <= 1'b1;
                        end
                    end
                endcase
            end
        end
        else begin
            write_ram <= 1'b0;
            write_ram_addr[LABEL_SIZE-1:0] <= 8'b0;
            write_size[15:0] <= 16'd0;
            read_ram <= 1'b1;
            read_ram_addr[LABEL_SIZE-1:0] <= 8'd0;
            //
            state <= 0;
            connected_done <= 1'b0;
        end
    end
    assign out_done = connected_done;
    
//------------------------------------------------------------------------------
    
    // Corners location   
    always @(posedge clock)
    begin
        if (reset_n) begin
            if (process_write) begin
                if (process_pixel) begin
                    //(process_x < (WIDTH - 3)) && (process_y < (HEIGHT - 3))) begin
                    //$display("label: %d, size: %d", process_label, size);
                    if (process_new_label) begin
                        // Values
                        size[15:0] <= 16'd1;
                        left1_x[15:0] <= WIDTH[15:0];
                        left1_y[15:0] <= HEIGHT[15:0];
                        top1_x[15:0] <= WIDTH[15:0];
                        top1_y[15:0] <= HEIGHT[15:0];
                        right1_x[15:0] <= 16'd0;
                        right1_y[15:0] <= 16'd0;
                        bottom1_x[15:0] <= 16'd0;
                        bottom1_y[15:0] <= 16'd0;
                        left2_x[15:0] <= WIDTH[15:0];
                        left2_y[15:0] <= HEIGHT[15:0];
                        top2_x[15:0] <= WIDTH[15:0];
                        top2_y[15:0] <= HEIGHT[15:0];
                        right2_x[15:0] <= 16'd0;
                        right2_y[15:0] <= 16'd0;
                        bottom2_x[15:0] <= 16'd0;
                        bottom2_y[15:0] <= 16'd0;
                    end
                    else if (process_change_label) begin
                       // Values
                       size[15:0] <= read_size[15:0];
                       left1_x[15:0] <= read_left1_x[15:0];
                       left1_y[15:0] <= read_left1_y[15:0];
                       top1_x[15:0] <= read_top1_x[15:0];
                       top1_y[15:0] <= read_top1_y[15:0];
                       right1_x[15:0] <= read_right1_x[15:0];
                       right1_y[15:0] <= read_right1_y[15:0];
                       bottom1_x[15:0] <= read_bottom1_x[15:0];
                       bottom1_y[15:0] <= read_bottom1_y[15:0];
                       left2_x[15:0] <= read_left2_x[15:0];
                       left2_y[15:0] <= read_left2_y[15:0];
                       top2_x[15:0] <= read_top2_x[15:0];
                       top2_y[15:0] <= read_top2_y[15:0];
                       right2_x[15:0] <= read_right2_x[15:0];
                       right2_y[15:0] <= read_right2_y[15:0];
                       bottom2_x[15:0] <= read_bottom2_x[15:0];
                       bottom2_y[15:0] <= read_bottom2_y[15:0];
                    end
                    else if (process_connected_label) begin
                        // Blobs connection
                        size[15:0] <= size[15:0] + 16'd1 + read_size[15:0];
                        if (left1_x > read_left1_x) begin
                            left1_x[15:0] <= read_left1_x[15:0];
                            left1_y[15:0] <= read_left1_y[15:0];
                        end
                        if (left2_x >= read_left2_x) begin
                            left2_x[15:0] <= read_left2_x[15:0];
                            left2_y[15:0] <= read_left2_y[15:0];
                        end
                        if (top1_y > read_top1_y) begin
                            top1_x[15:0] <= read_top1_x[15:0];
                            top1_y[15:0] <= read_top1_y[15:0];
                        end
                        if (top2_y >= read_top2_y) begin
                            top2_x[15:0] <= read_top2_x[15:0];
                            top2_y[15:0] <= read_top2_y[15:0];
                        end
                        if (right1_x < read_right1_x) begin
                            right1_x[15:0] <= read_right1_x[15:0];
                            right1_y[15:0] <= read_right1_y[15:0];
                        end
                        if (right2_x <= read_right2_x) begin
                            right2_x[15:0] <= read_right2_x[15:0];
                            right2_y[15:0] <= read_right2_y[15:0];
                        end
                        if (bottom1_y < read_bottom1_y) begin
                            bottom1_x[15:0] <= read_bottom1_x[15:0];
                            bottom1_y[15:0] <= read_bottom1_y[15:0];
                        end
                        if (bottom2_y <= read_bottom2_y) begin
                            bottom2_x[15:0] <= read_bottom2_x[15:0];
                            bottom2_y[15:0] <= read_bottom2_y[15:0];
                        end
                    end 
                    else begin 
                        size[15:0] <= size[15:0] + 16'd1;
                        // Corners location
                        if (left1_x > process_x) begin
                            left1_x[15:0] <= process_x[15:0];
                            left1_y[15:0] <= process_y[15:0];
                        end
                        if (left2_x >= process_x) begin
                            left2_x[15:0] <= process_x[15:0];
                            left2_y[15:0] <= process_y[15:0];
                        end
                        if (top1_y > process_y) begin
                            top1_x[15:0] <= process_x[15:0];
                            top1_y[15:0] <= process_y[15:0];
                        end
                        if (top2_y >= process_y) begin
                            top2_x[15:0] <= process_x[15:0];
                            top2_y[15:0] <= process_y[15:0];
                        end
                        if (right1_x < process_x) begin
                            right1_x[15:0] <= process_x[15:0];
                            right1_y[15:0] <= process_y[15:0];
                        end
                        if (right2_x <= process_x) begin
                            right2_x[15:0] <= process_x[15:0];
                            right2_y[15:0] <= process_y[15:0];
                        end
                        if (bottom1_y < process_y) begin
                            bottom1_x[15:0] <= process_x[15:0];
                            bottom1_y[15:0] <= process_y[15:0];
                        end
                        if (bottom2_y <= process_y) begin
                            bottom2_x[15:0] <= process_x[15:0];
                            bottom2_y[15:0] <= process_y[15:0];
                        end
                    end
                end
            end
        end
    end
    
//------------------------------------------------------------------------------
        
endmodule
//
// FIFO memory block for connected components
//
module fifo_conn #( 
        parameter N = 8,
        parameter MEMORY_SIZE = 4096,
        parameter ADDRESS_SIZE = 12
    ) (
        input clock,
        input reset_n,
        // Size
        input [15:0] width,
        // Data input
        input write, 
        input [N-1:0] pi11,
        // Data output
        output [N-1:0] po00, po01, po02,
        output [N-1:0] po10, 
        output valid
    );
    
    reg [15:0] SIZE;
    always @(posedge clock)
    begin
        if (!reset_n) begin
            SIZE[15:0] <= width[15:0] - 16'd3; 
        end
    end
    
    wire [N-1:0] net_i;    
    assign net_i[N-1:0] = pi11[N-1:0];
    
    wire [N-1:0] net_in;
    register1 #(N) reg_in (
        .clock(clock),
        .enable(write),
        .d(net_i[N-1:0]),
        .q(net_in[N-1:0])
    );
    assign po10[N-1:0] = net_in[N-1:0];
        
    wire [N-1:0] net_out;
    fifo_prg #(
        .MEMORY_WIDTH(N),
        .MEMORY_SIZE(MEMORY_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    ) ffbuf (
        .clk(clock),
        .reset_n(reset_n),
        .enable(write),
        .data_in(net_in[N-1:0]),
        .size(SIZE[15:0]),
        .data_out(net_out[N-1:0])
    );
    
    wire [N-1:0] net_o0;
    wire [N-1:0] net_o1;
    wire [N-1:0] net_o2;
    register3 #(N) regs_out (
        .clock(clock),
        .enable(write),
        .d(net_out[N-1:0]),
        .q0(net_o0[N-1:0]),
        .q1(net_o1[N-1:0]),
        .q2(net_o2[N-1:0])
    );
    
    assign po02[N-1:0] = net_o0[N-1:0];
    assign po01[N-1:0] = net_o1[N-1:0];
    assign po00[N-1:0] = net_o2[N-1:0];
        
    reg _valid;
    always @(posedge clock) 
    begin
        if (reset_n) begin
            _valid <= write;
        end
        else begin
            _valid <= 1'b0;
        end
    end
    assign valid = _valid;
   
endmodule
//
// RAM banks
//
module ram_banks #(
        parameter WORD_SIZE = 16,
        parameter ADDRESS_SIZE = 8
    ) (
        input clock,
        input enable,
        input [ADDRESS_SIZE-1:0] address_write,
        input write,
        input [WORD_SIZE-1:0] write_left_x,
        input [WORD_SIZE-1:0] write_left_y,
        input [WORD_SIZE-1:0] write_top_x,
        input [WORD_SIZE-1:0] write_top_y,
        input [WORD_SIZE-1:0] write_right_x,
        input [WORD_SIZE-1:0] write_right_y,
        input [WORD_SIZE-1:0] write_bottom_x,
        input [WORD_SIZE-1:0] write_bottom_y,
        input [ADDRESS_SIZE-1:0] address_read,
        input read,
        output [WORD_SIZE-1:0] read_left_x,
        output [WORD_SIZE-1:0] read_left_y,
        output [WORD_SIZE-1:0] read_top_x,
        output [WORD_SIZE-1:0] read_top_y,
        output [WORD_SIZE-1:0] read_right_x,
        output [WORD_SIZE-1:0] read_right_y,
        output [WORD_SIZE-1:0] read_bottom_x,
        output [WORD_SIZE-1:0] read_bottom_y
    );
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_lefts_x(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_left_x[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_left_x[WORD_SIZE-1:0])
    );
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_lefts_y(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_left_y[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_left_y[WORD_SIZE-1:0])
    );
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_tops_x(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_top_x[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_top_x[WORD_SIZE-1:0])
    );
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_tops_y(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_top_y[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_top_y[WORD_SIZE-1:0])
    );    
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_rights_x(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_right_x[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_right_x[WORD_SIZE-1:0])
    );    
    
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_rights_y(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_right_y[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_right_y[WORD_SIZE-1:0])
    );
      
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_bottoms_x(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_bottom_x[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_bottom_x[WORD_SIZE-1:0])
    ); 
      
    ram_bank #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE)
    )mem_bottoms_y(
        .clock(clock), 
        .enable(enable),
        .address_write(address_write[ADDRESS_SIZE-1:0]),
        .write(write),
        .data_in(write_bottom_y[WORD_SIZE-1:0]),
        .address_read(address_read[ADDRESS_SIZE-1:0]),
        .read(read),
        .data_out(read_bottom_y[WORD_SIZE-1:0])
    );
    
endmodule
//
// Simultaneous Read/Write memory
//
module ram_bank #(
        parameter WORD_SIZE = 16,
        parameter ADDRESS_SIZE = 7,
        parameter FILENAME = "memory.bin"
    ) ( 
        input clock,
        input enable,
        input [ADDRESS_SIZE-1:0] address_write,
        input write,
        input [WORD_SIZE-1:0] data_in,
        input [ADDRESS_SIZE-1:0] address_read,
        input read,
        output [WORD_SIZE-1:0] data_out
    );
    
    reg [WORD_SIZE-1:0] data [0:(1<<ADDRESS_SIZE)-1];
    //initial $readmemb (FILENAME, data);
    
    integer k;
    reg [WORD_SIZE-1:0] _data_out;
    always @(posedge clock) begin
        if (enable) begin
            if (write) begin
                data[address_write] <= data_in;
            end
            if (read) begin
                _data_out <= data[address_read];
            end
        end
    end
    assign data_out = _data_out;
    
endmodule
