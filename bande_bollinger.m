function bande_bollinger(prezzo_close, date, titolo)

% bande di Bollinger
k = 20; % finestra temporale
n_rilevazioni = length(date);
[mid, upper, lower] = bollinger(prezzo_close, k, 0, 2);

diff_low = prezzo_close - lower;
diff_up = prezzo_close - upper;

% Plot del grafico
hold on
plot(date, prezzo_close, LineWidth=1.5);
plot(date, mid, LineWidth=1.5);
plot(date, upper, LineWidth=1.5);
plot(date, lower, LineWidth=1.5);

b = false; % Nessuna posizione attiva

% Creo un ciclo che indica il momento in cui vendere e in cui comprare
for i = 1:n_rilevazioni-2
    % Faccio plottare il puntoin cui comprare solo se non si ha gia
    % comprato prima
    if (~b && ((diff_low(i)>0 && diff_low(i+1)<0)) && ((diff_low(i+1)<0 && diff_low(i+2)>0)))
        b = true;
        plot(date(i+1), prezzo_close(i+1), '^', color='g', MarkerFaceColor='g');
        
    end
    % Faccio plottare il punto in cui vendere solo se prima ha comprato     
    if (b &&((diff_up(i)<0 && diff_up(i+1)>0)) && ((diff_up(i+1)>0 && diff_up(i+2)<0)))
        b = false;
        plot(date(i+1), prezzo_close(i+1), 'v', color='r', MarkerFaceColor='r');
        
    end
end

legend({titolo, 'SMA20', 'Upper', 'Lower', 'Buy', 'Sell'});
title('Bande di Bollinger', FontWeight='bold');
xlim([date(k),date(end)]);
grid on
hold off