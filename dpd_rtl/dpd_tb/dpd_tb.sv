
//*************************************************************************************
`timescale 1ns / 10ps

//`include "../package_dpd.svh"

module dpd_tb
   (output [23:0] sig);


   
// == Generate clock and reset ===
reg clk;
reg reset_b;
	
always
  #25 clk = ~clk;


  
initial
begin
  clk = 1;
  reset_b = 0;
  #100 reset_b = 1; 
end 


    u32 cnt;
	always_ff @(posedge clk, negedge reset_b)
	    if (~reset_b) begin 
		    cnt <= 32'd0;
	    end else begin
		    cnt <= cnt + 32'd1;
	    end
	wire dpd_adapt = (cnt>=32'd1000)&(cnt<=32'd1800);



//////////////////////////////////////////////////////////////////////////////////////
//  	integer data_file;
//  	initial begin
//  		data_file = $fopen("input_file.txt", "r");
//  	end
//  	
//      s20 sig_in_i; 
//  	s20 sig_in_q;
//  	integer tmp;
//  	always_ff @(posedge clk) begin
//  	    tmp = $fscanf(data_file, "%d,%d\n", sig_in_i, sig_in_q); 
//  	end
////////////////////////////////////////////////////////////////////////////////////////


 
    s20 sig_in_i; 
	s20 sig_in_q;	
	gen_signal gen_signal_inst
	   (.clk	(clk	), 
		.reset_b(reset_b), 
		.sig_i	(sig_in_i),
		.sig_q  (sig_in_q)
		);



////////////////////////////// WRITE FILE ////////////////////////////////////
	integer write_data1;
	initial begin
		write_data1 = $fopen("in_sig.txt", "w");
	end
		
	always_ff @(posedge clk) begin
		$fdisplay(write_data1, "%d,%d", sig_in_i, sig_in_q);
	end	
////////////////////////////////////////////////////////////////////////////

	
	
	




	s20 sig_pa_out_i;
	s20 sig_pa_out_q;
	s20 sig_out_i;
	s20 sig_out_q;
	dpd #(.DELAY(540)) dpd_inst(
		.clk		(clk		),
		.reset_b	(reset_b	),
		.dpd_adapt	(dpd_adapt	),
		.sig_in_i	(sig_in_i), 
		.sig_in_q	(sig_in_q),
		.sig_pa_i   (sig_pa_out_i  ),
		.sig_pa_q   (sig_pa_out_q  ),
		.sig_out_i	(sig_out_i),
		.sig_out_q  (sig_out_q)
	);
///////////////////////////////////////////////////////////////////////////////////////









	
///////////////// PA model ////////////////////////////////////////////////////////////
	intf_coef_3_5 coeff_pa();
	always_comb begin
		{coeff_pa.i[0 ], coeff_pa.q[0 ]} = { -20'sd169240, -20'sd33408  };  
		{coeff_pa.i[1 ], coeff_pa.q[1 ]} = {  20'sd472844,  20'sd86066  };  
		{coeff_pa.i[2 ], coeff_pa.q[2 ]} = { -20'sd469769, -20'sd114184 };  
		{coeff_pa.i[3 ], coeff_pa.q[3 ]} = {  20'sd8696  ,  20'sd11745  };  
		{coeff_pa.i[4 ], coeff_pa.q[4 ]} = { -20'sd22564 , -20'sd26655  };  
		{coeff_pa.i[5 ], coeff_pa.q[5 ]} = {  20'sd20995 ,  20'sd21438  };  
		{coeff_pa.i[6 ], coeff_pa.q[6 ]} = {  20'sd179460,  20'sd13802  };  
		{coeff_pa.i[7 ], coeff_pa.q[7 ]} = { -20'sd465891, -20'sd39397  };  
		{coeff_pa.i[8 ], coeff_pa.q[8 ]} = {  20'sd365568,  20'sd35596  };  
		{coeff_pa.i[9 ], coeff_pa.q[9 ]} = { 40'd0 };  
		{coeff_pa.i[10], coeff_pa.q[10]} = { 40'd0 };  
		{coeff_pa.i[11], coeff_pa.q[11]} = { 40'd0 };  
		{coeff_pa.i[12], coeff_pa.q[12]} = { 40'd0 }; 
		{coeff_pa.i[13], coeff_pa.q[13]} = { 40'd0 };  
		{coeff_pa.i[14], coeff_pa.q[14]} = { 40'd0 }; 
    end
	
	s20 sig_out_i_0;
	s20 sig_out_q_0;
	intf_coef_3_5 yy_pa();
	dpd_mem3 dpd_mem3_inst(
		.clk	    (clk),
		.reset_b    (reset_b),
		.sig_in_i   (sig_out_i),   
		.sig_in_q   (sig_out_q),   
		.sig_out_i  (sig_out_i_0),
		.sig_out_q  (sig_out_q_0),
        .coeff      (coeff_pa),
		.yy			(yy_pa)
	);
		
		
    s20 sig_out_i_1;
	s20 sig_out_q_1;
	assign sig_out_i_1 = {sig_out_i_0[16:0], 3'd0};
	assign sig_out_q_1 = {sig_out_q_0[16:0], 3'd0};
    delay_rg #(.W(40), .D(500)) delay_rg_inst
	   (.clk     (clk     ),
		.data_in ({sig_out_i_1,sig_out_q_1}),     
		.data_out({sig_pa_out_i,sig_pa_out_q}));
	
///////////////////////////////////////////////////////////////////////////////////////	
	

	
	u20 magn_sig_in;
	mag_complex mag_complex_inst(
	    .clk	  (clk),
		.sig_in_i (sig_in_i),    
		.sig_in_q (sig_in_q),
		.magn     (magn_sig_in)  		
	);
	
	
	u20 magn_sig_out;
	mag_complex mag_complex_inst1(
	    .clk	  (clk),
		.sig_in_i (sig_out_i),    
		.sig_in_q (sig_out_q),
		.magn     (magn_sig_out)  		
	);
	
	u20 magn_sig_pa_out;
	mag_complex mag_complex_inst2(
	    .clk	  (clk),
		.sig_in_i (sig_pa_out_i),    
		.sig_in_q (sig_pa_out_q),
		.magn     (magn_sig_pa_out)  		
	);
	
	
	
	
////////////////////////////// WRITE FILE ////////////////////////////////////
	integer write_data;
	initial begin
		write_data = $fopen("output_file.txt", "w");
	end
		
	always_ff @(posedge clk) begin
		$fdisplay(write_data, "%d,%d", sig_pa_out_i, sig_pa_out_q);
	end	
////////////////////////////////////////////////////////////////////////////		

	

endmodule














