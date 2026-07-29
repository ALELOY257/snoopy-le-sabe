module top_hall(
    input clk,
    input rst,
    input hall_in,
    input init,
    output [7:0] distance
);

    wire HA;
    wire PADD, LD, LDV;
    wire [3:0] pulse_count;

    control_hall u_ctrl(
        .clk(clk), .rst(rst), .HA(HA),.init(init),
        .PADD(PADD), .LD(LD), .LDV(LDV)
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
        .clk(clk), .rst(rst), .LD(LD), .LDV(LDV), 
        .distance(distance)
    );


endmodule