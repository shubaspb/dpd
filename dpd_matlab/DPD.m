function Out = DPD(x, coeff, mem, degree)


len=length(x)-mem;
Out=[];
y=[];

for n = 1:len   
    %A=[   a00 a01 a02 ... a0(M-1) , a10 a11 a12 ... a1(M-1 ), ... , a(K-1)0 a(K-1)1 a(K-1)(M-1))   ]   
    xx=x(n:(n + mem-1));
    [Out(n), y] = DPD_core(xx, coeff, mem, degree);
end

Out=reshape(Out,1,length(Out));
Out=[zeros(1,4)  Out(1:end-1)];








