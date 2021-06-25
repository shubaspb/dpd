function [Sp_dB, f_axe] = Spectr(X, fd, num_graph)

X=reshape(X,1,length(X));

n = length(X);
win=blackman(1,n);
%X = X - mean(X);


Sp_X = abs(fft(X.*win/n));
Z = sqrt(var(Sp_X)); %Sp_X(1);
Sp_dB = 20*log10(Sp_X/max(abs(Sp_X)));
%Sp_dB = 20*log10(Sp_X);
Sp_dB (Sp_dB<=-60) = -60;
f_axe = [(-n/2:-1) (0:n/2-1)]/n*fd/1e6;
Sp_dB = [Sp_dB(n/2+1:n)  Sp_dB(1:n/2)];


if (num_graph==0)
    
else
figure(num_graph); 

size(f_axe), 
size(Sp_dB),

plot(f_axe, Sp_dB); 
grid on
xlabel('F, MHz')
ylabel('dB')
end


end

