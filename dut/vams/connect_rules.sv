

`include "disciplines.vams"
`timescale 1ns / 1ps

`include "nreal.sv"

`define Vsup  3.0
`define Vthi  2.0
`define Vtlo  1.0
`define Vlow  0
`define Tr    0.4n
`define Rlo   200
`define Rhi   200
`define Rx    40
`define Rz    10M
`define Vdelta      `Vsup/64
`define Vdelta_tol  `Vdelta/4
`define Tr_delta    `Tr/20
`define rsupply     4
`define rpull       1.5e3
`define rlarge      9.0e3
`define rweak       5.5e4
`define rmedium     3.2e5
`define rsmall      1.9e6

connectrules CR_nreal;

  connect ERN_bidir #(.vdelta(`Vdelta), .vtol(`Vdelta_tol), .ttol(`Tr_delta),
        .tr(`Tr_delta), .tf(`Tr_delta), .rout(`Rlo), .rz(`Rz));

endconnectrules

connectmodule ERN_bidir (Din, Aout);
inout Din;
nreal Din;         //inout nreal
\logic Din;        //discrete domain
inout Aout;
electrical Aout;   //inout electrical

  parameter real vss=0             from (-inf:inf); // Voltage of negative supply
  parameter real vsup=1.8          from (0:inf);    // supply voltage based on vss
  parameter real vdelta=vsup/64    from (0:vsup];   // voltage delta
  parameter real vx=vss            from [0:vsup];   // X output voltage
  parameter real vtol=vdelta/4     from (0:vdelta); // voltage tolerance
  parameter real ttol=10p          from (0:1m];     // time tolerance
  parameter real tr=10p            from (0:inf);    // risetime of analog output
  parameter real tf=tr             from (0:inf);    // falltime of analog output
  parameter real ttol_t=(tr+tf)/20 from (0:inf);    // time tol of transition
  parameter real tdelay=0          from [0:1m);     // delay time of analog output
  parameter real rout=200          from (0:inf);    // output resistance
  parameter real rx=rout           from (0:inf);    // X output resistance
  parameter real rz=10M            from (0:inf);    // Z output resistance
  parameter integer currentmode=0  from [0:1];      // 0: voltage, 1: current mode
  parameter real idelta=10u        from (0:inf);    // current delta
  parameter real itol=idelta/4     from (0:idelta); // current tolerance
  parameter real ix=0              from [0:inf);    // X output current
  parameter real i0=0              from [0:inf);    // 0 output current
  parameter integer clamp=0        from [0:1];      // 0: disable, 1: enable clamp
  parameter real dvclamp=vsup/20   from (0:vsup/2); // clamp zoon from supply
  parameter real vbias=vss+vsup/2  ;                // bias level for input load
  parameter real rin=200           from (0:inf);    // input resistance
  parameter integer idealmode=0    from [0:1];      // ideal supply mode

  parameter real vdd=vss+vsup;               // internal parameter: vss+vsup
  parameter real vdd10=vdd+vsup*10;          // internal parameter: vdd+vsup*10
  parameter real vss10=vss-vsup*10;          // internal parameter: vss-vsup*10
  parameter integer voltagemode=1-currentmode; // internal parameter: not current
  real Dreg;       //real register for A to D wreal conversion
  real RealN;      //real register for D wreal to A conversion
  real Rout;       //output resistance
  real VprevD;                         //Voltage at previous delta-step
  real RealA;
  real VprevA;                         //Voltage at previous analog-step
  real iAout;                          //Analog current

  integer D_count = 0;

  reg sie;

  wreal R_val;

  wreal D_val;

  initial begin
        RealN = 0;
        sie = $SIE_input(Din, R_val);
        D_count = $driver_count(Din);
        Rout = rz;
        VprevD = vss;
        Dreg = `wrealZState;
  end

  assign D_val = sie?R_val:Din;

  always begin
      if (((sie && (D_val === `wrealZState || D_count == 1)))
          || (!sie && (D_val === `wrealZState || D_count == 0))) begin
          Rout = rz;
          if (currentmode) RealN = 0;
      end else if ( D_val === `wrealXState ) begin
          RealN = currentmode?ix:vx;
          Rout = rx;
      end else begin
          Rout = rout;
      	  //filter out digital noise within +/-vdelta
          if (currentmode) begin
              if ( abs(Din-RealN) >= idelta ) RealN = D_val; 
          end else begin
              if ( abs(D_val-RealN) >= vdelta ) RealN = D_val;
          end
      end
      @(D_val) ;
  end

  //discretize V(Aout) triggered by absdelta function
  always @(absdelta(V(Aout)*voltagemode, vdelta, ttol, vtol))
    if ( (sie && (D_val === `wrealZState || D_count == 1)) || !sie )
    	Dreg = currentmode? -iAout : V(Aout);
    else
        Dreg = `wrealZState;

  always @(absdelta(iAout*currentmode, idelta, ttol, itol)) begin
    if ( (sie && (D_val === `wrealZState || D_count == 1)) || !sie ) begin
        if ( V(Aout) > vdd10 && VprevD < vdd10 )
          $display("Warning: AMS IE %M at %g: I(Aout)=%g is causing V(Aout)=%g 10x vsup above vdd. Please check for any mismatch between the electrical circuit and the E2R settings.",
              $abstime, iAout, V(Aout));
        if ( V(Aout) < vss10 && VprevD > vss10 )
          $display("Warning: AMS IE %M at %g: I(Aout)=%g is causing V(Aout)=%g 10x vsup below vss. Please check the E2R load settings (vbias, rin)",
              $abstime, iAout, V(Aout));
    	Dreg = currentmode? -iAout : V(Aout);
        VprevD = V(Aout);
    end else
        Dreg = `wrealZState;
  end

  assign Din = Dreg;

  analog initial VprevA = vss;
  analog begin
    RealA = transition(RealN, tdelay, tr, tf, ttol_t);
    if (currentmode) begin
      if ( abs(RealA) < itol ) begin // set up load for current E2R:
        iAout = (V(Aout)-vbias)/rin;
        I(Aout) <+ iAout;
      end else // do current R2E 
      if (RealA > 0) begin
        if (clamp) begin
          if (V(Aout) > vdd - dvclamp) begin
            if (VprevA < vdd - dvclamp)
              $display("Warning: AMS IE %M at %g: wreal Din=%g is causing V(Aout)=%g being clamped near vdd. Please check for any mismatch between the electrical circuit and the R2E",
                $abstime, RealN, V(Aout));
            VprevA = V(Aout);
            RealA = RealA * (vdd - V(Aout)) / dvclamp;
          end
        end else begin
          if (V(Aout) > vdd10 ) begin
            if (VprevA < vdd10 )
              $display("Warning: AMS IE %M at %g: wreal Din=%g is causing V(Aout)=%g being 10x vsup above vdd. Please check for any mismatch between the electrical circuit and the R2E",
                $abstime, RealN, V(Aout));
            VprevA = V(Aout);
          end
        end
        iAout = -RealA + V(Aout)/rz;
        I(Aout) <+ iAout;
      end else begin
        if (clamp) begin
          if ( V(Aout) < vss + dvclamp ) begin
            if ( VprevA > vss + dvclamp )
              $display("Warning: AMS IE %M at %g: wreal Din=%g is causing V(Aout)=%g being clamped near vss. Please check for any mismatch between the electrical circuit and the R2E",
               $abstime, RealN, V(Aout));
            VprevA = V(Aout);
            RealA = RealA * (V(Aout) - vss) / dvclamp;
          end
        end else begin
          if ( V(Aout) < vss10 ) begin
            if ( VprevA > vss10 )
              $display("Warning: AMS IE %M at %g: wreal Din=%g is causing V(Aout)=%g being 10x vsup below vss. Please check for any mismatch between the electrical circuit and the R2E",
               $abstime, RealN, V(Aout));
            VprevA = V(Aout);
          end
        end
        iAout = -RealA + V(Aout)/rz;
        I(Aout) <+ iAout;
      end
    end else begin
      if (idealmode) begin
        V(Aout) <+ RealA;
      end else begin
        iAout = (V(Aout) - RealA) / Rout;
        I(Aout) <+ iAout;
      end
    end
  end

endmodule

