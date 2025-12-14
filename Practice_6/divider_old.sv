module cell_divider_old (
	input logic r_in,
	input logic b_in,
	input logic c_in,
	input logic n_global,
	output logic c_out,
	output logic r_out
);

	logic d_out;

	assign {c_out, d_out} = r_in + ~b_in + c_in;
	assign r_out = n_global ? r_in : d_out;

endmodule

module row_divider_old (
	input logic [3:0] r_in,
	input logic [3:0] b,
	output logic [3:0] r_out,
	output logic q_bit
);

	wire [4:0] c_bits;
	wire n_global;
	
	assign c_bits[0] = 1'b1;
	assign n_global = ~c_bits[4];
	assign q_bit = c_bits[4];

	cell_divider cell1 ( .r_in(r_in[0]), .b_in(b[0]), .c_in(c_bits[0]), .n_global(n_global), .c_out(c_bits[1]), .r_out(r_out[0]) );
	cell_divider cell2 ( .r_in(r_in[1]), .b_in(b[1]), .c_in(c_bits[1]), .n_global(n_global), .c_out(c_bits[2]), .r_out(r_out[1]) );
	cell_divider cell3 ( .r_in(r_in[2]), .b_in(b[2]), .c_in(c_bits[2]), .n_global(n_global), .c_out(c_bits[3]), .r_out(r_out[2]) );
	cell_divider cell4 ( .r_in(r_in[3]), .b_in(b[3]), .c_in(c_bits[3]), .n_global(n_global), .c_out(c_bits[4]), .r_out(r_out[3]) );

endmodule

module divider_old (
	input logic [3:0] a,
	input logic [3:0] b,
	output logic [3:0] q,
	output logic [3:0] r
);

	logic [3:0] r0, r1, r2, r3;
	logic [3:0] q_temp;

	row_divider row0 ( .r_in({3'b0, a[3]}), .b(b), .r_out(r0), .q_bit(q_temp[3]) );
	row_divider row1 ( .r_in({r0[2:0], a[2]}), .b(b), .r_out(r1), .q_bit(q_temp[2]) );
	row_divider row2 ( .r_in({r1[2:0], a[1]}), .b(b), .r_out(r2), .q_bit(q_temp[1]) );
	row_divider row3 ( .r_in({r2[2:0], a[0]}), .b(b), .r_out(r3), .q_bit(q_temp[0]) );

	assign q = q_temp;
	assign r = r3;

endmodule