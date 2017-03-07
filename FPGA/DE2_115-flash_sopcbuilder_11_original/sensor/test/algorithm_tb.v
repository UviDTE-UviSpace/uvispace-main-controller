`timescale 1 ns / 100 ps

module algorithm_tb;

    parameter N = 8;
    parameter WIDTH = 80;
    parameter HEIGHT = 60;
    
    // Data memory
    reg [N-1:0] data [0:(WIDTH*HEIGHT)-1];
    
    // Read file of input data memory
    initial begin
        $readmemb("memory.bin", data);
    end
    
    reg clock;
    reg reset_n;
    reg enable;
    wire done;
    
    wire read_en;

    wire read_done;
    
    wire [31:0] red_location_p1;
    wire [31:0] red_location_p2;
    wire [31:0] green_location_p1;
    wire [31:0] green_location_p2;
    wire [31:0] blue_location_p1;
    wire [31:0] blue_location_p2;
    
    reg write;
    reg write_clock;
    reg [1:0] write_data;
    
    wire read;
    wire read_clock;
    wire [1:0] read_data;
    
    algorithm a (
        .clock(clock),
        .reset_n(reset_n),
        // Image size
        .image_size(WIDTH * HEIGHT),
        .iFilas(HEIGHT),
        .iColumnas(WIDTH),
        // Initial address in memory
        .ini_Imagen(13'd0),
        .ini_Dilatacion(13'd0),
        // Start algorithm
        .start(enable),
        // End algoritm
        .out_red_location_p1(red_location_p1[31:0]),
        .out_red_location_p2(red_location_p2[31:0]),
        .out_green_location_p1(green_location_p1[31:0]),
        .out_green_location_p2(green_location_p2[31:0]),
        .out_blue_location_p1(blue_location_p1[31:0]),
        .out_blue_location_p2(blue_location_p2[31:0]),
        .oDone(done),
        // Data input
        .write(write),
        .write_clock(write_clock),
        .write_data(write_data[1:0]),
        // Data output
        .read(read),
        .read_clock(read_clock),
        .read_data(read_data[1:0])
    );
    
    initial clock = 1'b0;
    always #5 clock = ~clock;
    
    initial reset_n = 1'b0;
    initial #100 reset_n = 1'b1;
     
    initial enable = 1'b0;
    initial #150 enable = 1'b1;
    
    initial write = 1'b0;
    initial write_clock = 1'b0;
    
    integer i = 0;
    integer j = 0;
    always @(posedge clock)
    begin
        if (enable) begin
	        write = 1'b1;
	        write_clock = ~write_clock;
	        write_data[1:0] = data[i][1:0];
	        i = i + 1;
	        if (read) begin
	            if (read_data[1:0] == data[j][1:0]) begin
	                $display("%d: %d: %d [OK]", $time, read_data[1:0], data[j][1:0]);
	            end
	            else begin
	                $display("%d: %d: %d [ERROR]", $time, read_data[1:0], data[j][1:0]);
	            end
	            j = j + 1;
	        end
	        else begin
	            $display("%d: Left(%d,%d) Right(%d,%d) Top(%d,%d) Bottom(%d,%d)", $time,  
	                     red_location_p1[15:0], red_location_p1[31:16],
	                     red_location_p2[15:0], red_location_p2[31:16],
	                     green_location_p1[15:0], green_location_p1[31:16],
	                     green_location_p2[15:0], green_location_p2[31:16]);
	        end
	    end
    end
    
    //initial #10000 $finish;

endmodule
