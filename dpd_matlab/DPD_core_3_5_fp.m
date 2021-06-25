function [Out, y] = DPD_core_3_5_fp(xx, coeff)

coeff=round(coeff*2^20);
xx=round(xx*2^19);


y = zeros(1,5*3);

H=2^19;


for i=1:3
    x=xx(i);
    abs_x=abs(x);

    abs_0=H;
    abs_1=abs_x;
    abs_2=abs_x*abs_x/H; 
    abs_3=abs_1*abs_2/H;
    abs_4=abs_2*abs_2/H;  

    y(0+i)  = x*(abs_0)/H;    
    y(3+i)  = x*(abs_1)/H;
    y(6+i)  = x*(abs_2)/H;
    y(9+i)  = x*(abs_3)/H;
    y(12+i) = x*(abs_4)/H;
end
    y(1:15)=y(1:15).'/2;
    
    %[abs_0  abs_1 abs_2 abs_3 abs_4],
    
    
    
Out = y*coeff/H;

y=y/2^18;
Out=Out/2^19;
    
%Out = y(8)*coeff(8)/H;
