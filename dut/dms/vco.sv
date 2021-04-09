`timescale 1ns / 1ps

module vco(
    input real VcoIn,
    output logic VcoOut,
    input logic[4:0] tune
  );
  
  parameter real center_freq = 5.0;     //GHz
  parameter real vco_gain = 1.0;        //GHz/V
  parameter real tune_step = 100.0;     //MHz/step = 3200MHz total range
  parameter real vcoin_mid = 1.5;        //V - VcoIn mid voltage that does not affect freq
  
  real tuned_center;                    //GHz
  real input_adjusted_target_freq;      //GHz
  real clk_delay;                       //ns
  
  always begin
    tuned_center = center_freq + (($signed(tune) - 15) * tune_step/1000);
    input_adjusted_target_freq = tuned_center + ((VcoIn - vcoin_mid) * vco_gain);
    clk_delay = 0.5/input_adjusted_target_freq;
    @(tune, VcoIn);
  end
  
  initial begin
    VcoOut = 1'b0;
    forever #(clk_delay) VcoOut = !VcoOut;
  end
  
endmodule
  
