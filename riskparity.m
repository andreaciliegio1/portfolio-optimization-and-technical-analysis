function [Quote, Rendimento, Varianza, Sharpe, Sharpe_EFF] = riskparity(matriceC, vettore_mu, out_sample_ES, risk_free)
    % Numero di titoli
    nc = length(vettore_mu);

    % Definizione del problema di ottimizzazione: minimizzazione della distanza dai contributi al rischio uguali
    prob = optimproblem("Description", "Risk parity", "ObjectiveSense", "min");

    % Quote del portafoglio
    Quote = optimvar("Quote", nc);

    % TRC: Total Risk Contributions di ciascun titolo (devono essere bilanciati)
    TRC = (matriceC * Quote) .* Quote;

    % Obiettivo: minimizzare la somma dei quadrati delle deviazioni dei contributi normalizzati dal valore teorico 1/nc
    Utility = (TRC / ((Quote' * matriceC) * Quote) - 1/nc).^2;

    % Vincolo: pieno investimento (somma quote = 1)
    prob.Constraints.quote = sum(Quote) == 1;

    % Vincolo: no short selling (quote ≥ 0)
    prob.Constraints.segno = Quote >= 0;

    % Inizializzazione: tutte le quote a 1
    initialGuess.Quote = ones(size(Quote));

    % Imposta la funzione obiettivo
    prob.Objective = sum(Utility);

    % Risolve il problema
    sol = solve(prob, initialGuess);

    % Estrae e arrotonda le quote ottimali
    Quote = round(sol.Quote, 5);

    % Calcola rendimento atteso
    Rendimento = vettore_mu' * Quote;

    % Calcola varianza 
    Varianza = Quote' * matriceC * Quote;

    % Calcola Sharpe ratio 
    Sharpe = (Rendimento - risk_free) / sqrt(Varianza);

    % Calcola Sharpe ratio EFF
    Sharpe_EFF = ((out_sample_ES' * Quote) - risk_free) / sqrt(Varianza);
end
