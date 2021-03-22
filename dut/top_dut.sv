
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

module top_dut(input refclk, output logic finalclk);

  logic d, up, down;
  EEnet cp_out;
  real ig;
  
  dms_pfd pll_pfd(d, refclk, finalclk, up, down);
  dms_cp#(.v_vdd(3.0)) pll_cp(up, down, cp_out);
  
  //IsrcG ics1(node1, refclk * -3e-3);
  //VRsrc r1(node1, node2, 0.0, 1, ig);
  CapG#(.c(10e-12), .rs(10), .ic(1.5)) c1(cp_out);
  //ResG r1(cp_out, 50.0);
  //lpf_cosim cp_lpf(node2);
  
  `ifdef AMS_COSIM
    //real rup, rdn, rvout, rvsrc;
    //nreal nvout, nvsrc;
    EEnet rup, rdn, nvout, nvsrc;
    
    assign rup = '{up*3.0, 0, 1};
    assign rdn = '{down*3.0, 0, 1};
    assign nvsrc = '{3.0, 0, 0};
    assign nvout = '{0, 0, 1};
    
    charge_pump ams_cp(rup, rdn, nvout, nvsrc);
    ECapG#(.c(10e-12), .rs(10), .ic(1.5)) ec1(nvout);
  `endif
  

  initial begin
    d = 1'b1;
    finalclk = 1'b0;
    forever #9 finalclk <= !finalclk;
  end
  
endmodule

`endif

