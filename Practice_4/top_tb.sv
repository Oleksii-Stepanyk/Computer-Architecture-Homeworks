`timescale 1ns/1ns

module top_tb;

	logic [15:0] unsigned_int;
	logic [3:0] m_s_b;
	logic mul_bit;
	
	logic [3:0] first_int, second_int;
	logic less, more, equal;
	logic one_bit_diff;
	
	logic [7:0] input_values;
	logic [2:0] selector;
	logic out_value;
	
	logic [5:0] weights;
	logic [5:0] doubles;
	logic weight_result;
	
	logic [3:0] input1;
	logic [3:0] input2;
	logic [7:0] combination_result;

	testbench_module DUT(
		.input_integer(unsigned_int),
		.most_significant_bit(m_s_b),
		.multiple_ones(mul_bit),
		.first_int(first_int),
		.second_int(second_int),
		.less(less),
		.more(more),
		.equal(equal),
		.one_bit_diff(one_bit_diff),
		.input_values(input_values),
		.selector(selector),
		.out_value(out_value),
		.weights(weights),
		.doubles(doubles),
		.weight_result(weight_result),
		.input1(input1),
		.input2(input2),
		.combination_result(combination_result)
	);
	
	initial begin
		unsigned_int = 16'd0; first_int = 4'd2; second_int = 4'd3;
		input_values = 8'b10101010; selector = 3'b000;
		weights = 6'b100100; doubles = 6'b000110;
		input1 = 4'd11; input2 = 4'd7;
		#10;
		unsigned_int = 16'd3; first_int = 4'd5; second_int = 4'd3;
		input_values = 8'b10101010; selector = 3'b001;
		weights = 6'b000000; doubles = 6'b000110;
		input1 = 4'd11; input2 = 4'd6;
		#10;
		unsigned_int = 16'd15; first_int = 4'd4; second_int = 4'd4;
		input_values = 8'b10101010; selector = 3'b010;
		weights = 6'b111111; doubles = 6'b000110;
		input1 = 4'd10; input2 = 4'd6;
		#10;
		unsigned_int = 16'd2500; first_int = 4'd15; second_int = 4'd0;
		input_values = 8'b10101010; selector = 3'b011;
		input1 = 4'd12; input2 = 4'd7;
		#10;
		unsigned_int = 16'd10000; first_int = 4'd0; second_int = 4'd15;
		input_values = 8'b10101010; selector = 3'b100;
		#10;
		unsigned_int = 16'd21846; first_int = 4'd7; second_int = 4'd8;
		input_values = 8'b10101010; selector = 3'b101;
		#10;
		unsigned_int = 16'b1111111111111111; first_int = 4'd8; second_int = 4'd7;
		input_values = 8'b10101010; selector = 3'b110;
		#10;
		unsigned_int = 16'b1111111111111111; first_int = 4'd8; second_int = 4'd7;
		input_values = 8'b10101010; selector = 3'b111;
		#10;
		unsigned_int = 16'b0000000000100000;
		#10;
		
		$stop;
	end
	
endmodule