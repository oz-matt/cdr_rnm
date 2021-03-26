
`timescale 1ns/1ps

import EE_pkg::*;


module dms_lpf(
    inout EEnet P
  );
  
  parameter real cap_to_gnd = 3e-12;
  parameter real series_res = 5206;
  parameter real series_cap_to_gnd = 36e-12;
  
  EEnet mid, vgnd;
  
  real ig;
  
  assign vgnd = '{0.2,0,0};
  
  fcap#(.c(cap_to_gnd), .rs(0.0), .ic(1.5)) ctg(P, vgnd);
  //VRsrc r1(P, vgnd, 0.0, series_res, ig);
  //fcap#(.c(series_cap_to_gnd), .rs(0.0)) srsc(mid, vgnd);
  
endmodule
