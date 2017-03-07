//
// SDRAM control 4 ports
//
module sdram_control #(
        parameter LENGTH = 128 // Length
    ) (
        // HOST Side
    	input REF_CLK, // System Clock
    	input RESET_N, // System Reset
    	input CLK,
        // Load configuration
        input LOAD, // Write register load & fifo clear
        // Input address
        input [22:0] ADDR1,
        input [22:0] ADDR2,
        input [22:0] MAX_ADDR1,
        input [22:0] MAX_ADDR2,
        // FIFO Write
        input write, // Write Request
        input write_clk, // Write fifo clock
        input [15:0] WR1_DATA, // Data input
        input [15:0] WR2_DATA, // Data input
    	// FIFO Write Side 1
    	output WR1_FULL, // Write fifo full
    	output [9:0] WR1_USE, // Write fifo usedw
    	// FIFO Write Side 2
    	output WR2_FULL, // Write fifo full
    	output [9:0] WR2_USE, // Write fifo usedw
    	// FIFO Read
    	input read, // Read Request
    	input read_clk, // Read fifo clock
    	output [15:0] RD1_DATA, // Data output
    	output [15:0] RD2_DATA, // Data output
    	// FIFO Read Side 1
    	output RD1_EMPTY, // Read fifo empty
    	output [9:0] RD1_USE, // Read fifo usedw
    	// FIFO Read Side 2
    	output RD2_EMPTY, // Read fifo empty
    	output [9:0] RD2_USE, // Read fifo usedw
    	// SDRAM Side
    	output [11:0] SA, // SDRAM address output
    	output [1:0] BA, // SDRAM bank address
    	output [1:0] CS_N, // SDRAM Chip Selects
    	output CKE, // SDRAM clock enable
    	output RAS_N, // SDRAM Row address Strobe
    	output CAS_N, // SDRAM Column address Strobe
    	output WE_N, // SDRAM write enable
    	inout [15:0] DQ, // SDRAM data bus
    	output [1:0] DQM //SDRAM data mask lines
    );
    
    `include "Sdram_Params.h"
    
//------------------------------------------------------------------------------
    
    // Configuration control
    
    wire WR1, WR2; // Write Request
    wire WR1_CLK, WR2_CLK; // Write fifo clock
    assign WR1 = write;
    assign WR2 = write;
    assign WR1_CLK = write_clk;
    assign WR2_CLK = write_clk; 
    
    wire RD1, RD2; // Read Request
    wire RD1_CLK, RD2_CLK; // Read fifo clock
    assign RD1 = read;
    assign RD2 = read;
    assign RD1_CLK = read_clk;
    assign RD2_CLK = read_clk;
    
    // Internal Controller Registers
    reg [`ASIZE-1:0] mADDR; //Internal address
    reg [8:0] mLENGTH; //Internal length
    
    // Registers max address
    reg [`ASIZE-1:0] rMAX_ADDR1;
    reg [`ASIZE-1:0] rMAX_ADDR2;
    
    // Register length
    reg [9:0] rLENGTH;
    
    reg [`ASIZE-1:0] rWR1_ADDR; //Register write address
    reg [`ASIZE-1:0] rWR2_ADDR; //Register write address
    
    reg [`ASIZE-1:0] rRD1_ADDR; //Register read address
    reg [`ASIZE-1:0] rRD2_ADDR; //Register read address
    
    // Internal Address & Length Control
    always @(posedge CLK or negedge RESET_N)
    begin
	   if (!RESET_N) begin
	       rWR1_ADDR <= ADDR1;
	       rWR2_ADDR <= ADDR2;
	       rRD1_ADDR <= ADDR1;
	       rRD2_ADDR <= ADDR2;
	       rMAX_ADDR1 <= MAX_ADDR1;
	       rMAX_ADDR2 <= MAX_ADDR2;
           rLENGTH <= LENGTH;
	   end
	   else begin
            // Load configuration (write register load & fifo clear)
            if (LOAD) begin
                rLENGTH <= LENGTH;
                // Write Side 
                rWR1_ADDR <= ADDR1;
                rWR2_ADDR <= ADDR2;
                // Read Side
                rRD1_ADDR <= ADDR1;
                rRD2_ADDR <= ADDR2;
                // Max address
                rMAX_ADDR1 <= MAX_ADDR1;
                rMAX_ADDR2 <= MAX_ADDR2;
            end
            else begin
                if (mWR_DONE & WR_MASK[0]) begin
                    if(rWR1_ADDR < rMAX_ADDR1 - rLENGTH)
                        rWR1_ADDR <= rWR1_ADDR + rLENGTH;
                    else
                        rWR1_ADDR <= ADDR1;
                end
                if (mWR_DONE & WR_MASK[1]) begin
                    if (rWR2_ADDR < rMAX_ADDR2 - rLENGTH)
                        rWR2_ADDR <= rWR2_ADDR + rLENGTH;
                    else
                        rWR2_ADDR <= ADDR2;
                end 
                if (mRD_DONE & RD_MASK[0]) begin
                    if(rRD1_ADDR < rMAX_ADDR1 - rLENGTH)
                        rRD1_ADDR <= rRD1_ADDR + rLENGTH;
                    else
                        rRD1_ADDR <= ADDR1;
                end
                if (mRD_DONE & RD_MASK[1]) begin
                    if(rRD2_ADDR < rMAX_ADDR2 - rLENGTH)
                        rRD2_ADDR <= rRD2_ADDR + rLENGTH;
                    else
                        rRD2_ADDR <= ADDR2;
                end
            end
        end
    end
    
