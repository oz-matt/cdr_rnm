
`timescale 1ns/1ps

import EE_pkg::*;

module  fcap(P, N);
inout EEnet P, N;

parameter real c=1e-9;     // capacitance
parameter real rs=0;       // series resistance
parameter real ic=0;       // initial capacitor voltage at time zero
parameter real tinc=1e-9;  // timestep for computing voltage update (sec)
parameter real vtol=1e-4;  // minimum voltage change to update output
parameter real rmin=1e-4;    // minimum differential resistance.
parameter real rmax=1e15;    // "off" resistance for Z

real Tlast=0,Icap=0; // voltage on capacitor @ time, and current value
real Inew, Vlast=0, Vcap=0, Vnext=0, Ilast, ttst=0;
real InewP, VlastP=0, VcapP=0, VnextP=0, IlastP;
real InewN, VlastN=0, VcapN=0, VnextN=0, IlastN;
real VPdrv,RPdrv,VNdrv,RNdrv;
real VPstage,RPstage,VNstage,RNstage;
real EV_P,ER_P,EV_N,ER_N;          // effective external V & R values
real VPin,RPin,VNin,RNin;              // inputs with small changes ignored
real tinct = tinc * 1s;

reg ck=0;

always #(tinct) ck=!ck;   // toggle clock at defined rate

// Vin, Rin with small changes ignored
always @(P.V,P.R) begin
  if ((abs(P.V-VPin)<1e-13)==1'b0)       VPin=P.V;
  if ((abs(P.R-RPin)<=RPin*1e-13)==1'b0) RPin=P.R;
end
always @(N.V,N.R) begin
  if ((abs(N.V-VNin)<1e-13)==1'b0)       VNin=N.V;
  if ((abs(N.R-RNin)<=RNin*1e-13)==1'b0) RNin=N.R;
end

initial begin
  VPdrv=0;
  RPdrv=rmax;
  VNdrv=0;
  RNdrv=rmax;
  VPstage=0;
  RPstage=rmax;
  VNstage=0;
  RNstage=rmax;
  EV_P=P.V;
  ER_P=P.R;
  EV_N=N.V;
  ER_N=N.R;
end

always @(VPin, RPin, VNin, RNin, P.I, N.I, ck) begin

  if (RPin<rmax && (RPdrv===`wrealZState || RPin!=RPdrv || RNdrv===`wrealZState || RNin!=RNdrv)) begin // normal case
    if (RPdrv<rmax) begin
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
  
  ttst <= $realtime - Tlast;
  
  //Inew = (((VPin-VNin)-(Vlast)) / 1) * c;
  InewP = (rs==0)? P.I : ((VPin-VNin)-(Vlast))/rs;
  InewN = (rs==0)? N.I : ((VPin-VNin)-(Vlast))/rs;
  //Inew = ((VPin-VNin)-(Vlast))/rs;
  //Vcap += (Inew+Ilast)/2*($realtime-Tlast)/(c*1s);
  
  // Discrete time integral with form: integral(t) = integral(t-dt) + 0.5 x dt x (input(t) + input(t-dt))
  VnextP = ((InewP/*input(t)*/ + IlastP/*input(t-dt)*/)/2)/(c*1s);  
  VnextN = ((InewN+IlastN)/2)/(c*1s);
  VcapP += VnextP;
  VcapN += VnextN;
  IlastP = InewP;
  IlastN = InewN;
  
  VPstage = VcapP/2;
  RPstage = ER_N + rs;
  VNstage = VcapN/2;
  RNstage = ER_P + rs;
  
  if($realtime-Tlast>tinct*0.25) begin
    Tlast <= $realtime; 
    if(abs((VPin-VNin)-(Vlast))>vtol) Vlast <= VPin-VNin;
    if(abs(VPdrv-VPstage)>vtol) VPdrv <= VPstage;
    //if(abs(RPdrv-RPstage)>vtol) RPdrv <= RPstage;
    if(abs(VNdrv-VNstage)>vtol) VNdrv <= VNstage;
    //if(abs(RNdrv-RNstage)>vtol) RNdrv <= RNstage;
  end
  
end

assign P = '{VPdrv,0,0};
assign N = '{VNdrv,0,0};

endmodule

