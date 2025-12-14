module divider_cell (
	input logic r_in,
	input logic b_in_inv,   
	input logic c_in,
	input logic n_sel,
	output logic r_out,
	output logic c_out
);

	logic d_out;

	assign {c_out, d_out} = r_in + b_in_inv + c_in;
	assign r_out = n_sel ? r_in : d_out;

endmodule

module row_divider (
	input logic [3:0] b_inv,
	input logic [2:0] r_above,
	input logic seed_bit,
	output logic [3:0] r_row_out,
	output logic q_bit
);

	logic [4:0] c;
	logic n_sel;

	assign c[0] = 1'b1;
	assign q_bit = c[4];
	assign n_sel = ~q_bit;
	
	divider_cell cell_0 (
		.r_in(seed_bit),
		.b_in_inv(b_inv[0]),
		.c_in(c[0]),
		.n_sel(n_sel),
		.r_out(r_row_out[0]),
		.c_out(c[1])
	);
	
	divider_cell cell_1 (
		.r_in(r_above[0]),
		.b_in_inv(b_inv[1]),
		.c_in(c[1]),
		.n_sel(n_sel),
		.r_out(r_row_out[1]),
		.c_out(c[2])
	);
	
	divider_cell cell_2 (
		.r_in(r_above[1]),
		.b_in_inv(b_inv[2]),
		.c_in(c[2]),
		.n_sel(n_sel),
		.r_out(r_row_out[2]),
		.c_out(c[3])
	);

	
	divider_cell cell_3 (
		.r_in(r_above[2]),
		.b_in_inv(b_inv[3]),
		.c_in(c[3]),
		.n_sel(n_sel),
		.r_out(r_row_out[3]),
		.c_out(c[4])
	);


endmodule

module divider (
	input logic [3:0] a,
	input logic [3:0] b,
	output logic [3:0] q,
	output logic [3:0] r
);

	logic [3:0] b_inv;
	assign b_inv = ~b;

	logic [3:0] r_row3, r_row2, r_row1;

	row_divider row3 (
		.b_inv(b_inv),
		.seed_bit(a[3]),
		.r_above(3'b000),
		.r_row_out(r_row3),
		.q_bit(q[3])
	);

	row_divider row2 (
		.b_inv(b_inv),
		.seed_bit(a[2]),
		.r_above(r_row3[2:0]),
		.r_row_out(r_row2),
		.q_bit(q[2])
	);

	row_divider row1 (
		.b_inv(b_inv),
		.seed_bit(a[1]),
		.r_above(r_row2[2:0]),
		.r_row_out(r_row1),
		.q_bit(q[1])
	);

	row_divider row0 (
		.b_inv(b_inv),
		.seed_bit(a[0]),
		.r_above(r_row1[2:0]),
		.r_row_out(r),
		.q_bit(q[0])
	);

endmodule