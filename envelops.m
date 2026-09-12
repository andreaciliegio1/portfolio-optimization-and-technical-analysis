function envelops(prezzo_close, date, SMA_20, WMA_20, EMA_20, titolo, ev)
% Envelops
k = 20; % Finestra temporale
n_rilevazioni = length(date);

 % Indico con quale media costruire le bande
        if ev(1) == 1
            media_mobile = SMA_20;
        end

        if ev(1) == 2
            media_mobile = WMA_20;
        end

        if ev(1) == 3
            media_mobile = EMA_20;
        end
    

% Trovo i limiti inferiori e superiori
lim_inf = media_mobile - media_mobile*0.05;
lim_sup = media_mobile + media_mobile*0.05;

diff_inf = prezzo_close - lim_inf;
diff_sup = prezzo_close - lim_sup;

% Plot delle bande
hold on
plot(date, prezzo_close, LineWidth=1.5);
plot(date, media_mobile, LineWidth=1.5);
plot(date, lim_inf, LineWidth=1.5);
plot(date, lim_sup, LineWidth=1.5);

a = false;  % nessuna posizione attiva

 for i = 2:n_rilevazioni-1
    % Segnale di acquisto: incrocio dal basso l'envelope inferiore
    if ~a && diff_inf(i) < 0 && diff_inf(i-1) > 0
        a = true;
        plot(date(i), prezzo_close(i), '^', 'Color', 'g', 'MarkerFaceColor', 'g');
        
    end

    % Segnale di vendita: incrocio dall'alto l'envelope superiore
    if a && diff_sup(i) > 0 && diff_sup(i-1) < 0
        a = false;
        plot(date(i), prezzo_close(i), 'v', 'Color', 'r', 'MarkerFaceColor', 'r');
        
    end
end

legend({titolo, 'SMA20', 'Limite inferiore', 'Limite superiore', 'Buy', 'Sell'});
title('Envelops', 'FontWeight','bold');
xlim([date(k),date(end)]);
grid on;
hold off