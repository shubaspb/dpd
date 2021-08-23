
module mult
  #(parameter WA = 20,
    parameter WB = 20,
    parameter WO = 20)
   (input  clk,
    input signed [WA-1:0] a,
    input signed [WB-1:0] b,
    output reg signed [WO-1:0] o);

reg signed [WA+WB-1:0] o_full;

always@(posedge clk)
begin
    o_full <= a*b;
    o <= o_full[WA+WB-1:WA+WB-WO];
end

endmodule