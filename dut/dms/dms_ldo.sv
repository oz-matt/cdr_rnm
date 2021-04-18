`timescale 1ns/1ps

//`include "VRsrcD.sv"
//`include "EEIO.sv"

import cds_rnm_pkg::*;
import EE_pkg::*;

module dms_ldo (
    input wreal4state VIN,
    inout EEnet VOUT,
    inout EEnet VDD,
    inout EEnet VSS,
    input logic en
  );
 
  parameter real VIN_MIN = 2.5;
  parameter real VIN_MAX = 5.1;
  parameter real SCALE = 2;
  parameter real VDROP = 100e-3;
  parameter real IQ = 1e-9;
  parameter real TS = 1e-9;
  parameter real IMAX = 5e-3;
  parameter real IACTIVE = 1e-3;
  parameter real ROUT_OFF = 1e9;
  parameter real ROUT_ACTIVE = 10e3;
  parameter real K_GAIN = 300;
  
  logic active;
  real res=10000, ipass, ipdn, rmin;
  real VTARGET;
  bit clk;
  real en_res, en_res_bounded;
  
  always_comb begin
    VTARGET = ((VIN * SCALE) < (VDD.V - VDROP)) ? (VIN * SCALE) : (VDD.V - VDROP);
    en_res = en ? res : ROUT_OFF;
    rmin = VDROP / IMAX;
    en_res_bounded = (en_res > rmin) ? en_res : rmin;
  end
  
  assign active = (VIN <= VIN_MAX) && (VIN >= VIN_MIN) && en;
  
  always #(TS * 1s) clk = !clk;
  
  always @(posedge clk) begin
    res += (VOUT.V - VTARGET) * K_GAIN;
    // NOTE: We start at 10000R which equates to a VOUT of 1.5V since the other R is also 10000R.
    // Must observe that MORE res equals LESS current = LESS VOUT
    // Therefore, if VOUT - VTARGET is positive, we need MORE res = less VOUT!
  end  
  
  
  VRsrc pass_res (
    .P(VDD),
    .N(VOUT),
    .vval(),
    .rval(en_res_bounded),
    .imeas(ipass)
  );
  
 VRsrc pulldown_res (
    .P(VOUT),
    .N(VSS),
    .vval(),
    .rval(10000),
    .imeas(ipdn)
  );
 
 
  CapG  #(.c(100e-12), .rs(250)) outputCap (
       .P          (VOUT)
  );
  endmodule
  
  
