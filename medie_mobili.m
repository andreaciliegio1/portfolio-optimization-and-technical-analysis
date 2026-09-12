function  [SMA_20, WMA_20, EMA_20] = medie_mobili(prezzi_c, date, titolo, n)


% media mobile semplice
SMA_5 = movmean(prezzi_c, 5);  % Media mobile "corta"
SMA_20 = movmean(prezzi_c, 20); % Media mobile "lunga"

% media mobile ponderata
k = 20; % finestra considerata
x = 1:k;
x = x/sum(x);
l = length(prezzi_c);

WMA_20 = NaN(n, 1); % Inizializzazione matrice

for t = k:l
    k_prezzi = prezzi_c(t-k+1:t);
    WMA_20(t) = (x*k_prezzi)/sum(x);
end

% media mobile esponenziale
EMA_20 = movavg(prezzi_c, 'e', 20);

% Creazione grafici
% Plot SMA corta e lunga
if n(1) == 1 
hold on
plot(date, prezzi_c, LineWidth=1.5);
plot(date, SMA_5, LineWidth=1.5);
plot(date, SMA_20, LineWidth=1.5);
legend({titolo, 'SMA5','SMA20'});
title('Medie Mobili', FontWeight='bold');
xlim([date(k),date(end)]);
grid on
hold off
end

% Plot media mobile ponderata
if n(1) == 2
hold on
plot(date, prezzi_c, LineWidth=1.5);
plot(date, SMA_20, LineWidth=1.5);
plot(date, WMA_20, LineWidth=1.5);
title('Medie Mobili', FontWeight='bold');
legend({titolo, 'SMA20', 'WMA20'})
xlim([date(k),date(end)]);
grid on
hold off
end

% Plot media mobile esponenziale
if n(1) == 3
hold on
plot(date, prezzi_c, LineWidth=1.5);
plot(date, SMA_20, LineWidth=1.5);
plot(date, EMA_20, LineWidth=1.5);
title('Medie Mobili', FontWeight='bold');
legend({titolo, 'SMA20', 'EMA20'})
xlim([date(k),date(end)]);
grid on
hold off
end

% Plot di tutte le medie sovrapposte
if n(1) == 4
hold on
plot(date, prezzi_c, LineWidth=1.5);
plot(date, SMA_20, LineWidth=1.5);
plot(date, WMA_20, LineWidth=1.5);
plot(date, EMA_20, LineWidth=1.5);
legend({titolo, 'SMA20', 'WMA20', 'EMA20'})
title('Medie Mobili', FontWeight='bold');
xlim([date(k),date(end)]);
grid on
hold off
end