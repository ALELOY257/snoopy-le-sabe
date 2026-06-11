`timescale 1ns/1ps // <time_unit>/<time_precision



module ws2812_driver_tb;
    reg clk;
    reg rst;
    reg [23:0] pixel_data;
    wire [9:0] pixel_addr;
    wire data_out;

    ws2812_driver instance1(
        .clk (clk),
        .rst (rst),
        .pixel_data (pixel_data),
        .pixel_addr (pixel_addr),
        .data_out (data_out)
    );

    initial clk = 0;
    always #20 clk = ~clk;

    initial begin
        $dumpfile("ws2812_driver_tb.vcd");
        $dumpvars(0, ws2812_driver_tb);

        pixel_data = 24'hFF0000;
        rst =1;
        #80;
        rst=0;

        #100000;

        $finish;
    end

endmodule
