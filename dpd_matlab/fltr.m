function Y = fltr(X, file_name)

open(file_name);
coeff=ans.Num;
Y=filter(coeff,1,X); 
end