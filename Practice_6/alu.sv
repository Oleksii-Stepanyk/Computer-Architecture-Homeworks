module alu (
	input logic [31:0] a,
	input logic [31:0] b,
	input logic [2:0] ALUControl,
	output logic [31:0] result,
	output logic [3:0] flags
);

	// Flags
	logic negative;
	logic zero;
	logic carry;
	logic overflow;

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
	logic arithmetic;

	logic sltOverflow;
	logic slt;
	logic [31:0] sltResult;

	// Multiplexer
	assign cin = ALUControl[0];
	assign bMux = (cin) ? ~b : b;

	// Sum or Difference
	assign tempSum = {1'b0, a} + {1'b0, bMux} + cin;
	assign cout = tempSum[32];
	assign sum_diff = tempSum[31:0];

	// Slt and overflow calculation
	assign arithmetic = ~(ALUControl[1] | ALUControl[2]);
	assign a_sum_Xor = a[31] ^ sum_diff[31];
	assign a_b_cin_Xnor = ~(a[31] ^ b[31] ^ cin);

	assign sltOverflow = a_b_cin_Xnor & a_sum_Xor;
	assign overflow = sltOverflow & arithmetic; // V

	assign slt = sltOverflow ^ sum_diff[31];
	assign sltResult = {31'd0, slt };

	assign carry = arithmetic & cout; // C

	always_comb begin
		case (ALUControl)
			3'b000: result = sum_diff;
			3'b001: result = sum_diff;
			3'b010: result = a & b;
			3'b011: result = a | b;
			3'b101: result = sltResult;
			default: result = 32'b0;
		endcase
	end

	assign negative = result[31]; // N
	assign zero = ~|result; // Z

	// Refer to Pic.3
	assign flags = { negative, zero, carry, overflow };

endmodule