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

localparam integer BIT_TICKS = 217;

// Inicialización del módulo
uart uut ( 
    .clk(clk),
    .rst_n(rst_n),
    .rx_line(rx_line),
    .data_received(data_received),

    .rx_error(rx_error),
    .rx_data(rx_data),
    .data_available(data_available)
);

// Reloj
initial clk = 0; 
always #1 clk = ~clk;

// Tarea para enviar un byte UART
task send_uart_byte;
    input [7:0] data;
    integer i;
    begin
        // Línea en reposo
        rx_line = 1'b1;
        repeat(BIT_TICKS) @(posedge clk);

        // Start bit
        rx_line = 1'b0;
        repeat(BIT_TICKS) @(posedge clk);

        // Datos LSB primero
        for (i = 0; i < 8; i = i + 1) begin
            rx_line = data[i];
            repeat(BIT_TICKS) @(posedge clk);
        end

        // Stop bit
        rx_line = 1'b1;
        repeat(BIT_TICKS) @(posedge clk);
    end
endtask

initial begin
    $dumpfile("uart_TB.vcd");
    $dumpvars(-1, uart_TB);

    $monitor(
        "t=%0t rst_n=%b rx_line=%b data_received=%b rx_error=%b rx_data=%h data_available=%b",
        $time, rst_n, rx_line, data_received, rx_error, rx_data, data_available
    );
end

initial begin
    // Valores iniciales
    rst_n = 1'b0;
    rx_line = 1'b1;
    data_received = 1'b0;

    // Mantener reset unos ciclos
    repeat(5) @(posedge clk);

    // Salir de reset
    rst_n = 1'b1;

    repeat(5) @(posedge clk);

    // Enviar byte de prueba
    send_uart_byte(8'h57);

    // Esperar dato disponible
    wait(data_available == 1'b1);

    @(posedge clk);

    // Verificación básica
    if (rx_error) begin
        $display("ERROR: El UART marcó rx_error.");
    end else if (rx_data !== 8'h57) begin
        $display("ERROR: Se esperaba 57, pero se recibió %h", rx_data);
    end else begin
        $display("OK: Byte recibido correctamente: %h", rx_data);
    end

    // Confirmar que el dato fue leído
    data_received = 1'b1;
    @(posedge clk);
    data_received = 1'b0;

    repeat(20) @(posedge clk);

    $finish;
end

endmodule