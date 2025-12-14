`timescale 1ns/1ns

module double_display_tb;
	logic clk;
	logic reset;
	logic clk_out;
	logic [6:0] const_1 = 7'd1;
	logic [6:0] const_2 = 7'd10;
	logic [3:0] display_out1;
	logic [3:0] display_out2;

	counter uut1 (
		.clk(clk),
		.reset(reset),
		.const1(const_1),
		.const2(const_2),
		.display_out(display_out1),
		.clr_out(clk_out)
	);

	counter uut2 (
		.clk(clk_out),
		.reset(reset),
		.const1(const_1),
		.const2(const_2),
		.display_out(display_out2),
		.clr_out()
	);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 0;
		reset = 0;

		$display("[%0t] Applying reset...", $time);
		reset = 1;
		@(posedge clk);
		@(posedge clk);
		reset = 0;

		$display("[%0t] Counters running...", $time);
		#500;

		$display("[%0t] Resetting again...", $time);
		reset = 1;
		@(posedge clk);
		reset = 0;

		#500;

		$display("[%0t] Simulation finished.", $time);
		$stop;
	end
endmodule