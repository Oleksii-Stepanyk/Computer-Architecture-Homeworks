module weighted_majority(
	input[5:0] inputs,
	input[5:0] doubles,
	output result
);

	reg signed [3:0] i;
	reg [3:0] count;
	reg [1:0] multiplier;

	always @(*) begin
	  count = 4'b0;
	  multiplier = 2'd1;
	  
	  for (i = 0; i < 6; i = i + 1) begin
			multiplier = 2'd1;
			if (doubles[i] == 1'b1) begin
				multiplier = 2'd2;
			end
			count = count + inputs[i] * multiplier;
	  end
	end

	assign result = (count >= 3);

endmodule