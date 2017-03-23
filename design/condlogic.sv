module condlogic(
    input logic clk, reset,
    input logic [3:0] Cond,
    input logic [3:0] ALUFlags,
    input logic [1:0] FlagW,
    input logic [3:0] FlagsE,
    input logic PCS, RegW, MemW, Branch, BLE,
    output logic [3:0] Flags,
    output logic PCSrc, RegWrite, MemWrite, BranchEO, BLEO
    );

    // TODO add logic for Flags
    logic [1:0] FlagWrite;
    //logic CondEx;

    flopenr #(2)flagreg1(clk, reset, FlagWrite[1],
        ALUFlags[3:2], Flags[3:2]);
    flopenr #(2)flagreg0(clk, reset, FlagWrite[0],
        ALUFlags[1:0], Flags[1:0]);

    // write controls are conditional
    condcheck cc(Cond, ALUFlags, CondEx);
    assign FlagWrite = FlagW & {2{CondEx}};
    assign RegWrite = RegW & CondEx;
    assign MemWrite = MemW & CondEx;
    assign BranchEO = Branch & CondEx;
    assign PCSrc = (PCS & CondEx); //| (Branch & CondEx);
    assign BLEO = BLE & CondEx;

endmodule
