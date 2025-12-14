module clk_div_50m_to_500hz(
	input clk,
	input reset,
	output reg out_500hz
	);

	reg [25:0] cnt;
    
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			cnt <= 26'd0;
			out_500hz <= 1'b0;
		end
		else begin
			if (cnt == 26'd49_999) begin
				cnt <= 26'd0;
				out_500hz <= ~out_500hz;
			end else begin
				cnt <= cnt + 1'b1;
			end
		end
	end
endmodule
