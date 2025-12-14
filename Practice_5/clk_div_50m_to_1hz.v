module clk_div_50m_to_1hz(
	input clk,
	input reset,
	output reg out_1hz
	);

	reg [25:0] cnt;
    
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			cnt <= 26'd0;
			out_1hz <= 1'b0;
		end
		else begin
			if (cnt == 26'd24_999_999) begin
				cnt <= 26'd0;
				out_1hz <= ~out_1hz;
			end else begin
				cnt <= cnt + 1'b1;
			end
		end
	end
endmodule
