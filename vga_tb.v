module test;

  reg clk = 0;
  wire px_clk;
  wire vsync;

  /* Make a reset that pulses once. */
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);
     wait(dut.y_px == 5);
     $finish;
  end

  reg last_vsync = 0;
  always @(posedge px_clk)
    last_vsync <= vsync;
  wire load = last_vsync == 1'b1 && vsync == 1'b0; // convert next number every new screen
  VgaSyncGen dut(.clk(clk), .px_clk(px_clk), .vsync(vsync));

    always @(posedge px_clk)
        if(bcd_ready)
            bcd <= {dig_4, dig_3, dig_2, dig_1};
    
    reg [15:0] bcd;
    reg [15:0] var = 16'd1234;
    wire bcd_ready;
    wire [3:0] dig_4, dig_3, dig_2, dig_1;

    
    wire load_bcd = last_vsync == 1'b1 && vsync == 1'b0; // convert next number every new screen

    bcd bcd_0(.reset(reset), .clk(px_clk), .load(load_bcd), .ready(bcd_ready), .number(var), .dig_1(dig_1), .dig_2(dig_2), .dig_3(dig_3), .dig_4(dig_4));

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

endmodule // test
