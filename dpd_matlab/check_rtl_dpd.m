clear all; clc;

[sig_in_i,sig_in_q,sig_pa_i,sig_pa_q,dpd_reg_i,dpd_reg_q,sig_del_i,sig_del_q,fit3_i] = importfile3('iladata.csv', 10, 9000);

tt=3500:4500;

dpd_reg = abs(dpd_reg_i+1i*dpd_reg_q);
sig_del = abs(sig_del_i+1i*sig_del_q);
sig_in = abs(sig_in_i+1i*sig_in_q);
sig_pa = abs(sig_pa_i+1i*sig_pa_q);


figure(54)
subplot(2,2,1)
plot(tt,dpd_reg(tt),tt,sig_del(tt))
legend('dpd reg','sig del')
grid on

subplot(2,2,2)
tt=1000:7000;
plot(tt, sig_in(tt)/200000, tt, sig_pa(tt+507)/200000)
legend('sig in','sig pa')
grid on

subplot(2,2,3)
tt=1500:2500;
plot(sig_in(tt)/400000, sig_pa(tt+508)/400000, '.')
legend('before adapt')
grid on
subplot(2,2,4)
tt=4500:5500;
plot(sig_in(tt)/400000, sig_pa(tt+508)/400000, '.')
legend('after adapt')
grid on