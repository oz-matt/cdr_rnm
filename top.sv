`include "pfd_cosim.sv"

import EE_pkg::*;

`include "EEnet_symbols.sv"
`include "lpf_cosim.sv"
`include "cp_cosim.sv"

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

module top();

  logic d, refclk, finalclk, up, down;
  EEnet cp_out;
  real ig;
  
  pfd_cosim pll_pfd(d, refclk, finalclk, up, down);
  cp_cosim#(.v_vdd(3.0)) pll_cp(up, down, cp_out);
  
  //IsrcG ics1(node1, refclk * -3e-3);
  //VRsrc r1(node1, node2, 0.0, 1, ig);
  CapG#(.c(10e-12), .rs(10), .ic(1.5)) c1(cp_out);
  
  //lpf_cosim cp_lpf(node2);
  
  `ifdef AMS_COSIM
    real VB[1:0] = {1e-2, 1e-2};
    
    //get ams
    cpump cpump_wreal(ZN, ZP, 3.0 * down, 0.0, 3.0 * up, VB);
    lpf_single#() lpf_wreal(3.0, ZP, ZN, B0, B1, VRESET, VCPOUT, VCNOUT);
  `endif
  
  

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
    $display("node1: V is %5.3f, I is %5.3f, R is %5.3f", cp_out.V, cp_out.I, cp_out.R);
    $display("ig: %5.3f", ig);
    $finish();
  end
  

endmodule
