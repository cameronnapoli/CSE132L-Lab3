module controller(input logic clk, reset,

	input logic [27:26] Op,
	input logic [25:20] Funct,
	input logic [15:12] Rd,
    output logic [1:0] RegSrc,
    output logic RegWrite,
    output logic [1:0] ImmSrc,
    output logic ALUSrc,
    output logic [3:0] ALUControl,
    output logic MemWrite, MemtoReg,
    output logic BEDmem, BL,
    output logic PCSrc,
// Inputs for CLU /////////
    input logic [3:0] CondE,
    input logic [3:0] ALUFlagsE,
    input logic [1:0] FlagWE,
    input logic PCSE, RegWE, MemWE,BranchE);
////////////////////////
    logic [1:0] FlagW;
    logic PCS, RegW, MemW;

    
    decoder dec(Op[27:26], Funct[25:20], Rd[15:12],
        FlagW, PCS, RegW, MemW,
        MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl,
	BEDmem, BL);

    condlogic cl(clk, reset, CondE, ALUFlagsE,
        FlagWE, PCSE, RegWE, MemWE, BranchE,
        PCSrc, RegWrite, MemWrite);


endmodule
