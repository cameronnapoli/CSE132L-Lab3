module regPCPCF(
    input logic clk,
    input logic stallF,
    input logic [31:0] PC,
    output logic [31:0] PCF
    );
always @(posedge clk)
begin
if (~stallF)
    PCF <= PC;
end
endmodule

module regIFID(
    input logic clk,
    input logic flushD,
    input logic stallD,
    input logic [31:0] InstrF,
    output logic [31:0] InstrD
    );
always @(posedge clk)
begin
    if(flushD) begin
        InstrD <= 32'h0;
    end
    else if(~stallD) begin
        InstrD <= InstrF;
    end
end
endmodule


module regIDEX( // Simple just uses flush
    input logic clk,
    input logic flushE,
    input logic [31:0] InstrD,
    output logic [31:0] InstrE,
    input logic [31:0] RD1D,
    output logic [31:0] RD1E,
    input logic [31:0] RD2D,
    output logic [31:0] RD2E,
    input logic [31:0] RD3D,
    output logic [31:0] RD3E,
    input logic [31:0] ExtendD,
    output logic [31:0] ExtendE,

    input logic PCSrcD,
    output logic PCSrcE,
    input logic RegWriteD,
    output logic RegWriteE,
    input logic MemtoRegD,
    output logic MemtoRegE,
    input logic MemWriteD,
    output logic MemWriteE,
    input logic [3:0] ALUControlD,
    output logic [3:0] ALUControlE,
    input logic BranchD,
    output logic BranchE,
    input logic ALUSrcD,
    output logic ALUSrcE,
    input logic FlagWriteD,
    output logic FlagWriteE,
    input logic [3:0] Flags,
    output logic [3:0] FlagsE,
    input logic CondD,
    output logic CondE,
    input logic BLD,
    output logic BLE);

//Implement Flush functionality
always @(posedge clk)
begin
    if(flushE) begin
        InstrE <= 32'h0;
        RD1E <= 32'h0;
        RD2E <= 32'h0;
        RD3E <= 32'h0;
        ExtendE <= 32'h0;

        PCSrcE <= 1'b0;
        RegWriteE <= 1'b0;
        MemtoRegE <= 1'b0;
        MemWriteE <= 1'b0;
        ALUControlE <= 1'b0;
        BranchE <= 1'b0;
        ALUSrcE <= 1'b0;
        FlagWriteE <= 1'b0;
        FlagsE <= 4'b0000;
        CondE <= 1'b0;
        BLE <= 1'b0;
    end
    else begin
        InstrD <= InstrE;
        RD1E <= RD1D;
        RD2E <= RD2D;
        RD3E <= RD3D;
        ExtendE <= ExtendD;

        PCSrcE <= PCSrcD;
        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoRegD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        BranchE <= BranchD;
        ALUSrcE <= ALUSrcD;
        FlagWriteE <= FlagWriteD;
        FlagsE <= Flags;
        CondE <= CondD;
        BLE <= BLD;
    end
end
endmodule


module regEXMEM(
    input logic clk,
    input logic BLE,
    output logic BLM,
    input logic PCSrcE,
    output logic PCSrcM,
    input logic RegWriteE,
    output logic RegWriteM,
    input logic MemtoRegE,
    output logic MemtoRegM,
    input logic MemWriteE,
    output logic MemWriteM,

    input logic [31:0] ALUResultE,
    output logic [31:0] ALUResultM,
    input logic [31:0] WriteDataE,
    output logic [31:0] WriteDataM,
    input logic [31:0] WA3E,
    output logic [31:0] WA3M );

always @(posedge clk)
begin
    BLM <= BLE;
    PCSrcM <= PCSrcE;
    RegWriteM <= RegWriteE;
    MemtoRegM <= MemtoRegE;
    MemWriteM <= MemWriteE;
    ALUResultM <= ALUResultE;
    WriteDataM <= WriteDataE;
    WA3M <= WA3E;
end

endmodule


module regMEMWB(
    input logic clk,
 
    input logic BLM,
    output logic BLW,
    input logic PCSrcM,
    output logic PCSrcW,
    input logic RegWriteM,
    output logic RegWriteW,
    input logic MemtoRegM,
    output logic MemtoRegW,
    
    input logic [31:0] ReadDataM,
    output logic [31:0] ReadDataW,
    input logic [31:0] ALUOutM,
    output logic [31:0] ALUOutW,
    input logic [31:0]  WA3M,
    output logic [31:0] WA3W);

always @(posedge clk)
begin 
    BLW = BLM;
    PCSrcW = PCSrcM;
    RegWriteW = RegWriteM;
    MemtoRegW = MemtoRegM;
    ReadDataW = ReadDataM;
    ALUOutW = ALUOutM;
    WA3W = WA3M;
end


endmodule
