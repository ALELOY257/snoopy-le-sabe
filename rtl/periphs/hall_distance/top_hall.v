module top_hall(
    input clk,
    input rst,
    input hall_in,
    input init,
    output [7:0] distance
);

    wire HA, v;
    wire PADD, LD, DMULT, LDV;
    wire [3:0] pulse_count;
    wire [7:0] pp; // poner los bits
    wire mult_done;

    control_hall u_ctrl(
        .clk(clk), .rst(rst), .HA(HA), .v(v), .init(init),
        .PADD(PADD), .LD(LD), .DMULT(DMULT), .LDV(LDV)
    );

    flanco u_flanco(
        .clk(clk), .rst(rst), .hall_in(hall_in),
        .HA(HA)
    );

    contador u_pulse_count(
        .clk(clk), .rst(rst), .LD(LD), .PADD(PADD),
        .pulse_count(pulse_count)
    );

    distance_reg u_distance_reg(
        .clk(clk), .rst(rst), .LD(LD), .LDV(LDV), .pp(pp),
        .distance(distance)
    );

    comparador u_comparador(
        .a(mult_done), .b(1'd1),
        .v(v)
    );

    mult_top u_mult( // ver la remplazabilidad de esto por un sumador y ya
        .clk(clk), .rst(rst), .init(DMULT),
        .A(pulse_count), .B(7),// este b depende de cuando elijamos la rueda
        .pp(pp), .done(mult_done)
    );



endmodule