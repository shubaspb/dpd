function [w, e]=FIT_LMS_fp(mu,x,d,mem, degree)

k=degree*mem;
w=ones(k,1)*0.01;
len=length(x)-mem;
y = zeros(1,k);
e=[];

for n = 1:len   

    xx=x(n:(n + mem-1));
    coeff = conj(w);
    %[Out, y] = DPD_core(xx, coeff, mem, degree);
    [Out, y] = DPD_core_3_5_fp(xx, coeff);  
    
    y=reshape(y,length(y),1);
    ee=d(n)-Out;  
    
    if (abs(ee)>0)
        e=[e abs(ee)]; 
    end
        
    
    w=w+mu*y*conj(ee);
    
end

