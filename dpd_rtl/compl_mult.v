
module compl_mult
 #(parameter W = 20)                     
 (    
    input  [W*2-1:0] a, 
    input  [W*2-1:0] b, 
    output [W*2-1:0] o  
 );

    wire signed [W-1:0] a_i = a[W*2-1:W];
    wire signed [W-1:0] a_q = a[W-1:0];
    wire signed [W-1:0] b_i = b[W*2-1:W];
    wire signed [W-1:0] b_q = b[W-1:0];
 
    wire signed [2*W-1:0] w_i_i = a_i * b_i;
    wire signed [2*W-1:0] w_q_q = a_q * b_q;
    wire signed [2*W-1:0] w_i_q = a_i * b_q;
    wire signed [2*W-1:0] w_q_i = a_q * b_i;
    
    wire signed [2*W:0]   w_new_i = w_i_i - w_q_q;
    wire signed [2*W:0]   w_new_q = w_q_i + w_i_q;
	
    wire signed [W-1:0] o_i = w_new_i[2*W-2:W-1] + w_new_i[W-2];
    wire signed [W-1:0] o_q = w_new_q[2*W-2:W-1] + w_new_q[W-2];  

	assign o = {o_i, o_q};

endmodule