//------------------------------------------------------------------------------            
                
    // DRAM Control
    
    reg [`DSIZE/8-1:0] _DQM; // SDRAM data mask lines
    reg [11:0] _SA; // SDRAM address output
    reg [1:0] _BA; // SDRAM bank address
    reg [1:0] _CS_N; // SDRAM Chip Selects
    reg _CKE; // SDRAM clock enable
    reg _RAS_N; // SDRAM Row address Strobe
    reg _CAS_N; // SDRAM Column address Strobe
    reg _WE_N; // SDRAM write enable
    
    reg [`DSIZE-1:0] mDATAOUT; // Controller Data output
    
    always @(posedge CLK)
    begin
    	_SA <= (ST == SC_CL + mLENGTH) ? 12'h200 : ISA;
    	_BA <= IBA;
    	_CS_N <= ICS_N;
    	_CKE <= ICKE;
    	_RAS_N <= (ST == SC_CL + mLENGTH) ? 1'b0 : IRAS_N;
    	_CAS_N <= (ST == SC_CL + mLENGTH) ? 1'b1 : ICAS_N;
    	_WE_N <= (ST == SC_CL + mLENGTH) ? 1'b0 : IWE_N;
    	PM_STOP <= (ST == SC_CL + mLENGTH) ? 1'b1 : 1'b0;
    	PM_DONE <= (ST == SC_CL + SC_RCD + mLENGTH + 2) ? 1'b1 : 1'b0;
    	_DQM <= (active && (ST >= SC_CL)) ? (((ST == SC_CL + mLENGTH) && Write) ? 2'b11 : 2'b00) : 2'b11;
    	mDATAOUT <= DQ;
    end
    
    assign DQM = _DQM;
    assign SA = _SA;
    assign BA = _BA;
    assign CS_N = _CS_N;
    assign CKE = _CKE;
    assign RAS_N = _RAS_N;
    assign CAS_N = _CAS_N;
    assign WE_N = _WE_N;
    
    wire [`DSIZE-1:0] mDATAIN; // Controller Data input
    
    sdr_data_path data_path1(
        .CLK(CLK),
        .RESET_N(RESET_N),
        .DATAIN(mDATAIN),
        .DM(2'b00),
        .DQOUT(DQOUT),
        .DQM(IDQM)
    );
                
//------------------------------------------------------------------------------
                
    // FIFO write
    
    reg IN_REQ; // Input data request to write side fifo
    
    wire [`DSIZE-1:0] mDATAIN1; // Controller Data input 1
    wire [9:0] write_side_fifo_rusedw1;
    Sdram_FIFO  write_fifo1(
				.data(WR1_DATA),
				.wrreq(WR1),
				.wrclk(WR1_CLK),
				.aclr(LOAD),
				.rdreq(IN_REQ & WR_MASK[0]),
				.rdclk(CLK),
				.q(mDATAIN1),
				.wrfull(WR1_FULL),
				.wrusedw(WR1_USE),
				.rdusedw(write_side_fifo_rusedw1)
				);
                
    wire [`DSIZE-1:0] mDATAIN2; // Controller Data input 2
    wire [9:0] write_side_fifo_rusedw2;
    Sdram_FIFO 	write_fifo2(
				.data(WR2_DATA),
				.wrreq(WR2),
				.wrclk(WR2_CLK),
				.aclr(LOAD),
				.rdreq(IN_REQ & WR_MASK[1]),
				.rdclk(CLK),
				.q(mDATAIN2),
				.wrfull(WR2_FULL),
				.wrusedw(WR2_USE),
				.rdusedw(write_side_fifo_rusedw2)
				);
				
    assign mDATAIN = (WR_MASK[0]) ? mDATAIN1 : mDATAIN2;    
    
//------------------------------------------------------------------------------
    
    // FIFO read
    
    reg OUT_VALID; // Output data request to read side fifo
    
    wire [8:0] read_side_fifo_wusedw1;
    Sdram_FIFO 	read_fifo1(
				.data(mDATAOUT),
				.wrreq(OUT_VALID & RD_MASK[0]),
				.wrclk(CLK),
				.aclr(LOAD),
				.rdreq(RD1),
				.rdclk(RD1_CLK),
				.q(RD1_DATA),
				.wrusedw(read_side_fifo_wusedw1),
				.rdempty(RD1_EMPTY),
				.rdusedw(RD1_USE)
				);
				
    wire [8:0] read_side_fifo_wusedw2;
    Sdram_FIFO 	read_fifo2(
				.data(mDATAOUT),
				.wrreq(OUT_VALID & RD_MASK[1]),
				.wrclk(CLK),
				.aclr(LOAD),
				.rdreq(RD2),
				.rdclk(RD2_CLK),
				.q(RD2_DATA),
				.wrusedw(read_side_fifo_wusedw2),
				.rdempty(RD2_EMPTY),
				.rdusedw(RD2_USE)
				);
                
//------------------------------------------------------------------------------

    // DRAM Internal Control
    wire [`ASIZE-1:0] saddr;
    wire load_mode;
    wire nop;
    wire reada;
    wire writea;
    wire refresh;
    wire precharge;
    wire oe;
    wire ref_ack;
    wire ref_req;
    wire init_req;
    wire cm_ack;
    wire active;
    wire CCD_CLK;

    control_interface control1 (
                .CLK(CLK),
                .RESET_N(RESET_N),
                .CMD(CMD),
                .ADDR(mADDR),
                .REF_ACK(ref_ack),
                .CM_ACK(cm_ack),
                .NOP(nop),
                .READA(reada),
                .WRITEA(writea),
                .REFRESH(refresh),
                .PRECHARGE(precharge),
                .LOAD_MODE(load_mode),
                .SADDR(saddr),
                .REF_REQ(ref_req),
				.INIT_REQ(init_req),
                .CMD_ACK(CMDACK)
                );

    command command1(
                .CLK(CLK),
                .RESET_N(RESET_N),
                .SADDR(saddr),
                .NOP(nop),
                .READA(reada),
                .WRITEA(writea),
                .REFRESH(refresh),
				.LOAD_MODE(load_mode),
                .PRECHARGE(precharge),
                .REF_REQ(ref_req),
				.INIT_REQ(init_req),
                .REF_ACK(ref_ack),
                .CM_ACK(cm_ack),
                .OE(oe),
				.PM_STOP(PM_STOP),
				.PM_DONE(PM_DONE),
                .SA(ISA),
                .BA(IBA),
                .CS_N(ICS_N),
                .CKE(ICKE),
                .RAS_N(IRAS_N),
                .CAS_N(ICAS_N),
                .WE_N(IWE_N)
                );

