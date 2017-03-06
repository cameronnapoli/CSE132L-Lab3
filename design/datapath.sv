// Group Name: The Motherboard Maniacs
// Cameron Napoli  73223093
// Matt Rommel     43905998
// Noah Correa     83305686
// Yuen Chong Lai  82761961

module datapath(
    input logic clk, reset,
    input logic [1:0] RegSrc,
    input logic RegWrite,
    input logic [1:0] ImmSrc,
    input logic ALUSrc,
    input logic [3:0] ALUControl,
    input logic MemtoReg,
    input logic PCSrc,

    output logic [3:0] ALUFlags,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData,
    input logic BL);


    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [31:0] Shamt, Out3, Reg, WD;
    logic [3:0] RA1, RA2, RA3, WA; //Added RA3, WriteData, Write Address


    // next PC logic
    mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);


    // register file logic
    mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2); //why??
    mux2 #(4) writeaddress(Instr[15:12], 4'b1110, BL, WA); //write address depends on BL
    mux2 #(32) writedata(Result, PCPlus4, BL, WD); //write data depends on BL
    // clk, we, ra1, ra2, ra3,
    // wa, wd3, r15, rd1, rd2, rd3
    regfile rf(clk, RegWrite, RA1, RA2, Instr[11:8],
        WA, WD, PCPlus8,
        SrcA, WriteData, Out3); //added RA3, Out3

    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    extend ext(Instr[23:0], ImmSrc, ExtImm);


    //Shift Logic
    mux2 #(32) shamtmux(ExtImm, Out3,  Instr[4], Shamt);
	shifter shftr(Instr[6:5], WriteData, Shamt, Reg);

    // ALU logic
    mux2 #(32) srcbmux(Reg, ExtImm, ALUSrc, SrcB); // Instr[25] should be the control...
    alu alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
endmodule


module shifter(
    input logic [1:0] sh, // control bits
    input logic [31:0] readVal1, // R2 value from RegFile
    input logic [31:0] shiftAmount, // R3 value or shamt from instruction
    output logic [31:0] shiftedOutput); // shifted output

always_comb
    case(sh)
        2'b00: // LSL (Logical Shift Left)
            shiftedOutput = readVal1 << shiftAmount;
        2'b01: // LSR (Logical Shift Right)
            shiftedOutput = readVal1 >> shiftAmount;
        2'b10: // ASR (Arithmetic Shift Right)
            shiftedOutput = readVal1 >>> shiftAmount;
        2'b11: // ROR (Rotate Right)
            case(shiftAmount[4:0])
                5'b00000: shiftedOutput = readVal1[31:0];
                5'b00001: shiftedOutput = {readVal1[0], readVal1[31:1]};
                5'b00010: shiftedOutput = {readVal1[1:0], readVal1[31:2]};
                5'b00011: shiftedOutput = {readVal1[2:0], readVal1[31:3]};
                5'b00100: shiftedOutput = {readVal1[3:0], readVal1[31:4]};
                5'b00101: shiftedOutput = {readVal1[4:0], readVal1[31:5]};
                5'b00110: shiftedOutput = {readVal1[5:0], readVal1[31:6]};
                5'b00111: shiftedOutput = {readVal1[6:0], readVal1[31:7]};
                5'b01000: shiftedOutput = {readVal1[7:0], readVal1[31:8]};
                5'b01001: shiftedOutput = {readVal1[8:0], readVal1[31:9]};
                5'b01010: shiftedOutput = {readVal1[9:0], readVal1[31:10]};
                5'b01011: shiftedOutput = {readVal1[10:0], readVal1[31:11]};
                5'b01100: shiftedOutput = {readVal1[11:0], readVal1[31:12]};
                5'b01101: shiftedOutput = {readVal1[12:0], readVal1[31:13]};
                5'b01110: shiftedOutput = {readVal1[13:0], readVal1[31:14]};
                5'b01111: shiftedOutput = {readVal1[14:0], readVal1[31:15]};
                5'b10000: shiftedOutput = {readVal1[15:0], readVal1[31:16]};
                5'b10001: shiftedOutput = {readVal1[16:0], readVal1[31:17]};
                5'b10010: shiftedOutput = {readVal1[17:0], readVal1[31:18]};
                5'b10011: shiftedOutput = {readVal1[18:0], readVal1[31:19]};
                5'b10100: shiftedOutput = {readVal1[19:0], readVal1[31:20]};
                5'b10101: shiftedOutput = {readVal1[20:0], readVal1[31:21]};
                5'b10110: shiftedOutput = {readVal1[21:0], readVal1[31:22]};
                5'b10111: shiftedOutput = {readVal1[22:0], readVal1[31:23]};
                5'b11000: shiftedOutput = {readVal1[23:0], readVal1[31:24]};
                5'b11001: shiftedOutput = {readVal1[24:0], readVal1[31:25]};
                5'b11010: shiftedOutput = {readVal1[25:0], readVal1[31:26]};
                5'b11011: shiftedOutput = {readVal1[26:0], readVal1[31:27]};
                5'b11100: shiftedOutput = {readVal1[27:0], readVal1[31:28]};
                5'b11101: shiftedOutput = {readVal1[28:0], readVal1[31:29]};
                5'b11110: shiftedOutput = {readVal1[29:0], readVal1[31:30]};
                5'b11111: shiftedOutput = {readVal1[30:0], readVal1[31]};
            endcase
        default:
            shiftedOutput = 32'bx;
    endcase

endmodule