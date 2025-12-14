module InstructionMemory (
    input logic [31:0] A,
    output logic [31:0] RD
);

    logic [31:0] memory [63:0];

    initial begin
        $readmemh("C:\\Users\\Heilstah\\AppData\\Local\\quartus\\Practice_8\\program.mem", memory);
    end

    assign RD = memory[A[31:2]];

endmodule
