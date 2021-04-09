
`timescale 1ns/1ps

import cds_rnm_pkg::*;

module pgainamp (
    output wreal1driver OUTP,   // differential outputs
    output wreal1driver OUTN, 
    input wreal1driver INP,     // differential inputs
    input wreal1driver INN, 
    input logic[2:0] VCVGA,     // digital control voltage
    input wreal1driver VB,      // required bias inputs
    input wreal1driver IBB, 
    input wreal1driver VDD,     // power supplies
    input wreal1driver VSS, 
    input logic PD              // powerdown control
  );

  import mymath_pkg::*;
  
  



endmodule


