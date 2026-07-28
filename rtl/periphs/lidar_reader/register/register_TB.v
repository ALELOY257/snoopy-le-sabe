`timescale 10ns / 10ns
`define BENCH

module register_TB;

localparam N_BYTES = 110;

reg clk;
reg rst_r;
reg [7:0] rx_byte;
reg rx_error;
reg rx_available;

wire data_received;
wire [7:0] TOF_data [0:N_BYTES-1];

integer i;
reg [7:0] checksum;

// DUT
register #(
    .N_BYTES(N_BYTES)
) uut (
    .clk(clk),
    .rst_r(rst_r),
    .rx_byte(rx_byte),
    .rx_error(rx_error),
    .rx_available(rx_available),

    .data_received(data_received),
    .TOF_data(TOF_data)
);

// Reloj
initial clk = 0;
always #1 clk = ~clk;


// Tarea para enviar un byte al register
task send_byte;
    input [7:0] data;
    begin
        rx_byte = data;
        rx_error = 1'b0;
        rx_available = 1'b1;

        // Esperar a que el register reconozca el byte
        wait(data_received == 1'b1);

        @(posedge clk);

        // Simula que el UART recibió el data_received
        rx_available = 1'b0;

        // Espera a que baje data_received
        wait(data_received == 1'b0);

        @(posedge clk);
    end
endtask


initial begin
    $dumpfile("register_TB.vcd");
    $dumpvars(-1, register_TB);

    $monitor(
        "t=%0t rst_r=%b rx_byte=%h rx_av=%b rx_err=%b data_received=%b",
        $time, rst_r, rx_byte, rx_available, rx_error, data_received
    );
end


initial begin
    // Valores iniciales
    rst_r = 1'b1;
    rx_byte = 8'h00;
    rx_error = 1'b0;
    rx_available = 1'b0;

    repeat(5) @(posedge clk);

    // Salir del reset
    rst_r = 1'b0;

    repeat(5) @(posedge clk);

    // Checksum inicial: header + mark
    checksum = 8'h57 + 8'h01;

    // Enviar header
    send_byte(8'h57);

    // Enviar function mark
    send_byte(8'h01);

    // Enviar bytes de datos simulados
    // Aquí mando N_BYTES-1 datos y luego el checksum final.
    for (i = 0; i < N_BYTES-1; i = i + 1) begin
        checksum = checksum + i[7:0];
        send_byte(i[7:0]);
    end

    // Enviar checksum
    send_byte(checksum);

    repeat(20) @(posedge clk);

    // Revisiones simples
    if (TOF_data[0] !== 8'h00) begin
        $display("ERROR: TOF_data[0] debería ser 00, pero es %h", TOF_data[0]);
    end else begin
        $display("OK: TOF_data[0] = %h", TOF_data[0]);
    end

    if (TOF_data[1] !== 8'h01) begin
        $display("ERROR: TOF_data[1] debería ser 01, pero es %h", TOF_data[1]);
    end else begin
        $display("OK: TOF_data[1] = %h", TOF_data[1]);
    end

    $display("Checksum enviado = %h", checksum);

    repeat(20) @(posedge clk);

    $finish;
end

endmodule