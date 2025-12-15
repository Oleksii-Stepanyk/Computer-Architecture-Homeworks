`timescale 1ns/1ns

module state_machine_tb;
    logic clk, reset;
    logic enable;
    logic [7:0] state1_duration, state2_duration, state3_duration;
    logic done;
    logic irrigation_active, ventilation_active;
    
    state_machine DUT (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .state1_duration(state1_duration),
        .state2_duration(state2_duration),
        .state3_duration(state3_duration),
        .done(done),
        .irrigation_active(irrigation_active),
        .ventilation_active(ventilation_active)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
	// Main Test Sequence
    initial begin
        $display("=== State Machine Standalone Test ===");
        
        reset = 1;
        enable = 0;
        state1_duration = 8'd0;
        state2_duration = 8'd0;
        state3_duration = 8'd0;
        
        #15;
        reset = 0;
        #10;
        
        $display("\n--- Test 1: Short durations (5, 3, 4) ---");
        state1_duration = 8'd5;
        state2_duration = 8'd3;
        state3_duration = 8'd4;
        
        @(posedge clk);
        enable = 1;
        $display("Time=%0t: Enabled FSM", $time);
        
        @(posedge done);
        $display("Time=%0t: FSM cycle completed (done=1)", $time);
        
        @(posedge clk);
        enable = 0;
        $display("Time=%0t: Disabled FSM", $time);
        
        #20;
        
        $display("\n--- Test 2: Medium durations (10, 8, 6) ---");
        state1_duration = 8'd10;
        state2_duration = 8'd8;
        state3_duration = 8'd6;
        
        @(posedge clk);
        enable = 1;
        $display("Time=%0t: Enabled FSM", $time);
        
        @(posedge done);
        $display("Time=%0t: FSM cycle completed (done=1)", $time);
        
        @(posedge clk);
        enable = 0;
        $display("Time=%0t: Disabled FSM", $time);
        
        #40;
        
        $display("\n--- Test 3: Longer durations (15, 12, 10) ---");
        state1_duration = 8'd15;
        state2_duration = 8'd12;
        state3_duration = 8'd10;
        
        @(posedge clk);
        enable = 1;
        $display("Time=%0t: Enabled FSM", $time);
        
        @(posedge done);
        $display("Time=%0t: FSM cycle completed (done=1)", $time);
        
        @(posedge clk);
        enable = 0;
        $display("Time=%0t: Disabled FSM", $time);
        
        #40;

		$display("\n--- Test 4: Disable during operation (15, 12, 10) ---");
        state1_duration = 8'd15;
        state2_duration = 8'd12;
        state3_duration = 8'd10;
        
        @(posedge clk);
        enable = 1;
        $display("Time=%0t: Enabled FSM", $time);
        
        @(posedge irrigation_active);
        $display("Time=%0t: First State Active", $time);
        enable = 0;
        $display("Time=%0t: Disabled FSM", $time);
        
        #100;
        
        $display("\n=== All Tests Completed Successfully ===");
        $stop;
    end
    
	// Display when actuators are active
    always @(posedge clk) begin
        if (irrigation_active)
            $display("Time=%0t: STATE1 - Irrigation active", $time);
        if (ventilation_active)
            $display("Time=%0t: STATE3 - Ventilation active", $time);
    end
    
	// Detect invalid states
    always @(posedge clk) begin
        if (irrigation_active && ventilation_active) begin
            $display("ERROR: Both irrigation and ventilation active at time %0t", $time);
            $stop;
        end
        
        if (done && (irrigation_active || ventilation_active)) begin
            $display("ERROR: done=1 while actuators active at time %0t", $time);
            $stop;
        end
    end
    
endmodule