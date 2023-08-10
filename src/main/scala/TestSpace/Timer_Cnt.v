// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Timer_Cnt
// Git hash  : 72a3ba00bf8112f87f4c70cf56c4d31a0db88aa8

`timescale 1ns/1ps

module Timer_Cnt (
  input      [1:0]    io_gpio_in,
  output     [31:0]   io_cnt,
  input               clk,
  input               reset
);

  wire                valid;
  wire                restart;
  reg        [31:0]   cnt;

  assign valid = io_gpio_in[0];
  assign restart = io_gpio_in[1];
  assign io_cnt = cnt;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      cnt <= 32'h0;
    end else begin
      if(valid) begin
        cnt <= (cnt + 32'h00000001);
      end else begin
        if(restart) begin
          cnt <= 32'h0;
        end
      end
    end
  end


endmodule
