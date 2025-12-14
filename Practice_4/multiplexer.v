module multiplexer(
    input [7:0] input_values,
    input [2:0] selector,
    output reg out_value
);

	reg mut_8_7, mut_6_5, mut_4_3, mut_2_1;
	reg mut_87_65, mut_43_21;

	function mux_2_1;
		input a, b, sel;
		begin
			mux_2_1 = sel ? b : a;
		end
	endfunction
    
	always @(*) begin
		mut_8_7 = mux_2_1(input_values[6], input_values[7], selector[0]);
		mut_6_5 = mux_2_1(input_values[4], input_values[5], selector[0]);
		mut_4_3 = mux_2_1(input_values[2], input_values[3], selector[0]);
		mut_2_1 = mux_2_1(input_values[0], input_values[1], selector[0]);
		mut_87_65 = mux_2_1(mut_8_7, mut_6_5, selector[1]);
		mut_43_21 = mux_2_1(mut_4_3, mut_2_1, selector[1]);
		out_value = mux_2_1(mut_87_65, mut_43_21, selector[2]);
	end
endmodule