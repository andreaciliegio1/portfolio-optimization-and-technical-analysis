function plot_rendimenti(RisultatiMDP,RisultatiRP,RisultatiMVC,RisultatiMV,out_sample)
    %Calcolo i rendimenti effettivi
    EffettiviMDP = RisultatiMDP(1:end-4,:).*out_sample';
    EffettiviRP = RisultatiRP(1:end-4,:).*out_sample';
    EffettiviMVC = RisultatiMVC(1:end-4,:).*out_sample';
    EffettiviMV = RisultatiMV(1:end-4,:).*out_sample';

    %Calcolo i rendimenti effettivi cumulati
    CumulateMDP = cumsum(sum(EffettiviMDP,1),2);
    CumulateRP = cumsum(sum(EffettiviRP,1),2);
    CumulateMVC = cumsum(sum(EffettiviMVC,1),2);
    CumulateMV = cumsum(sum(EffettiviMV,1),2);
    x= 0:1:size(out_sample,1)-1;
    
    % Plot rendimenti di ogni strategia utilizzata
    if not(isnan(CumulateMDP))
        plot(x,CumulateMDP,'c-','LineWidth',1);
        hold on
    end
   
    if not(isnan(CumulateRP))
        plot(x,CumulateRP,'LineWidth',1);
        hold on
    end

    if not(isnan(CumulateMVC))
        plot(x,CumulateMVC,'m-','LineWidth',1);
        hold on
    end

    if not(isnan(CumulateMV))
        plot(x,CumulateMV,'k-','LineWidth',1);
        hold on
    end
    
end