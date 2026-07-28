module flanco(
    input clk,
    input rst,
    input hall_in,
    output reg HA
);
    reg hall_prev;
    always @(posedge clk) begin
        if (rst) begin
            hall_prev <= 0;
            HA <= 0;
        end
        else begin
            hall_prev <= hall_in;
            HA <= (hall_prev == 1) && (hall_in == 0);
        end
    end
endmodule