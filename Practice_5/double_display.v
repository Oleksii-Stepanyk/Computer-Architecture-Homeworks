module double_display (
	input click,
	input reset,
	output select_dp1,
	output select_dp2,
	output a_out,
	output b_out,
	output c_out,
	output d_out,
	output e_out,
	output f_out,
	output g_out,
	output dp_out
);

	reg [6:0] const_1 = 7'd1;
	reg [6:0] const_2 = 7'd9;

	wire [3:0] display_out1;
	wire [3:0] display_out2;

	wire [7:0] seg1_out;
	wire [7:0] seg2_out;
	wire [7:0] display_mux_out;

	wire clk_out;
	wire clk_1hz;
	wire clk_500hz;
		
	clk_div_50m_to_1hz clk_div_1hz_inst (
		.clk(click),
		.reset(reset),
		.out_1hz(clk_1hz)
	);

	counter counter1 (
		.clk(clk_1hz),
		.reset(reset),
		.const1(const_1),
		.const2(const_2),
		.display_out(display_out1),
		.clr_out(clk_out)
	);

	counter counter2 (
		.clk(clk_out),
		.reset(reset),
		.const1(const_1),
		.const2(const_2),
		.display_out(display_out2),
		.clr_out()
	);

	clk_div_50m_to_500hz clk_div_500hz_inst (
		.clk(click),
		.reset(reset),
		.out_500hz(clk_500hz)
	);

	sev_seg_dec decoder_1 (
		.enc_input(display_out1),
		.dec_output(seg1_out)
	);

	sev_seg_dec decoder_2 (
		.enc_input(display_out2),
		.dec_output(seg2_out)
	);

	assign display_mux_out = (clk_500hz) ? seg1_out : seg2_out;

	assign {dp_out, g_out, f_out, e_out, d_out, c_out, b_out, a_out} = display_mux_out;

	assign select_dp1 = clk_500hz;
	assign select_dp2 = ~clk_500hz;

endmodule