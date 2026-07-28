module rsr_rx_data (
    input clk,
    input rx_line,
    input LD,
    input SH,
    
    output [7:0] rx_data
);

    reg [9:0] rx_data_reg;
    
    assign rx_data = rx_data_reg[8:1];
    
    always @(negedge clk) begin
        if (LD) begin
            rx_data_reg <= 10'b00000000;
        end else if (SH) begin
            rx_data_reg <= {rx_line, rx_data_reg[9:1]};
        end
    end
    
endmodule