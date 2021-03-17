
`timescale 1ns/1ps

import EE_pkg::*;

`include "EEnet_symbols.sv"

module cp_cosim(
    input up,
    input down,
    inout EEnet cp_out
  );

  parameter real v_vdd = 3.0;
  
  EEnet vdd;
  
  VsrcG cp_vsrc(vdd, v_vdd);
  Isrc cp_iswitch1(cp_out, vdd, up * 1e-2);
  IsrcG cp_iswitch2(cp_out, down * 1e-2);
 
endmodule
