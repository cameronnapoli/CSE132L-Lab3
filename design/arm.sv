module arm(
    input logic clk, reset,
    output logic [31:0] PCF, // {datapath} O to imem
    input logic [31:0] InstrF, // {datapath} I from imem
    output logic MemWriteM, // {datapath} O to datapath
    output logic [31:0] ALUResultM, WriteDataM, // {datapath} O to dmem
    output logic BEDmem); // {datapath} to dmem

    logic [3:0] ALUFlags, ALUControl;
    logic RegWrite, ALUSrc, MemtoReg, PCSrc;
    logic [1:0] RegSrc, ImmSrc;
    logic BL;
    logic [31:0] InstrD; // Intermediary signal to allow Instr to pass through pipe

    // MemWrite needs to be intercepted
    controller c(clk, reset, InstrDController, ALUFlags,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ALUControl,
        MemWrite, MemtoReg,
	    BEDmem, BL,
	    PCSrc);

    logic BranchD; // Needs to be added to controller
    // Needs FlagWriteE, CondE, FlagsE, ALUFlags to go to condlogic
    // Need Flags, CondExe from controller

    datapath dp(clk, reset, PC, Instr, InstrDController,
        PCSrc, RegWrite, MemtoReg, MemWrite,
        ALUControl, BranchD, ALUSrc, ImmSrc,
        RegSrc, ALUFlags, FlagWriteE, CondE, FlagsE, Flags, // Need to fix a few of these
        ALUResult, WriteData, ReadData, BL);


endmodule
