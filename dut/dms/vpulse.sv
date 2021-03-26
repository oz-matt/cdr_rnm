`timescale 1ns/1ps
import EE_pkg::*;

`define Z `wrealZState
`define X `wrealXState

module vpulse(P, vpulsed);
inout EEnet P;
input real vpulsed;

parameter real width=500; // All parameter timescales refer to the simulation `timescale directive
parameter real period=1000;
parameter real transition=10;

real pulse=0;

initial begin

  assert (width <= period) 
    else begin
      $fatal("VPulse width is larger than the period");
    end

  forever begin
  
    #((transition*0.25)/2.5);
    pulse <= vpulsed/30;
    #(transition/2.5);
    pulse <= vpulsed/2;
    #(transition/2.5);
    pulse <= (vpulsed*29)/30;
    #((transition*0.25)/2.5);
    pulse <= vpulsed;
  
    #(width);
  
    #((transition*0.25)/2.5);
    pulse <= (vpulsed*29)/30;
    #(transition/2.5);
    pulse <= vpulsed/2;
    #(transition/2.5);
    pulse <= vpulsed/30;
    #((transition*0.25)/2.5);
    pulse <= 0;
  
    #(period-width);
  
  end
end

assign P = '{pulse, 0, 0}; //Create ideal pulse voltage source

endmodule

