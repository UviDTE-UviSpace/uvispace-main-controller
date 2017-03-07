//
// Avalon MM Slave for parallel input/output sensor registers 
//
module apio_sensor (
        // Avalon clock interface signals
        input csi_clk,
        input csi_reset_n,
        // Signals for Avalon-MM slave port
        input [7:0] avs_s1_address,
        input avs_s1_chipselect,
        input avs_s1_read,
        output reg [31:0] avs_s1_readdata,
        input avs_s1_write,
        input [31:0] avs_s1_writedata,
        // Output signals for export registers to top module
        output [31:0] avs_export_red_threshold_min,
        output [31:0] avs_export_red_threshold_max,
        output [31:0] avs_export_green_threshold_min,
        output [31:0] avs_export_green_threshold_max,
        output [31:0] avs_export_blue_threshold_min,
        output [31:0] avs_export_blue_threshold_max
    );
    
    // Registers address
    `define ADDR_RED_THRESHOLD_MIN 8'h00
    `define ADDR_RED_THRESHOLD_MAX 8'h04
    `define ADDR_GREEN_THRESHOLD_MIN 8'h08
    `define ADDR_GREEN_THRESHOLD_MAX 8'h0c
    `define ADDR_BLUE_THRESHOLD_MIN 8'h10
    `define ADDR_BLUE_THRESHOLD_MAX 8'h14
    
    // Registers default values
    parameter RED_THRESHOLD_MIN = 32'd424673280;
    parameter RED_THRESHOLD_MAX = 32'd1073026373;
    parameter GREEN_THRESHOLD_MIN = 32'd281600;
    parameter GREEN_THRESHOLD_MAX = 32'd599785019;
    parameter BLUE_THRESHOLD_MIN = 32'd212;
    parameter BLUE_THRESHOLD_MAX = 32'd577281023;
        
    // Registers    
    reg [31:0] data_red_threshold_min;
    reg [31:0] data_red_threshold_max;
    reg [31:0] data_green_threshold_min;
    reg [31:0] data_green_threshold_max;
    reg [31:0] data_blue_threshold_min;
    reg [31:0] data_blue_threshold_max;
    
    // Read/Write registers
    always @(posedge csi_clk or negedge csi_reset_n) 
    begin
        if (!csi_reset_n) begin
            avs_s1_readdata <= 0;
            data_red_threshold_min[31:0] <= RED_THRESHOLD_MIN[31:0];
            data_red_threshold_max[31:0] <= RED_THRESHOLD_MAX[31:0];
            data_green_threshold_min[31:0] <= GREEN_THRESHOLD_MIN[31:0];
            data_green_threshold_max[31:0] <= GREEN_THRESHOLD_MAX[31:0];
            data_blue_threshold_min[31:0] <= BLUE_THRESHOLD_MIN[31:0];
            data_blue_threshold_max[31:0] <= BLUE_THRESHOLD_MAX[31:0];
        end
        else if (avs_s1_chipselect) begin
            if (avs_s1_read) begin
                case (avs_s1_address)
                    `ADDR_RED_THRESHOLD_MIN: 
                        avs_s1_readdata[31:0] <= data_red_threshold_min[31:0];
                    `ADDR_RED_THRESHOLD_MAX: 
                        avs_s1_readdata[31:0] <= data_red_threshold_max[31:0];
                    `ADDR_GREEN_THRESHOLD_MIN:
                        avs_s1_readdata[31:0] <= data_green_threshold_min[31:0];
                    `ADDR_GREEN_THRESHOLD_MAX:
                        avs_s1_readdata[31:0] <= data_green_threshold_max[31:0];
                    `ADDR_BLUE_THRESHOLD_MIN:
                        avs_s1_readdata[31:0] <= data_blue_threshold_min[31:0];
                    `ADDR_BLUE_THRESHOLD_MAX:
                        avs_s1_readdata[31:0] <= data_blue_threshold_max[31:0];
                    default:
                        avs_s1_readdata <= avs_s1_readdata;  
                endcase
            end
            if (avs_s1_write) begin
                case (avs_s1_address)
                    `ADDR_RED_THRESHOLD_MIN:
                        data_red_threshold_min[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_RED_THRESHOLD_MAX:
                        data_red_threshold_max[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_GREEN_THRESHOLD_MIN:
                        data_green_threshold_min[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_GREEN_THRESHOLD_MAX:
                        data_green_threshold_max[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_BLUE_THRESHOLD_MIN:
                        data_blue_threshold_min[31:0] <= avs_s1_writedata[31:0];
                    `ADDR_BLUE_THRESHOLD_MAX:
                        data_blue_threshold_max[31:0] <= avs_s1_writedata[31:0];
                endcase
            end
        end
    end
    
    assign avs_export_red_threshold_min[31:0] = data_red_threshold_min[31:0];
    assign avs_export_red_threshold_max[31:0] = data_red_threshold_max[31:0];
    assign avs_export_green_threshold_min[31:0] = data_green_threshold_min[31:0];
    assign avs_export_green_threshold_max[31:0] = data_green_threshold_max[31:0];
    assign avs_export_blue_threshold_min[31:0] = data_blue_threshold_min[31:0];
    assign avs_export_blue_threshold_max[31:0] = data_blue_threshold_max[31:0];
    
endmodule
