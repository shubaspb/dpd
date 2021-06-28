
module mag_complex(
    input    	clk,
    input  s20  sig_in_i,   
	input  s20  sig_in_q, 
    output u20	magn      
    );  
	
    localparam NUMS = 12;  // number of stages
	
    s24 sig_i;
    s24 sig_q; 
    s24 s_i;
    s24 s_q;
	always_comb begin
		sig_i = {sig_in_i, 4'd0};
		sig_q = {sig_in_q, 4'd0};
		s_i = {sig_i[23], sig_i[23:1]};          
		s_q = {sig_q[23], sig_q[23:1]};
	end

    s24 s_i_abs;            
    s24 s_q_abs; 
    always @(posedge clk)
        begin
            s_i_abs <= (s_i[23]) ? (-s_i) : s_i;  
            s_q_abs <= (s_q[23]) ? (-s_q) : s_q;    
        end

    s24 i_rg [0:NUMS-1];
    s24 q_rg [0:NUMS-1];
    s24 a_rg [0:NUMS-1];        
    mag_complex_stage  #(.NUM_STAGE(0)) mag_complex_stage_inst0 (
        .clk        (clk        ),
        .i_in       (s_i_abs  ),            
        .q_in       (s_q_abs  ),              
        .i_out      (i_rg[0]    ),            
        .q_out      (q_rg[0]    )
    );
                
    genvar i;
    generate
        for (i=1; i<NUMS; i=i+1) begin: cordic_mag_complex
            mag_complex_stage  #(.NUM_STAGE(i)) mag_complex_stage_instn (
                .clk        (clk     ),
                .i_in       (i_rg[i-1]  ),            
                .q_in       (q_rg[i-1]  ),              
                .i_out      (i_rg[i]    ),            
                .q_out      (q_rg[i]    )
            );
        end
    endgenerate

	s24 norm = 24'sd5093861;
   	s48 mag_norm;
    always_ff @(posedge clk)
 		mag_norm <= i_rg[NUMS-1] * norm;

	assign magn = mag_norm[45:26];
	
	
	
    
endmodule



