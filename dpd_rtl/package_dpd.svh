
typedef logic [0:0] u1;
typedef logic [7:0] u8;
typedef logic [9:0] u10;
typedef logic [15:0] u16;
typedef logic [19:0] u20;
typedef logic [31:0] u32;
typedef logic [39:0] u40;
typedef logic [47:0] u48;
typedef logic [63:0] u64;

typedef logic signed [15:0] s16;
typedef logic signed [19:0] s20;
typedef logic signed [23:0] s24;
typedef logic signed [31:0] s32;
typedef logic signed [47:0] s48;

interface intf_coef_3_5;
    logic [19:0] i [0:14];
    logic [19:0] q [0:14];
endinterface: intf_coef_3_5

module ff
   #(parameter W = 16)
   (input clk,
    input [W-1:0] d,
    output reg [W-1:0] q);
always_ff @(posedge clk)
    q <= d;
endmodule