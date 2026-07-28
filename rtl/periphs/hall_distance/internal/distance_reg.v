module distance_reg(
    input clk,
    input rst,
    input LD,
    input LDV,
    input [7:0] pp,
    output reg [7:0] distance
);
    always @(posedge clk) begin
        if (rst)
            distance <= 0;
        else if (LD)
            distance <= 0;
        else if (LDV)
            distance <= pp;
        
    end
endmodule