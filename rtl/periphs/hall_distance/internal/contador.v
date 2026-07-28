module contador(
    input clk,
    input rst,
    input LD,
    input PADD,
    output reg [7:0] pulse_count
);
    always @(posedge clk) begin
        if (rst)
            pulse_count <= 0;
        else if (LD)
            pulse_count <= 0;
        else if (PADD)
            pulse_count <= pulse_count + 1;
    end
endmodule