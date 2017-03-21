module controller(input logic clk, reset,
/*
    input logic [31:12] Instr,
    input logic [3:0] ALUFlags,  // Flags get passed from IF/ID registers
								 // to ID/EX and are no longer needed
*/
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
    output logic PCSrc);

    logic [1:0] FlagW;
    logic PCS, RegW, MemW;

    
    decoder dec(Op[27:26], Funct[25:20], Rd[15:12],
        FlagW, PCS, RegW, MemW,
        MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl,
	BEDmem, BL);
	/*
    condlogic cl(clk, reset, Instr[31:28], ALUFlags,
        FlagW, PCS, RegW, MemW,
        PCSrc, RegWrite, MemWrite);
		*/
		// Controller gets values from ID/EX registers

endmodule
