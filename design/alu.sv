module alu(
    input logic [31:0] SrcA,
    input logic [31:0] SrcB,
    input logic [3:0] ALUControl,
    output logic [31:0] ALUResult,
    output logic [3:0] ALUFlags   // {Neg, Zero, Carry, Overflow}
    );

    logic neg_flag;
    logic zero_flag;
    logic carry_flag;
    logic overflow_flag;

    assign ALUFlags = {neg_flag, zero_flag, carry_flag, overflow_flag};

    assign zero_flag = ~|ALUResult;
    assign neg_flag = ALUResult[31];

    always_comb

    begin
        ALUResult = 'd0;
        carry_flag = 'd0;
        overflow_flag = 'd0;

	case(ALUControl)
        4'b0000 :     //and
        begin
            ALUResult = SrcA & SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b0001 :     //Xor
        begin
            ALUResult = SrcA ^ SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b0010 :     //sub
        begin
            {carry_flag, ALUResult} = SrcA - SrcB;
            if (~SrcA[31] & SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b0011 :     //Rsub
        begin
            {carry_flag, ALUResult} = SrcB - SrcA;
            if (~SrcB[31] & SrcA[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcB[31] & ~SrcA[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b0100 :     //add
        begin
            {carry_flag, ALUResult} = SrcA + SrcB;
            if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b0101 :     //addC
        begin
            {carry_flag, ALUResult} = SrcA + SrcB + carry_flag;
            if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b0110 :     //subC
        begin
            {carry_flag, ALUResult} = SrcA - SrcB- carry_flag;
            if (~SrcA[31] & SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b0111 :     //RsubC
        begin
            {carry_flag, ALUResult} = SrcB - SrcA - carry_flag;
            if (~SrcB[31] & SrcA[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcB[31] & ~SrcA[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b1000 :     //Test&
        begin
            ALUResult = SrcA & SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end


        4'b1001 :     //Test^
        begin
            ALUResult = SrcA ^ SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b1010 :     //Comp
        begin
            {carry_flag, ALUResult} = SrcA - SrcB;
            if (~SrcA[31] & SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b1011 :     //CompNeg
        begin
            {carry_flag, ALUResult} = SrcA + SrcB;
            if (~SrcA[31] & SrcB[31] & ALUResult[31])
                overflow_flag = 1'b1;
            else if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                overflow_flag = 1'b1;
            else
                overflow_flag = 1'b0;
        end

        4'b1100 :     //Orr
        begin
            ALUResult = SrcA | SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b1101 :     //Shifts
        begin
            ALUResult = SrcB;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b1110 :     //Bitwise Clear
        begin
            ALUResult = SrcA & (~SrcB);
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        4'b1111 :     //Bitwise Not
        begin
            ALUResult = ~SrcA;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end

        default :
        begin
            ALUResult = 32'd0;
            carry_flag = 1'b0;
            overflow_flag = 1'b0;
        end


        endcase
    end

endmodule

// 0010 0011 0100 0101 0110 0111 1010 1011
