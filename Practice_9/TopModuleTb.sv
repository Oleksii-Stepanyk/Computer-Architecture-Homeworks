`timescale 1ns/1ns

module TopModuleTb();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr, Instr;
    logic MemWrite;
    logic irrigation_active, ventilation_active, peripheral_done;

    // instantiate device to be tested
    TopModule dut(clk, reset, WriteData, DataAdr, Instr, MemWrite,
        irrigation_active, ventilation_active, peripheral_done);    
    // initialize test
    initial begin
        reset <= 1; #13; reset <= 0;
    end
    // generate clock to sequence tests
    always begin
        clk <= 1; #10; clk <= 0; #10;
    end
    
    // Monitor peripheral outputs
    always @(posedge clk) begin
        if (irrigation_active || ventilation_active || peripheral_done) begin
            $display("Time=%0t: irrigation=%b, ventilation=%b, done=%b", 
                     $time, irrigation_active, ventilation_active, peripheral_done);
        end
    end
    
    // check results
    always @(negedge clk) begin
        if (!reset && Instr == 32'h0000006f) begin
            $display("Hit infinite JAL loop at Instr=%h, stopping", Instr);
            $display("Final peripheral state: irrigation=%b, ventilation=%b, done=%b",
                     irrigation_active, ventilation_active, peripheral_done);
            $stop;
        end
    end
endmodule