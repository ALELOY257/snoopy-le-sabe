module uart_control #(

// Establecimiento de los estados como parámetros

    parameter START        = 4'b0000,
    parameter CHECK_SB0    = 4'b0001,
    parameter ADD_COUNT0   = 4'b0010,
    parameter CHECK_COUNT0 = 4'b0011,
    parameter CHECK_SB1    = 4'b0100,
    parameter SH_RST       = 4'b0101,
    parameter ADD_COUNT1   = 4'b0110,
    parameter CHECK_COUNT1 = 4'b0111,
    parameter DEC_I        = 4'b1000,
    parameter CHECK_I      = 4'b1001,
    parameter CHECK_EB     = 4'b1010,
    parameter RX_AVAIL     = 4'b1011,
    parameter RX_ERROR     = 4'b1100,
    parameter CHECK_RECEV  = 4'b1101,
    parameter END_STATE    = 4'b1110

) (

    input clk,
    input zero,
    input E,
    input rx_line,
    input data_received,
    input rst_n,
    
    output reg LD,
    output reg SH,
    output reg DEC,
    output reg RESET,
    output reg ADD,
    output reg SEL,
    output reg rx_error,
    output reg data_available

);


    reg [3:0] current_state;
    reg [4:0] count;


    always @(posedge clk) begin

        if(!rst_n) begin
            current_state <= START;
            
        end else begin

            case (current_state)
                START: begin
                    current_state <= CHECK_SB0;
                    count <= 5'd0;
                end

                CHECK_SB0: begin
                    if(!rx_line) begin
                        current_state <= ADD_COUNT0;
                    end else begin 
                        current_state <= CHECK_SB0;
                    end
                end



                ADD_COUNT0: begin
                    current_state <= CHECK_COUNT0;
                end

                CHECK_COUNT0: begin
                    if(E) begin
                        current_state <= CHECK_SB1;
                    end else begin 
                        current_state <= ADD_COUNT0;
                    end
                end

                CHECK_SB1: begin
                   if(!rx_line) begin
                        current_state <= SH_RST;
                    end else begin 
                        current_state <= START;
                    end
                end

                SH_RST: begin
                    current_state <= ADD_COUNT1;
                end

                ADD_COUNT1: begin
                    current_state <= CHECK_COUNT1;
                end

                CHECK_COUNT1: begin
                    if (E) begin
                        current_state <= CHECK_I;
                    end else begin
                        current_state <= ADD_COUNT1;
                    end
                end

                CHECK_I: begin
                    if (zero) begin
                        current_state <= CHECK_EB;
                    end else begin
                        current_state <= DEC_I;
                    end
                end

                DEC_I: begin
                    current_state <= SH_RST;
                end

                CHECK_EB: begin
                    if (rx_line) begin
                        current_state <= RX_AVAIL;
                    end else begin
                        current_state <= RX_ERROR;
                    end
                end

                RX_AVAIL: begin
                    current_state <= CHECK_RECEV;
                end

                RX_ERROR: begin
                    current_state <= END_STATE;
                end

                CHECK_RECEV: begin
                    if (data_received) begin
                        current_state <= END_STATE;
                    end else begin
                        current_state <= CHECK_RECEV;
                    end
                end

                END_STATE: begin
                    count = count + 1;
                    current_state <= (count>28) ? START : END_STATE ;
                end

                default: current_state <= START;
            
            endcase
        end
    end

// Salidas según el estado

always @(*) begin

    case (current_state)

        START: begin
            LD    = 1'b1;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b1;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        CHECK_SB0: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        ADD_COUNT0: begin
            LD    = 1'b0;
            ADD = 1'b1;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        CHECK_COUNT0: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end 

        CHECK_SB1: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end 

        SH_RST: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b1;
            SH   = 1'b1;
            DEC  = 1'b0;
            RESET  = 1'b1;
            rx_error = 1'b0;
            data_available = 1'b0;
        end   

        ADD_COUNT1: begin
            LD    = 1'b0;
            ADD = 1'b1;
            SEL   = 1'b1;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        CHECK_COUNT1: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b1;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        CHECK_I: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end


        DEC_I: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b1;
            SH   = 1'b0;
            DEC  = 1'b1;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        CHECK_EB: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        RX_AVAIL: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b1;
        end

        CHECK_RECEV: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b1;
        end

        RX_ERROR: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b1;
            data_available = 1'b0;
        end


        END_STATE: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

        default: begin
            LD    = 1'b0;
            ADD = 1'b0;
            SEL   = 1'b0;
            SH   = 1'b0;
            DEC  = 1'b0;
            RESET  = 1'b0;
            rx_error = 1'b0;
            data_available = 1'b0;
        end

    endcase
end

//Bloque que asigna codigos ASCII a las señales

`ifdef BENCH
reg [8*12-1:1] state_name;
always @(*) begin
    case (current_state)
        START: state_name = "START";
        CHECK_SB0: state_name = "CHECK_SB0";
        ADD_COUNT0: state_name = "ADD_COUNT0";
        CHECK_COUNT0: state_name = "CHECK_COUNT0";
        CHECK_SB1: state_name = "CHECK_SB1";
        SH_RST: state_name = "SH_RST";
        ADD_COUNT1: state_name = "ADD_COUNT1";
        CHECK_COUNT1: state_name = "CHECK_COUNT1";
        DEC_I: state_name = "DEC_I";
        CHECK_I: state_name = "CHECK_I";
        CHECK_EB: state_name = "CHECK_EB";
        RX_AVAIL: state_name = "RX_AVAIL";
        RX_ERROR: state_name = "RX_ERROR";
        CHECK_RECEV: state_name = "CHECK_RECEV";
        END_STATE: state_name = "END_STATE";
    endcase
end
`endif


endmodule