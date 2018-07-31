module test;

  reg clk = 0;
  reg med_clk = 0;
  reg slow_clk = 0;
  reg [15:0] var = 16'd97;
  wire load;
  reg reset = 1;
  wire ready;

  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);
     # 2
     reset <= 0;
     # 2

     wait(var == 3);
     # 1000
     $finish;
  end

  always @(posedge slow_clk) begin
      var <= var + 1;
      if(var == 16'd99)
          var <= 0;
  end

    always @(posedge clk)
        if(ready)
            bcd <= {dig_4, dig_3, dig_2, dig_1};

  reg last_med_clk;
  always @(posedge clk)
    last_med_clk <= med_clk;
  assign load = med_clk & ~ last_med_clk;

  wire [3:0] dig_1;
  wire [3:0] dig_2;
  wire [3:0] dig_3;
  wire [3:0] dig_4;

  reg [15:0] bcd = 0;

  bcd bcd_0 (.reset(reset), .clk(clk), .load(load), .number(var), .ready(ready),
    .dig_1(dig_1), .dig_2(dig_2), .dig_3(dig_3), .dig_4(dig_4));

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;
  always #2000 slow_clk = !slow_clk;
  always #500 med_clk = !med_clk;

endmodule // test

