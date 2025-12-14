`timescale 1ns/1ns

module TopModuleTb();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr, Instr;
    logic MemWrite;

    // instantiate device to be tested
    TopModule dut(clk, reset, WriteData, DataAdr, Instr, MemWrite);
    // initialize test
    initial begin
        reset <= 1; #13; reset <= 0;
    end
    // generate clock to sequence tests
    always begin
        clk <= 1; #10; clk <= 0; #10;
    end
    // check results
    always @(negedge clk) begin
        if (!reset && Instr == 32'h0000006f) begin
            $display("Hit infinite JAL loop at Instr=%h, stopping", Instr);
            $stop;
        end
    end
endmodule