//------------------------------------------------------------------------------    
    
    wire [`DSIZE-1:0] DQOUT; // SDRAM data out link
    wire [`DSIZE/8-1:0] IDQM; //SDRAM data mask lines
    wire [11:0] ISA; // SDRAM address output
    wire [1:0] IBA; // SDRAM bank address
    wire [1:0] ICS_N; // SDRAM Chip Selects
    wire ICKE; // SDRAM clock enable
    wire IRAS_N; // SDRAM Row address Strobe
    wire ICAS_N; // SDRAM Column address Strobe
    wire IWE_N; // SDRAM write enable
    
    assign DQ = oe ? DQOUT : `DSIZE'hzzzz;
    assign active = Read | Write;
    
    // Internal Registers / Wires
    reg [1:0] WR_MASK; //Write port active mask
    reg [1:0] RD_MASK; //Read port active mask
    reg mWR_DONE; //Flag write done, 1 pulse SDR_CLK
    reg mRD_DONE; //Flag read done, 1 pulse SDR_CLK
    reg mWR, Pre_WR; //Internal WR edge capture
    reg mRD, Pre_RD; //Internal RD edge capture
    reg [9:0] ST; //Controller status
    reg [1:0] CMD; //Controller command
    reg PM_STOP; //Flag page mode stop
    reg PM_DONE; //Flag page mode done
    reg Read; //Flag read active
    reg Write; //Flag write active
       
    wire CMDACK; // Controller command
    
    always @(posedge CLK or negedge RESET_N)
    begin
        if (RESET_N==0) begin
            CMD			<=  0;
            ST			<=  0;
            Pre_RD		<=  0;
            Pre_WR		<=  0;
            Read		<=	0;
            Write		<=	0;
            OUT_VALID	<=	0;
            IN_REQ		<=	0;
            mWR_DONE	<=	0;
            mRD_DONE	<=	0;
        end
        else begin
            Pre_RD	<=	mRD;
            Pre_WR	<=	mWR;
            case(ST)
                0:	begin
                    if ({Pre_RD,mRD}==2'b01) begin
                        Read	<=	1;
                        Write	<=	0;
                        CMD		<=	2'b01;
                        ST		<=	1;
                    end
                    else if({Pre_WR,mWR}==2'b01) begin
                        Read	<=	0;
                        Write	<=	1;
                        CMD		<=	2'b10;
                        ST		<=	1;
                    end
                end
                1:	begin
				    if (CMDACK==1) begin
				        CMD<=2'b00;
				        ST<=2;
				    end
		        end
		        default:
		          begin
		              if (ST != SC_CL + SC_RCD + mLENGTH + 1)
		                  ST <= ST + 1;
		              else
		                  ST <= 0;
		          end
		      endcase
		      if (Read) begin
		          if (ST == SC_CL + SC_RCD + 1)
		          		OUT_VALID	<=	1;
		          else if (ST==SC_CL + SC_RCD + mLENGTH + 1) begin
		              OUT_VALID	<=	0;
		              Read		<=	0;
		              mRD_DONE	<=	1;
		          end
		      end
		      else
		          mRD_DONE	<=	0;
		      if (Write) begin
		          if(ST==SC_CL-1)
		              IN_REQ	<=	1;
		          else if (ST == SC_CL + mLENGTH - 1)
		              IN_REQ	<=	0;
		          else if (ST == SC_CL + SC_RCD + mLENGTH) begin
		              Write	<=	0;
		              mWR_DONE<=	1;
		          end
		  	  end
		      else
		          mWR_DONE<=	0;
        end
    end

    //  Auto Read / Write Control
    always @(posedge CLK or negedge RESET_N)
    begin
        if (!RESET_N) begin
            mWR <= 0;
            mRD <= 0;
            mADDR <= 0;
            mLENGTH <= 0;
        end
        else begin
            if ((mWR == 0) && (mRD == 0) && (ST == 0) &&
                (WR_MASK == 0) && (RD_MASK == 0) &&
                (LOAD == 0)) begin
                //  Write Side 1
                if ((write_side_fifo_rusedw1 >= rLENGTH) && (rLENGTH != 0)) begin
                    mADDR <= rWR1_ADDR;
                    mLENGTH <= rLENGTH;
                    WR_MASK <= 2'b01;
                    RD_MASK <= 2'b00;
                    mWR <= 1;
                    mRD <= 0;
                end
                // Write Side 2
                else if ((write_side_fifo_rusedw2 >= rLENGTH) && (rLENGTH != 0)) begin
                    mADDR <= rWR2_ADDR;
                    mLENGTH <= rLENGTH;
                    WR_MASK <= 2'b10;
                    RD_MASK <= 2'b00;
                    mWR <= 1;
                    mRD <= 0;
                end
                // Read Side 1
                else if ((read_side_fifo_wusedw1 < rLENGTH)) begin
                    mADDR <= rRD1_ADDR;
                    mLENGTH <= rLENGTH;
                    WR_MASK <= 2'b00;
                    RD_MASK <= 2'b01;
                    mWR <= 0;
                    mRD <= 1;
                end
                // Read Side 2
                else if ((read_side_fifo_wusedw2 < rLENGTH)) begin
                    mADDR <= rRD2_ADDR;
                    mLENGTH <= rLENGTH;
                    WR_MASK <= 2'b00;
                    RD_MASK <= 2'b10;
                    mWR <= 0;
                    mRD <= 1;
                end
            end
            if (mWR_DONE) begin
                WR_MASK <= 0;
                mWR <= 0;
            end
            if (mRD_DONE) begin
                RD_MASK <= 0;
                mRD <= 0;
            end
        end
    end
    
//------------------------------------------------------------------------------

endmodule
