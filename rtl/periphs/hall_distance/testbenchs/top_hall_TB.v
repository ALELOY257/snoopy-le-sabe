`timescale 1ns/1ps

module top_hall_tb;

    reg clk;
    reg rst;
    reg init;
    reg hall_in;

    wire [7:0] distance;

    top_hall dut (
        .clk(clk),
        .rst(rst),
        .hall_in(hall_in),
        .init(init),
        .distance(distance)
    );

    initial clk = 1'b0;
    always #20 clk = ~clk;   // 25 MHz clock, 40 ns period

    initial begin
        $dumpfile("top_hall_tb.vcd");
        $dumpvars(0, top_hall_tb);

        rst = 1'b1;
        init = 1'b0;
        hall_in = 1'b1;      // idle high, active-low pulse

        #80;
        rst = 1'b0;

        @(negedge clk);
        init = 1'b1;

        @(negedge clk);
        init = 1'b0;

        repeat (4) begin
            @(negedge clk);
            hall_in = 1'b0;
            @(negedge clk);
            hall_in = 1'b1;
        end

        repeat (20) @(negedge clk);

        $finish;
    end

endmodule