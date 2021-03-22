
`timescale 1ns/1ps

import EE_pkg::*;


module dms_lpf(
    inout EEnet P
  );
  
  parameter real cap_to_gnd = 3e-12;
  parameter real series_res = 5206;
  parameter real series_cap_to_gnd = 36e-12;
  
  CapG#(.c(cap_to_gnd), .rs(0.0)) ctg(P);
  CapG#(.c(series_cap_to_gnd), .rs(series_res)) srsc(P);
  
endmodule
