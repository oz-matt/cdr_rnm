`include "d_ff_with_async_rst.sv"

module pfd(
    input d,
    input refclk,
    input finalclk,
    output logic up,
    output logic down
  );
  
  wand rsig;
  
  d_ff_with_async_rst dffup(d, refclk, rsig, up, );
  d_ff_with_async_rst dffdn(d, finalclk, rsig, down, );

  assign rsig = up;
  assign rsig = down;

endmodule
