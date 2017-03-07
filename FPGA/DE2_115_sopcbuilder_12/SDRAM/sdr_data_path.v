// 
// SDRAM data path
//
module sdr_data_path(
        input CLK, // System Clock
        input RESET_N, // System Reset
        input [15:0] DATAIN, // Data input from the host
        input [1:0] DM, // byte data masks
        output [15:0] DQOUT,
        output reg [1:0] DQM // SDRAM data mask ouputs
    );
    
    // Allign the input and output data to the SDRAM control path
    always @(posedge CLK or negedge RESET_N)
    begin
        if (!RESET_N) begin
            DQM[1:0] <= 2'b11;
        end
        else begin
            DQM[1:0] <= DM[1:0];
        end                 
    end
    
    assign DQOUT[15:0] = DATAIN[15:0];
    
endmodule
