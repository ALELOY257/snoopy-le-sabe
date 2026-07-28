module comp_contador (
    input [7:0] count,

    output reg Z
);

parameter N_BYTES = 110;

always @(*) begin
    if (count == N_BYTES - 1) begin
        Z = 1;
    end else begin
        Z = 0;
    end
end
    
endmodule