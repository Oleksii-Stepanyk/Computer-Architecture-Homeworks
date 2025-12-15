module TopModule (
    input logic clk, reset,
    output logic [31:0] WriteData, DataAdr, OutInstr,
    output logic MemWrite,
    output logic irrigation_active,
    output logic ventilation_active,
    output logic peripheral_done
);
    logic [31:0] PC, Instr, ReadData;
    logic [31:0] config_reg, status_reg;
    
    logic enable;
    logic [7:0] state1_duration;
    logic [7:0] state2_duration;
    logic [7:0] state3_duration;
    
    assign enable = config_reg[0];
    assign state1_duration = config_reg[8:1];
    assign state2_duration = config_reg[16:9];
    assign state3_duration = config_reg[24:17];
    
    assign status_reg = {29'b0, ventilation_active, irrigation_active, peripheral_done};

    RISCVSingle rvsingle(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
    InstructionMemory imem(PC, Instr);
	DataMemory dmem(clk, MemWrite, DataAdr, WriteData, ReadData, config_reg, status_reg);
    
    state_machine peripheral(clk, reset, enable,
        state1_duration, state2_duration, state3_duration,
        peripheral_done, irrigation_active, ventilation_active);

    assign OutInstr = Instr;

endmodule