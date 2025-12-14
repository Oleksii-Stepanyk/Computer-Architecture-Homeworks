`timescale 1ns/1ns

module divider_tb;

	logic [3:0] a, b;
	logic [3:0] q, r;
	logic [3:0] expected_q, expected_r;
	integer i, j;
	integer errors = 0;
	integer tests_run = 0;

	divider DUT (
		.a(a),
		.b(b),
		.q(q),
		.r(r)
	);

	initial begin
		$display("--- Starting Divider Testbench ---");

		for (i = 0; i < 16; i++) begin
			for (j = 1; j < 16; j++) begin
				a = i;
				b = j;
				#10;

				expected_q = a / b;
				expected_r = a % b;

				if (q !== expected_q || r !== expected_r) begin
					$error("FAIL: %0d / %0d. Got q=%0d, r=%0d (Expected q=%0d, r=%0d)",
					a, b, q, r, expected_q, expected_r);
					errors++;
				end
				tests_run++;
			end
		end

		#20;
		if (errors == 0) begin
			$display("--- ALL %0d DIVIDER TESTS PASSED ---", tests_run);
		end else begin
			$error("--- DIVIDER TESTS FAILED: %0d errors ---", errors);
		end
		$stop;
	end

endmodule