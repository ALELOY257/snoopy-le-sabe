module control_hall(
    input clk,
    input rst,
    input HA,
    input init,
    output reg PADD,
    output reg LD,
    output reg LDV
);

    localparam START = 3'b000;
    localparam F_INACTIVE = 3'b001;
    localparam F_ACTIVE = 3'b010;
    localparam PCOUNT = 3'b011;
    localparam ADD_DISTANCE = 3'b100;

    reg [2:0] current_state, next_state;

    always @(posedge clk) begin
        if (rst)
            current_state <= START;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            START: begin
                if (init) next_state <= F_INACTIVE;
                else next_state <= START;
            end

            F_INACTIVE: begin
                if (HA) next_state <= F_ACTIVE;
                else next_state <= F_INACTIVE;
            end

            F_ACTIVE: begin
                if (HA) next_state <= F_ACTIVE;
                else next_state <= PCOUNT;
            end

            PCOUNT: begin
                next_state <= ADD_DISTANCE;
            end

            ADD_DISTANCE: begin
                next_state <= F_INACTIVE;
            end

            default: next_state <= START;
        endcase
    end

    always @(*) begin
        PADD = 0;
        LD = 0;
        LDV = 0;
        case (current_state)
            START: begin
                LD=1;
            end

            F_INACTIVE: begin
            end

            F_ACTIVE: begin
            end

            PCOUNT: begin
                PADD=1;
            end

            ADD_DISTANCE: begin
                LDV = 1;
            end

        endcase
    end
endmodule