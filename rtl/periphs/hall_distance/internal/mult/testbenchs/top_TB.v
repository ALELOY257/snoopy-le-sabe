`timescale 1ns/1ps

module top_TB;

reg clk;
reg init;
reg rst;
reg [3:0] A;
reg [3:0] B;

wire [7:0] res;
wire done;

top instance1 (
    .clk(clk), 
    .rst(rst), 
    .init(init), 
    .A(A), 
    .B(B), 
    .pp(res), 
    .done(done)
);

initial clk = 0;
always #20 clk = ~clk;

initial begin
    $dumpfile("top_TB.vcd");
    $dumpvars(0, top_TB); 

    A = 0; B = 0; init = 0; rst = 1;
    #40 rst = 0;

    @(negedge clk);
    A = 3;
    B = 4;
    init = 1;
    
    @(negedge clk);
    init = 0; 

    wait(done); 
    
    #100; 
    $finish;
end

endmodule