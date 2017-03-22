// Group Name: The Motherboard Maniacs
// Cameron Napoli  73223093
// Matt Rommel     43905998
// Noah Correa     83305686
// Yuen Chong Lai  82761961

module decoder(
    input logic [1:0] Op,
    input logic [5:0] Funct,
    input logic [3:0] Rd,
    output logic [1:0] FlagW,
    output logic PCS, RegW, MemW,
    output logic MemtoReg, ALUSrc,
    output logic [1:0] ImmSrc, RegSrc,
    output logic [3:0] ALUControl,
    output logic ByteEnableDmem,
    output logic BLControl);

    logic [11:0] controls;
    logic Branch, ALUOp;

    // Main Decoder
    always_comb
        casex(Op)
            // Data-processing immediate
            2'b00:
                if (Funct[5])
                    controls = 12'b000010100100;
                // Data-processing register
                else
                    controls = 12'b001100100100;
            // LDR
            2'b01:
                if (Funct[0])
        			if (Funct[5])
                		controls = {10'b0001111000, Funct[2], 1'b0};
    			else
    				controls = {10'b0011111000, Funct[2], 1'b0};
                // STR
                else
        			if (Funct[5])
                		controls = {10'b1001110100, Funct[2], 1'b0};
        			else
                		controls = {10'b1011110100, Funct[2], 1'b0};
            // B
            2'b10:
                if(Funct[4])  // BL
                    controls = {11'b01101010100, 1'b1};
                else          // B
                    controls = {11'b01101000100, 1'b0};
            default:
                controls = 12'bx;
        endcase

    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
        RegW, MemW, Branch, ALUOp, ByteEnableDmem, BLControl} = controls;

    // ALU Decoder
    always_comb
        if (ALUOp) begin // which DP Instr?
    	    ALUControl = Funct[4:1];
            // update flags if S bit is set (C & V only for arith)
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] &
                (ALUControl inside {4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1010, 4'b1011});
        end
        else begin
            ALUControl = 4'b0100; // add for non-DP instructions
            FlagW = 2'b00; // don't update Flags
        end

    // PC Logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
