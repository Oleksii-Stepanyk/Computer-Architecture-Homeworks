module DataMemory(
    input logic clk,
    input logic WE,
    input logic [31:0] A,
    input logic [31:0] WD,
    output logic [31:0] RD,
    output logic [31:0] config_reg,
    input logic [31:0] status_reg_in
);

    logic [31:0] memory [63:0];
    
    parameter CONFIG_ADDR = 6'd10;
    parameter STATUS_ADDR = 6'd11;

    initial begin
        $readmemh("C:\\Users\\Heilstah\\AppData\\Local\\quartus\\Practice_8\\program.data", memory);
    end

    always_comb begin
        if (A[31:2] == STATUS_ADDR)
            RD = status_reg_in;
        else
            RD = memory[A[31:2]];
    end

    always @(posedge clk) begin
        if (WE) begin
            memory[A[31:2]] <= WD;
        end
    end
    
    assign config_reg = memory[CONFIG_ADDR];

endmodule