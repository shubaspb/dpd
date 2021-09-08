
module mag_5(
    input       reset_b,
    input       clk,
    input  s20  sig_in_i,
    input  s20  sig_in_q,
    output u20  mag_0,
    output u20  mag_1,
    output u20  mag_2,
    output u20  mag_3,
    output u20  mag_4);

u20 magn_0;
polar_cordic #(.W(20)) polar_cordic_inst (
    .reset_b    (reset_b),
    .clk        (clk),
    .sig_i      (sig_in_i),
    .sig_q      (sig_in_q),
    .magnitude  (magn_0),
    .angle      ()
);

u20 magn_1;
delay_rg #(.W(20), .D(11)) delay_rg_inst1
   (.reset_b(reset_b),
    .clk    (clk),
    .din    (magn_0),
    .dout   (magn_1));

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