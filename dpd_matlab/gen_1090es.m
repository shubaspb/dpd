
clear all;clc;
LENGTH_OUT=4000;


load('sig_1090es_all')

Spectr(X, 20, 20);

%X = fltr(X, 'fir_20_4.mat');

X=round(X/16*0.9);

figure(67)
plot(abs(X))
grid on


sig_1090es_hex = signal_to_fpga(X);

X=[X, zeros(1,100000)];
    
Spectr(X, 20, 21);



  











