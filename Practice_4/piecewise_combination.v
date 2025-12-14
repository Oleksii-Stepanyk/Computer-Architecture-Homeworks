module piecewise_combination(
    input [3:0] input1,
	 input [3:0] input2,
    output [7:0] combination_result
);

	assign combination_result = (((input1 % 2) + (input2 % 2)) == 2) ? input1 * input2 : input1 * 4;
    
endmodule