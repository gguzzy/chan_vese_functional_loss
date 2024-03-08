% Funzione per re-inizializzare la funzione di Level Set
function phi = reinitializeLevelSet(phi, deltaT, G)
    % Calcolo dei termini discreti per le derivate spaziali
    phi_x = diff(phi, 1, 2);
    phi_y = diff(phi, 1, 1);
    
    % Calcolo di nabla phi
    nabla_phi = sqrt(phi_x.^2 + phi_y.^2);
    
    % Implementazione dell'equazione PDE per la re-inizializzazione
    phi = phi - deltaT .* sign(phi) .* (1 - nabla_phi) .* G;
end
