module control_motor(
    input clk,
    input rst,
    input v_dc,
    input v_pwm,
    input v_dir,
    input v_time,
    input pwm,
    input init,
    output reg LD,
    output reg ADDTIME,
    output reg RSTTIME,
    output reg RSTPWM,
    output reg ADDPWM,
    output reg ADDDC,
    output reg LDLINE
);

    localparam START =       4'b0000;
    localparam CHECKDIR =    4'b0001;
    localparam FNLOW =       4'b0010;
    localparam FNPWM =       4'b0011;
    localparam CHECKTIME =   4'b0100;
    localparam CHECKPWM =    4'b0101;
    localparam CNTZERORT =   4'b0110;
    localparam ADDCNTRT =    4'b0111;
    localparam ACTPWM =      4'b1000;
    localparam CHECKRTDC =   4'b1001;
    localparam INCREMENTDC = 4'b1010;
    localparam CHECKPCDC =   4'b1011;
    localparam DONEPWM =     4'b1100;

    reg [3:0] current_state, next_state;

    always @(posedge clk) begin
        if (rst)
            current_state <= START;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            START: begin
                if (init) next_state <= CHECKDIR;
                else next_state <= START;
            end

            CHECKDIR: begin
                if (v_dir) next_state <= FNLOW;
                else next_state <= FNPWM;
            end

            FNLOW: begin
                next_state <= CHECKDIR;
            end

            FNPWM: begin
                next_state <= CHECKPWM;
            end

            CHECKPWM: begin
                if (v_pwm) next_state <= ACTPWM;
                else next_state <= CHECKTIME;
            end

            ACTPWM: begin
                next_state <= CHECKTIME;
            end

            CHECKTIME: begin
                if (v_time) next_state <= CNTZERORT;
                else next_state <= ADDCNTRT;
            end

            CNTZERORT: begin
                next_state <= CHECKRTDC;
            end

            ADDCNTRT: begin
                next_state <= CHECKRTDC;
            end

            CHECKRTDC: begin
                if (v_dc) next_state <= INCREMENTDC;
                else next_state <= CHECKPCDC;
            end

            INCREMENTDC: begin
                next_state <= CHECKPCDC;
            end

            CHECKPCDC: begin
                next_state <= DONEPWM;
            end

            DONEPWM: begin
                next_state <= CHECKDIR;
            end

            default: next_state <= START;
        endcase
    end

    always @(*) begin
        LD=0;
        ADDTIME=0;
        RSTTIME=0; 
        RSTPWM=0; 
        ADDPWM=0; 
        ADDDC=0;
        LDLINE=0;
        case (current_state)
            START: begin
                LD=1;
            end

            CHECKDIR: begin
            end

            FNLOW: begin
                LDLINE=1;
            end

            FNPWM: begin
                LDLINE=1;
                ADDPWM=1;
            end

            CHECKPWM: begin
            end

            ACTPWM: begin
                RSTPWM =1 ;
            end

            CHECKTIME: begin
            end

            CNTZERORT: begin
                RSTTIME = 1;
            end

            ADDCNTRT: begin
                ADDTIME = 1;
            end

            CHECKRTDC: begin
            end

            INCREMENTDC: begin
                ADDDC =1;
            end

            CHECKPCDC: begin
            end

            DONEPWM: begin
            end

        endcase
    end
endmodule