
`timescale 1ns/1ps

import EE_pkg::*;

module fres(P, N, rval);
inout EEnet P, N;
input real rval;

parameter integer itermax=20;
parameter real rmax=1e15;

real VPin,RPin,VNin,RNin;
real Tdrv=0; // Last update time to output
real EV_P,ER_P,EV_N,ER_N;          // effective external V & R values
real VPdrv,RPdrv,VNdrv,RNdrv;          // voltage & resistance output drives
integer num_iter=0;

initial begin   // block starts in "off" mode, effective values are as measured:
  VPdrv=0;
  RPdrv=rmax;
  VNdrv=0;
  RNdrv=rmax; 
  EV_P=P.V;
  ER_P=P.R;
  EV_N=N.V;
  ER_N=N.R;
end

// Vin, Rin with small changes ignored
always @(P.V,P.R) begin
  if ((abs(P.V-VPin)<1e-13)==1'b0)       VPin=P.V;
  if ((abs(P.R-RPin)<=RPin*1e-13)==1'b0) RPin=P.R;
end
always @(N.V,N.R) begin
  if ((abs(N.V-VNin)<1e-13)==1'b0)       VNin=N.V;
  if ((abs(N.R-RNin)<=RNin*1e-13)==1'b0) RNin=N.R;
end

always begin

  //Check if we are iterating too many times on a single point  
  if ($realtime > Tdrv) begin // If this is the first iteration at this timepoint, we are happy
    Tdrv = $realtime;
    num_iter = 0;
  end
  else begin // Had another iteration at this timepoint, let's make sure we're not over the limit
    num_iter+=1;
    if (num_iter==itermax) $fatal("<EE> ERROR: instance %M node P unconverged at T=%.0fns", $realtime);
  end
  
  
  // Our effect on EG and EI of N and P are the only things that matter about this module
  // For a resistor (using the V+R method), our effect on EG is the insertion of -(1/newPR)
  // and for EI it is the insertion of -(newPV/newPR).
  // Knowing this, the new EG and EI become:
  //
  // EG = 1/(P.R) - 1/(newPR)
  // EI = (P.V)/(P.R) - (newPV)/(newPR)
  //
  // with the insertion of our module's effect
  //
  // Solving and reducing for ER (which is 1/EG) and EV (EI/EG), we get
  // ER = (P.R)(newPR) / (newPR - P.R)
  // EV = ((P.V)(newPR) - (P.R)(newPV))/(newPR - P.R)
  
  if (RPin<rmax && (RPdrv===`wrealZState || RPin!=RPdrv || RNdrv===`wrealZState || RNin!=RNdrv)) begin // normal case
    if (RPdrv<rmax) begin                       // compute effective vals
      // NEW effective sum of Voltages and sum of Resistances with our resistor plugged in
      ER_P = (RPin * RPdrv) / (RPdrv - RPin);  
      EV_P = ((VPin * RPdrv) - (RPin * VPdrv)) / (RPdrv-RPin);  
      ER_N = (RNin * RNdrv) / (RNdrv - RNin);          
      EV_N = ((VNin * RNdrv) - (RNin * VNdrv)) / (RNdrv-RNin); 
    end 
    else begin // undriven
      ER_P = RPin;  
      EV_P = VPin;  
      ER_N = RNin;          
      EV_N = VNin; 
    end
  end
  else begin
    ER_P = `wrealZState;  
    EV_P = VPin;  
    ER_N = `wrealZState;          
    EV_N = VNin; 
  end
      
  
  
  VPdrv = EV_N; // Could check if the difference between VPdrv and EV_N > vtol
  RPdrv = ((ER_N + rval) < rmax)? ER_N + rval : `wrealZState;
  VNdrv = EV_P;
  RNdrv = ((ER_P + rval) < rmax)? ER_P + rval : `wrealZState;
  
  @(VPin, RPin, VNin, RNin); // Wait for next change
end

assign P = '{VPdrv,0,RPdrv};
assign N = '{VNdrv,0,RNdrv};

endmodule

