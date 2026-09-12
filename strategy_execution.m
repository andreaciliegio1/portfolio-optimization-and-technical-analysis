function [RisultatiMDP,RisultatiRP, RisultatiMVC, RisultatiMV] = strategy_execution(C,mu,Strategie,out_sample_ES, risk_free)
    [RisultatiMDP,RisultatiRP,RisultatiMVC, RisultatiMV] = deal(NaN(size(C,1)+4,1));
    
    % Eseguo le strategie selezionate
    if Strategie(1) == 1
        [QuoteMDP,RendimentoMDP,VarianzaMDP,SharpeMDP,SharpeEFFMDP] = mostdiversifiedportfolio(C,mu,out_sample_ES, risk_free);
        RisultatiMDP = [QuoteMDP;RendimentoMDP;VarianzaMDP;SharpeMDP;SharpeEFFMDP];
    end
   
    if Strategie(2) == 1
        [QuoteRP,RendimentoRP,VarianzaRP,SharpeRP,SharpeEFFRP] = riskparity(C,mu,out_sample_ES, risk_free);
        RisultatiRP = [QuoteRP;RendimentoRP;VarianzaRP;SharpeRP;SharpeEFFRP];
    end
    
    if Strategie(3) == 1
        [QuoteMVC,RendimentoMVC,VarianzaMVC,SharpeMVC,SharpeEFFMVC] = meanvarianceconstraint(C,mu,out_sample_ES, risk_free);
        RisultatiMVC = [QuoteMVC;RendimentoMVC;VarianzaMVC;SharpeMVC;SharpeEFFMVC];
    end

     if Strategie(4) == 1
        [QuoteMV,RendimentoMV,VarianzaMV,SharpeMV,SharpeEFFMV] = meanvariance(C,mu,out_sample_ES, risk_free);
        RisultatiMV = [QuoteMV;RendimentoMV;VarianzaMV;SharpeMV;SharpeEFFMV];
    end
end