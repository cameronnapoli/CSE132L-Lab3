module hazardunit(
	input logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W,
    output logic StallF,
    output logic StallID,
    output logic FlushID,
    output logic FlushE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic RegWriteM,
    output logic RegWriteW,
    output logic MemtoRegE
    );

endmodule
