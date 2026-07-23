module uart (
    input clk,
    input rst_n,
    input rx_line,
    input data_received,
    
    output rx_error,
    output [7:0] rx_data,
    output data_available
);
    

wire [9:0] counter;
wire [9:0] time_bit;

wire zero;
wire equal;

wire load;
wire dec;
wire shift;
wire reset;
wire add;
wire SEL;


contador_dec count_dec (
    .clk(clk),
    .LD(load),
    .DEC(dec),
    
    .zero(zero)
);

rsr_rx_data rsr_rx_data (
    .clk(clk),
    .rx_line(rx_line),
    .LD(load),
    .SH(shift),
    
    .rx_data(rx_data)
);

contador count (
    .clk(clk),
    .RESET(reset),
    .ADD(add),
    
    .counter(counter)
);

mux mux (
    .SEL(SEL),
    
    .time_bit (time_bit)
);


comparador_time_bit comparador_time_bit (
    .counter(counter),
    .time_bit(time_bit),
    
    .E(equal)
);

uart_control uart_control (
    .clk(clk),
    .rst_n(rst_n),
    .rx_line(rx_line),
    .data_received(data_received),
    .zero(zero),
    .E(equal),
    
    .LD(load),
    .DEC(dec),
    .SH(shift),
    .RESET(reset),
    .ADD(add),
    .SEL(SEL),
    .rx_error(rx_error),
    .data_available(data_available)
);


endmodule