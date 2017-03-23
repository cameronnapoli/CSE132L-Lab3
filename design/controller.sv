
module controller( // IO is done for controller
	input logic clk, reset,

	// Control unit (Decoder) input
	input logic [27:26] Op,
	input logic [25:20] Funct,
	input logic [15:12] Rd,
	// Control unit output
	output logic PCSrcD,
    output logic RegWriteD,
    output logic MemtoRegD,
    output logic MemWriteD,
    output logic [3:0] ALUControlD,
    output logic BranchD,
    output logic ALUSrcD,
    output logic [1:0] FlagWriteD,
    output logic [1:0] ImmSrcD, RegSrcD,
	output logic ByteEnableDmem,
	output logic BLD,

	// Condlogic input
    input logic [3:0] CondE,
    input logic [3:0] ALUFlagsE,
    input logic [1:0] FlagWE,
	input logic [3:0] FlagsE,
    input logic PCSE, RegWE, MemWE, BranchE, BLE,
	// Condlogic output
	output logic [3:0] Flags,
	output logic PCSrcEO, RegWriteEO, MemWriteEO, BranchEO, BLEO
	);

	decoder dec(Op, Funct, Rd, // confirmed
		PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD,
	    BranchD, ALUSrcD, FlagWriteD, ImmSrcD, RegSrcD,
		ByteEnableDmem, BLD);

	condlogic cd(clk, reset, CondE, ALUFlagsE, // confirmed
	    FlagWE, FlagsE, PCSE, RegWE, MemWE, BranchE, BLE,
	    Flags, PCSrcEO, RegWriteEO, MemWriteEO, BranchEO, BLEO );


endmodule
