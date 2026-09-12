function [strategia_vincente, i, strat] = strategia(RiepilogueII)

% Conto il numero di volte che compare la singola strategia tra le vincenti
n_MDP = length(find(RiepilogueII == 'Strategia vincente: Most Diversified Portfolio'));
n_RP = length(find(RiepilogueII == 'Strategia vincente: Risk Parity Constraint'));

strat = [n_MDP, n_RP];
% Trovo la strategia che vince più volte
[strategia_vincente, i] = max(strat);

