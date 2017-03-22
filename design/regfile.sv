// Group Name: The Motherboard Maniacs
// Cameron Napoli 73223093
// Matt Rommel 43905998
// Noah Correa 83305686
// Yuen Chong Lai 82761961

module regfile(
    input logic clk,
    input logic we3, BL,
    input logic [3:0] ra1, ra2, ra3, wa3,
    input logic [31:0] wd3, r15,
    output logic [31:0] rd1, rd2, rd3);

    logic [31:0] rf[14:0];

    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 15 reads PC + 8 instead

    always @(negedge clk) begin
        if (we3) rf[wa3] <= wd3;
        if (BL) rf[14] <= r15 - 4'b1000;
    end
    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    assign rd3 = (ra3 == 4'b1111) ? r15 : rf[ra3];

endmodule
