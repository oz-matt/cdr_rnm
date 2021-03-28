
`timescale 1ns/1ps

import EE_pkg::*;

module  fcap(P, N);
inout EEnet P, N;
/*
parameter real c=1e-9;     // capacitance
parameter real rs=0;       // series resistance
parameter real ic=0;       // initial capacitor voltage at time zero
parameter real tinc=1e-9;  // timestep for computing voltage update (sec)
parameter real vtol=1e-4;  // minimum voltage change to update output

real Vcap=ic,Tcap=0,Icap=0; // voltage on capacitor @ time, and current value
real Inew, VPlast,VNlast,Tlast;

reg ck=0;

always #(tinct) ck=!ck;   // toggle clock at defined rate

always @(P.V,N.V,ck) begin               // on input change or clock cycle:
  
  Inew = (((P.V-N.V)-(VPold-VNold))/($realtime-Told))*(c*1s);
  
end

assign P = '{`wrealZState,-InewP,rs};
assign N = '{`wrealZState,InewP,rs};
*/
endmodule

