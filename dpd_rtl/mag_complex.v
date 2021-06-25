
module mag_complex(
    input          reset_b,  // reset
    input          clk,      // clock
    input  [19:0]  sig_in_i,   
	input  [19:0]  sig_in_q, 
    output [19:0]  magn      
    );  
	

    wire [23:0]  sig_i = {sig_in_i, 4'd0};
    wire [23:0]  sig_q = {sig_in_q, 4'd0}; 
	
	
    
    localparam NUMS = 12;  // number of stages

    
    wire signed [23:0] s_i = {sig_i[23], sig_i[23:1]};          
    wire signed [23:0] s_q = {sig_q[23], sig_q[23:1]};
    

    reg signed [23:0] s_i_abs;            
    reg signed [23:0] s_q_abs; 
    always @(posedge clk, negedge reset_b)
        if (~reset_b) begin
            s_i_abs <= 24'd0;    
            s_q_abs <= 24'd0;   
        end else begin
            s_i_abs <= (s_i[23]) ? (-s_i) : s_i;  
            s_q_abs <= (s_q[23]) ? (-s_q) : s_q;    
        end

    wire [23:0] i_rg [0:NUMS-1];
    wire [23:0] q_rg [0:NUMS-1];
    wire [23:0] a_rg [0:NUMS-1];
        
    mag_complex_stage  #(.NUM_STAGE(0)) mag_complex_stage_inst0 (
        .reset_b    (reset_b    ),
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
                .reset_b    (reset_b    ),
                .clk        (clk     ),
                .i_in       (i_rg[i-1]  ),            
                .q_in       (q_rg[i-1]  ),              
                .i_out      (i_rg[i]    ),            
                .q_out      (q_rg[i]    )
            );
        end
    endgenerate

    wire signed [23:0] magnitude = i_rg[NUMS-1];


	wire signed [23:0] norm = 24'sd5093861; //  24'sd6907013;  //
   	reg signed [47:0] mag_norm;
    always @(posedge clk, negedge reset_b)
 		if(~reset_b) begin
 			mag_norm <= 48'd0;
 		end else begin
 			mag_norm <= magnitude * norm;
 		end	
	assign magn = mag_norm[45:26];
	
	
	
    
endmodule



