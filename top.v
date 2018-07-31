`default_nettype none

module top (
	input  clk,
    output [4:0] leds,
    output hsync,
    output vsync,
    output r1,
    output r2,
    output g1,
    output g2,
    output b1,
    output b2

);
    parameter [5:0] green  = 6'b001100;
    parameter [5:0] white  = 6'b111111;
    parameter [5:0] purple = 6'b010001;

    reg reset = 1;
    always @(posedge clk)
        reset <= 0;

    wire [9:0] x_px;
    wire [9:0] y_px;
    wire px_clk;
    wire activevideo;
    wire [5:0] color_px;

    VgaSyncGen vga_inst( .clk(clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .px_clk(px_clk), .activevideo(activevideo));

    assign r1 = activevideo & color_px[0];
    assign r2 = activevideo & color_px[1];
    assign g1 = activevideo & color_px[2];
    assign g2 = activevideo & color_px[3];
    assign b1 = activevideo & color_px[4];
    assign b2 = activevideo & color_px[5];

    assign color_px = number_color_px | purple;
    wire [5:0] number_color_px;

    parameter X_OFFSET = 64;
    parameter Y_OFFSET = 176;
    parameter SCALE = 3;

    reg [20:0] count;
    reg [15:0] var = 16'd0;
    always @(posedge clk)
        count <= count + 1;
    wire slow_clk = count[18];

    always @(posedge slow_clk) begin
        var <= var + 1;
        if(var == 16'd9999)
            var <= 16'd0;
    end

    assign leds = var;

    reg last_vsync = 0;
    always @(posedge px_clk)
        last_vsync <= vsync;

    always @(posedge px_clk)
        if(bcd_ready)
            bcd <= {dig_4, dig_3, dig_2, dig_1};
    
    reg [15:0] bcd;
    wire bcd_ready;
    wire [3:0] dig_4, dig_3, dig_2, dig_1;

    
    wire load_bcd = last_vsync == 1'b1 && vsync == 1'b0; // convert next number every new screen

    bcd bcd_0(.reset(reset), .clk(px_clk), .load(load_bcd), .ready(bcd_ready), .number(var), .dig_1(dig_1), .dig_2(dig_2), .dig_3(dig_3), .dig_4(dig_4));

    numbers #( .scale(SCALE), .ink(green), .x_off(X_OFFSET), .y_off(Y_OFFSET)) numbers_0(.clk(px_clk), .x_px(x_px), .y_px(y_px), .var0(bcd), .color_px(number_color_px));

endmodule
