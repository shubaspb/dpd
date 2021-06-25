clear all; clc;
close all;

n=3000;
mu=0.125;   
K=0.7;
len_dpd=100e3;


% working signal from rtl
delay1=10;
[pa_in_work_i, pa_in_work_q] = importfile('../dpd_rtl/dpd_tb/in_sig.txt', n+delay1);


pa_in_work = pa_in_work_i' + 1i*pa_in_work_q';
pa_in_work = pa_in_work/2^19;

pa_in_train = gen_adapt_signal(0);  % test signal for adaptation 

    
load coef_pa_fit_3_2;       % PA coeff
coef_pa_fit=coef_pa_fit*0.9;
coef_pa_fit0=round(coef_pa_fit*2^17); abs(sum(coef_pa_fit0))

pa_out_train = DPD_fp(pa_in_train, coef_pa_fit,  3, 3); % PA model

hdl_analize( pa_out_train );  % comnpare with hdl


% DPD training
[coef_pd, e2]= FIT_LMS_fp(mu, pa_out_train, pa_in_train, 3, 5);

% DPD
dpd_out = DPD_fp(pa_in_work, coef_pd,  3, 5);

% PA
dpd_pa_out = DPD_fp(dpd_out, coef_pa_fit, 3, 3);
pa_out_work = DPD_fp(pa_in_work, coef_pa_fit,  3, 3);

% analise result
[loss_db, nonlinear_suppression_db] = dpd_analise_result( pa_in_work, pa_out_work(2:end)*K, dpd_pa_out(5:end), 100  );
loss_db-20*log10(K), nonlinear_suppression_db,


hdl_analize_all(1);




