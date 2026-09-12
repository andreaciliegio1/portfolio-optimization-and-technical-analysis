%% ANDREA CILIEGIO 2148291

% Pulizia ambiente di lavoro
clc; clf; clear; close all; 

% Estrazione dati
dati = readtable("Basedati.xlsx", "Sheet", "Basedatirendimenti");     % Data load
stock_returns = dati{:, 2:end};                                       % Rendimenti
ticker_list = dati.Properties.VariableNames(2:end);                   % Titoli
stock_prices = readtable("Basedati.xlsx", "Sheet", "Basedatiprezzi"); % Prezzi
date=stock_prices{:,1};                                               % Osservazioni
stock_prices = stock_prices{:, 2:end};

% Info box
disp(['Numero di osservazioni: ' num2str(size(stock_returns,1))]) % Osservazioni
disp(['Numero di titoli: ' num2str(size(stock_returns,2))]) % Titoli

% Definizione periodi
answer = inputdlg({'Giorni periodo in sample:', 'Giorni periodo out of sample:','Dimensione di portafoglio desiderata:'},...
    'Simulation parameters',[1 50]);
answer = str2double(answer);
if isempty(answer)
    return
end
while true
    if sum(str2double(answer(1:2))) > size(stock_returns,1) || ismember(0,answer)
        disp("Errore nella selezione dei parametri. Per favore ripeti.")
        answer = inputdlg({'Giorni periodo in sample:', 'Giorni periodo out of sample:','Dimensione di portafoglio desiderata:'},...
        'Simulation parameters',[1 50]);
    else
        OS_star = stock_returns(end-(answer(2)-1):end, :); % t*
        IS = stock_returns(end - (answer(2)+answer(1)-1):end-(answer(2)),:); % t
        break
    end
end
IS_backup = IS; % Copia della matrice originale

% Selezione strategie 
available_strategies = {'Most Diversified Portfolio','Risk Parity', 'Mean Variance Constraint', 'Mean Variance (short selling)'};
[idx,~] = listdlg('PromptString',{'Seleziona i modelli di calibrazione da utilizzare - preselection step'},'ListString', available_strategies,"ListSize",[200,300]);
while length(idx) < 1
    disp("Devi selezionare almeno un modello di calibrazione.")
    [idx,~] = listdlg('PromptString',{'Seleziona i modelli di calibrazione da utilizzare - preselection step'},'ListString', available_strategies,"ListSize",[200,300]);
end
Strategies = zeros(1,size(available_strategies,2));
for i=1:length(available_strategies)
    if ismember(i,idx)
        Strategies(i) = 1;
    else
        Strategies(i) = 0;
    end
end

legenda = [available_strategies(Strategies==true), "Integrated Adaptive Strategy Model - Optimum"];

% Inizializzazione variabili
[MDP_Results,RP_Results, MVC_Results, MV_Results] = deal(NaN(size(ticker_list,2)+4,size(OS_star,1)));  

% Inserimento risk free
risk_free = input('Inserisci il valore del risk free: ');

% Applicazione delle strategie
for i=1:size(OS_star,1)
    C = cov(IS,1); 
    mu = transpose(mean(IS));  
    out_sample_ES = transpose(OS_star(i,:)); 
    [MDP_Results(:,i),RP_Results(:,i), MVC_Results(:,i), MV_Results(:,i)] = strategy_execution(C,out_sample_ES,Strategies,out_sample_ES, risk_free);
    IS(1,:) = [];
    IS(end+1,:) = OS_star(i,:);
end

% Sharpe ratio
Sharpe_ratiosEX = [];
Sharpe_ratiosEFF = [MDP_Results(end,:);RP_Results(end,:); MVC_Results(end,:); MV_Results(end,:)];
[~, ~,Riepilogue,Winner_WeightsEFF] = determina_vincente(MDP_Results,RP_Results,MVC_Results,MV_Results, Sharpe_ratiosEX,real(Sharpe_ratiosEFF),0);

