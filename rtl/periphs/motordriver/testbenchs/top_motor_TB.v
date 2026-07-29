`timescale 1ns/1ps

module top_motor_tb;

    reg clk;
    reg rst;
    reg init;
    reg [1:0] direction;

    wire stby;
    wire fn_in1;
    wire fn_in2;
    wire pwm;

    top_motor dut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .direction(direction),
        .stby(stby),
        .fn_in1(fn_in1),
        .fn_in2(fn_in2),
        .pwm(pwm)
    );

    initial clk = 1'b0;
    always #20 clk = ~clk;   // 25 MHz, 40 ns period

    initial begin
        $dumpfile("top_motor_tb.vcd");
        $dumpvars(0, top_motor_tb);

        rst = 1'b1;
        init = 1'b0;
        direction = 2'b01;

        repeat (4) @(negedge clk);
        rst = 1'b0;

        @(negedge clk);
        init = 1'b1;
        @(negedge clk);
        init = 1'b0;

        // Let the FSM run long enough to show the ramp behavior.
        // At 25 MHz, 10 ms is 250000 cycles, so this is intentionally long.
        #30000000;  // 30 ms

        // Now test the "stall" direction path.
        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;

        direction = 2'b00;
        @(negedge clk);
        init = 1'b1;
        @(negedge clk);
        init = 1'b0;

        #2000000;   // 2 ms more for observation

        $finish;
    end

    initial begin
        $monitor("%0t rst=%b init=%b dir=%b stby=%b fn1=%b fn2=%b pwm=%b",
                 $time, rst, init, direction, stby, fn_in1, fn_in2, pwm);
    end

endmodule