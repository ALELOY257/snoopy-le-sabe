module rsr_rx_data (
    input clk,
    input rx_line,
    input LD,
    input SH,
    
    output [7:0] rx_data
);

    reg [7:0] rx_data_reg;
    
    assign rx_data = rx_data_reg;
    
    always @(posedge clk) begin
        if (LD) begin
            rx_data_reg <= 8'b00000000;
        end else if (SH) begin
            rx_data_reg <= {rx_line, rx_data_reg[7:1]};
        end
    end
    
endmodule