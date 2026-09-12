function momentum(prezzo_close, date, titolo)

% Momentum
k = 10; % Finestra temporale
n_rilevazioni = length(date);
m = nan(n_rilevazioni, 1);

% Calolo del momentum
for f = k:n_rilevazioni
    m(f) = (prezzo_close(f) /prezzo_close(f-k+1))*100;
end
linea_100 = repmat(100, n_rilevazioni, 1);

% Plot del grafico
hold on
yyaxis left
plot(date, prezzo_close, LineWidth=1.5);
yyaxis right
plot(date, m, LineWidth=1.5);
plot(date, linea_100, '--', LineWidth=1.5);
legend({titolo, 'Momentum10', 'Linea100'});
title('Momentum', FontWeight='bold');
xlim([date(k),date(end)]);
grid on
hold off