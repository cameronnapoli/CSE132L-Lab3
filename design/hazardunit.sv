module hazardunit(
    output logic StallF,
    output logic StallD,
    output logic FlushD,
    output logic FlushE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,

    input logic Match_1E_M,
    input logic Match_1E_W,
    input logic Match_2E_M,
    input logic Match_2E_W,
    input logic Match_12D_E,

    input logic RegWriteM,
    input logic RegWriteW,
    input logic MemtoRegE,
    input logic PCSrcD,
    input logic PCSrcE,
    input logic PCSrcM

    );

//Match_1E_M = (RA1E == WA3M)
//Match_1E_W = (RA1E == WA3W)
//Match_2E_M = (RA2E == WA3M)
//Match_2E_W = (RA2E == WA3W)

//Match_12D_E = (RA1D == WA3E) + (RA2D == WA3E)

//Forwarding
always_comb begin
	//Forwarding
	if (Match_1E_M & RegWriteM)
		ForwardAE = 2'b10; // SrcAE = ALUOutM
	else if (Match_1E_W & RegWriteW)
		ForwardAE = 2'b01; // SrcAE = ResultW
	else
		ForwardAE = 2'b00; // SrcAE from regfile

	if (Match_2E_M & RegWriteM)
		ForwardBE = 2'b10;
	else if (Match_1E_W & RegWriteW)
		ForwardBE = 2'b01;
	else
		ForwardBE = 2'b00;

	//RAW
	//IF LDR and WA3E (in execute stage) Matches RA1D or RA2D
	//Then Stall in Decode Stage.(FlushE, stallD, stallF)
	//Match_12D_E = (RA1D == WA3E) + (RA2D == WA3E)
	logic LDRstall = Match_12D_E | MemtoRegE;

	//Control Hazards 437
	logic PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	StallD = LDRstall;
	StallF = LDRstall | PCWrPendingF;
	FlushE = LDRstall | BranchTakenE;
	FlushD = PCWrPendingF | PCSrcW | BranchTakenE;

end

endmodule
