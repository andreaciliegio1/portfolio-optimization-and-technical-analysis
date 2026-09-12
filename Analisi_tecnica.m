function Analisi_tecnica(date, prezzi, titolo)

% Indico quale media mobile visualizzare
[n,~] = listdlg('PromptString',{'Seleziona la media mobile che vuoi visualizzare'},'ListString', {'SMA','WMA', 'EMA', 'TUTTE'},"ListSize",[400,200], "SelectionMode", "single");

% Indico la media mobile da usare per costruire le bande evenlops
[ev,~] = listdlg('PromptString',{'Quale media vuoi utilizzare per le bande Envelops? '},'ListString', {'SMA','WMA', 'EMA'},"ListSize",[400,100], "SelectionMode", "single");


figure('Name', "Media mobile: " + titolo, 'units', 'normalized', 'outerposition', [0 0 1 1]);
% Medie mobili
[SMA_20, WMA_20, EMA_20] = medie_mobili(prezzi, date, titolo, n);

% Envelops
figure('Name', "Evenelops e Bande di Bollinger: " + titolo, 'units', 'normalized', 'outerposition', [0 0 1 1]);
subplot(2,1,1);
envelops(prezzi, date, SMA_20, WMA_20, EMA_20, titolo, ev);

% Bande di bollinger
subplot(2,1,2);
bande_bollinger(prezzi, date, titolo);

% Momentum
figure('Name', "Momentum: " + titolo, 'units', 'normalized', 'outerposition', [0 0 1 1]);
momentum(prezzi, date, titolo);

% RSI
figure('Name', "RSI: " + titolo, 'units', 'normalized', 'outerposition', [0 0 1 1]);
rsi(prezzi, date, titolo);

% MFI
%figure('Name', "MFI - Supertrend: " + titolo, 'units', 'normalized', 'outerposition', [0 0 1 1]);
%subplot(1,2,1);
%mfi(prezzi, date, titolo, high, low, volume);

% SUPERTREND
%subplot(1,2,2);
%supertrend(prezzi, date, titolo, high, low, volume);


