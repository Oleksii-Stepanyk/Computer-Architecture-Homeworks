module RegisterFile (
    input logic clk,
    input logic WE3,
    input logic [4:0] A1, A2, A3,
	output logic [31:0] RD1, RD2,
	input  logic [31:0] WD3
);

    logic [31:0] registers [31:0];

    initial begin
        registers = '{default:32'b0};
    end

    always @(posedge clk) begin
        if (WE3) begin
            registers[A3] <= WD3;
        end
    end

    assign RD1 = (A1 != 0) ? registers[A1] : 0;
    assign RD2 = (A2 != 0) ? registers[A2] : 0;
    
endmodule