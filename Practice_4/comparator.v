module comparator(
   input [3:0] first_int,
	input [3:0] second_int,
   output less, more, equal,
   output one_bit_diff
);

	assign less = first_int < second_int;
	assign more = first_int > second_int;
	assign equal = first_int == second_int;
	assign one_bit_diff = (first_int == second_int + 1)
							 || (first_int + 1 == second_int);
endmodule