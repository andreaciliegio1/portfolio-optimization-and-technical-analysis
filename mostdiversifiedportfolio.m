function [Quote, Rendimento, Varianza, Sharpe, Sharpe_EFF] = mostdiversifiedportfolio(matriceC, vettore_mu, out_sample_ES, risk_free)
    % Numero di titoli
    nc = length(vettore_mu);

    % Estrae le varianze individuali dai diagonali della matrice di covarianza
    Variances = diag(matriceC);

    % Calcola le deviazioni standard dei singoli titoli
    Dev_st = sqrt(Variances);

    % Definizione del problema di ottimizzazione: massimizzare l'indice di diversificazione
    prob = optimproblem("Description", "Most Diversified Portfolio", "ObjectiveSense", "max");

    % Quote del portafoglio
    quote = optimvar("Quote", nc);

    % Funzione obiettivo MDP: somma pesata delle deviazioni standard / deviazione standard del portafoglio
    Utility = (sum(quote .* Dev_st)) / (sqrt(quote' * matriceC * quote));

    % Vincolo: pieno investimento (somma quote = 1)
    prob.Constraints.quote = sum(quote) == 1;

    % Vincolo: nessuna posizione short (quote ≥ 0)
    prob.Constraints.segno = quote >= 0;

    % Inizializzazione con quote uguali (tutte a 1)
    initialGuess.Quote = ones(size(quote));

    % Assegna la funzione obiettivo al problema
    prob.Objective = Utility;

    % Risoluzione del problema
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
