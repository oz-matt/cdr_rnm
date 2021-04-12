
`timescale 1ns/1ps

`define M_TWO_PI 6.28318530718

import "DPI" pure function real sin (input real rTheta);

import cds_rnm_pkg::*;

module vco_sin (
    input wreal1driver VcoIn, 
    output wreal1driver VcoOut, 
    input logic [4:0] tune
  );

  parameter real center_freq=7e6;           // freq when zero input (Hz)
  parameter real vco_gain=2e6;             // freq gain constant in (Hz/V)
  parameter real vmag=0.8;                  // magnitude of output sinusoid
  parameter real tinc=2;                    // output sample rate (ns)
  parameter real tune_step = 1e5;           // coarse tuning frequency step (Hz)
  parameter real vcoin_mid = 1.5;        //V - VcoIn mid voltage that does not affect freq
  
  real tuned_center;
  real input_adjusted_target_freq;
  real period;
  real phase_acc=0;
  real pct_done_with_period=0;
  real vout=0;
  
  real VcoOutLast=0, fmt1=0, fmt2=0, fmeas=0;
  
  always begin
    tuned_center = center_freq + (($signed(tune) - 15) * tune_step);
    input_adjusted_target_freq = tuned_center + ((VcoIn - vcoin_mid) * vco_gain);
    period = 1/input_adjusted_target_freq;
    //clk_delay = 0.5/input_adjusted_target_freq;
    @(tune, VcoIn);
  end
  
  always begin
    phase_acc += (tinc * 1e-9);
    
    if (phase_acc >= period) phase_acc -= period;
    
    pct_done_with_period = phase_acc/period;
    vout = vmag * $sin(`M_TWO_PI * input_adjusted_target_freq * phase_acc);
    #(tinc);
  end
  
  assign VcoOut = vout;

endmodule
