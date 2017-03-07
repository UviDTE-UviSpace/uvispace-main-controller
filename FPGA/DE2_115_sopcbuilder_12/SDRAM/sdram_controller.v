///
/// SDRAM controller
/// ================
///
/// This module stores temporal image data in memory SDRAM, throught "Multi-Port
/// SDRAM Controller", that go over memory position to position, storing image
/// data in two memory banks, defines throught to the corresponding parameters.
///
/// The data are store in two banks of memory, so DATA1 with 16-bit bus width 
/// consists on 5-bit for green color and 10-bit for blue color, and DATA2 
/// with 16-bit bus width consists on 5-bit for green color and 10-bit for red 
/// color.
///
/// iReadClock is connected to clock signal fo the module that reads frames 
/// from SDRAM. Each time a pixel needs to be read from SDRAM, iRead is set 
/// high to request pixel reading, and when request is carried out.
/// 
/// ..Note::Load is set high the pixel´s memory position is cleared.
///   
module sdram_controller (
        // Clock Input
        input clock_50,
        input sdram_clock,
        input dram_clock,
        input reset_n,
        // Image size input
        input [15:0] width,
        input [15:0] height,
        // Image data input
        input iWrite,
        input iWriteClock,
        input [7:0] iRed,
        input [7:0] iGreen,
        input [7:0] iBlue,
        input [7:0] iGray,
        // Image data output
        input iRead,
        input iReadClock,
        output [7:0] oRed,
        output [7:0] oGreen,
        output [7:0] oBlue,
        output [7:0] oGray,
        // SDRAM Interface
        inout [15:0] DRAM_DQ, // SDRAM Data bus 16 Bits
        output [11:0] DRAM_ADDR, // SDRAM Address bus 12 Bits
        output DRAM_LDQM, // SDRAM Low-byte Data Mask 
        output DRAM_UDQM, // SDRAM High-byte Data Mask
        output DRAM_WE_N, // SDRAM iWrite Enable
        output DRAM_CAS_N, // SDRAM Column Address Strobe
        output DRAM_RAS_N, // SDRAM Row Address Strobe
        output DRAM_CS_N, // SDRAM Chip Select
        output DRAM_BA_0, // SDRAM Bank Address 0
        output DRAM_BA_1, // SDRAM Bank Address 0
        output DRAM_CLK, // SDRAM Clock
        output DRAM_CKE // SDRAM Clock Enable
    );
    
//------------------------------------------------------------------------------  
    
    reg [22:0] size;
    always @(posedge clock_50)
    begin
        if (reset_n) begin
            size[22:0] <= {7'b0, width[15:0]} * {7'b0, height[15:0]};
        end
    end
    
//------------------------------------------------------------------------------  
    
    // Image size input
    reg [22:0] addr1; // Base address bank 1
    reg [22:0] addr2; // Base address bank 2
    reg [22:0] max_addr1; // Max address bank 1
    reg [22:0] max_addr2; // Max address bank 2
    
    always @(posedge sdram_clock or negedge reset_n)
    begin
        if (!reset_n) begin
            addr1[22:0] = 23'd0;//0;
            addr2[22:0] = size[22:0];//width * height;
            max_addr1[22:0] = size[22:0];//width * height;
            max_addr2[22:0] = {size[21:0], 1'b0};//2 * width * height;
        end
        else begin
            addr1[22:0] = addr1[22:0];
            addr2[22:0] = addr2[22:0];
            max_addr1[22:0] = max_addr1[22:0];
            max_addr2[22:0] = max_addr2[22:0];
        end
    end
   
    assign DRAM_CLK = dram_clock;
    
    sdram_control sdram_ctrl(
        .REF_CLK(clock_50),
        .RESET_N(1'b1),
        // SDRAM control clock
        .CLK(sdram_clock),
        // Load configuration
        .LOAD(!reset_n),
        // Input address
        .ADDR1(addr1),
        .ADDR2(addr2),
        .MAX_ADDR1(max_addr1),
        .MAX_ADDR2(max_addr2),
        // FIFO iWrite
        .write(iWrite),
        .write_clk(iWriteClock),
        .WR1_DATA({iGreen[7:0], iBlue[7:0]}), // Bank 1
        .WR2_DATA({iGray[7:0], iRed[7:0]}), // Bank 2
        // FIFO read
        .read(iRead),
        .read_clk(iReadClock),
        .RD1_DATA({oGreen[7:0], oBlue[7:0]}), // Bank 1
        .RD2_DATA({oGray[7:0], oRed[7:0]}), // Bank 2
        // SDRAM Side
        .SA(DRAM_ADDR),
        .BA({DRAM_BA_1, DRAM_BA_0}),
        .CS_N(DRAM_CS_N),
        .CKE(DRAM_CKE),
        .RAS_N(DRAM_RAS_N),
        .CAS_N(DRAM_CAS_N),
        .WE_N(DRAM_WE_N),
        .DQ(DRAM_DQ),
        .DQM({DRAM_UDQM, DRAM_LDQM})
    );
    
//------------------------------------------------------------------------------  
   
endmodule
