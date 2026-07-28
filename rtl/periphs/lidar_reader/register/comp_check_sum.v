module comp_check_sum (
    input [7:0] check_sum,
    input [7:0] rx_byte,

    output reg valid_CS
);

always @(*) begin
     if (check_sum == rx_byte) begin
        valid_CS = 1;
     end else begin
        valid_CS = 0;
     end
end



endmodule