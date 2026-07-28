module TOF_data_register #(
    parameter N_BYTES = 110
)(
    input clk,

    input [7:0] rx_byte,
    input [7:0] count,

    input LDbyte,

    output reg [7:0] TOF_data [0:N_BYTES-1]
);
    
always @(negedge clk) begin
    if (LDbyte) begin
        TOF_data[count] = rx_byte;
    end
end




endmodule