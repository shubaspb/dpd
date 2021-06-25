
`timescale 1ns / 10ps


module dpd_test_sig
   #(parameter W = 16)  
   (input clk, 
    input reset_b,   
    input start,	
    output reg [W-1:0] sig_i,
    output reg [W-1:0] sig_q);

    reg start_reg0, start_reg1;
	reg start_read;
	always @(posedge clk, negedge reset_b)
	    if (~reset_b) begin
		    start_reg0 <= 1'd0;
			start_reg1 <= 1'd0;
			start_read <= 1'd0;
	    end else begin
		    start_reg0 <= start;
			start_reg1 <= start_reg0;
			start_read <= start_reg0 & (~start_reg1);
	    end	
		
    reg [9:0] cnt;
	always @(posedge clk, negedge reset_b)
	    if (~reset_b) begin 
		    cnt <= 10'd1023;
	    end else begin
		    if (start_read)
			    cnt <= 10'd0;
		    else
			    cnt <= cnt + ~&cnt;
	    end

	reg [W-1:0] ram_i [0:1023];
	initial begin 
	   $readmemb("dpd_sig_train_i.mem", ram_i); 
	end
	always @ (posedge clk, negedge reset_b)
	    if (~reset_b)
		    sig_i <= {(W){1'b0}};
	    else
		    sig_i = ram_i[cnt];	


	reg [W-1:0] ram_q [0:1023];
	initial begin 
	   $readmemb("dpd_sig_train_q.mem", ram_q); 
	end
	always @ (posedge clk, negedge reset_b)
	    if (~reset_b)
		    sig_q <= {(W){1'b0}};
	    else
		    sig_q = ram_q[cnt];	
			
			
			

endmodule













