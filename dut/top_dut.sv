
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

module top_dut(input refclk, output logic finalclk);

  logic d, up, down;
  EEnet dms_cp_unfiltered, dms_cp_out;
  real ig;
  
  dms_pfd pll_pfd(d, refclk, finalclk, up, down);
  dms_cp#(.v_vdd(3.0)) pll_cp(up, down, dms_cp_unfiltered);
  
  //IsrcG ics1(node1, refclk * -3e-3);
  //VRsrc r1(dms_cp_unfiltered, dms_cp_out, 0.0, 10.0, ig);
  //CapG#(.c(10e-12), .rs(10.0), .ic(1.5)) c1(dms_cp_out);
  //ResG r1(dms_cp_unfiltered, 50.0);
  //lpf_cosim cp_lpf(dms_cp_out);
  
  `ifdef AMS_COSIM
    EEnet rup, rdn, ams_cp_unfiltered, nvsrc, ams_cp_out;
    real ier;
    
    assign rup = '{up*3.0, 0, 1.0};
    assign rdn = '{down*3.0, 0, 1.0};
    assign nvsrc = '{3.0, 0, 0};
    assign ams_cp_unfiltered = '{0, 0, 1.0};
    
    charge_pump ams_cp(rup, rdn, ams_cp_unfiltered, nvsrc);
    //EVRsrc er1(ams_cp_unfiltered, ams_cp_out, 0.0, 10.0, ier);
    //ECapG#(.c(10e-12), .rs(10.0), .ic(1.5)) ec1(ams_cp_out);
  `endif
  

  initial begin
    d = 1'b1;
    finalclk = 1'b0;
    forever #11 finalclk <= !finalclk;
  end
  
endmodule

`endif

