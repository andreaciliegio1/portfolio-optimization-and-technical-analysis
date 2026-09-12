function [Var_port_5perc, ES_port_5perc, VaR_historical_5perc, ES_historical_5perc] = var(prezzi, w)

%% return matrix
data_return=(prezzi(2:end,:)-prezzi(1:end-1,:))./(prezzi(1:end-1,:));

%% set parameters
alpha= 0.05;
quantiles=norminv(alpha);   %% calcola i quantili della normale standard
quantiles_1_a=norminv(1-alpha);
timestep=1;  

%% stima dei parametri GBM
%media
miu=sum(data_return,1)/(height(prezzi)*timestep);   

meann=repmat(miu,height(data_return),1);
C=((data_return-meann).'*(data_return-meann))/((height(data_return)-1)*timestep);

% Var al 5% parametrico
Var_port_5perc=(prezzi(1,:).'.*w).'*miu.'*(timestep) ...
        +sqrt((prezzi(1,:).'.*w).'*C*(prezzi(1,:).'.*w))*sqrt(timestep)*quantiles;

% ES al 5% parametrico
ES_port_5perc=-(prezzi(1,:).'.*w).'*miu.'*(timestep)...
        -sqrt((prezzi(1,:).'.*w).'*C*(prezzi(1,:).'.*w))*...
        sqrt(timestep)*(exp(-(quantiles_1_a^2)/2))/(sqrt(2*pi)*(1-(1-alpha)));

%% historical simulation

% Var al 5% storico
VaR_historical_5perc=(prezzi(1,:)*w)*quantile((data_return)*w,alpha);

% ordino i dati
data_return_sort=sort(data_return*w);

% ES al 5% storico
ES_historical_5perc=(prezzi(1,:)*w)*...
        mean(data_return_sort(1:find(data_return_sort>quantile((data_return)*w,alpha))));

