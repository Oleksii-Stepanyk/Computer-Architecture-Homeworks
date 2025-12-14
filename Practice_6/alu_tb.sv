`timescale 1ns/1ns

module alu_tb;

    logic [31:0] a, b;
    logic [2:0]  ALUControl;
    logic [31:0] result;
    logic [3:0] flags;
    integer errors = 0;

    alu DUT (
        .a(a),
        .b(b),
        .ALUControl(ALUControl),
        .result(result),
        .flags(flags)
    );

    logic n, z, c, v;
    assign n = flags[3];
    assign z = flags[2];
    assign c = flags[1];
    assign v = flags[0];

    task check_result (
        string testid,
        logic [31:0] exp_result,
        logic exp_z,
        logic exp_n,
        logic exp_c,
        logic exp_v
    );
        #10;
        if (result !== exp_result || z !== exp_z || n !== exp_n || c !== exp_c || v !== exp_v) begin
            $error("[%s] FAILED. a=0x%h, b=0x%h, Op=%b", testid, a, b, ALUControl);
            $error("  Got:  Res=0x%h, z=%b, n=%b, c=%b, v=%b", result, z, n, c, v);
            $error("  Exp:  Res=0x%h, z=%b, n=%b, c=%b, v=%b", exp_result, exp_z, exp_n, exp_c, exp_v);
            errors++;
        end else begin
            $display("[%s] PASSED. a=0x%h, b=0x%h, Op=%b", testid, a, b, ALUControl);
        end
    endtask

    initial begin
        $display("--- Starting ALU Testbench ---");

        a = 10; b = 20; ALUControl = 3'b000;
        check_result("ADD", 30, 0, 0, 0, 0);

        a = 32'hFFFFFFFF; b = 1; ALUControl = 3'b000;
        check_result("ADD_ZERO", 0, 1, 0, 1, 0);

        a = 32'h7FFFFFFF; b = 1; ALUControl = 3'b000;
        check_result("ADD_OVF_POS", 32'h80000000, 0, 1, 0, 1);

        a = 32'h80000000; b = 32'hFFFFFFFF; ALUControl = 3'b000;
        check_result("ADD_OVF_NEG", 32'h7FFFFFFF, 0, 0, 1, 1);

        a = 30; b = 10; ALUControl = 3'b001;
        check_result("SUB", 20, 0, 0, 1, 0);

        a = 10; b = 30; ALUControl = 3'b001;
        check_result("SUB_NEG", 32'hFFFFFFEC, 0, 1, 0, 0);
        
        a = 10; b = 10; ALUControl = 3'b001;
        check_result("SUB_ZERO", 0, 1, 0, 1, 0);
        
        a = 32'h80000000; b = 1; ALUControl = 3'b001;
        check_result("SUB_OVF", 32'h7FFFFFFF, 0, 0, 1, 1);

        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; ALUControl = 3'b010;
        check_result("AND_ZERO", 0, 1, 0, 0, 0);
        
        a = 32'hFFFF0000; b = 32'h80808080; ALUControl = 3'b010;
        check_result("AND_NEG", 32'h80800000, 0, 1, 0, 0);
        
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; ALUControl = 3'b011;
        check_result("OR_NEG", 32'hFFFFFFFF, 0, 1, 0, 0);

        a = 32'h0000F000; b = 32'h00000F00; ALUControl = 3'b011;
        check_result("OR_POS", 32'h0000FF00, 0, 0, 0, 0);
        
        a = 10; b = 20; ALUControl = 3'b101;
        check_result("SLT_T", 1, 0, 0, 0, 0);

        a = 20; b = 10; ALUControl = 3'b101;
        check_result("SLT_F_GT", 0, 1, 0, 0, 0);
        
        a = 10; b = 10; ALUControl = 3'b101;
        check_result("SLT_F_EQ", 0, 1, 0, 0, 0);
        
        a = -10; b = 5; ALUControl = 3'b101;
        check_result("SLT_T_NEG", 1, 0, 0, 0, 0);
        
        a = 5; b = -10; ALUControl = 3'b101;
        check_result("SLT_F_NEG", 0, 1, 0, 0, 0);
        
        a = -20; b = -10; ALUControl = 3'b101;
        check_result("SLT_T_NEG_NEG", 1, 0, 0, 0, 0);

        #20;
        if (errors == 0) begin
            $display("--- ALL ALU TESTS PASSED ---");
        end else begin
            $error("--- ALU TESTS FAILED: %0d errors ---", errors);
        end
        $stop;
    end

endmodule