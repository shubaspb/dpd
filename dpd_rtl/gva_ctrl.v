

module gva_ctrl
   (input      clk, 
    input      reset_b, 
    input      adapt_in,
    output reg adapt_out,
    output reg gva_on
    );


    localparam GVA_SW_ON  = 3750;  // 30 us
    localparam GVA_SW_OFF = 6750;  // 38 + 16 us
    localparam PERIOD  = 10000000;  // 80 ms
    
    
            
    reg adapt_in1;
    reg adapt_in2;
    reg start_cnt;
    always @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            adapt_in1 <= 1'b0;
            adapt_in2 <= 1'b0;
            start_cnt <= 1'b0;
        end else begin  
            adapt_in1 <= adapt_in; 
            adapt_in2 <= adapt_in1; 
            start_cnt <= adapt_in1 & (~adapt_in2);
        end  
        
    reg [31:0] cnt;
    always @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            cnt <= 32'hffffffff;
        end else begin  
            if (start_cnt)
                cnt <= 32'd0;
            //else if (cnt==PERIOD)
            //  cnt <= 32'd0;
            else
                cnt <= cnt + ~&cnt;
        end     
        
    always @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            adapt_out <= 1'b0;
            gva_on <= 1'b0;
        end else begin  
            adapt_out <= (cnt>=GVA_SW_ON)&(cnt<=GVA_SW_OFF); 
            gva_on <= (cnt>=32'd1)&(cnt<=GVA_SW_OFF);
        end  

        
endmodule





















