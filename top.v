`default_nettype none

module top (
	input  clk,
    output LED,
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

    assign color_px = number_color_px;
    wire [5:0] number_color_px;

    parameter X_OFFSET = 64;
    parameter Y_OFFSET = 176;
    parameter SCALE = 3;

    reg [19:0] count;
    reg [15:0] var = 0;
    always @(posedge clk)
        count <= count + 1;
    wire slow_clk = count[19];

    always @(posedge slow_clk)
        var <= var + 1;

    numbers #( .scale(SCALE), .ink(green), .x_off(X_OFFSET), .y_off(Y_OFFSET)) numbers_0(.clk(px_clk), .x_px(x_px), .y_px(y_px), .var0(var), .color_px(number_color_px));

endmodule
