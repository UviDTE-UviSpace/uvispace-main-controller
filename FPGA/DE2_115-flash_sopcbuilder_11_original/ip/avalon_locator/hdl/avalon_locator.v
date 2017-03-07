//
// Avalon MM Slave for parallel input/output sensor registers 
//
module avalon_locator (
        // Avalon clock interface signals
        input csi_clk,
        input csi_reset_n,
        // Signals for Avalon-MM slave port
        input [5:0] avs_s1_address,
        input avs_s1_chipselect,
        input avs_s1_read,
        output reg [31:0] avs_s1_readdata,
        input avs_s1_write,
        input [31:0] avs_s1_writedata,
        // Input signals for export registers to top module
        input [11:0] avs_export_width,
        input [11:0] avs_export_height,
        input avs_export_clock,
        input avs_export_write,
        input avs_export_pixel,
        input [11:0] avs_export_x,
        input [11:0] avs_export_y,
        input avs_export_done
    );
    
    // Registers address
    `define ADDR_CTRL 6'h00
    // Search window
    `define ADDR_WRT 6'h03
    `define ADDR_X 6'h4
    `define ADDR_Y 6'h06
    `define ADDR_WIDTH 6'h08
    `define ADDR_HEIGHT 6'h0a
    // Corners location
    `define ADDR_LOCATION_P1_X 6'h0c
    `define ADDR_LOCATION_P1_Y 6'h0e
    `define ADDR_LOCATION_P2_X 6'h10
    `define ADDR_LOCATION_P2_Y 6'h12
    `define ADDR_LOCATION_P3_X 6'h14
    `define ADDR_LOCATION_P3_Y 6'h16
    `define ADDR_LOCATION_P4_X 6'h18
    `define ADDR_LOCATION_P4_Y 6'h1a
    `define ADDR_LOCATION_P5_X 6'h1c
    `define ADDR_LOCATION_P5_Y 6'h1e
    `define ADDR_LOCATION_P6_X 6'h20
    `define ADDR_LOCATION_P6_Y 6'h22
    `define ADDR_LOCATION_P7_X 6'h24
    `define ADDR_LOCATION_P7_Y 6'h26
    `define ADDR_LOCATION_P8_X 6'h28
    `define ADDR_LOCATION_P8_Y 6'h2a
    
    // Registers default values
    parameter X = 12'd0;
    parameter Y = 12'd0;
    parameter WIDTH = 12'd2592;
    parameter HEIGHT = 12'd1944;
    
    reg [31:0] data_ctrl;    
    
    // Region of interest registers
    reg data_write;
    reg [11:0] data_x;
    reg [11:0] data_y;
    reg [11:0] data_width;
    reg [11:0] data_height;
    wire [11:0] data_out_x;
    wire [11:0] data_out_y;
    wire [11:0] data_out_width;
    wire [11:0] data_out_height;
    
    // Read/Write registers
    always @(posedge csi_clk or negedge csi_reset_n) 
    begin
        if (!csi_reset_n) begin
            avs_s1_readdata <= 0;
            data_x[11:0] <= X[11:0];
            data_y[11:0] <= Y[11:0];
            data_width[11:0] <= WIDTH[11:0];
            data_height[11:0] <= HEIGHT[11:0];
        end
        else if (avs_s1_chipselect) begin
            if (avs_s1_read) begin
                case (avs_s1_address)
                    // Control register
                    `ADDR_CTRL:
                        avs_s1_readdata[31:0] <= data_ctrl[31:0];
                    // Configuration registers
                    `ADDR_X: 
                        avs_s1_readdata[31:0] <= {20'd0, data_out_x[11:0]};
                    `ADDR_Y: 
                        avs_s1_readdata[31:0] <= {20'd0, data_out_y[11:0]};
                    `ADDR_WIDTH:
                        avs_s1_readdata[31:0] <= {20'd0, data_out_width[11:0]};
                    `ADDR_HEIGHT:
                        avs_s1_readdata[31:0] <= {20'd0, data_out_height[11:0]};
                    // Result registers
                    `ADDR_LOCATION_P1_X:
                        avs_s1_readdata[31:0] <= {20'b0, left2_x[11:0]};
                    `ADDR_LOCATION_P1_Y:
                        avs_s1_readdata[31:0] <= {20'b0, left2_y[11:0]};
                    `ADDR_LOCATION_P2_X:
                        avs_s1_readdata[31:0] <= {20'b0, left1_x[11:0]};
                    `ADDR_LOCATION_P2_Y:
                        avs_s1_readdata[31:0] <= {20'b0, left1_y[11:0]};
                    `ADDR_LOCATION_P3_X:
                        avs_s1_readdata[31:0] <= {20'b0, top1_x[11:0]};
                    `ADDR_LOCATION_P3_Y:
                        avs_s1_readdata[31:0] <= {20'b0, top1_y[11:0]};
                    `ADDR_LOCATION_P4_X:
                        avs_s1_readdata[31:0] <= {20'b0, top2_x[11:0]};
                    `ADDR_LOCATION_P4_Y:
                        avs_s1_readdata[31:0] <= {20'b0, top2_y[11:0]};
                    `ADDR_LOCATION_P5_X:
                        avs_s1_readdata[31:0] <= {20'b0, right1_x[11:0]};
                    `ADDR_LOCATION_P5_Y:
                        avs_s1_readdata[31:0] <= {20'b0, right1_y[11:0]};
                    `ADDR_LOCATION_P6_X:
                        avs_s1_readdata[31:0] <= {20'b0, right2_x[11:0]};
                    `ADDR_LOCATION_P6_Y:
                        avs_s1_readdata[31:0] <= {20'b0, right2_y[11:0]};
                    `ADDR_LOCATION_P7_X:
                        avs_s1_readdata[31:0] <= {20'b0, bottom2_x[11:0]};
                    `ADDR_LOCATION_P7_Y:
                        avs_s1_readdata[31:0] <= {20'b0, bottom2_y[11:0]};
                    `ADDR_LOCATION_P8_X:
                        avs_s1_readdata[31:0] <= {20'b0, bottom1_x[11:0]};
                    `ADDR_LOCATION_P8_Y:
                        avs_s1_readdata[31:0] <= {20'b0, bottom1_y[11:0]};
                    default:
                        avs_s1_readdata <= avs_s1_readdata;  
                endcase
            end
            if (avs_s1_write) begin
                case (avs_s1_address)
                    `ADDR_CTRL:
                        data_ctrl[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_WRT:
                        data_write <= avs_s1_writedata[0];
                    `ADDR_X:
                        data_x[11:0] <= avs_s1_writedata[11:0];
                    `ADDR_Y:
                        data_y[11:0] <= avs_s1_writedata[11:0];
                    `ADDR_WIDTH:
                        data_width[11:0] <= avs_s1_writedata[11:0];
                    `ADDR_HEIGHT:
                        data_height[11:0] <= avs_s1_writedata[11:0];
                endcase
            end
        end
    end
    
    wire enable;
    assign enable = data_ctrl[0];
    
    wire [11:0] left1_x, left1_y;
    wire [11:0] left2_x, left2_y;
    wire [11:0] top1_x, top1_y;
    wire [11:0] top2_x, top2_y;
    wire [11:0] right1_x, right1_y;
    wire [11:0] right2_x, right2_y;
    wire [11:0] bottom1_x, bottom1_y;
    wire [11:0] bottom2_x, bottom2_y;
    locator loc (
        .clock(avs_export_clock),
        .reset_n(csi_reset_n),
        // Enable tracking
        .enable(enable),
        // Size of image
        .width(avs_export_width[11:0]),
        .height(avs_export_height[11:0]),
        // Search window
        .sw_write(data_write),
        .sw_x(data_x[11:0]),
        .sw_y(data_y[11:0]),
        .sw_width(data_width[11:0]),
        .sw_height(data_height[11:0]),
        // Out search window
        .out_x(data_out_x[11:0]),
        .out_y(data_out_y[11:0]),
        .out_width(data_out_width[11:0]),
        .out_height(data_out_height[11:0]),
        // Image data input
        .in_write(avs_export_write),
        .in_pixel(avs_export_pixel),
        .in_x(avs_export_x[11:0]),
        .in_y(avs_export_y[11:0]),
        .in_done(avs_export_done),
        // Data output
        .out_left1_x(left1_x[11:0]),
        .out_left1_y(left1_y[11:0]),
        .out_left2_x(left2_x[11:0]),
        .out_left2_y(left2_y[11:0]),
        .out_top1_x(top1_x[11:0]),
        .out_top1_y(top1_y[11:0]),
        .out_top2_x(top2_x[11:0]),
        .out_top2_y(top2_y[11:0]),
        .out_right1_x(right1_x[11:0]),
        .out_right1_y(right1_y[11:0]),
        .out_right2_x(right2_x[11:0]),
        .out_right2_y(right2_y[11:0]),
        .out_bottom1_x(bottom1_x[11:0]),
        .out_bottom1_y(bottom1_y[11:0]),
        .out_bottom2_x(bottom2_x[11:0]),
        .out_bottom2_y(bottom2_y[11:0])
    );
    
endmodule
