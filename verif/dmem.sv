
module dmem(
    input logic clk, we,
    input logic [31:0] a, wd,
    input logic be,
    output logic [31:0] rd);

        logic [31:0] RAM[100:0];

        //STORE Instruction
        always @(posedge clk) begin
        	if(we) begin
        		if (be) begin
            		case(a[1:0])
            			2'b00: begin RAM[a[31:2]][7:0] <= wd[7:0]; end
            			2'b01: begin RAM[a[31:2]][15:8] <= wd[7:0]; end
            			2'b10: begin RAM[a[31:2]][23:16] <= wd[7:0]; end
            			2'b11: begin RAM[a[31:2]][31:24] <= wd[7:0]; end
            		endcase
        		end
        		else begin
        			RAM[a[31:2]] <= wd;
        		end
            end
    	end
    	//LoadR
    	always_comb begin
        	if (be) begin
        		case(a[1:0])
        			2'b00: begin rd = {24'b0, RAM[a[31:2]][7:0]}; end
        			2'b01: begin rd = {24'b0, RAM[a[31:2]][15:8]}; end
        			2'b10: begin rd = {24'b0, RAM[a[31:2]][15:8]}; end
        			2'b11: begin rd = {24'b0, RAM[a[31:2]][15:8]}; end
        		endcase
    		end
        	//Load
    		else begin
                rd = RAM[a[31:2]];
            end
    	end



    endmodule
