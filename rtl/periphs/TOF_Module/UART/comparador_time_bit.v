module comparador_time_bit (
    input [9:0] counter,
    input [9:0] time_bit,
    
    output reg E
);

always @(*) begin
    if (counter == time_bit) begin
        E = 1;
    end else begin
        E = 0;
    end
end
    
endmodule