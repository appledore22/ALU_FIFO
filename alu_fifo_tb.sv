// Code your testbench here
// or browse Examples
module tb();
  reg clk,reset;
  reg [9:0]data;
  reg valid;
  wire ready;
  wire [8:0]result;
  
  top t1(clk,reset,data,valid,ready,result);
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;

    clk = 0;
    reset = 0;
    valid = 0;
    #3;
    reset = 1;
    #20;
    reset = 0;
        @(posedge clk);

    data = 355;
    valid = 1;
    @(posedge clk);
        data = 10'h151;
    @(posedge clk);
        data = 10'h232;
    @(posedge clk);
        data = 10'h140;
    @(posedge clk);
        data = 10'h110;
    @(posedge clk);
        data = 10'h150;
     @(posedge clk);
        data = 10'h250;
     @(posedge clk);
        data = 10'h240;
     @(posedge clk);
        data = 10'h250;
     @(posedge clk);
        data = 10'h130;
 @(posedge clk);
        data = 10'h230;
 @(posedge clk);
        data = 10'h330;
 @(posedge clk);
        data = 10'h230;
 @(posedge clk);
        data = 10'h130;

       #300;


    $finish;
  end
  
  always #5 clk = ~clk;
endmodule
