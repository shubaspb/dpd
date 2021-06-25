function [s_out] = hdl_analize_all( flag )


nn=2000;
delay=500;

[di, dq, si, sq] = importfile4('../dpd_rtl/dpd_tb/fit.txt', 27+19, nn+100);

d=(di+1i*dq)/2^0;
s=(si+1i*sq)/2^0;

figure(34)
tt=1:length(d);
plot(tt,abs(d(tt)),tt,abs(s(tt)))
legend('d','s')
grid on


[sin_i,sin_q] = importfile('../dpd_rtl/dpd_tb/in_sig.txt', 11+delay, 20000+10);
[sout_i,sout_q] = importfile('../dpd_rtl/dpd_tb/output_file.txt', 55+delay, 20000);

s_in = sin_i + 1i*sin_q;
s_out = sout_i + 1i*sout_q;

del=4+500;
tt1=11:810;
tt2=2500:2900;


figure(36)
subplot(2,2,1)
plot(tt1,abs(s_in(tt1+del)),tt1, abs(s_out(tt1)))
legend('in', 'out')
grid on
subplot(2,2,2)
plot(tt2,abs(s_in(tt2+del)),tt2, abs(s_out(tt2)))
legend('in', 'out')
grid on
subplot(2,2,3)
plot(abs(s_in(tt1+del)),abs(s_out(tt1)),'.')
grid on
axis([0 5 0 5]*1e5)
subplot(2,2,4)
plot(abs(s_in(tt1+del)),abs(s_out(tt1)),'.', abs(s_in(tt2+del)), abs(s_out(tt2)),'.')
grid on
axis([0 5 0 5]*1e5)




end

