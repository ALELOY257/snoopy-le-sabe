module acc_check_sum (
    input clk,
    input [7:0] rx_byte,
    input RST,
    input ACC,

    output reg [7:0] check_sum
);

parameter HEADER = 8'h57;
parameter MARK   = 8'h01;

always @(negedge clk) begin
    if (RST) begin
        check_sum = HEADER + MARK;
    end else if (ACC) begin
        check_sum = check_sum + rx_byte;
    end
end

    
endmodule