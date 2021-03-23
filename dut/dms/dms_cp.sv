
`timescale 1ns/1ps

import EE_pkg::*;


module dms_cp#(parameter v_vdd = 3.0)(
    input up,
    input down,
    EEnet cp_out
  );

  
  
  EEnet vdd;
  
  VsrcG cp_vsrc(vdd, v_vdd);
  
  Isrc cp_iswitch1(cp_out, vdd, 
    up *                                        // ctrl sig from pfd
    //(cp_out.V < v_vdd) *                      // Shut off current src if lpf is full
    1e-4);                                      // nom current drive
    
  IsrcG cp_iswitch2(cp_out, 
    down *                                      // ctrl sig from pfd
    ((cp_out.V >= 0.1) && (cp_out.R <= 1e3)) *  // Check that current src can pull the requested current from the src
    1e-4);                                      // nom current drive
    
  ResG rout(cp_out, 1e9);
 
endmodule
