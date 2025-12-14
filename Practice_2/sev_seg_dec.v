module sev_seg_dec(
input [3:0] enc_input,
output reg [7:0] dec_output
);
always @* begin
case(enc_input)
4'b0000:
dec_output = 8'b00000010; //a,b,c,d,e,f,g
4'b0001:
dec_output = 8'b10011110; //one
4'b0010:
dec_output = 8'b00100100; //two
4'b0011:
dec_output = 8'b00001100; //three
4'b0100:
dec_output = 8'b10011000; //four
4'b0101:
dec_output = 8'b01001000; //five
4'b0110:
dec_output = 8'b01000000; //six
4'b0111:
dec_output = 8'b00011110; //seven
4'b1000:
dec_output = 8'b00000000; //eight
4'b1001:
dec_output = 8'b00001000; //nine
4'b1010:
dec_output = 8'b00010000; //A
4'b1011:
dec_output = 8'b11000000; //b
4'b1100:
dec_output = 8'b01100010; //C
4'b1101:
dec_output = 8'b10000100; //d
4'b1110:
dec_output = 8'b01100000; //E
4'b1111:
dec_output = 8'b01110000; //F
endcase
end
endmodule