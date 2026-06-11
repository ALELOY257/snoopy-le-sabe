
module top(
    input clk,
    input rst,
    output screen
);

    wire  [9:0] pixel_addr;
    // wire [23:0] pixel_data;

    ws2812_driver screen_driver(
        .clk (clk),
        .rst (~rst),
        .pixel_data (24'h00FF00),
        .pixel_addr (pixel_addr),
        .data_out(screen)
    );

    // framebuffer screen_framebuffer (
    //     .clk (clk),
    //     .read_addr (pixel_addr),
    //     .pixel_out (pixel_data),
    //     .write_addr (ui_addr),
    //     .write_data (ui_data),
    //     .write_en (ui_wen)
    // );
endmodule