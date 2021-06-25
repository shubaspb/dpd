function X = gen_test_signal_3( nn, len_pulse, period_pulse )
 % noisy pulses
    %XXX=randn(1,nn)+1i*randn(1,nn);
    XXX=randn(1,nn)+1i*randn(1,nn);
    XXX=XXX/3;
    XXX=0.25*exp(1i*2*pi*0.0371*(0:nn-1))+0.35*exp(1i*2*pi*0.0153*(0:nn-1))+0.45*exp(1i*2*pi*0.0062*(0:nn-1));
    X=zeros(1,nn); 
    for i=1:period_pulse:nn-len_pulse
        X(i+1:i+len_pulse)=XXX(i+1:i+len_pulse); %*0.2 + 0.5+1i*0.5;
    end
    real_X = fltr(real(X), 'Num8MHz.mat');
    imag_X = fltr(imag(X), 'Num8MHz.mat');
    %X=X';
    X=real_X + 1i*imag_X;
    X=X*1;
    
end

