
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

`define twopi 6.28318530718

module top_dut(input refclk, output logic finalclk);

  real VcoIn;
  logic[4:0] tune;
  real VcoOut;
  real tnow, tlast, vnow, vlast, fmnow=0, fmlast=0, fmeas=0, fmeas2=0, fmnow2=0, fmlast2=0;
  
  logic crossed;

  vco_sin vco_i(.*);
  
  initial begin
    VcoIn = 1.5;
    tune = 5'b01111;
    #1000;
    for(real j=0;j<1000;j=j+1) begin
      VcoIn = 0.5 + (j/500);
      if (j == 500) tune = 5'b10011;
      #10;
    end
    $finish();
  end


  always @(VcoOut) begin
    tlast = tnow;
    vlast = abs(vnow);
    tnow = $realtime;
    vnow = abs(VcoOut);
  end
  
  always @(crossed) begin
    fmlast = fmnow;
    fmnow = $realtime - ((vnow * ($realtime - tlast)) / (vnow + vlast));
    fmeas = 1 / ((fmnow - fmlast) * 2 * 1e-9);
    
    fmlast2 = fmnow2;
    fmnow2 = $realtime;
    fmeas2 = 1 / ((fmnow2 - fmlast2) * 2 * 1e-9);
  end
  
  assign crossed = (VcoOut > 0);





  /*logic d, up, down;
  EEnet dms_cp_unfiltered, dms_cp_out, dms_vco_out;
  real ig;
  
  vpulse#(.width(10000), .period(30000), .transition(100)) vp_gen(vp, 5.0);
  
  VsrcG v1(vdd, 1.0);
  VsrcG v2(vcc, 5.0);

  VRsrc r1(vcc, vp, 0.0, 700,);
  ResG r2(vp, 700);
  VRsrc r3(vp, mid1, 0.0, 700,);
  //fres r4(mid1, mid2, 1e-4);
  VRsrc r4(mid1, mid2, 0.0, 0.0,);
  CapG c1(mid1);
  VRsrc r5(mid2, mid3, 0.0, 700,);

  VRsrc r6(vdd, mid3, 0.0, 700,);
  ResG r7(mid3, 700);

  assign osc_v = mid1.V - mid2.V;
  
  VRsrc r10(vp, mid12, 0.0, 700,);
  fcap fc1(mid12, mid22);
  VRsrc r12(mid22, mid32, 0.0, 700,);

  VRsrc r13(vdd, mid32, 0.0, 700,);
  ResG r14(mid32, 700);

  assign osc_v_ref = mid12.V - mid22.V;
  
  
  
  dms_pfd dms_pfd_i(d, refclk, finalclk, up, down);
  dms_cp#(.v_vdd(3.0), .iamp(7e-5)) dms_cp_i(up, down, dms_cp_unfiltered);
  
  dms_lpf dms_lpf_i(dms_cp_unfiltered);
  dms_vco dms_vco_i(.vctrl(dms_cp_unfiltered), .vcoout(dms_vco_out));
  
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
  
  initial begin
    d = 1'b1;
    finalclk = 1'b0;
    forever #11 finalclk <= !finalclk;
  end
  
*/
endmodule

`endif


