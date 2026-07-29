module top_motor(
    input clk,
    input rst,
    input init,
    input [1:0]direction, // i have to evaluate the option of a rst being needed when a change of direction is passed
    output stby,
    output fn_in1,
    output fn_in2,
    output pwm
);
    wire v_dc, v_pwm, v_dir, v_time;
    wire LD, ADDTIME, RSTTIME, RSTPWM, ADDPWM, ADDDC,LDLINE;
    wire [7:0] pwm_count, dc_count;
    wire [31:0] time_count;
    wire ramp_tick;

    control_motor u_ctrl(
        .clk(clk), .rst(rst), .v_dc(v_dc), .v_pwm(v_pwm), .v_dir(v_dir), .v_time(v_time), .pwm(pwm), .init(init),
        .LD(LD), .ADDTIME(ADDTIME), .RSTTIME(RSTTIME), .RSTPWM(RSTPWM), .ADDPWM(ADDPWM), .ADDDC(ADDDC), .LDLINE(LDLINE)
    );

    stby_reg u_stby_reg(
        .clk(clk), .rst(rst), .LD(LD),
        .stby(stby)
    );

    comparador u_comp_dir( 
        .a(direction), .b(2'b00), .mode(2'b00),
        .v(v_dir)
    );

    fn_in_reg u_fn_in_reg(
        .clk(clk), .rst(rst), .LDLINE(LDLINE), .direction(direction),
        .fn_in1(fn_in1), .fn_in2(fn_in2)
    );

    contador u_count_pwm(
        .clk(clk), .rst(rst), .LD(LD), .ADDCOUNTER(ADDPWM), .RSTCOUNTER(RSTPWM),
        .count_out(pwm_count)
    );

    contador u_count_time(
        .clk(clk), .rst(rst), .LD(LD), .ADDCOUNTER(ADDTIME), .RSTCOUNTER(RSTTIME),
        .count_out(time_count)
    );

    contador u_count_dc(
        .clk(clk), .rst(rst), .LD(LD), .ADDCOUNTER(ADDDC), .RSTCOUNTER(),
        .count_out(dc_count)
    );

    comparador u_comp_pwm(
        .a(pwm_count), .b(255), .mode(2'b00),
        .v(v_pwm)
    );

    comparador u_comp_time(
        .a(time_count), .b(250000), .mode(2'b00),
        .v(v_time)
    );

    ramp_tick_reg u_ramp_tick( // this could be omitted with v_time, for now and for clarity, it will remain like this
        .v_time(v_time),
        .ramp_tick(ramp_tick)
    );

    comparador u_comp_rtdc(
        .a(ramp_tick), .b(1), .c(dc_count), .d(8'd255), .mode(2'b11),
        .v(v_dc)
    );

    comparador u_comp_pwmdc(
        .a(pwm_count), .b(dc_count), .mode(2'b01),
        .pwm(pwm)
    );
    
endmodule