module hazardunit(
	input logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W,
    output logic StallF,
    output logic StallD,
    output logic FlushD,
    output logic FlushE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
<<<<<<< HEAD
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
=======
    output logic RegWriteM,
    output logic RegWriteW,
    output logic MemtoRegE
>>>>>>> 7b1bde13f5856048d677d1a34ae7fca1adcee57f
    );

//Match_1E_M = (RA1E == WA3M)
//Match_1E_W = (RA1E == WA3W)
//Match_2E_M = (RA2E == WA3M)
//Match_2E_W = (RA2E == WA3W)

//Match_12D_E = (RA1D == WA3E) + (RA2D == WA3E)

//Forwarding  
if (Match_1E_M & RegWriteM) 
	ForwardAE = 10; // SrcAE = ALUOutM
else if (Match_1E_W & RegWriteW) 
	ForwardAE = 01; // SrcAE = ResultW
else 
	ForwardAE = 00; // SrcAE from regfile

if (Match_2E_M & RegWriteM) 
	ForwardBE = 10; 
else if (Match_1E_W & RegWriteW) 
	ForwardBE = 01; 
else 
	ForwardBE = 00; 

//RAW
//IF LDR and WA3E (in execute stage) Matches RA1D or RA2D
//Then Stall in Decode Stage.(FlushE, stallD, stallF)
//Match_12D_E = (RA1D == WA3E) + (RA2D == WA3E)
LDRstall = Match_12D_E | MemtoRegE;
StallF = StallD = FlushE = LDRstall;

//Control Hazards 437
PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
StallD = LDRstall;
StallF = LDRstall | PCWrPendingF;
FlushE = LDRstall | BranchTakenE;
FlushD = PCWrPendingF | PCSrcW | BranchTakenE;


endmodule
