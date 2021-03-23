`ifndef DMS_TOP_ASSERT_GUARD
`define DMS_TOP_ASSERT_GUARD

module dms_top_assert(
    input refclk, 
    input finalclk,
    input d,
    input up,
    input down,
    EEnet dms_cp_out,
    input real ig
  );
  
  real dms_cp_out_V;
  bit[63:0] dms_cp_out_WV;
  
  always @* begin
    dms_cp_out_WV = $realtobits(dms_cp_out.V);
    dms_cp_out_V = $bitstoreal(dms_cp_out_WV);
  end
  
  initial begin
    dms_cp_out_V = 0;
  end
  
  ERROR_d_sent_low: 
    `assert_clk(refclk, d);
    
  ERROR_cp_out_range_check: 
    `assert_clk(refclk, 
      (dms_cp_out_V >= 0.0) &&
      (dms_cp_out_V <= 3.0));
    
  ERROR_dms_pfd_xzcheck:
    `assert_clk(refclk, 
      !$isunknown(d) && 
      !$isunknown(refclk) && 
      !$isunknown(finalclk) && 
      !$isunknown(up) &&
      !$isunknown(down));
  
endmodule

`endif
