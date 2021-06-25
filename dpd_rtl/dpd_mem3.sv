

module dpd_mem3
(
    input      	clk,
	input reset_b,
    input  s20 	sig_in_i,   
	input  s20 	sig_in_q, 
	output s20  sig_out_i,
	output s20  sig_out_q,
	intf_coef_3_5 coeff,
	intf_coef_3_5 yy
);


    s20 mag [0:4];
	mag_5 mag_5_inst(
		.clk	(clk	),
		.sig_in_i (sig_in_i),    
		.sig_in_q (sig_in_q),  
		.mag_0	(mag[0]	),
		.mag_1	(mag[1]	),
		.mag_2	(mag[2]	),
		.mag_3	(mag[3]	),
		.mag_4  (mag[4]	)
		);  
		
	s20 sig_in_i_del; 
    delay_rg #(.W(20), .D(16)) delay_rg_inst1
	   (.clk		(clk	),
		.data_in	(sig_in_i),     
		.data_out	(sig_in_i_del)); 
		
	s20 sig_in_q_del; 
    delay_rg #(.W(20), .D(16)) delay_rg_inst2
	   (.clk		(clk	),
		.data_in	(sig_in_q),     
		.data_out	(sig_in_q_del)); 

	
	s20 sm_i [0:4];
	s20 sm_q [0:4];
	
	mult #(.WA(20),.WB(20),.WO(20)) mult_0 (.clk(clk), .a(sig_in_i_del), .b(mag[0]), .o(sm_i[0]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_1 (.clk(clk), .a(sig_in_q_del), .b(mag[0]), .o(sm_q[0]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_2 (.clk(clk), .a(sig_in_i_del), .b(mag[1]), .o(sm_i[1]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_3 (.clk(clk), .a(sig_in_q_del), .b(mag[1]), .o(sm_q[1]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_4 (.clk(clk), .a(sig_in_i_del), .b(mag[2]), .o(sm_i[2]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_5 (.clk(clk), .a(sig_in_q_del), .b(mag[2]), .o(sm_q[2]) );
	mult #(.WA(20),.WB(20),.WO(20)) mult_6 (.clk(clk), .a(sig_in_i_del), .b(mag[3]), .o(sm_i[3]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_7 (.clk(clk), .a(sig_in_q_del), .b(mag[3]), .o(sm_q[3]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_8 (.clk(clk), .a(sig_in_i_del), .b(mag[4]), .o(sm_i[4]) );	
	mult #(.WA(20),.WB(20),.WO(20)) mult_9 (.clk(clk), .a(sig_in_q_del), .b(mag[4]), .o(sm_q[4]) );

	
	u40 rg0 [0:2];
	u40 rg1 [0:2];
	u40 rg2 [0:2];
	u40 rg3 [0:2];
	u40 rg4 [0:2];
	always_ff @ (posedge clk)
		begin
		    rg0[0] <= {sm_i[0], sm_q[0]};
		    rg1[0] <= {sm_i[1], sm_q[1]};
		    rg2[0] <= {sm_i[2], sm_q[2]};
		    rg3[0] <= {sm_i[3], sm_q[3]};
		    rg4[0] <= {sm_i[4], sm_q[4]};	
		    for(int i=0; i<3; i++) begin
			    rg0[i+1] <= rg0[i];
				rg1[i+1] <= rg1[i];
				rg2[i+1] <= rg2[i];
				rg3[i+1] <= rg3[i];
				rg4[i+1] <= rg4[i];
			end
		end
	

	
	s20 ad_i [0:14];
	s20 ad_q [0:14];
	
	compl_mult #(.W(20)) m_0  ( .clk(clk), .a(rg0[2]), .b({coeff.i[0 ],coeff.q[0 ]}), .o({ad_i[0 ], ad_q[0 ]}) );	
	compl_mult #(.W(20)) m_1  ( .clk(clk), .a(rg0[1]), .b({coeff.i[1 ],coeff.q[1 ]}), .o({ad_i[1 ], ad_q[1 ]}) );	
	compl_mult #(.W(20)) m_2  ( .clk(clk), .a(rg0[0]), .b({coeff.i[2 ],coeff.q[2 ]}), .o({ad_i[2 ], ad_q[2 ]}) );	
	compl_mult #(.W(20)) m_3  ( .clk(clk), .a(rg1[2]), .b({coeff.i[3 ],coeff.q[3 ]}), .o({ad_i[3 ], ad_q[3 ]}) );	
	compl_mult #(.W(20)) m_4  ( .clk(clk), .a(rg1[1]), .b({coeff.i[4 ],coeff.q[4 ]}), .o({ad_i[4 ], ad_q[4 ]}) );
	compl_mult #(.W(20)) m_5  ( .clk(clk), .a(rg1[0]), .b({coeff.i[5 ],coeff.q[5 ]}), .o({ad_i[5 ], ad_q[5 ]}) );
	compl_mult #(.W(20)) m_6  ( .clk(clk), .a(rg2[2]), .b({coeff.i[6 ],coeff.q[6 ]}), .o({ad_i[6 ], ad_q[6 ]}) );
	compl_mult #(.W(20)) m_7  ( .clk(clk), .a(rg2[1]), .b({coeff.i[7 ],coeff.q[7 ]}), .o({ad_i[7 ], ad_q[7 ]}) );
	compl_mult #(.W(20)) m_8  ( .clk(clk), .a(rg2[0]), .b({coeff.i[8 ],coeff.q[8 ]}), .o({ad_i[8 ], ad_q[8 ]}) );
	compl_mult #(.W(20)) m_9  ( .clk(clk), .a(rg3[2]), .b({coeff.i[9 ],coeff.q[9 ]}), .o({ad_i[9 ], ad_q[9 ]}) );
	compl_mult #(.W(20)) m_10 ( .clk(clk), .a(rg3[1]), .b({coeff.i[10],coeff.q[10]}), .o({ad_i[10], ad_q[10]}) );
	compl_mult #(.W(20)) m_11 ( .clk(clk), .a(rg3[0]), .b({coeff.i[11],coeff.q[11]}), .o({ad_i[11], ad_q[11]}) );
	compl_mult #(.W(20)) m_12 ( .clk(clk), .a(rg4[2]), .b({coeff.i[12],coeff.q[12]}), .o({ad_i[12], ad_q[12]}) );
	compl_mult #(.W(20)) m_13 ( .clk(clk), .a(rg4[1]), .b({coeff.i[13],coeff.q[13]}), .o({ad_i[13], ad_q[13]}) );
	compl_mult #(.W(20)) m_14 ( .clk(clk), .a(rg4[0]), .b({coeff.i[14],coeff.q[14]}), .o({ad_i[14], ad_q[14]}) );

	
	s20 add_i [0:4];
	s20 add_q [0:4];
	s24 add_all_i;
	s24 add_all_q;
	always_comb begin
		add_i[0] = ad_i[0 ] + ad_i[5 ] + ad_i[10];
		add_i[1] = ad_i[1 ] + ad_i[6 ] + ad_i[11];
		add_i[2] = ad_i[2 ] + ad_i[7 ] + ad_i[12];
		add_i[3] = ad_i[3 ] + ad_i[8 ] + ad_i[13];
		add_i[4] = ad_i[4 ] + ad_i[9 ] + ad_i[14];
		add_q[0] = ad_q[0 ] + ad_q[5 ] + ad_q[10];
		add_q[1] = ad_q[1 ] + ad_q[6 ] + ad_q[11];
		add_q[2] = ad_q[2 ] + ad_q[7 ] + ad_q[12];
		add_q[3] = ad_q[3 ] + ad_q[8 ] + ad_q[13];
		add_q[4] = ad_q[4 ] + ad_q[9 ] + ad_q[14];
		add_all_i = add_i[0] + add_i[1] + add_i[2] + add_i[3] + add_i[4];
		add_all_q = add_q[0] + add_q[1] + add_q[2] + add_q[3] + add_q[4];
		sig_out_i = add_all_i[19:0];
		sig_out_q = add_all_q[19:0];
	end

	always_comb begin
		{yy.i[0 ], yy.q[0 ]} = rg0[2];
		{yy.i[1 ], yy.q[1 ]} = rg0[1];
		{yy.i[2 ], yy.q[2 ]} = rg0[0];
		{yy.i[3 ], yy.q[3 ]} = rg1[2];
		{yy.i[4 ], yy.q[4 ]} = rg1[1];
		{yy.i[5 ], yy.q[5 ]} = rg1[0];
		{yy.i[6 ], yy.q[6 ]} = rg2[2];
		{yy.i[7 ], yy.q[7 ]} = rg2[1];
		{yy.i[8 ], yy.q[8 ]} = rg2[0];
		{yy.i[9 ], yy.q[9 ]} = rg3[2];
		{yy.i[10], yy.q[10]} = rg3[1];
		{yy.i[11], yy.q[11]} = rg3[0];
		{yy.i[12], yy.q[12]} = rg4[2];
		{yy.i[13], yy.q[13]} = rg4[1];
		{yy.i[14], yy.q[14]} = rg4[0];
	end
	
	
endmodule
















