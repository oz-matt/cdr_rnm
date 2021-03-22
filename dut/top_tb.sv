
module top_tb();

  import uvm_pkg::*;
  import EE_pkg::*;

  `include "../tests/top_test.sv"

  logic refclk, fclk;
  
  top_dut dut(refclk, fclk);
  initial begin
    refclk = 1'b0;
    forever begin
      repeat(10) begin
        #11
        refclk <= !refclk;
      end
      repeat(10) begin
        #10
        refclk <= !refclk;
      end
      repeat(10) begin
        #8
        refclk <= !refclk;
      end
      repeat(10) begin
        #7
        refclk <= !refclk;
      end
    end
  end
  
  initial begin
    $timeformat(-9, 1, "ns", 10);
    run_test();
 end
 
  bind dut dms_top_assert dut_top_assert(.*, .cp_out(cp_out));
  
endmodule

