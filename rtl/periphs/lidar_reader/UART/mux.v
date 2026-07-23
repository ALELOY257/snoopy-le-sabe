module mux (
    input SEL,
    
    output reg [9:0] time_bit
);


always @(*) begin
    if (SEL) begin
        time_bit = 10'b0001101100;
    end else begin
        time_bit = 10'b0000110110;
    end
end

    
endmodule