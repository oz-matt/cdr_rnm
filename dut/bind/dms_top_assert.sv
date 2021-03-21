`ifndef DMS_TOP_ASSERT_GUARD
`define DMS_TOP_ASSERT_GUARD

`include "top.sv"
`include "assert_macros.sv"

module dms_top_assert(
    input refclk, 
    input finalclk,
    input d,
    input up,
    input down,
    EEnet cp_out,
    input real ig
  );
  
  real cp_out_V;
  bit[63:0] cp_out_WV;
  
  always @* begin
    cp_out_WV = $realtobits(cp_out.V);
    cp_out_V = cp_out_WV;
  end
  
  always @(posedge refclk) begin
    cp_out_V <= cp_out.V;
  end
  
  initial begin
    cp_out_V = 0;
  end
  
  ERROR_d_sent_low: 
    `assert_clk(refclk, d);
    
  ERROR_cp_out_too_low: 
    `assert_clk(refclk, cp_out_V < 0.5);
  
endmodule

`endif
