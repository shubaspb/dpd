function [pa_in_train] = gen_adapt_signal(write_file)

len_train= 900; 
pa_in_train = gen_test_signal_3(len_train*2, len_train, len_train*2);
pa_in_train=pa_in_train(200:len_train+100)*0.9;

if ( write_file)
w=16;
pa_in_train_r = round(pa_in_train*0.7*(2^(w-1)));
pa_in_train_i = real(pa_in_train_r);
pa_in_train_q = imag(pa_in_train_r);
zz = Dop_code(pa_in_train_i, w, 0);
pa_in_train_i = zeros(1,1024);
pa_in_train_i(1:length(zz))=zz;
write_sig(pa_in_train_i, w, '../dpd_rtl/dpd_sig_train_i.mem');
write_sig(pa_in_train_i, w, '../dpd_rtl/dpd_tb/dpd_sig_train_i.mem');
zz = Dop_code(pa_in_train_q, w, 0);
pa_in_train_q = zeros(1,1024);
pa_in_train_q(1:length(zz))=zz;
write_sig(pa_in_train_q, w, '../dpd_rtl/dpd_sig_train_q.mem'); 
write_sig(pa_in_train_q, w, '../dpd_rtl/dpd_tb/dpd_sig_train_q.mem'); 
end

end

