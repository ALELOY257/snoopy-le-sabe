module comp_frame_byte (
    input [7:0] rx_byte,
    input [7:0] frame_byte,

    output reg VF
);

always @(*) begin
    if (rx_byte == frame_byte) begin
        VF = 1;
    end else begin
        VF = 0;
    end
end
    
endmodule