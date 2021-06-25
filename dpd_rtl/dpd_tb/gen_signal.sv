

module gen_signal
   (input 	u1 	clk, 
    input 	u1 	reset_b, 
	output 	s20 sig_i,
	output	s20	sig_q
	);


	u32 freq_0 = 32'd128849019;	
	u32 freq_1 = 32'd30064771;	
	u32 freq_2 = 32'd42949673;

	u16 ampl_0 = 16'd11089; // 16'd12321;
	u16 ampl_1 = 16'd4482;  // 16'd4980;
	u16 ampl_2 = 16'd7549;  // 16'd8388;

	
			
    s16 s_i_0;
    s16 s_q_0;
    dds_signal_generator #(
        .WIDTH_NCO      (16),
        .WIDTH_PHASE    (32),
        .WIDHT_ADDR_ROM (14),
        .INIT_ROM_FILE  ("sin_nco_14_16.mem")) 
    dds_signal_generator_inst0(
        .clk            (clk), 
        .reset_b        (reset_b), 
        .start          (1'b1), 
        .frequency      (freq_0),   
        .phase          (32'd0), 
        .amplitude      (ampl_0), 
        .real_sig       (s_i_0[15:0]),
        .imag_sig       (s_q_0[15:0])
        );  
				
    s16 s_i_1;
    s16 s_q_1;
    dds_signal_generator #(
        .WIDTH_NCO      (16),
        .WIDTH_PHASE    (32),
        .WIDHT_ADDR_ROM (14),
        .INIT_ROM_FILE  ("sin_nco_14_16.mem")) 
    dds_signal_generator_inst1(
        .clk            (clk), 
        .reset_b        (reset_b), 
        .start          (1'b1), 
        .frequency      (freq_1),
        .phase          (32'd0), 
        .amplitude      (ampl_1), 
        .real_sig       (s_i_1[15:0]),
        .imag_sig       (s_q_1[15:0])
        );   	
					
    s16 s_i_2;
    s16 s_q_2;
    dds_signal_generator #(
        .WIDTH_NCO      (16),
        .WIDTH_PHASE    (32),
        .WIDHT_ADDR_ROM (14),
        .INIT_ROM_FILE  ("sin_nco_14_16.mem")) 
    dds_signal_generator_inst2(
        .clk            (clk), 
        .reset_b        (reset_b), 
        .start          (1'b1), 
        .frequency      (freq_2),
        .phase          (32'd0), 
        .amplitude      (ampl_2), 
        .real_sig       (s_i_2[15:0]),
        .imag_sig       (s_q_2[15:0])
        );   	
			
    s16 s_i_all;
    s16 s_q_all;
	always @ (posedge clk, negedge reset_b)
		if(!reset_b) begin
			s_i_all <= '0;
			s_q_all <= '0;
		end else begin
			s_i_all <= s_i_0 + s_i_1 + s_i_2;
			s_q_all <= s_q_0 + s_q_1 + s_q_2; 
		end		
		
	assign sig_i = {s_i_all, 4'd0};
    assign sig_q = {s_q_all, 4'd0};
		
		
		


		
endmodule





















