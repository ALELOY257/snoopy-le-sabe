module mux_register (
    input SEL,

    output reg [7:0] frame_byte
);

parameter HEADER = 8'h57;
parameter MARK   = 8'h01;


always @(*) begin
    if (SEL) begin
        frame_byte = MARK;
    end else begin
        frame_byte = HEADER;
    end
end
    
endmodule