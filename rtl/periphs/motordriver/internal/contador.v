module contador(
    input clk,
    input rst,
    input LD,
    input ADDCOUNTER,
    input RSTCOUNTER,
    output reg [31:0] count_out
);

    always @(negedge clk ) begin
        if (rst)
            count_out <= 0;
        else if (LD)
            count_out <= 0;
        else if (ADDCOUNTER)
            count_out <= count_out + 1;
        else if (RSTCOUNTER)
            count_out <= 0;
    end
endmodule