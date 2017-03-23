module top(
    input  logic clk, reset,
    output logic [31:0] DataAdr,
    output logic [31:0] WriteData,
    output logic MemWrite
    );

    logic [31:0] PC, Instr, ReadData;
    logic BE;


    // instantiate processor and memories
    arm  arm (clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, BE);

    imem imem(PC, Instr);

    dmem dmem(clk, MemWrite, DataAdr, WriteData, BE, ReadData);

endmodule
