`timescale 1ns/1ns

module state_machine_tb;
	logic clk, reset;
	logic ready, add_sub;
	logic [3:0] a, b;
	logic [3:0] out_res;
	logic out_valid;

	state_machine DUT (
		.clk(clk),
		.reset(reset),
		.ready(ready),
		.add_sub(add_sub),
		.a(a),
		.b(b),
		.out_res(out_res),
		.out_valid(out_valid)
	);

	initial clk = 0;
	always #5 clk = ~clk;

	task automatic do_op(input logic do_add, input [3:0] a_i, input [3:0] b_i);
		logic [3:0] exp;
		begin
			a       <= a_i;
			b       <= b_i;
			add_sub <= do_add;
			ready   <= 1'b1;

			@(posedge clk); // INIT -> RDY
			@(posedge clk); // RDY  -> ADD/SUB (result cycle)
			@(posedge clk); // ADD/SUB set

			exp = do_add ? (a_i + b_i) : (a_i - b_i);

			if (!out_valid) begin
				$display(1, "[%0t] out_valid not asserted in result cycle", $time);
			end

			if (out_res !== exp) begin
				$display(1, "[%0t] Mismatch: %s a=%0d b=%0d got=%0d exp=%0d",
						$time, do_add ? "ADD" : "SUB", a_i, b_i, out_res, exp);
			end
				$display("[%0t] PASS: %s a=%0d b=%0d -> out_res=%0d",
						$time, do_add ? "ADD" : "SUB", a_i, b_i, out_res);

			ready <= 1'b0;
			@(posedge clk); // ADD/SUB -> INIT

			if (out_valid !== 1'b0) $display(1, "[%0t] out_valid should be 0 after result cycle", $time);
		end
	endtask

	initial begin
		reset   = 1;
		ready   = 0;
		add_sub = 0;
		a = 0; b = 0;
	
		@(posedge clk);
		reset = 1'b0;
	
		@(posedge clk);
		if (out_valid !== 1'b0) $display(1, "[%0t] out_valid should be 0 while idle", $time);
		if (out_res   !== 4'd0) $display(1, "[%0t] out_res should be 0 while idle", $time);
	
		do_op(1, 4'd3,  4'd5);  // ADD 3+5=8
		do_op(0, 4'd9,  4'd2);  // SUB 9-2=7
	
		do_op(1, 4'd15, 4'd1);  // ADD 15+1=0 (wrap)
		do_op(0, 4'd0,  4'd1);  // SUB 0-1=15 (wrap)
	
		a = 4'd4; b = 4'd6; add_sub = 1'b1; ready = 1'b1;
		@(posedge clk); // INIT -> RDY
		@(posedge clk); // RDY -> ADD
		@(posedge clk); // ADD set
		
		if (!(out_valid && out_res === (a + b))) $display(1, "[%0t] back-to-back op1 failed", $time);
	
		a = 4'd10; b = 4'd3; add_sub = 1'b0;
		@(posedge clk); // INIT -> RDY
		@(posedge clk); // RDY -> SUB
		@(posedge clk); // SUB set
		
		if (!(out_valid && out_res === (a - b))) $display(1, "[%0t] back-to-back op2 failed", $time);
		ready = 1'b0;
		@(posedge clk); // SUB -> INIT
	
		a = 4'd2; b = 4'd2; add_sub = 1'b1; ready = 1'b1;
		@(posedge clk); // INIT -> RDY
		
		reset = 1'b1;
		@(posedge clk); // RDY -> INIT
	
		reset = 1'b0; ready = 1'b0;
		if (out_valid !== 1'b0) $display(1, "[%0t] out_valid should be 0 after reset", $time);
		@(posedge clk);
	
		$display("[%0t] All tests passed", $time);
		$stop;
	end
endmodule