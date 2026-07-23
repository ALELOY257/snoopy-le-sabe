module contador (
    input clk,
    input RESET,
    input ADD,
    
    output [9:0] counter
);

    reg [9:0] counter_reg;
    
    assign counter = counter_reg;
    
    always @(negedge clk) begin
        if (RESET) begin
            counter_reg <= 10'b0000000000;
        end else if (ADD) begin
            counter_reg <= counter_reg + 1;
        end
    end

    
endmodule