
module mag_5(
    input       clk,
    input  s20  sig_in_i,
    input  s20  sig_in_q,
    output u20  mag_0,
    output u20  mag_1,
    output u20  mag_2,
    output u20  mag_3,
    output u20  mag_4);

u20 magn_1;
mag_complex mag_complex_inst(
    .clk      (clk),
    .sig_in_i (sig_in_i),
    .sig_in_q (sig_in_q),
    .magn     (magn_1)
);  

u40 magn_2_full;
always_ff @(posedge clk)
    magn_2_full <= magn_1*magn_1;

u20 magn_2;
always_comb begin
    magn_2 = magn_2_full[38:19]+magn_2_full[18];
end 

u20 magn_1_del1;
u20 magn_1_del2;
u20 magn_2_del1;
u40 magn_3_full;
u40 magn_4_full;
always_ff @(posedge clk) begin
    magn_1_del1 <= magn_1;
    magn_1_del2 <= magn_1_del1;
    magn_2_del1 <= magn_2;
    magn_3_full <= magn_2*magn_1_del1;
    magn_4_full <= magn_2*magn_2;
end 

always_ff @(posedge clk) begin
    mag_0 <= 20'd524287;
    mag_1 <= magn_1_del2[19:0];
    mag_2 <= magn_2_del1[19:0];
    mag_3 <= magn_3_full[38:19]+magn_3_full[18];
    mag_4 <= magn_4_full[38:19]+magn_4_full[18];
end

endmodule