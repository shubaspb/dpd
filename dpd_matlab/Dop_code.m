function Y = Dop_code(X, w, flag_convert)

% to 2's complement code
if (flag_convert==0)
for i=1:length(X)
   if X(i)<0
      Y(i) = 2^w - abs(X(i));
   else
       Y(i) = X(i);
   end
end
end

% from 2's complement code
if (flag_convert==1)
for i=1:length(X)
   if X(i)>=2^(w-1)
      Y(i) =  X(i)-2^w;
   else
      Y(i) = X(i);
   end
end
end



end

