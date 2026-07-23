module contador_register (
    input clk,
    input RST,
    input ADDI,

    output reg [7:0] count
);

always @(negedge clk) begin
    if (RST) begin
        count = 8'b0;
    end else if (ADDI) begin
        count = count + 1;
    end
end
    
endmodule