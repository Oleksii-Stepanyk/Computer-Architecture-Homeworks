module sev_seg_dec(
input [3:0] enc_input,
output reg [7:0] dec_output
);
	always @* begin
		case(enc_input)
		4'b0000:
			dec_output = 8'b00000011; //zero
		4'b0001:
			dec_output = 8'b10011111; //one
		4'b0010:
			dec_output = 8'b00100101; //two
		4'b0011:
			dec_output = 8'b00001101; //three
		4'b0100:
			dec_output = 8'b10011001; //four
		4'b0101:
			dec_output = 8'b01001001; //five
		4'b0110:
			dec_output = 8'b01000001; //six
		4'b0111:
			dec_output = 8'b00011111; //seven
		4'b1000:
			dec_output = 8'b00000001; //eight
		4'b1001:
			dec_output = 8'b00001001; //nine
		4'b1010:
			dec_output = 8'b00010001; //A
		4'b1011:
			dec_output = 8'b11000001; //b
		4'b1100:
			dec_output = 8'b01100011; //C
		4'b1101:
			dec_output = 8'b10000101; //d
		4'b1110:
			dec_output = 8'b01100001; //E
		4'b1111:
			dec_output = 8'b01110001; //F
		endcase
	end
endmodule