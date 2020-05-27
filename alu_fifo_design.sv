module top(clk,reset,data,valid,ready,result);
  input clk,reset;
  input [9:0]data;
  input valid;
  output ready;
  output [8:0]result;
  
  wire [9:0]data_out_fifo;
  wire [8:0]data_out_alu;

  wire ready_out_alu;
  wire full,empty,valid_out;
  
  wire full_out,empty_out;
  
  fifo f_in(clk,reset,data,data_out_fifo,valid,valid_out,ready_out_alu,full,empty);
  alu alu1(clk,reset,valid_out,data_out_fifo[3:0],data_out_fifo[7:4],data_out_fifo[9:8],data_out_alu,ready_out_alu);
  fifo #(.memory_width(8)) f_out(clk,reset,data_out_alu,result,ready_out_alu,ready,1'b1,full_out,empty_out);
  
endmodule

module fifo(clk,reset,data_in,data_out,valid,valid_out,ready,full,empty);
 
   parameter memory_width = 9;
  
  input clk,reset;
  input [memory_width:0]data_in;
  output reg [memory_width:0]data_out;
  input ready;
  input valid;
  output reg valid_out;
  output reg full,empty;
  
 
  reg [memory_width:0] mem [8];
  reg [2:0]wptr;
  reg [2:0]rptr;
  

  always@(posedge clk or posedge reset)
    begin
      if (reset)
        begin
          wptr <= 0;
          rptr <= 0;
          valid_out <= 0;
          full <= 0;
          empty <= 1;
        end
      else
        if(valid)
        	begin
              if(wptr == (rptr -1))
                begin
                  full <= 1;
                  valid_out <= 0;
                  empty <= 0;
                end
              else
                begin
                    mem[wptr] <= data_in;
                    wptr <= wptr + 1;
                end                
        	end        
    end
  always@(negedge clk)
    begin
      if(reset)
        rptr <= 0;
      else
      if(ready)
        begin
          data_out <= mem[rptr];
          valid_out <= 1;
          rptr <= rptr + 1;          
        end
    end
endmodule

module alu(clk,reset,valid,data1,data2,operand,result,ready);
  
  parameter cycles = 3;
  
  input clk,reset;
  input valid;
  input [3:0]data1,data2;
  input [1:0]operand;
  output reg [8:0]result;
  output reg ready;
  
  reg [4:0]count = 0;
  
  always@(posedge reset)
    begin
      ready <= 1;
      result <= 0;
      count <= 0;
    end
  always@(posedge clk)
    begin
      if(valid)
        begin
          case(operand)
            0: result = data1+data2;
            1: result = data1-data2;
            2: 
              	begin                  
                  if(count == cycles-1)
                    begin
                       result = data1*data2;
                      	ready = 1;
                      count = 0;
                    end
                  else
                    begin
                     	count = count + 1;
                  		ready = 0;
                    end
                end
            3: result = data1/data2;            
          endcase 
        end
    end
     
   
  
  
  
endmodule
