
`timescale 1ns/1ps

import EE_pkg::*;

`define Z `wrealZState
`define X `wrealXState

module rnm_clkgen(P, vpulsed, period);
inout EEnet P;
input real vpulsed;
input real period;

real transition; 
assign transition = period/100;

real pulse=0, Tlast=0;

initial begin

  forever begin
  
    Tlast = $realtime; 
  
    wait($realtime > (Tlast + (transition*0.25)/2.5));
    pulse = vpulsed/30;
    Tlast = $realtime; 
    wait($realtime > (Tlast + (transition/2.5)));
    pulse = vpulsed/2;
    Tlast = $realtime; 
    wait($realtime > (Tlast + (transition/2.5)));
    pulse = (vpulsed*29)/30;
    Tlast = $realtime; 
    wait($realtime > (Tlast + ((transition*0.25)/2.5)));
    pulse = vpulsed;
    Tlast = $realtime; 
  
    wait($realtime > (Tlast + (period/2)));
  
    Tlast = $realtime; 
    wait($realtime > (Tlast + ((transition*0.25)/2.5)));
    Tlast = $realtime; 
    pulse = (vpulsed*29)/30;
    wait($realtime > (Tlast + (transition/2.5)));
    pulse = vpulsed/2;
    Tlast = $realtime; 
    wait($realtime > (Tlast + (transition/2.5)));
    pulse = vpulsed/30;
    Tlast = $realtime; 
    wait($realtime > (Tlast + ((transition*0.25)/2.5)));
    pulse = 0;
    Tlast = $realtime; 
  
    wait($realtime > (Tlast + (period/2)));
  
  end
end

assign P = '{pulse, 0, 0}; //Create ideal pulse voltage source

endmodule

