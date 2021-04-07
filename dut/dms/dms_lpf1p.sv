
`timescale 1ns/1ps

module dms_lpf1p import cds_rnm_pkg::*; (OUT, IN, poleTrim, gainTrim);

 output wreal1driver OUT;    // output of filter
 input wreal1driver IN;      // input to filter
 input [3:0] poleTrim;  // Pole adjust control
 input [3:0] gainTrim;  // Gain adjust control
 real Fp;               // corner frequency (Hz)
 real Av;               // voltage gain (V/V)

 parameter real Ts = 1; // input sample rate (ns)
 parameter real poleStep = 50e3; // Fp change per step
 parameter real poleFmin = 50e3;  // Default pole location for control = 0
 parameter real gainStep = 1.0/16; // gain change per step

 real K,d0,d1,n0,n1,x0,x1,y0,y1;
 
 
endmodule
