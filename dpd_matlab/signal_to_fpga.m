function [x_iq] = signal_to_fpga(x)

x = round(x);
x_i = Dop_code(real(x), 12, 0);
x_q = Dop_code(imag(x), 12, 0);
x_i=dec2hex(x_i,3);
x_q=dec2hex(x_q,3);

x_iq=[x_i,x_q];

end

