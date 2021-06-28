

module dpd_test_sig
   #(parameter W = 16)  
    (input               clk,
    input                reset_b,
    input                start,
    output logic [W-1:0] sig_i,
    output logic [W-1:0] sig_q);

    u1 start_reg0;
	u1 start_reg1;
    u1 start_read;
    always_ff @(posedge clk)
        begin
            start_reg0 <= start;
            start_reg1 <= start_reg0;
            start_read <= start_reg0 & (~start_reg1);
        end 
        
    u10 cnt;
    always_ff @(posedge clk, negedge reset_b)
        if (~reset_b) begin 
            cnt <= 10'd1023;
        end else begin
            if (start_read)
                cnt <= 10'd0;
            else
                cnt <= cnt + ~&cnt;
        end

    logic [W-1:0] ram_i [0:1023];
    initial begin 
       $readmemb("dpd_sig_train_i.mem", ram_i); 
    end
    always_ff @ (posedge clk)
        sig_i = ram_i[cnt]; 

    logic [W-1:0] ram_q [0:1023];
    initial begin 
       $readmemb("dpd_sig_train_q.mem", ram_q); 
    end
    always_ff @ (posedge clk)
        sig_q = ram_q[cnt]; 

endmodule
