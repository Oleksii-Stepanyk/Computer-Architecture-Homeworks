module clk_div_50m_to_1hz(
	input clk,
	input reset,
	output reg out_1hz
	);
	reg [25:0] cnt;
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			cnt <= 26'd0;
		end
		else begin
			cnt <= (cnt <= 26'd49_999_999) ? (cnt + 1) : 0;
			out_1hz <= (cnt == 50_000_000) ? ~out_1hz : out_1hz;
		end
	end
endmodule