% Sorting dei pesi in ordine decrescente
Sorting = migliori_titoli(Winner_WeightsEFF);
for i=1:size(Sorting,1)
    for j=1:size(Sorting,2)
        if not(isnan(Sorting(i,j)))
            Sorting_tick(i,j) = ticker_list(Sorting(i,j));
        end
    end
end

% Riduzione dei titoli al numero desiderato
Output_matrix = Sorting(1:answer(3),1:size(OS_star,1)); 
Matr_output_OS_double_star = Sorting(1:answer(3),size(OS_star,1)+1:end); 
for i=1:size(Output_matrix,1)
    for j=1:size(Output_matrix,2)
        if not(isnan(Output_matrix(i,j)))
            Output_matrix_Tick(i,j) = ticker_list(Output_matrix(i,j));
        end
    end
end

% Plot dei primi 5 titoli dal peso maggiore per ogni strategia vincente
figure('Name', 'Primi 5 titoli caratterizzati dal peso maggiore di tutte le strategie vincenti', 'NumberTitle', 'off');
uitable('Data', Output_matrix_Tick, 'ColumnName', strcat("Giorno ", string(1:size(Output_matrix_Tick,2))), 'RowName', strcat("Posizione ", string(1:size(Output_matrix_Tick,1))), 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
input('Premere invio per continuare...'); clc;

% Post selezione
[MDP_ResultsII,RP_ResultsII, MVC_ResultsII, MV_ResultsII] = deal(NaN(answer(3)+4,size(OS_star,1)));
OS_to_actual_returns = [];

for i=1:size(OS_star,1)
    IS = IS_backup(:,Output_matrix(:,i));
    C = cov(IS,1); 
    mu = transpose(mean(IS));  
    out_sample_ES = transpose(OS_star(i,Output_matrix(:,i))); 
    OS_to_actual_returns(i,:) = out_sample_ES; 
    [MDP_ResultsII(:,i),RP_ResultsII(:,i)] = strategy_execution(C,out_sample_ES,Strategies,out_sample_ES, risk_free);
    IS_backup(1,:) = [];
    IS_backup(end+1,:) = OS_star(i,:);
end

Sharpe_ratiosEXII = [];
Sharpe_ratiosEFFII = [MDP_ResultsII(end,:);RP_ResultsII(end,:); MVC_ResultsII(end,:); MV_ResultsII(end,:)];
[~, ~,RiepilogueII,Winner_WeightsEFFII] = determina_vincente(MDP_ResultsII,RP_ResultsII,MVC_ResultsII,MV_ResultsII,Sharpe_ratiosEXII,real(Sharpe_ratiosEFFII),0);
        
% Actual returns 
IASM_returnsII = sum(Winner_WeightsEFFII.*OS_to_actual_returns');
IASM_cumulated_returnsII = cumsum(IASM_returnsII);

% Creazione grafico rendimenti
X = 0:(answer(2)-1); 
figure('units','normalized','outerposition',[0 0 1 1])

plot_rendimenti(MDP_ResultsII(:,answer(2)),RP_ResultsII(:,answer(2)),MVC_ResultsII(:,answer(2)),MV_ResultsII(:,answer(2)),OS_to_actual_returns);
hold on
plot(X,IASM_cumulated_returnsII,'-r','LineWidth',2)
title("Rendimenti effettivi dopo l'attività di preselezione")
xlabel('Roll')
ylabel('Rendimenti cumulati')
legend(legenda,"Location","best")
hold off
input('Premere invio per continuare...'); clc;

% Strategia vincente il maggior numero di volte
[strategia_vincente, i, strat] = strategia(RiepilogueII);
i_selected = strat > 0;
strat = strat(i_selected);

% Presenza titoli
presenze = zeros(size(ticker_list));
for a = 1:length(ticker_list)
presenze(a) = sum(strcmp(ticker_list{a}, Output_matrix_Tick(:)));
end

percentuale_presenze = presenze / size(Output_matrix_Tick, 2);

% Primi 5 titoli per presenza
[presenze_decrescenti , indici_ordinamento] = sort(percentuale_presenze, 'descend');

% Creazione grafico strategia più vincente
figure('units','normalized','outerposition',[0 0 1 1])
bar(strat);
x_bar = ["MDP", "RP", "MVC", "MV"];
set(gca, 'XTick', 1:sum(i_selected), 'XTickLabel', x_bar(i_selected));
ylabel("Numero di vittorie");
title("La strategia vincente il maggior numero di volte è: " + available_strategies(i));
for i = 1:length(strat)
    text(i, strat(i) + 5, num2str(strat(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 8);
end
ylim([0, strategia_vincente + 10]); 
input('Premere invio per continuare...'); clc;

% Creazione grafico presenze dei titoli
x = 1:2:length(presenze_decrescenti)*2;  
figure('units','normalized','outerposition',[0 0 1 1])
bar(x, presenze_decrescenti);            
set(gca, 'XTick', x, 'XTickLabel', ticker_list(indici_ordinamento));
xtickangle(45); 
ylabel("Frequenza relativa");
title("Presenza dei titoli nel portafoglio");
for i = 1:length(presenze_decrescenti)
    text(x(i), presenze_decrescenti(i) + 0.04, sprintf('%.1f%%', presenze_decrescenti(i)*100), ...
         'HorizontalAlignment', 'center', 'FontSize', 8);
end
ylim([0, max(presenze_decrescenti)+0.1]);
input('Premere invio per continuare...'); clc;

% ANALISI TECNICA
% Estrazione prezzi e nomi dei titoli piu presenti
primi = stock_prices(:, indici_ordinamento(1:answer(3)));
titoli = string(ticker_list(indici_ordinamento(1:answer(3))));

%% Con i valori di high low e i volumi è possibile fare l'analisi tecnica utilizzando anche MFI e SUPERTREND
%high = readtable("Basedati.xlsx", "Sheet", "High");
%high = high{:, 2:end};
%low = readtable("Basedati.xlsx", "Sheet", "Low");
%low = low{:, 2:end};
%volume = readtable("Basedati.xlsx", "Sheet", "Volume");
%volume = volume{:, 2:end};

% Applicazione analisi tecnica ad ogni titolo
for c = 1:answer(3)
    prezzi = primi(:,c);
    titolo = titoli(:,c);

date_OS = date(end-(answer(2)-1):end,:);
valori_OS = prezzi(end-(answer(2)-1):end,:);

Analisi_tecnica(date_OS, valori_OS, titolo);
if c < answer(3)
input(['Premi INVIO per visualizzare i grafici del titolo ' num2str(c+1)]);
else
   input('Premi INVIO per continuare...');
end
end

% VAR
w = repmat(1/answer(3), answer(3), 1);
[Var_port_5perc, ES_port_5perc, VaR_historical_5perc, ES_historical_5perc] = var(primi, w);
v = [Var_port_5perc, ES_port_5perc, VaR_historical_5perc, ES_historical_5perc];

etichette = {'VaR parametrico', 'ES parametrico', 'VaR storico', 'ES storico'};

% Creazione grafico VAR
figure('units','normalized','outerposition',[0 0 1 1]);
bar(v);
set(gca, 'XTickLabel', etichette, 'XTick', 1:4);
xtickangle(45);
title('Confronto tra VaR ed ES - Parametrico vs Storico');

for i = 1:length(v)
    text(i, v(i) - 0.002, sprintf('%.2f', v(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);
end
ylim([min(v)-1, 0]);

disp(['Il VAR parametrico al 5% è: ', num2str(Var_port_5perc)]);
disp(['ES parametrico è: ', num2str(ES_port_5perc)]);
disp(['Il VAR Historical al 5% è: ', num2str(VaR_historical_5perc)]);
disp(['ES Historical è: ', num2str(ES_historical_5perc)]);
