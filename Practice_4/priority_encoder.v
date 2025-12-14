module priority_encoder(
    input [15:0] input_integer,
    output reg [3:0] most_significant_bit,
    output multiple_ones
);

    reg signed [4:0] i;
    reg found;
    reg [3:0] count_ones;
    
    always @(*) begin
        found = 1'b0;
        most_significant_bit = 4'b0;
        count_ones = 3'b0;
        
        for (i = 15; i >= 0; i = i - 1) begin
            if (input_integer[i] == 1'b1) begin
                if (!found) begin
                    most_significant_bit = i;
                    found = 1'b1;
                end
                count_ones = count_ones + 1'b1;
            end
        end
    end
    
    assign multiple_ones = (count_ones > 1);
    
endmodule
