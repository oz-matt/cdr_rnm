`timescale 1ns/1ps

module d_ff_with_async_rst(
    input d,
    input clk,
    input rst,
    output logic q,
    output logic qbar
  );
  
  always @(posedge clk or posedge rst) begin
    if(rst) q <= 0;
    else q <= d;
  end

endmodule
