module example(
	input [3:0] op1, op2,
	input [1:0] dec_in,
	output [3:0] sum,
	output reg [3:0] dec_out,
	output ternary1, ternary2
	);
	assign sum = op1 + op2;
	always@* begin
		case(dec_in)
			0: dec_out <= 4'b0001;
			1: dec_out <= 4'b0010;
			2: dec_out <= 4'b0100;
			default: dec_out <= 4'b1000;
		endcase
	end
	assign ternary1 = ((dec_out[0] == 1'b1) ||
		(dec_out[2] == 1'b1)) ? 1'b1 : 1'b0;
	assign ternary2 = (dec_out[1] == 1'b1) ? 1'b1 :
		(dec_out[3] == 1'b1) ? 1'b1 : 1'b0;
endmodule
