function [Sp_dB, f_axe] = Spectr2(X, fd, n)

X=reshape(X,1,length(X));

%n = length(X);
win=blackman(1,n);
%X = X - mean(X);
Sp_X=zeros(1,n);
for k=1:floor(length(X)/n)
    Sp_X = Sp_X + abs(fft(X((k-1)*n+1:n*k)).*win/n);
end

Z = sqrt(var(Sp_X)); %Sp_X(1);
Sp_dB = 20*log10(Sp_X/max(abs(Sp_X)));
%Sp_dB = 20*log10(Sp_X);
Sp_dB (Sp_dB<=-60) = -60;
f_axe = [(-n/2:-1) (0:n/2-1)]/n*fd/1e6;
Sp_dB = [Sp_dB(n/2+1:n)  Sp_dB(1:n/2)];



end

