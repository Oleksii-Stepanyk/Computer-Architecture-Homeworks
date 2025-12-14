module counter (
    input clk,
    input reset,
    input [6:0] const1,
    input [6:0] const2,
    output [3:0] display_out,
    output clr_out
);
    reg [6:0] cnt;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			cnt <= 7'd0;
		end 
		else begin
			if (cnt >= const2) begin
				cnt <= 7'd0;
			end
			else begin
				cnt <= cnt + const1;
			end
		end
	end

	assign display_out = (cnt[3:0] == const2) ? 7'd0 : cnt[3:0];
	assign clr_out = (cnt == const2); 
endmodule