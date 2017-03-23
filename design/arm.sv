module arm(
    input logic clk, reset,
    output logic [31:0] PCF, // {datapath} O to imem
    input logic [31:0] InstrF, // {datapath} I from imem
    output logic MemWriteM, // {datapath} O to datapath
    output logic [31:0] ALUResultM, WriteDataM, // {datapath} O to dmem
    output logic BEDmem); // {datapath} to dmem

    logic [3:0] ALUFlags, ALUControl, CondE, Flags;
    logic RegWrite, Branch, ALUSrc, MemtoReg, PCSrc, MemWrite, FlagWE, FlagsE;
    logic [1:0] RegSrc, ImmSrc, FlagWrite;
    logic BL;
    logic [31:0] InstrD; // Intermediary signal to allow Instr to pass through pipe
	logic PCSE, RegWE, MemWE, BranchE, BLE;
	logic PCSrcEO, RegWriteEO, MemWriteEO, BranchEO, BLEO;

    // MemWrite needs to be intercepted
    controller c(clk, reset, InstrD[27:26], InstrD[25:20], InstrD[15:12],
	// control unit output
		PCSrc, RegWrite, MemtoReg, MemWrite,
		ALUControl, Branch, ALUSrc, FlagWrite,ImmSrc,RegSrc,
		BEDmem, BL,
		// condlogic input
		CondE, ALUFlags, FlagWrite, FlagWE, FlagsE,
		PCSE, RegWE, MemWE, BranchE, BLE,
		
		// condlogic output
		Flags,
		PCSrcEO, RegWriteEO, MemWriteEO, BranchEO, BLEO
		);

    logic BranchD; // Needs to be added to controller
    // Needs FlagWriteE, CondE, FlagsE, ALUFlags to go to condlogic
    // Need Flags, CondExe from controller

    datapath dp(clk, reset, PC, Instr, InstrDController,
        PCSrc, RegWrite, MemtoReg, MemWrite,
        ALUControl, BranchD, ALUSrc, ImmSrc,
        RegSrc, ALUFlags, FlagWriteE, CondE, FlagsE, Flags, // Need to fix a few of these
        ALUResult, WriteData, ReadData, BL);


endmodule
