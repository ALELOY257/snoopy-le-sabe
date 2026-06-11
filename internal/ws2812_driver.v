module ws2812_driver(
    input clk,
    input rst,
    input [23:0] pixel_data,
    output reg [9:0] pixel_addr,
    output reg data_out
);

    // This might change if the datasheet i used is incorrenct :(
    parameter T1H = 23;
    parameter T1L = 9;
    parameter T0H = 9;
    parameter T0L = 23;
    parameter TRESET = 1250;

    localparam IDLE = 2'd0 ;
    localparam SEND_HIGH = 2'd1 ;
    localparam SEND_LOW = 2'd2;
    localparam RESET = 2'd3;

    reg [1:0] state;
    reg [10:0] counter;
    reg [4:0] bit_index;

    always @(posedge clk) begin
        if (rst) begin 
            state <= IDLE;
            counter <= 0;
            bit_index <= 23;
            pixel_addr <= 0;
            data_out <= 0;
        end else begin
                case (state)
                IDLE:begin
                    data_out <= 0;
                    counter <=0;
                    bit_index <= 23;
                    state <= SEND_HIGH;
                end

                SEND_HIGH: begin
                    data_out <= 1;
                    if(counter < (pixel_data[bit_index] ? T1H : T0H)) begin
                        counter <= counter +1;
                    end else begin
                        counter <= 0;
                        state <= SEND_LOW;
                    end
                end

                SEND_LOW: begin
                    data_out <= 0;
                    if (counter < (pixel_data[bit_index] ? T1L : T0L))begin
                        counter <= counter +1;
                    end else begin
                        counter <= 0;

                        if (bit_index > 0) begin
                            bit_index <= bit_index -1;
                            state <= SEND_HIGH;
                        end else if (pixel_addr < 1023) begin
                            pixel_addr <= pixel_addr +1;
                            bit_index <= 23;
                            state <= SEND_HIGH;
                        end else begin
                            state <= RESET;
                        end
                    end
                end

                RESET: begin
                    data_out <= 0;
                    if (counter < TRESET) begin
                        counter <= counter +1;
                    end else begin
                        counter <= 0;
                        pixel_addr <= 0;
                        bit_index <= 23;
                        state <= SEND_HIGH;
                    end
                end
            endcase
        end


    end
endmodule
