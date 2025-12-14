module TopModule (
    input logic clk, reset,
    output logic [31:0] WriteData, DataAdr, OutInstr,
    output logic MemWrite
);
    logic [31:0] PC, Instr, ReadData;

    RISCVSingle rvsingle(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
    InstructionMemory imem(PC, Instr);
    DataMemory dmem(clk, MemWrite, DataAdr, WriteData, ReadData);

	 assign OutInstr = Instr;

endmodule