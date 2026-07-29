module fn_in_reg(
    input clk,
    input rst,
    input LDLINE,
    input [1:0]direction,
    output reg fn_in1,
    output reg fn_in2
);
    always @(negedge clk ) begin
        if (rst) begin
            fn_in1 <= 0;
            fn_in2 <= 0;
        end
        else if (LDLINE) begin
            fn_in1 <= direction[1];
            fn_in2 <= direction[0];
        end
    end
endmodule