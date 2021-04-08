
`ifndef TOP_SV_GUARD
`define TOP_SV_GUARD

import EE_pkg::*;
import nreal::*;

//`define AMS_COSIM // Define to run DMS and AMS co-sim. Do not define for just DMS sim

`define twopi 6.28318530718

module top_dut(input refclk, output logic finalclk);

real IN,OUT;       // filter input & output
real Av;           // coefs passed to filter
logic [3:0] Trim;  // Filter trim control
real Fin,Vdc,Vpk;  // controls for input signal
real Phs=0;        // phase for sine generator
parameter real Ts=7;       // fixed timestep size (ns)
real idealH_f;     // Calculate ideal freq response

 // INSTANTIATE THE FILTER TO BE TESTED
dms_lpf2 #(.Ts (Ts*1e-9), .fpole0 (3e6), .fpole1 (5e6), .trimStep (250e3)) lpf2 (OUT, IN, Trim, Av);

// Sine Input Generation
always begin
  IN = Vdc + Vpk*$sin(`twopi*Phs);  // compute input from levels & phase
  #Ts Phs = Phs+Ts*Fin/1e9;       // update phase after delay
  if (Phs>=1) Phs -= 1;           // keep phase in range 0 to 1
  idealH_f = Av / $sqrt( ((1 + (Fin/3e6)**2)) * ((1 + (Fin/5e6)**2)) );

end


// Test Procedure
initial begin         // test procedure
  Trim=4'h7; Av=1;   // Trim at mid, unity gain
  Fin=1e6;Vdc=0;Vpk=1;// 1MHz input signal
  #2000               // Run for 2 cycles
  Fin=5e6;  #1200      // Fin matches Fp (expect 0.5 out)
  Av=3;     #1200      // Higher gain
  Av=0.2;   #1200      // Lower gain
  Av=1;     #1200      // Back to unity gain
  Vdc=1;    #4000      // DC shift of input signal
  Trim = 4'hF; #2000   // Trim to Max
  Vdc=0;    #1200      // back to zero DC level
  // Sweep the value of Trim from max (15) to min (0)
  // hold at each value for 600ns
  //  <<<  Add Code Here >>>

  #600;
  Trim = 4'h7;        // back to middle
  Fin=3e6; #1500      // now at fpole1
  Fin=5e6; #1500      // now at fpole2
  Trim = 4'h0;  #1500     // 
  Trim = 4'hF;  #1500     // 
  Trim = 4'h8; 
  Fin=1e5;  #2000     // Down to 100kHz input and center trim
  while (Fin<30e6) #(1e9/Fin) Fin=Fin*1.08; // slow freq ramp
  #200 $stop;         // done with simulation
end


// Measuring output peak magnitude 

real vhi,vlo;      // peak detector low/high measured
real Vpk_out;      // output of detector = (vhi-vlo)/2
reg up=0;          // state of detector
real measGain;


// PEAK DETECTOR: Compute (vhi-vlo)/2 for each cycle of output:
always @(OUT) begin
  if (OUT<Vdc) begin   // if input is low
    if (up) begin      // if it was high, it just crossed
      Vpk_out=(vhi-vlo)/2;  // compute peak difference
      vlo=OUT;         // reset min value
      up=0;            // put in low state
    end
    if (OUT<vlo) vlo=OUT;  // save low peak
  end
  else begin           // else input is high
    if (!up) begin     // if it was low, it just crossed
      Vpk_out=(vhi-vlo)/2;  // compute peak difference
      vhi=OUT;         // reset max value
      up=1;            // put in hgh state
    end
    if (OUT>vhi) vhi=OUT;  // save high peak
  end
end

// Compute the Gain
always @(Vpk_out) begin
  if (Vpk_out > 0.0)
     measGain = 20 * $log10(Vpk_out/Vpk);
  else
     measGain = -100.0;
end




















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


