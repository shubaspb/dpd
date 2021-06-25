function [loss_db, err] = dpd_analise_result( pa_in_work, pa_out_work, dpd_pa_out, num_graph )

    tt=150:length(pa_in_work)-100;

    loss_db = 10*log10( sum(abs(pa_out_work(tt)).^2)/sum(abs(dpd_pa_out(tt)).^2) );
    pa_in_x = abs(pa_in_work(1:end));
    pa_out_x = abs(pa_out_work(1:end));
    dpd_pa_out_x = abs(dpd_pa_out(1:end));

    figure(num_graph)


    subplot(2,2,1)
    plot(pa_in_x(tt),  pa_out_x(tt), '.', pa_in_x(tt),  dpd_pa_out_x(tt), '.')
    legend ('no DPD', 'DPD')
    grid on   

    err = 10*log10( sum((pa_in_x(tt)-pa_out_x(tt)).^2)/sum((pa_in_x(tt)-dpd_pa_out_x(tt)).^2) );
    
    fs=20e6;
    nk=1024*64;
    if (nk>=length(pa_in_work))
        pa_in_work = [pa_in_work zeros(1,nk)];
        pa_out_work = [pa_out_work zeros(1,nk)];
        dpd_pa_out = [dpd_pa_out zeros(1,nk)];
    end
    
    
    [pa_in_sp, f_axe] = Spectr2(pa_in_work, fs, nk);
    [pa_out_sp, f_axe] = Spectr2(pa_out_work, fs, nk);
    [dpd_pa_out_sp, f_axe] = Spectr2(dpd_pa_out, fs, nk);


    subplot(2,2,2) 
    kk=length(f_axe);
    kkk=kk/2-round(kk/5)+5:kk/2+round(kk/5)-5;
    plot(f_axe(kkk), pa_in_sp(kkk), f_axe(kkk), pa_out_sp(kkk),f_axe(kkk), dpd_pa_out_sp(kkk)); 
    grid on
    legend('pa in', 'pa out', 'dpd pa out')
    xlabel('F, MHz')
    ylabel('dB')
    
    %ss=find(pa_in_x>=max(pa_in_x)*0.9);
    %sss=ss(1)-200:ss(1)+200;
    if (length(pa_in_x)>=2000)
        gg=2000;
    else
        gg=length(pa_in_x)-10;
    end
    sss=1:gg;
    t_sss=sss/fs*1e6;
    subplot(2,2,[3,4])
    plot(t_sss, pa_in_x(sss), t_sss, pa_out_x(sss), t_sss, dpd_pa_out_x(sss))
    legend('pa in', 'pa out', 'dpd pa out')
    ylabel('y.e.')
    xlabel('us')
    grid on
    
    
    
    
    
%     figure(97)
%     plot(t_sss, 20*log10(pa_in_x(sss)), t_sss, 20*log10(pa_out_x(sss)), t_sss, 20*log10(dpd_pa_out_x(sss)))
%     legend('pa in', 'pa out', 'dpd pa out')
%     ylabel('y.e.')
%     xlabel('us')
%     grid on
    
    
    
    
    
%     figure(97)
%     kk=length(f_axe);
%     kkk=kk/2-round(kk/5)+5:kk/2+round(kk/5)-5;
%     
%     subplot(1,3,1) 
%     plot(f_axe(kkk), pa_in_sp(kkk)); 
%     grid on
%     xlabel('F, MHz')
%     ylabel('dB')
%     
%     subplot(1,3,2) 
%     plot( f_axe(kkk), pa_out_sp(kkk)); 
%     grid on
%     xlabel('F, MHz')
%     ylabel('dB')
%     
%     subplot(1,3,3) 
%     plot(f_axe(kkk), dpd_pa_out_sp(kkk)); 
%     grid on
%     xlabel('F, MHz')
%     ylabel('dB') 
    
    
end

