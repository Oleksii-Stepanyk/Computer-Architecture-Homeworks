module ALU (
	input logic [31:0] SrcA,
	input logic [31:0] SrcB,
	input logic [2:0] ALUControl,
	output logic [31:0] ALUResult,
	output logic Zero
);

	// Multiplexer
	logic [31:0] bMux;

	// Addition
	logic cout;
	logic cin;
	logic [32:0] tempSum;
	logic [31:0] sum_diff;

	// Overflow and Slt calculation
	logic a_sum_Xor;
	logic a_b_cin_Xnor;

	logic sltOverflow;
	logic slt;
	logic [31:0] sltResult;

	// Multiplexer
	assign cin = ALUControl[0];
	assign bMux = (cin) ? ~SrcB : SrcB;

	// Sum or Difference
	assign tempSum = {1'b0, SrcA} + {1'b0, bMux} + cin;
	assign cout = tempSum[32];
	assign sum_diff = tempSum[31:0];

	// Slt and overflow calculation
	assign a_sum_Xor = SrcA[31] ^ sum_diff[31];
	assign a_b_cin_Xnor = ~(SrcA[31] ^ SrcB[31] ^ cin);

	assign sltOverflow = a_b_cin_Xnor & a_sum_Xor;

	assign slt = sltOverflow ^ sum_diff[31];
	assign sltResult = {31'd0, slt };

	always_comb begin
		case (ALUControl)
			3'b000: ALUResult = sum_diff;
			3'b001: ALUResult = sum_diff;
			3'b010: ALUResult = SrcA & SrcB;
			3'b011: ALUResult = SrcA | SrcB;
			3'b100: ALUResult = SrcA << SrcB[4:0];
			3'b101: ALUResult = sltResult;
			default: ALUResult = 32'b0;
		endcase
	end

	assign Zero = ~|ALUResult;

endmodule