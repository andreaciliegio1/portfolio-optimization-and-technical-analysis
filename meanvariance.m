function [Quote, Rendimento, Varianza, Sharpe, Sharpe_EFF] = meanvariance(matriceC, vettore_mu, out_sample_ES, risk_free)
    % Numero di titoli
    nc = length(vettore_mu);

    % Definizione del problema di ottimizzazione (massimizzazione utilità MV)
    prob = optimproblem("Description", "Classic Mean Variance", "ObjectiveSense", "max");
    
    % quote del portafoglio
    quote = optimvar("Quote", nc);

    % Funzione obiettivo: rendimento atteso - (1/2) * rischio (varianza)
    Utility = (vettore_mu' * quote) - (1/2 * quote' * matriceC * quote);

    % Vincolo: somma delle quote deve essere 1 (pieno investimento)
    prob.Constraints.quote = sum(quote) == 1;

    % Inizializzazione della soluzione
    initialGuess.Quote = zeros(size(quote));
    
    % Assegnazione dell'obiettivo al problema
    prob.Objective = Utility;

    % Risoluzione del problema
    sol = solve(prob, initialGuess);

    % Quote ottimali arrotondate a 5 cifre decimali
    Quote = round(sol.Quote, 5);

    % Rendimento atteso del portafoglio 
    Rendimento = vettore_mu' * Quote;

    % Varianza del portafoglio 
    Varianza = Quote' * matriceC * Quote;

    % Sharpe ratio 
    Sharpe = (Rendimento - risk_free) / sqrt(Varianza);

    % Sharpe ratio EFF
    Sharpe_EFF = (out_sample_ES' * Quote - risk_free) / sqrt(Varianza);
end
