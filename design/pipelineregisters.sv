module regPCPCF(
    input logic clk,
    input logic stallF,
    input logic [31:0] PC,
    output logic [31:0] PCF
    );
always @(posedge clk)
begin
    PC <= PCF;
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
    InstrD <= InstrF;
end
endmodule


module regIDEX(
    input logic clk,
    input logic flushE,
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
    input logic [1:0] ImmSrcD,
    output logic [1:0] ImmSrcE,
    input logic CondD,
    output logic CondE);

//Implement Flush functionality
always @(posedge clk)
begin
    RD1E <= RD1D;
    RD2E <= RD2D;
    ExtendE <= ExtendD;
    PCSrcE <= PCSrcD;
    RegWriteE <= RegWriteD;
    MemtoRegE <= MemtoRegD;
    MemWriteE <= MemWriteD;
    ALUControlE <= ALUControlD;
    BranchE <= BranchD;
    ALUSrcE <= ALUSrcD;
    FlagWriteE <= FlagWriteD;
    ImmSrcE <= ImmSrcD;
    CondE <= CondD;
end
endmodule


module regEXMEM(
    input logic clk,
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
    PCSrcW = PCSrcM;
    RegWriteW = RegWriteM;
    MemtoRegW = MemtoRegM;
    ReadDataW = ReadDataM;
    ALUOutW = ALUOutM;
    WA3W = WA3M;
end


endmodule
