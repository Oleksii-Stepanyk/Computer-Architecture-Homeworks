module DataMemory(
    input logic clk,
    input logic WE,
    input logic [31:0] A,
    input logic [31:0] WD,
    output logic [31:0] RD
);

    logic [31:0] memory [63:0];

    initial begin
        $readmemh("C:\\Users\\Heilstah\\AppData\\Local\\quartus\\Practice_8\\program.data", memory);
    end

    assign RD = memory[A[31:2]];

    always @(posedge clk) begin
        if (WE) begin
            memory[A[31:2]] <= WD;
        end
    end

endmodule