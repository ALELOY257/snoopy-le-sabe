module register #(
    parameter N_BYTES = 8'b01101110

) (
    input clk,
    input rst_r,
    input [7:0] rx_byte,
    input rx_error,
    input rx_available,

    output data_received,
    output [7:0] TOF_data [0: N_BYTES - 1]

);

wire [7:0] count;
wire [7:0] frame_byte;
wire [7:0] check_sum;

wire VF;
wire CS;
wire Z;

wire reset;
wire load_byte;
wire SEL;
wire acc_CS;
wire add_1;




TOF_data_register #(
    .N_BYTES(N_BYTES)
) TOF_data_register (
    .clk(clk),
    .rx_byte(rx_byte),
    .count(count),
    .LDbyte(load_byte),

    .TOF_data(TOF_data)
);

mux_register mux_register (
    .SEL(SEL),

    .frame_byte(frame_byte)
);

comp_frame_byte comp_frame_byte (
    .rx_byte(rx_byte),
    .frame_byte(frame_byte),

    .VF(VF)
);

acc_check_sum acc_check_sum (
    .clk(clk),
    .rx_byte(rx_byte),
    .RST(reset),
    .ACC(acc_CS),

    .check_sum(check_sum)
);

comp_check_sum comp_check_sum (
    .check_sum(check_sum),
    .rx_byte(rx_byte),

    .valid_CS(CS)
);

contador_register contador_register (
    .clk(clk),
    .RST(reset),
    .ADDI(add_1),

    .count(count)
);

comp_contador comp_contador (
    .count(count),

    .Z(Z)
);

register_control register_control (
    .clk(clk),
    .rst_r(rst_r),
    .rx_error(rx_error),
    .rx_available(rx_available),
    .VF(VF),
    .CS(CS),
    .Z(Z),

    .RST(reset),
    .LDbyte(load_byte),
    .SEL(SEL),
    .ACC(acc_CS),
    .ADDI(add_1),
    .data_received(data_received)
);


    
endmodule