
`timescale 1ns/1ps

import EE_pkg::*;

module  fcap(P, N);
inout EEnet P, N;

parameter real c=1e-9;     // capacitance
parameter real rs=0;       // series resistance
parameter real ic=0;       // initial capacitor voltage at time zero
parameter real tinc=1e-9;  // timestep for computing voltage update (sec)
parameter real vtol=1e-4;  // minimum voltage change to update output

real Vcap=ic,Tcap=0,Icap=0; // voltage on capacitor @ time, and current value
real InewP;                  // recomputed current at end of interval
real tinct = tinc*1s;       // tinc converted to timescale units
real VPold,VNold,Told,RnewP, Idrv, Rdrv;             // voltage value to output pin (limited update)

reg ck=0;

always #(tinct) ck=!ck;   // toggle clock at defined rate

always @(P.V,N.V,ck) begin               // on input change or clock cycle:
  
  // The non-polarized cap (CapG) forces it's net to become an Ideal Voltage source
  // (i.e. an EEnet with voltage but 0 resistance) if rs = 0. In this case, we can
  // use the new current calculation by simply using the EEnet.I value. Since both
  // P and N currents are the same in a component, lets just use Inew = P.I.
  
  // If the series resistance is not zero, we must calc the new current
  InewP = (((P.V-N.V)-(VPold-VNold))/($realtime-Told))*(c*1s);
  //(rs==0)? (P.I) : ((P.V-VPout)-(N.V-VNout))/rs;
  
  RnewP = (P.V-N.V)/InewP;
  
  //Vcap += (Inew+Icap)/2*($realtime-Tcap)/(c*1s);  // update voltage by I*dT
  Tcap = $realtime;                      // save time of cap computation
  //Icap = InewP;
  if (abs(((P.V-N.V)-(VPold-VNold)))>vtol && Tcap-Told>tinct*0.25) begin  // if enough dV&dT
  
    // real oldmid = (P.V-N.V)/2;
    // newP = oldmid + (Vcap/2);
    // newN = oldmid - (Vcap/2);
    
    //if (abs(P.V-VPold)>1e-4) VPold<=P.V;       // measured pin voltages
    //if (abs(N.V-VNold)>1e-4) VNold<=N.V;
    Rdrv <= RnewP;
    VPold <= P.V;                        //  update output voltage
    VNold <= N.V;                       //  update output voltage
    Told <= $realtime;                   //  and save time of update
   Idrv <= InewP;
  end
end

// Drive voltage & resistance onto output pin:
assign P = '{`wrealZState,-InewP,rs};
assign N = '{`wrealZState,InewP,rs};

endmodule

