function [err_i] = hdl_analize( Out_fp )

Out_fp=Out_fp*2^19;


[rtl_i,rtl_q] = importfile('../dpd_rtl/dpd_tb/output_file.txt', 27+19, 20000);

tt=1:800;
tt1=tt+1000-17;

mat_i=real(Out_fp(tt));
mat_q=imag(Out_fp(tt));

err_i = mat_i(tt)-rtl_i(tt1)';
err_q = mat_q(tt)-rtl_q(tt1)';


figure(10)
subplot(2,2,1)
plot(tt,abs(Out_fp(tt)),tt, abs(rtl_i(tt1)+1i*rtl_q(tt1)))
legend('matlab','rtl', 'in')
grid on



figure(9)
subplot(2,2,1)
plot(tt,real(Out_fp(tt)),tt,rtl_i(tt1))
legend('matlab','rtl', 'in')
grid on
subplot(2,2,2)
plot(tt,imag(Out_fp(tt)),tt,rtl_q(tt1))
legend('matlab','rtl')
grid on
subplot(2,2,3)
plot(tt, 20*log10(abs(err_i./mat_i(tt))))
grid on
subplot(2,2,4)
plot(tt, 20*log10(abs(err_q./mat_q(tt))))
grid on
end

