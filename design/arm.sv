module arm(
    input logic clk, reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic MemWrite,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData,
    output logic BEDmem);

    logic [3:0] ALUFlags, ALUControl;
    logic RegWrite, ALUSrc, MemtoReg, PCSrc;
    logic [1:0] RegSrc, ImmSrc;
    logic BL;
    logic [31:12] InstrDController; // Intermediary signal to allow Instr to pass through pipe

    // MemWrite needs to be intercepted

    controller c(clk, reset, InstrDController, ALUFlags,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ALUControl,
        MemWrite, MemtoReg,
	    BEDmem, BL,
	    PCSrc);
    // datapath dp(clk, reset,
    //     RegSrc, RegWrite, ImmSrc,
    //     ALUSrc, ALUControl,
    //     MemtoReg, PCSrc,
    //     ALUFlags, PC, Instr, InstrDController,
    //     ALUResult, WriteData, ReadData, BL);

    logc BranchD; // Needs to be added to controller
    // Needs FlagWriteE, CondE, FlagsE, ALUFlags to go to condlogic
    // Need Flags, CondExe from controller

    datapath dp(clk, reset, PC, Instr, InstrDController,
        PCSrc, RegWrite, MemtoReg, MemWrite,
        ALUControl, BranchD, ALUSrc, ImmSrc,
        RegSrc, ALUFlags, FlagWriteE, CondE, FlagsE, Flags, // Need to fix a few of these
        ALUResult, WriteData, ReadData, BL);


endmodule
