module flanco(
    input clk,
    input rst,
    input hall_in,
    output HA
);
    reg hall_prev;
    always @(posedge clk) begin
        hall_prev <= sensor_in;
        HA <= (hall_prev == 1) && (hall_in == 0)
    end
endmodule