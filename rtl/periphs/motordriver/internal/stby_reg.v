module stby_reg(
    input clk,
    input rst,
    input LD,
    output reg stby
);

    always @(negedge clk ) begin
        if (rst)
            stby <= 0;
        else if (LD)
            stby <= 1;
    end
endmodule