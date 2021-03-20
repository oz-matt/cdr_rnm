
module top_tb();

import uvm_pkg::*;

`include "../tests/test_list.sv"

  logic refclk, fclk;
  
  top_dut dut(refclk, fclk);
  
  initial begin
    refclk = 1'b0;
    forever #10 refclk <= !refclk;
  end
  
  initial begin
    $timeformat(-9, 1, "ns", 10);
    run_test();
 end
 
endmodule

