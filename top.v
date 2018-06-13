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

    wire [9:0] x_px;
    wire [9:0] y_px;
    wire px_clk;
    wire activevideo;

    VgaSyncGen vga_inst( .clk(clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .px_clk(px_clk), .activevideo(activevideo));

    assign g1 = x_px > 200 ? 1 : 0;
    assign g2 = x_px > 400 ? 1 : 0;
    assign r1 = y_px > 150 ? 1 : 0;
    assign r2 = y_px > 300 ? 1 : 0;
    assign b1 = x_px > 300 ? 1 : 0;
    assign b2 = y_px > 250 ? 1 : 0;

endmodule
