module comparador(
    input a,
    input b,
    output v
);
    assign v = (a == b) ? 1'b1 : 1'b0;
endmodule