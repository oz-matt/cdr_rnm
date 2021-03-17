`include "/opt/cadence/XCELIUM1803/tools/affirma_ams/etc/dms/EE_pkg_examples/VsrcG.sv"
`include "/opt/cadence/XCELIUM1803/tools/affirma_ams/etc/dms/EE_pkg_examples/ResG.sv"
`include "pfd.sv"

`define EE_DEBUG

import EE_pkg::*;

module top();

  logic d, refclk, finalclk, up, down;
  
  pfd pllpfd(d, refclk, finalclk, up, down);
  
  initial begin
    d = 1'b1;
    refclk = 1'b0;
    finalclk = 1'b0;
    fork
      begin
        forever #10 refclk <= !refclk;
      end
      begin
        #3;
        forever #9 finalclk <= !finalclk;
      end
    join
  end
  
  initial begin
    #10000;
    $finish();
  end
  

endmodule
