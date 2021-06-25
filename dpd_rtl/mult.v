
module mult
 #(parameter WA = 20,
   parameter WB = 20,
   parameter WO = 20
 )                     
 (
    input  reset_b,  
    input  clk,      
    input signed [WA-1:0] a, 
    input signed [WB-1:0] b, 
    output reg signed [WO-1:0] o  
 );

    reg signed [WA+WB-1:0] o_full;

    always@(posedge clk, negedge reset_b)
    if(~reset_b) begin
        o_full <= {(WA+WB){1'b0}};
    end else begin
        o_full <= a*b;
    end
    
    always@(posedge clk, negedge reset_b)
    if(~reset_b) begin
        o <= {(WO){1'b0}};
    end else begin
        o <= o_full[WA+WB-1:WA+WB-WO];
    end


endmodule
