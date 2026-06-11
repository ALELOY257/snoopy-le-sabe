module framebuffer(
    input clk,
    input [9:0] read_addr,
    output reg [23:0] pixel_out,

    input [9:0] write_addr,
    input [23:0] write_data,
    input write_en
);
    reg [23:0] mem [0:1023];

    always @(posedge clk) begin
        pixel_out <= mem[read_addr];

        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

endmodule