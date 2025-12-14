module state_machine(
	input logic clk, reset, ready, add_sub,
	input [3:0] a,
	input [3:0] b,
	output logic [3:0] out_res,
	output logic out_valid
);

	typedef enum logic [1:0] {INIT, RDY, SUB, ADD} statetype;
	
	statetype state, nextstate;
	// state register
	always_ff @(posedge clk, posedge reset)
	if (reset) state <= INIT;
	else state <= nextstate;
	
	// next state logic
	always_comb
	case (state)
		INIT: if (ready) nextstate = RDY;
		else nextstate = INIT;
		RDY: if (add_sub) nextstate = ADD;
		else nextstate = SUB;
		ADD: nextstate = INIT;
		SUB: nextstate = INIT;
	endcase
	
	// output logic
	assign out_valid = ((state == ADD) || (state == SUB));
	assign out_res = (state == ADD) ? a + b : ((state == SUB) ? a - b : 0);
endmodule