module bcd (
            input  wire         clk,
            input  wire         load,
            input  wire         reset,
            input  wire [15:0]  number,



            output wire [3:0]   dig_5,
            output wire [3:0]   dig_4,
            output wire [3:0]   dig_3,
            output wire [3:0]   dig_2,
            output wire [3:0]   dig_1,
            output wire         ready
         );

    reg [15:0] number_r = 0;
    reg [3:0] dig_5_r = 0;
    reg [3:0] dig_4_r = 0;
    reg [3:0] dig_3_r = 0;
    reg [3:0] dig_2_r = 0;
    reg [3:0] dig_1_r = 0;

    assign dig_5 = dig_5_r;
    assign dig_4 = dig_4_r;
    assign dig_3 = dig_3_r;
    assign dig_2 = dig_2_r;
    assign dig_1 = dig_1_r;
    assign ready = state == IDLE ? 1'b1 : 1'b0;

    
    localparam IDLE = 0;        
    localparam WORK = 1;        

    reg [2:0] state = IDLE;

    always @(posedge clk) begin
        if( reset == 1 ) begin
            state <= IDLE;
        end
        case(state)
            IDLE: begin
                number_r <= number;

                if(load) begin
                    state <= WORK;
                    dig_5_r <= 0;
                    dig_4_r <= 0;
                    dig_3_r <= 0;
                    dig_2_r <= 0;
                    dig_1_r <= 0;
                end
            end
            WORK: begin
                number_r <= number_r - 1;
                dig_1_r <= dig_1_r + 1;

                if(dig_1_r == 9) begin
                    dig_1_r <= 0;
                    dig_2_r <= dig_2_r + 1;

                    if(dig_2_r == 9) begin
                        dig_2_r <= 0;
                        dig_3_r <= dig_3_r + 1;

                        if(dig_3_r == 9) begin
                            dig_3_r <= 0;
                            dig_4_r <= dig_4_r + 1;

                            if(dig_4_r == 9) begin
                                dig_4_r <= 0;
                                dig_5_r <= dig_5_r + 1;
                            end
                        end
                    end
                end

                if(number_r == 1)
                    state <= IDLE;
            end

        endcase
    end

endmodule
