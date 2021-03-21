
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;
`include "pfd_cosim.sv"
`include "EEnet_symbols.sv"
`include "lpf_cosim.sv"
`include "cp_cosim.sv"

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

module top_dut(input refclk, output logic finalclk);

  logic d, up, down;
  EEnet cp_out;
  real ig;
  
  //dms_top_assert dut_top_assert(.d(d), .refclk(refclk), .cp_out(cp_out));
  
  pfd_cosim pll_pfd(d, refclk, finalclk, up, down);
  cp_cosim#(.v_vdd(3.0)) pll_cp(up, down, cp_out);
  
  //IsrcG ics1(node1, refclk * -3e-3);
  //VRsrc r1(node1, node2, 0.0, 1, ig);
  CapG#(.c(10e-12), .rs(10), .ic(1.5)) c1(cp_out);
  
  //lpf_cosim cp_lpf(node2);
  
  `ifdef AMS_COSIM
    //real rup, rdn, rvout, rvsrc;
    //nreal nvout, nvsrc;
    EEnet rup, rdn, nvout, nvsrc;
    
    assign rup = '{up*3.0, 0, 1};
    assign rdn = '{down*3.0, 0, 1};
    assign nvsrc = '{3.0, 0, 0};
    assign nvout = '{0, 0, 1};
    
    cp_ams cp1(rup, rdn, nvout, nvsrc);
  `endif
  

  initial begin
    d = 1'b1;
    finalclk = 1'b0;
    forever #9 finalclk <= !finalclk;
  end
  
  initial begin
    #9000;
    d = 1'b0;
  end
  
endmodule

`endif

