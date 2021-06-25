
module mag_5(
    input         	   clk,
    input  		[19:0] sig_in_i,   
	input  		[19:0] sig_in_q, 
    output reg 	[19:0] mag_0,
	output reg 	[19:0] mag_1,
	output reg 	[19:0] mag_2,
	output reg 	[19:0] mag_3,
	output reg 	[19:0] mag_4
    );  
	
	
	wire [19:0] magn_1;
	mag_complex mag_complex_inst(
	    .clk	  (clk),
		.sig_in_i (sig_in_i),    
		.sig_in_q (sig_in_q),
		.magn     (magn_1)  		
	);  

	reg [39:0] magn_2_full;
    always @(posedge clk)
		begin
			magn_2_full <= magn_1*magn_1;
		end	
	wire [19:0] magn_2 = magn_2_full[38:19]+magn_2_full[18];		
		
	reg [19:0] magn_1_del1;
    always @(posedge clk)
		begin
			magn_1_del1 <= magn_1;
		end	
		
	reg [39:0] magn_3_full;
    always @(posedge clk)
		begin
			magn_3_full <= magn_2*magn_1_del1;		
		end	
	wire [19:0] magn_3 = magn_3_full[38:19]+magn_3_full[18];
	
	reg [39:0] magn_4_full;
    always @(posedge clk)
		begin
			magn_4_full <= magn_2*magn_2;
		end	
	wire [19:0] magn_4 = magn_4_full[38:19]+magn_4_full[18];

    
	reg [19:0] magn_1_del2;
	reg [19:0] magn_2_del1;
    always @(posedge clk)
		begin
			magn_1_del2 <= magn_1_del1;
			magn_2_del1 <= magn_2;
		end

    always @(posedge clk)
		begin
			mag_0 <= 20'd524287;
			mag_1 <= magn_1_del2[19:0]; 
			mag_2 <= magn_2_del1[19:0]; 
			mag_3 <= magn_3[19:0];       
			mag_4 <= magn_4[19:0];      
		end
		

	
    
endmodule



