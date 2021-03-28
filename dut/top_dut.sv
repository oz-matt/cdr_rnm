
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

module top_dut(input refclk, output logic finalclk);

  EEnet vdd, vcc, vp, mid1, mid2, mid3, mid12, mid22, mid32;
  logic ck, d;
  real osc_v, osc_v_ref;
  
  vpulse#(.width(10000), .period(30000), .transition(100)) vp_gen(vp, 5.0);
  
  VsrcG v1(vdd, 1.0);
  VsrcG v2(vcc, 5.0);

  VRsrc r1(vcc, vp, 0.0, 700,);
  ResG r2(vp, 700);
  VRsrc r3(vp, mid1, 0.0, 700,);
  fres r4(mid1, mid2, 700);
  //VRsrc r4(mid1, mid2, 0.0, 700,);
  VRsrc r5(mid2, mid3, 0.0, 700,);

  VRsrc r6(vdd, mid3, 0.0, 700,);
  ResG r7(mid3, 700);

  assign osc_v = mid1.V - mid2.V;
  
  VRsrc r10(vp, mid12, 0.0, 700,);
  VRsrc r11(mid12, mid22, 0.0, 700,);
  VRsrc r12(mid22, mid32, 0.0, 700,);

  VRsrc r13(vdd, mid32, 0.0, 700,);
  ResG r14(mid32, 700);

  assign osc_v_ref = mid12.V - mid22.V;


  /*logic d, up, down;
  EEnet dms_cp_unfiltered, dms_cp_out, vgnd;
  real ig;
  
  dms_pfd dms_pfd_i(d, refclk, finalclk, up, down);
  dms_cp#(.v_vdd(3.0), .iamp(7e-5)) dms_cp_i(up, down, dms_cp_unfiltered);
  
  dms_lpf dms_lpf_i(dms_cp_unfiltered);
  
  `ifdef AMS_COSIM
    EEnet rup, rdn, ams_cp_unfiltered, nvsrc;
    real ier;
    
    assign rup = '{up*3.0, 0, 1.0};
    assign rdn = '{down*3.0, 0, 1.0};
    assign nvsrc = '{3.0, 0, 0};
    assign ams_cp_unfiltered = '{0, 0, 3e4};
    
    ams_cp#(.iamp(7e-5)) ams_cp_i(rup, rdn, ams_cp_unfiltered, nvsrc);
    ams_lpf ams_lpf_i(ams_cp_unfiltered);
  `endif
  */

  initial begin
    d = 1'b1;
    finalclk = 1'b0;
    forever #11 finalclk <= !finalclk;
  end
  
  initial begin
    ck = 1'b1;
    forever begin
      #10;
      ck <= !ck;
      #20;
      ck <= !ck;
    end
  end
  
endmodule

`endif


