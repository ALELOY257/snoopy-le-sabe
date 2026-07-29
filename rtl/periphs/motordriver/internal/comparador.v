module comparador(
    input  [31:0]a,
    input  [31:0]b,
    input  [7:0] c,
    input  [7:0]d,
    input  [1:0] mode,
    output reg v
);
// este modulo usa un tercer output de "mode" pa evitarme escribir tres archivos de comparador
// 00 es para comparador de igualdad
// 01 es para comparador de a menor que b
// 10 es para comparador b menor que a
// 11 es para comparador doble (en este caso el de ramp_tick y duty_cycle del diagrama)
    always @* begin
        case (mode)
            2'b00: v = (a == b);
            2'b01: v = (a < b);
            2'b10: v = (a >= b);
            2'b11: v = (a == 1'b1 && c < d);
            default: v = 1'b0;
        endcase
    end

endmodule