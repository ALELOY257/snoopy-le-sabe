`timescale 10ns / 10ns
`define SIMULATION

module uart_TB;


reg clk;
reg rst_n;
reg rx_line;
reg data_received;
    
wire rx_error;
wire [7:0] rx_data;
wire data_available;

// Inicialización del modulo


uart uut ( 
    .clk (clk), .rst_n (rst_n), .rx_line (rx_line), .data_received (data_received), // Entradas
    .rx_error (rx_error), .rx_data (rx_data), .data_available (data_available) //Salidas
    
    );


initial clk = 0; 
always #1 clk = ~clk;


initial begin
    $dumpfile("uart_TB.vcd");
    $dumpvars(-1, uart_TB);

    $monitor("t=%0t rst_n=%b rx_line=%b data_received=%b rx_error=%b rx_data=%b data_available=%b", $time, rst_n, rx_line, data_received, rx_error, rx_data, data_available);
end


initial begin

    @(negedge clk);
    @(posedge clk);

    rst_n = 0;
    rx_line = 1;
    data_received = 0;

    @(negedge clk);
    @(posedge clk);

    rst_n = 0;
    rx_line = 0;
    data_received = 0;

    #109;

    rst_n = 0;
    rx_line = 0;
    data_received = 0;

    #217;

    rst_n = 0;
    rx_line = 0;
    data_received = 0;

    #230;

    rst_n = 0;
    rx_line = 0;
    data_received = 0;

    @(negedge clk);
    @(posedge clk);

    @(negedge clk);
    @(posedge clk);

    @(negedge clk);
    @(posedge clk);

    rst_n = 0;
    rx_line = 0;
    data_received = 1;

    wait(data_available == 1);

    #1000;

    $finish;
end



endmodule
