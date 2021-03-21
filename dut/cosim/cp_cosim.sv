
`timescale 1ns/1ps

import EE_pkg::*;

`include "EEnet_symbols.sv"

module cp_cosim#(parameter v_vdd = 3.0)(
    input up,
    input down,
    EEnet cp_out
  );

  
  
  EEnet vdd;
  
  VsrcG cp_vsrc(vdd, v_vdd);
  
  Isrc cp_iswitch1(cp_out, vdd, 
    up *                               // ctrl sig from pfd
    (cp_out.V < v_vdd) *               // Shut off current src if lpf is full
    1e-2);                             // nom current drive
    
  IsrcG cp_iswitch2(cp_out, 
    down *                             // ctrl sig from pfd
    (cp_out.V > 0) *                   // Shut off current src if lpf is drained
    1e-2);                             // nom current drive
 
endmodule
