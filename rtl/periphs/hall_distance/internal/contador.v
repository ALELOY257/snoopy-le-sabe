module contador(
    input clk,
    input rst,
    input LD,
    input PADD,
    output pulse_count
);
    always @(posedge clk) begin
        if (LD)
            pulse_count <= 0;
        else if (PADD)
            pulse_count <= pulse_count + 1;
    end
endmodule