
`timescale 1ns/1ps

`define M_TWO_PI 6.28318530718

module cwave_gen(
    output real cwave_out
  );
  
  parameter real Fs = 200e3; // Must be twice the nyquist frequency (twice the highest frequency we want to measure in the signal
  parameter real Ts = 1/Fs;
  parameter real Tss = Ts * 1s;
  
  parameter real Freq1 = 1e3;
  parameter real Freq2 = 15e3;
  parameter real Freq3 = 50e3;
  
  real s1, s2, s3;
 
  always #(Tss) begin
    s1 = 5 * $sin(`M_TWO_PI * Freq1 * ($realtime * 1e-9)); //sin function is assuming this T term is in seconds, but $realtime is in ns
    s2 = 8 * $sin(`M_TWO_PI * Freq2 * ($realtime * 1e-9));
    s3 = 13 * $sin(`M_TWO_PI * Freq3 * ($realtime * 1e-9));
    cwave_out = s1 + s2 + s3;
  end

endmodule
  
