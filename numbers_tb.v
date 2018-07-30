module test;

  reg clk = 0;
  reg reset = 1;
  reg [9:0] x_px = 0;
  reg [9:0] y_px = 0;

  /* Make a reset that pulses once. */
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);
     # 1 reset <= 0;
     wait(y_px == 100);
     $finish;
  end

  always @(posedge clk) begin
    x_px <= x_px + 1;
    if(x_px > 600) begin
        x_px <= 0;
        y_px <= y_px + 1;
    end
  end
    

  numbers #(.x_off(50), .y_off(80), .scale(3)) numbers_0 (.clk(clk), .x_px(x_px), .y_px(y_px), .var0(16'hABCD));

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

endmodule // test
