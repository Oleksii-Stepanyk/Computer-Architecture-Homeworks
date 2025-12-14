module testbench_module(
   input [3:0] first_int,
   input [3:0] second_int,
   output less, more, equal,
   output one_bit_diff,
   input [15:0] input_integer,
   output [3:0] most_significant_bit,
   output multiple_ones,
	input [7:0] input_values,
	input [2:0] selector,
	output out_value,
	input [5:0] weights,
	input [5:0] doubles,
	output weight_result,
	input [3:0] input1,
	input [3:0] input2,
	output [7:0] combination_result
);

    comparator comp_inst (
		.first_int(first_int),
		.second_int(second_int),
		.less(less),
		.more(more),
		.equal(equal),
		.one_bit_diff(one_bit_diff)
    );

    priority_encoder encoder_inst (
		.input_integer(input_integer),
		.most_significant_bit(most_significant_bit),
		.multiple_ones(multiple_ones)
    );
	 
	 multiplexer multiplexer_inst (
		.input_values(input_values),
		.selector(selector),
		.out_value(out_value)
	 );
	 
	 weighted_majority weighted_majority_inst (
		.inputs(weights),
		.doubles(doubles),
		.result(weight_result)
	 );
	 
	 piecewise_combination piecewise_inst (
		.input1(input1),
		.input2(input2),
		.combination_result(combination_result)
	 );

endmodule