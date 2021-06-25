function flag = write_sig(X, w, file_name)
len = length(X);
X_bin = zeros(w, len);
fid1 = fopen(file_name,'wt');
for i =1:length(X)
    if X(i)<0
        X(i) = 2^w - X(i);
    end
    X_bin(:,i) = bitget(uint32(X(i)), w:-1:1);
    for k=1:w-1
       fprintf(fid1,'%d', X_bin(k,i));
    end
    fprintf(fid1,'%d\n', X_bin(w,i));
end
    fclose(fid1);
    flag=1;
    
end

