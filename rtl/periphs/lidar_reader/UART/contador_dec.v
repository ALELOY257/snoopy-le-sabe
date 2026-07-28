module contador_dec (

    input clk,
    input LD,
    input DEC,

    output reg zero

);

reg [7:0] out;

    always @(negedge clk) begin
        if (LD) begin
            out <= 7'b0001000;
        end else if (DEC) begin
            out <= out - 1;
            zero = (out == 0); //Señal que se activa una vez el contador llega a 0
        end
    end



    
endmodule