// Copyright (c) 2018, Dmitry Shubin
// Digital Pre-distortion 
// LMS adaptation
// time adaptation = 50 us
// polinome 5 degree, time memory - 3 cycles
// must be: Fs > 4*signal_bandwidth , Fs is clk
// select gain for sig_pa_i by comparing mag sig_pa and mag sig_out
// select DELAY by minimum of err_fit_mag

`include "package_dpd.svh"

module dpd 
    #(parameter DELAY = 41)         // compensation for delay (transceiver + amplifier)
   (input       clk,                // clock
    input       reset_b,            // reset
    input       dpd_adapt,          // 1 - turn on adaptation, 0 - regular transmission
    input  s20  sig_in_i,           // signal from fpga, real part
    input  s20  sig_in_q,           // signal from fpga, image part
    input  s20  sig_pa_i,           // signal from amplifier, real part
    input  s20  sig_pa_q,           // signal from amplifier, image part
    output s20  sig_out_i,          // signal to amplifier, real part 
    output s20  sig_out_q,          // signal to amplifier, image part
    output u20  err_fit_mag);       // error fit delay

/////////////// Control /////////////////////////////////////////////////////////// 
u1 dpd_ad0;
u1 dpd_ad1;
ff #(.W(1)) ff1 (.clk, .d(dpd_adapt), .q(dpd_ad0));
ff #(.W(1)) ff2 (.clk, .d(dpd_ad0),   .q(dpd_ad1));

u1 start_adapt;
always_comb begin
    start_adapt = (dpd_ad0)&(~dpd_ad1);
end 

u16 cnt;
always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin 
        cnt <= '1;
    end else begin
        if (start_adapt)
            cnt <= '0;
        else
            cnt <= cnt + ~&cnt;
    end

u1 dpd_adapt_sig;
u1 dpd_adapt_coeff;
u1 dpd_adapt_sw_in;
always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin 
        dpd_adapt_sig <= '0;
        dpd_adapt_coeff <= '0;
        dpd_adapt_sw_in <= '0;
    end else begin
        dpd_adapt_sig <= (cnt>=1)&(cnt<=800);
        dpd_adapt_coeff <= (cnt>=(DELAY+150))&(cnt<=(DELAY+700));
        dpd_adapt_sw_in <= (cnt>=(DELAY+1))&(cnt<=(DELAY+800));
    end

s20 ss0_i;
s20 ss0_q;
always_comb begin
    {ss0_i,ss0_q} = (dpd_adapt_sw_in) ? {sig_pa_i,sig_pa_q} : {sig_in_i,sig_in_q};
end

s20 sig_fit_in_i;
s20 sig_fit_in_q;
ff #(.W(40)) ff3 (.clk, .d({ss0_i,ss0_q}), .q({sig_fit_in_i,sig_fit_in_q} ));

//////////////// FIT LMS //////////////////////////////////////////////////////////////////////////
s20 sig_dpd_i;
s20 sig_dpd_q;
intf_coef_3_5 coeff_fit();
intf_coef_3_5 yy();
dpd_mem3 dpd_mem3_inst2(
    .reset_b    (reset_b),
    .clk        (clk),
    .sig_in_i   (sig_fit_in_i),
    .sig_in_q   (sig_fit_in_q),
    .sig_out_i  (sig_dpd_i),
    .sig_out_q  (sig_dpd_q),
    .coeff      (coeff_fit),
    .yy         (yy)
);

////////////////// test signal /////////////////////////////////////////////////////////////////////
s16 sig_train_i; 
s16 sig_train_q;
dpd_test_sig #(.W(16)) dpd_test_sig_inst1
   (.clk    (clk),
    .reset_b(reset_b),
    .start  (dpd_adapt_sig),
    .sig_i  (sig_train_i),
    .sig_q  (sig_train_q));

u40 sig_train_all;
always_comb begin
    sig_train_all = {sig_train_i, 4'd0, sig_train_q, 4'd0};
end

s20 sig_del_i;
s20 sig_del_q;
delay_rg #(.W(40), .D(DELAY)) delay_rg_inst
   (.reset_b(reset_b),
    .clk    (clk),
    .din    (sig_train_all),
    .dout   ({sig_del_i,sig_del_q}));


///// latch feedback because its too hard to realise two complex multipliers by one cycle //////
///// the adaptation time is multiplied by 2 ///////////////////////////////////////////////////
u1 on_off;
always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin
        on_off <= 1'd0;
    end else begin
        on_off <= ~on_off;
    end 

s20 sig_dpd_reg_i;
s20 sig_dpd_reg_q;
s20 sig_del_reg_i;
s20 sig_del_reg_q;

ff #(.W(20)) ff6 (.clk, .d(sig_dpd_i), .q(sig_dpd_reg_i));
ff #(.W(20)) ff7 (.clk, .d(sig_dpd_q), .q(sig_dpd_reg_q));
ff #(.W(20)) ff8 (.clk, .d(sig_del_i), .q(sig_del_reg_i));
ff #(.W(20)) ff9 (.clk, .d(sig_del_q), .q(sig_del_reg_q));

s20 yy_reg_i [0:14];
s20 yy_reg_q [0:14];
always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin
        for (int i=0; i<15; i++)
            {yy_reg_i[i], yy_reg_q[i]} <= {'0, '0};
    end else begin
        if (on_off) begin
            for (int i=0; i<=15; i++)
                {yy_reg_i[i], yy_reg_q[i]} <= {yy.i[i], yy.q[i]};
        end else begin
            for (int i=0; i<15; i++)
                {yy_reg_i[i], yy_reg_q[i]} <= {'0, '0};
        end
    end

/////////////////// FIT LMS /////////////////////////////////////////////////////////////////
s20 fit1_i;
s20 fit1_q;
s20 fit2_i;
s20 fit2_q;
s20 fit3_i;
s20 fit3_q;
always_comb begin
    fit1_i = sig_del_reg_i - sig_dpd_reg_i;
    fit1_q = sig_del_reg_q - sig_dpd_reg_q;
    fit2_i = fit1_i;
    fit2_q = ~fit1_q;
    fit3_i = fit2_i >>> 3;
    fit3_q = fit2_q >>> 3;
end

polar_cordic #(.W(20)) polar_cordic_inst5 (
    .reset_b    (reset_b),
    .clk        (clk),
    .sig_i      (fit1_i),
    .sig_q      (fit1_q),
    .magnitude  (err_fit_mag),
    .angle      ());

s20 m_i [0:14];
s20 m_q [0:14];
generate
for (genvar i=0; i < 15; i++)  begin: mults
    compl_mult #(.W(20)) mult_0(
        .a      ({yy_reg_i[i],yy_reg_q[i]}),
        .b      ({fit3_i, fit3_q}), 
        .o      ({m_i[i], m_q[i]}));
end
endgenerate

s20 cc_i [0:14];
s20 cc_q [0:14];
always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin
        for (int i=0; i<3; i++) begin
            cc_i[i] <= 20'd349500;
            cc_q[i] <= 20'd0;
        end 
        for (int i=3; i<15; i++) begin
            cc_i[i] <= '0;
            cc_q[i] <= '0;
        end
    end else begin
        if (dpd_adapt_coeff) begin
            for (int i=0; i<=15; i++) begin
                cc_i[i] <= cc_i[i] + m_i[i];
                cc_q[i] <= cc_q[i] + m_q[i];
            end
        end
    end

always_comb begin
    for (int i=0; i<=15; i++) begin
        coeff_fit.i[i] = (dpd_adapt_coeff) ? cc_i[i]  : cc_i[i];
        coeff_fit.q[i] = (dpd_adapt_coeff) ? ~cc_q[i] : cc_q[i];
    end
end

always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin 
        sig_out_i <= '0;
        sig_out_q <= '0;
    end else begin
        if (dpd_adapt_sig) begin
            sig_out_i <= {sig_train_i, 4'd0};
            sig_out_q <= {sig_train_q, 4'd0};
        end else begin
            sig_out_i <= sig_dpd_i;
            sig_out_q <= sig_dpd_q;
        end
    end 


endmodule