
`timescale 1ns/1ps
`include "d_ff_with_async_rst.sv"

module pfd_cosim(
    input d,
    input refclk,
    input finalclk,
    output logic up,
    output logic down
  );
  
  // This block remains the same in AMS or DMS simulations. No `ifdef AMS_COSIM needed.
  
  wand rsig;
  
  d_ff_with_async_rst dffup(d, refclk, rsig, up, );
  d_ff_with_async_rst dffdn(d, finalclk, rsig, down, );

  assign rsig = up;
  assign rsig = down;

endmodule
