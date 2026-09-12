function [Quote, Rendimento, Varianza, Sharpe, Sharpe_EFF] = meanvarianceconstraint(matriceC, vettore_mu, out_sample_ES, risk_free)
    % Numero di titoli
    nc = length(vettore_mu);

    % Definizione del problema di ottimizzazione
    prob = optimproblem("Description", "Mean Variance Constraint", "ObjectiveSense", "max");
    quote = optimvar("Quote", nc);

    % Funzione obiettivo: rendimento atteso - penalità per la varianza
    Utility = (vettore_mu' * quote) - (1/2 * quote' * matriceC * quote);

    % Vincolo: somma delle quote deve essere 1 
    prob.Constraints.quote = sum(quote) == 1;

    % Vincolo aggiuntivo: nessuna posizione short 
    prob.Constraints.segno = quote >= 0;

    % Inizializzazione del punto di partenza per il solver
    initialGuess.Quote = zeros(size(quote));

    % Assegna la funzione obiettivo al problema
    prob.Objective = Utility;

    % Risolve il problema
    sol = solve(prob, initialGuess);

    % Estrae le quote ottimali e le arrotonda a 5 cifre decimali
    Quote = round(sol.Quote, 5);

    % Calcola il rendimento atteso 
    Rendimento = vettore_mu' * Quote;

    % Calcola la varianza del portafoglio 
    Varianza = Quote' * matriceC * Quote;

    % Calcola lo Sharpe ratio 
    Sharpe = (Rendimento - risk_free) / sqrt(Varianza);

    % Calcola lo Sharpe ratio EFF
    Sharpe_EFF = (out_sample_ES' * Quote - risk_free) / sqrt(Varianza);
end
