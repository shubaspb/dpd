function [xx] = gen_work_signal(n)

xx=exp(1i*2*pi*0.03*(0:n-1))*0.47 + exp(1i*2*pi*0.007*(0:n-1))*0.19 + exp(1i*2*pi*0.01*(0:n-1))*0.32;
xx_fp=round(xx*(2^19-1)*0.8);
T = [real(xx_fp)' imag(xx_fp)'];
dlmwrite('..\dpd_rtl\dpd_tb\input_file.txt',T,'precision', 9)

end


