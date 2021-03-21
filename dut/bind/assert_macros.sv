`ifndef ASSERT_MACROS_SV
`define ASSERT_MACROS_SV

`define assert_clk_xrst( argclk, arg ) \
  assert property (@(posedge argclk) disable iff (!rst_n) arg)

`define assert_clk( argclk, arg ) \
  assert property (@(posedge argclk) arg)

`endif 
