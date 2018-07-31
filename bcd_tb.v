module test;

  reg clk = 0;
  reg [15:0] number = 16'd12345;
  reg load = 0;
  reg reset = 1;
  wire ready;

  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);
     # 2
     reset <= 0;
     # 2
     load <= 1;
     # 2
     load <= 0;
     # 2


     wait(ready == 1);
     # 10
     $finish;
  end

  bcd bcd_0 (.reset(reset), .clk(clk), .load(load), .number(number), .ready(ready));

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

endmodule // test

