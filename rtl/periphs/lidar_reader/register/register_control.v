module register_control #(

    // Estados de la máquina de control

    parameter START          = 4'b0000,
    parameter CHECK_RX0      = 4'b0001,
    parameter SEND_RECEIVED0 = 4'b0010,
    parameter CHECK_HEADER   = 4'b0011,
    parameter CHECK_RX1      = 4'b0100,
    parameter SEND_RECEIVED1 = 4'b0101,
    parameter CHECK_MARK     = 4'b0110,
    parameter CHECK_RX2      = 4'b0111,
    parameter SEND_RECEIVED2 = 4'b1000,
    parameter LOAD_BYTE      = 4'b1001,
    parameter ACC_ADD        = 4'b1010,
    parameter CHECK_COUNT    = 4'b1011,
    parameter CHECK_SC       = 4'b1100,
    parameter FINISH         = 4'b1101

) (

    input clk,
    input rst_r,

    input rx_error,
    input rx_available,
    input VF,
    input CS,
    input Z,

    output reg RST,
    output reg LDbyte,
    output reg SEL,
    output reg ACC,
    output reg ADDI,
    output reg data_received

);

    reg [3:0] current_state;
    reg [4:0] count;


    // Máquina de estados
    always @(posedge clk) begin

        if (rst_r) begin
            current_state <= START;
        end else begin

            case (current_state)

                START: begin
                    count = 5'b0;
                    current_state <= CHECK_RX0;
                end

                CHECK_RX0: begin
                    if (rx_error == 1'b0 && rx_available == 1'b1) begin
                        current_state <= SEND_RECEIVED0;
                    end else begin
                        current_state <= CHECK_RX0;
                    end
                end

                SEND_RECEIVED0: begin
                    current_state <= CHECK_HEADER;
                end

                CHECK_HEADER: begin
                    if (VF) begin
                        current_state <= CHECK_RX1;
                    end else begin
                        current_state <= START;
                    end
                end

                CHECK_RX1: begin
                    if (rx_error == 1'b0 && rx_available == 1'b1) begin
                        current_state <= SEND_RECEIVED1;
                    end else begin
                        current_state <= CHECK_RX1;
                    end
                end

                SEND_RECEIVED1: begin
                    current_state <= CHECK_MARK;
                end

                CHECK_MARK: begin
                    if (VF) begin
                        current_state <= CHECK_RX2;
                    end else begin
                        current_state <= START;
                    end
                end

                CHECK_RX2: begin
                    if (rx_error == 1'b0 && rx_available == 1'b1) begin
                        current_state <= SEND_RECEIVED2;
                    end else begin
                        current_state <= CHECK_RX2;
                    end
                end

                SEND_RECEIVED2: begin
                    current_state <= LOAD_BYTE;
                end

                LOAD_BYTE: begin
                    current_state <= ACC_ADD;
                end

                ACC_ADD: begin
                    current_state <= CHECK_COUNT;
                end

                CHECK_COUNT: begin
                    if (Z) begin
                        current_state <= CHECK_SC;
                    end else begin
                        current_state <= CHECK_RX2;
                    end
                end
 
                CHECK_SC: begin
                    if (CS) begin
                        current_state <= FINISH;
                    end else begin
                        current_state <= START;
                    end
                end

                FINISH: begin
                    count = count + 1;
                    current_state <= (count>28) ? START : FINISH ;
                end

                default: begin
                    current_state <= START;
                end

            endcase
        end
    end


    // Salidas según el estado
    always @(*) begin

        case (current_state)

            START: begin
                RST           = 1'b1;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0;
                SEL           = 1'b0;
            end

            CHECK_RX0: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0;
                SEL = 1'b0;
            end

            SEND_RECEIVED0: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;
                SEL           = 1'b0;
            end

            CHECK_HEADER: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;             
                SEL = 1'b0;
            end

            CHECK_RX1: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0;   
                SEL = 1'b1;
            end

            SEND_RECEIVED1: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;
                SEL           = 1'b1;
            end

            CHECK_MARK: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;  
                SEL = 1'b1;
            end

            CHECK_RX2: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0; 
                SEL = 1'b0;
            end

            SEND_RECEIVED2: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;
                SEL           = 1'b0;
            end

            LOAD_BYTE: begin
                RST           = 1'b0;
                LDbyte        = 1'b1;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b1;
                SEL           = 1'b0;
            end

            ACC_ADD: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b1;
                ADDI          = 1'b1;
                data_received = 1'b1;
                SEL           = 1'b0;
            end

            CHECK_COUNT: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0; 
                SEL = 1'b0;
            end

            CHECK_SC: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0; 
                SEL = 1'b0;
            end

            FINISH: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0;
                SEL           = 1'b0;
            end

            default: begin
                RST           = 1'b0;
                LDbyte        = 1'b0;
                SEL           = 1'b0;
                ACC           = 1'b0;
                ADDI          = 1'b0;
                data_received = 1'b0;
            end

        endcase
    end


`ifdef BENCH
    reg [8*16-1:1] state_name;

    always @(*) begin
        case (current_state)
            START:          state_name = "START";
            CHECK_RX0:      state_name = "CHECK_RX0";
            SEND_RECEIVED0: state_name = "SEND_RECEIVED0";
            CHECK_HEADER:   state_name = "CHECK_HEADER";
            CHECK_RX1:      state_name = "CHECK_RX1";
            SEND_RECEIVED1: state_name = "SEND_RECEIVED1";
            CHECK_MARK:     state_name = "CHECK_MARK";
            CHECK_RX2:      state_name = "CHECK_RX2";
            SEND_RECEIVED2: state_name = "SEND_RECEIVED2";
            LOAD_BYTE:      state_name = "LOAD_BYTE";
            ACC_ADD:        state_name = "ACC_ADD";
            CHECK_COUNT:    state_name = "CHECK_COUNT";
            CHECK_SC:       state_name = "CHECK_SC";
            FINISH:         state_name = "FINISH";
            default:        state_name = "UNKNOWN";
        endcase
    end
`endif

endmodule