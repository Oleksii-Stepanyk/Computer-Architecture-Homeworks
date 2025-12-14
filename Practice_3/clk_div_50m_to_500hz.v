module clk_div_50m_to_500hz(
	input clk,
	input reset,
	output reg out_500hz
	);
	reg [25:0] cnt;
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			cnt <= 26'd0;
		end
		else begin
			cnt <= (cnt <= 26'd99_999) ? (cnt + 1) : 0;
			out_500hz <= (cnt == 100_000) ? ~out_500hz : out_500hz;
		end
	end
endmodule
