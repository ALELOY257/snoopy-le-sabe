`timescale 1ns/1ps // <time_unit>/<time_precision

module framebuffer_tb;
    reg clk;
    reg [9:0] read_addr;
    wire [23:0] pixel_out;
    reg [9:0] write_addr;
    reg [23:0] write_data;
    reg write_en;

    framebuffer instance1(
        .clk (clk),
        .read_addr(read_addr),
        .pixel_out(pixel_out),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en)
    );

    initial clk=0;
    always #20 clk = ~clk;

    initial begin
        $dumpfile("framebuffer_tb.vcd");
        $dumpvars(0, framebuffer_tb);

        write_en = 1;

        write_addr = 10'd5;
        write_data = 24'hFF0000;

        #40;

        read_addr = 10'd5;

        #40;
// test2
        write_en = 1;

        write_addr = 10'd1023;
        write_data = 24'h0000FF;

        #40;

        read_addr = 10'd1023;

        #40;
//test3
        write_en = 1;

        write_addr = 10'd0;
        write_data = 24'hAABBCC;
        #40;

        write_en=0;
        write_data=24'h001122;
        #40;

        read_addr = 10'd0;

        #40;


        $finish;
    end


endmodule