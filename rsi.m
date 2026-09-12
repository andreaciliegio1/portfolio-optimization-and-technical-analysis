function rsi(prezzo_close, date, titolo)

% RSI
f = 14; % finestra temporale
n_rilevazioni = length(date);
% Calcolo RSI
RSI = rsindex(prezzo_close);

hold on
plot(date, prezzo_close, LineWidth=1.5);
plot(date, RSI, LineWidth=1.5);

c = false; % nessuna posizione attiva

for i = 1:n_rilevazioni
    % Plot dei punti di vendita 
    if ~c && RSI(i) > 80
        c = true;
        plot(date(i), prezzo_close(i), 'vr', MarkerFaceColor='r');
    end
    % Plot dei punti di acquisto
    if c && RSI(i) < 20
        c = false;
        plot(date(i), prezzo_close(i), '^g', MarkerFaceColor='g');
    end
end
linea_80 = repmat(80, 1, length(date));
linea_20 = repmat(20, 1, length(date));
plot(date, linea_20, 'r--', 'HandleVisibility', 'off');
plot(date, linea_80, 'g--', 'HandleVisibility', 'off');
title('RSI', FontWeight='bold');
legend({titolo, 'RSI', 'Sell: RSI > 80', 'Buy: RSI<20', 'Ipervenduto', 'Ipercomprato'});
xlim([date(f+1),date(end)])
grid on
hold off