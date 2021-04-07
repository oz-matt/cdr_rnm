
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
        #12
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
        #13
        refclk <= !refclk;
      end
    end
  end
  
  initial begin
    $timeformat(-9, 1, "ns", 10);
    run_test();
 end
 
  //bind dut dms_top_assert dut_top_assert(.*, .dms_cp_out(dms_cp_out));
  
endmodule

