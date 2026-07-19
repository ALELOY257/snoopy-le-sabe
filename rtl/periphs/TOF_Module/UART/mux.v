module mux (
    input SEL,
    
    output reg [9:0] time_bit
);


always @(*) begin
    if (SEL) begin
        time_bit = 10'b0011011001;
    end else begin
        time_bit = 10'b0001101101;
    end
end

    
endmodule