function coef = FIT_RMS(x, d, mem, degree)

len=length(x)-mem;
y = zeros(len,degree*mem);

for n = 1:len  
    for k = 1:degree
        %A=[   a00 a01 a02 ... a0(M-1) , a10 a11 a12 ... a1(M-1 ), ... , a(K-1)0 a(K-1)1 a(K-1)(M-1))   ]
        y(n,(k - 1)*mem+(1:mem)) = (x(n:(n + mem-1)).*(abs(x(n:(n + mem -1))).^(k - 1))).';    
    end
end


y_m=d(mem-1+(1:len))';
coef = y\y_m;

