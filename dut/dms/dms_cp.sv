
`timescale 1ns/1ps

import EE_pkg::*;


module dms_cp#(
    parameter v_vdd = 3.0, 
    parameter real iamp = 1e-4
  )(
    input up,
    input down,
    EEnet cp_out
  );
  
  EEnet vdd;
  
  VsrcG cp_vsrc(vdd, v_vdd);
  
  Isrc cp_iswitch1(vdd, cp_out, 
    up *                                        // ctrl sig from pfd
    //((cp_out.V <= v_vdd - 0.1) && (cp_out.R <= 1e3)) * // Check that we can push 1e-4 amps into load (cp_out.R) without it overshooting vdd
    iamp);                                      // nom current drive
    
  IsrcG cp_iswitch2(cp_out, 
    down *                                      // ctrl sig from pfd
    //((cp_out.V >= 0.1) && (cp_out.R <= 1e3)) *  // Check that current src can pull the requested current from the src
    iamp);                                      // nom current drive
 
endmodule
