module distance_reg(
    input clk,
    input rst,
    input LD,
    input LDV,
    output reg [7:0] distance
);
    always @(posedge clk) begin
        if (rst)
            distance <= 0;
        else if (LD)
            distance <= 0;
        else if (LDV)
            distance <= distance + 8'd19;
    end
endmodule