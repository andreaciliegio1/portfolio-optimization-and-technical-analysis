function [RiepilogoATT, Quote_VincentiATT,RiepilogoEFF,Quote_VincentiEFF] = determina_vincente(RisultatiMDP,RisultatiRP,RisultatiMVC,RisultatiMV, Sharpe_RatiosATT,Sharpe_RatiosEFF,mode)
    [numero_tit,numero_rolls] = size(RisultatiMDP);
    RiepilogoATT = strings(numero_rolls,1);
    Quote_VincentiATT = NaN(numero_tit-4,numero_rolls);
    RiepilogoEFF = strings(numero_rolls,1);
    Quote_VincentiEFF = NaN(numero_tit-4,numero_rolls);
    for i = 1:numero_rolls
        % Se mode == 1, determina la strategia vincente basata su Sharpe ATT
        if mode == 1
            [~,idx] = max(Sharpe_RatiosATT(:,i));
            if idx == 1
                RiepilogoATT(i) = "Strategia vincente: Most Diversified Portfolio";
                Quote_VincentiATT(:,i) = RisultatiMDP(1:end-4,i);
            elseif idx == 2
                RiepilogoATT(i) = "Strategia vincente: Risk Parity Constraint";
                Quote_VincentiATT(:,i) = RisultatiRP(1:end-4,i);
            elseif idx == 3
                RiepilogoATT(i) = "Strategia vincente: Mean Variance Constraint";
                Quote_VincentiATT(:,i) = RisultatiMVC(1:end-4,i);
             elseif idx == 4
                RiepilogoATT(i) = "Strategia vincente: Mean Variance";
                Quote_VincentiATT(:,i) = RisultatiMV(1:end-4,i);
            end
        end
        %Determinazione vincenti secondo Sharpe reale (proiezione ottima)
        [~,idx1] = max(Sharpe_RatiosEFF(:,i));
        if idx1 == 1
            RiepilogoEFF(i) = "Strategia vincente: Most Diversified Portfolio";
            Quote_VincentiEFF(:,i) = RisultatiMDP(1:end-4,i);
        elseif idx1 == 2
            RiepilogoEFF(i) = "Strategia vincente: Risk Parity Constraint";
            Quote_VincentiEFF(:,i) = RisultatiRP(1:end-4,i);
        elseif idx1 == 3
            RiepilogoEFF(i) = "Strategia vincente: Mean Variance Constraint";
            Quote_VincentiEFF(:,i) = RisultatiMVC(1:end-4,i);
        elseif idx1 == 4
            RiepilogoEFF(i) = "Strategia vincente: Mean Variance";
            Quote_VincentiEFF(:,i) = RisultatiMV(1:end-4,i);
        end
    end
end