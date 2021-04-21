
`timescale 1ns/1ps

module dms_fir_filt (
    input real in,
    output real out
  );
  
  parameter real Fs = 200e3; // Must be twice the nyquist frequency (twice the highest frequency we want to measure in the signal)
  parameter real Ts = 1/Fs;
  parameter real Tss = Ts * 1s;
  
  parameter real c1 = 0.2372;
  parameter real c2 = 0.2637;
  parameter real c3 = 0.2637;
  parameter real c4 = 0.2372;
  
  real last1=0, last2=0, last3=0;
  
  always #(Tss) begin
    
    out = c1*in + c2*last1 + c3*last2 + c4*last3;
  
    last3 = last2;
    last2 = last1;
    last1 = in;
  end
  
endmodule
